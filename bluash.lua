testing = true


-- change this module-global value to false to have trace() not print anything
traceOn = true


--[[
Trace is a print() function that only prints if traceOn = true. When it prints, 
it prefixes the line with the file/line where the trace() is called
--]]
function trace(...)
    if traceOn == true then
        dgInfo = debug.getinfo(2)
        local prefix = string.format('[%s:%s:%s]: ', dgInfo.short_src, dgInfo.currentline, dgInfo.what)
        print(prefix .. ...)
    end
end
     
	 
--[[
Returns a table with details about script that loaded bluash module: 
- path: path to script
- interpreter: path to interpreter 
- arg: table of command line arguments
--]]
local function initScript(arg)
    -- table.foreach(arg, function (...) print('  ', ...) end)
    local script = {
        path = arg[0],
        interpreter = {path = arg[-1]},
        arg = {}
    }

    for i=1,#arg do 
        script.arg[i] = arg[i]
    end
    
    return script
end


-- Most things in bluash go in 'sh' table
sh = {
    script = initScript(arg)
}

local function exec(expr)
    return assert(loadstring('return '..expr))()
end

trace 'bluash loaded'


function isnumber(obj)
	return type(obj) == 'number'
end


function isstring(obj)
	return type(obj) == 'string'
end


function isboolean(obj)
	return type(obj) == 'boolean'
end


function key(k, _) 
	return k
end


function value(_, v)
	return v
end

--[[
foreach {mytable, myfunc, iterator, filter=myfilter}

applies myfunc(x) to each x in mytable that satisfies filter(x), where x 
is returned by iterator(mytable).

Example: 
    With tt = {'a', 'b', 'c', d:1, e:2, f:3, g:4}
	
		foreach {tt, print}
	
	outputs 
	
		1	a
		2	b
		3	c
	
	whereas 

		iseven = function (_,v) return type(v) == 'number' and v % 2 == 0 end
		foreach {tt, print, pairs, filter=iseven}
	
	outputs
	
		e	2
		g	4
--]]
function foreach(tbl, action, iterator, filter)
	local items
	local itemFilter
    if action == nil then -- assume all args in a table
		items = tbl[1]
		action = tbl[2]
		iterator = tbl[3] or ipairs
		itemFilter = tbl.filter
	else
		items = tbl
		iterator = iterator or ipairs
		itemFilter = filter
	end
    
    if itemFilter == nil then
		for k,v in iterator(items) do 
			action(k,v)
		end
	else
		for k,v in iterator(items) do 
			if itemFilter(k,v) == true then
				action(k,v)
			end
		end
    end
end

-- foreach using ipairs as iterator
function foreachi(tbl, action, filter)
	foreach(tbl, action, ipairs, filter)
end

-- foreach using pairs as iterator
function foreachkv(tbl, action, filter)
	foreach(tbl, action, pairs, filter)
end


if testing then
	local tt = {'a', 'b', 'c', d=1, e=2, f=3, g=4}
	foreach {tt, print}
	print '---'
	foreach(tt, print)
	print '---'
	foreachi {tt, print}
	print '---'

	local iseven = function (k,v) return isnumber(v) and v % 2 == 0 end
	foreach {tt, print, pairs, filter=iseven}
	print '---'
	foreachkv(tt, print, iseven)
end
	

-- table holding all function generators
gen = {}

-- table holding all predicate function generators
gen.pred = {}

-- generates a predicate function that will test fn(...) == result
function gen.pred.equal(fn, result) 
	return function(...) 
		return fn(...) == result 
	end 
end


--[[ 
Generates a function which, given two arguments, tests whether its 
second parameter is of type = typename. Simplest case if typename is 
the name of the type ('function', 'table', etc). But typename can be 
an array of type names, in which case the generated function tests 
whether the second argument is of a type in array. 
]]
function gen.istype(typename)
    local argType = type(typename)
    if argType == 'string' then
        return  function (obj) 
                    return type(v) == typename 
                end
    elseif argType == 'table' then
        return  function (_, v) 
                    local vType = type(v)
                    for _, aType in ipairs(typename) do 
                        if vType == aType then 
                            return true 
                        end 
                    end
                    return false
                end
    else
        error ('type "'..typename..'" not supported')
    end
end 


--[[
	Generates a function that passes only the indx'th argument to func:
	
		f2 = gen.only_arg(2, myfunc)
		f2(arg1, b, ...) 
	
	is same as 
	
		myfunc(b)
--]]
function gen.only_arg(indx, func) 
    return  function (...) 
                -- print(func, unpack(arg), arg.n, indx, arg[indx])
                func(arg[indx]) 
            end 
end 



-- Taken from metalua stdlib 
-- Courtesy of lua-users.org
function string.split(str, pattern)
   local t = {} 
   local fpat = "(.-)" .. pattern
   local last_end = 1
   local s, e, cap = string.find(str, fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
      last_end = e+1
      s, e, cap = string.find(str, fpat, last_end)
   end
   if last_end <= string.len(str) then
      cap = string.sub(str, last_end)
      table.insert(t, cap)
   end
   return t
end


local function EnvVar(varName)
    local envVar = {
        name  = varName, 
        value = os.getenv(varName),
        --split = function (self, char) return self.value:split(char) end
    }
    local mt = {
        __index = function (self, name) 
                    -- return a function that forwards all method calls to 'self.value as string' 
					trace ('getting field '..name)
					if name == 'value' then return nil end
                    return function(self, ...) return string[name](self.value, ...) end
                end,
        __tostring = function (self) 
                    trace ('Converting env var '.. self.name .. ' to string')
                    return tostring(rawget(self, 'value'))
                end,
    }
    setmetatable(envVar, mt)
    return envVar
end

    
local function OSEnv()
    local env = {}
    local meta = {
        __index = function(self, varName)
                trace ('Creating new env var ' .. varName)
                local envVar = EnvVar(varName)
                rawset(self, varName, envVar)
                return envVar
            end,
        __newindex = function (self, name, value)
                trace ('would set env var '..name..' to value '..tostring(value))
            end
        }
    setmetatable(env, meta)
    return env
end

sh.env = OSEnv()
sh.env.__doc = [[
Access the OS environment variables. They are fields of sh.env, created dynamically. 
Hence

	a = sh.env.HOME 

set a to an object which has two fields: name and value, and behaves as a string:

	print(a.name, a.value, a:sub(5,7))

will print 'HOME    something    th'. Note that string operations will raise an error()
if env var does not exist (a.value is nil).
]]


if testing then
    local home = sh.env.HOME
	print(home)
	print(sh.env.windir)
	print(sh.env.windir:sub(4))
end


function newMultiPath(multiPath)
    return multiPath:split(';')
end

    
local function dir(module, modName)
    local iprint = gen_indent_print(4)

    print ('Everything in ' .. modName)
    --foreach {module, print, 'key', filter = only_arg(2, pred.equal(type, 'function'))}
    foreach {module, iprint}
    
    print ('Functions in ' .. modName)
    foreach {module, iprint, 'key', filter = genfn_istype_value 'function'}
    
    print ('Tables in ' .. modName)
    foreach {module, iprint, filter = genfn_istype_value 'table' }
    
    print ('Constants in ' .. modName)
    foreach {module, iprint, filter = genfn_istype_value {'string', 'number'} }
    -- table.foreach(module, function (key, item) print (type(item)) end)
end

sh.dir = dir