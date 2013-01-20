traceOn = true

-- Trace is a print() function that only prints if traceOn = true. When it prints, 
-- it prefixes the line with the file/line where the trace() is called
function trace(...)
    if traceOn == true then
        dgInfo = debug.getinfo(2)
        local prefix = string.format('[%s:%s:%s]: ', dgInfo.short_src, dgInfo.currentline, dgInfo.what)
        print(prefix .. ...)
    end
end
        
-- Create 'script' table
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

sh = {
    script = initScript(arg)
}

local function exec(expr)
    return assert(loadstring('return '..expr))()
end

function tprint(tt, indent, addIndent)
    if type(tt) == 'string' then
        print(tt .. ' = {')
        tprint(exec(tt), 4)
        print('}')
        return
    end
    
    if addIndent == nil then addIndent = 4 end
    if indent == nil then indent = 0 end
    local indentStr = string.rep(' ', indent)
    for k,v in pairs(tt) do
        if type(v) == 'table' then
            print(indentStr .. k .. ' = {')
            tprint(v, indent+addIndent, addIndent)
            print(indentStr .. '}')
        else
            print(indentStr .. k .. ' = ' ..tostring(v))
        end
    end
end

trace 'bluash loaded'

trace 'command line args as seen by bluash:'

-- table.foreach(script, print)
tprint('sh.script')
tprint('sh.script.interpreter')


pred = {
    equal = function (lhs, rhs) 
                return function(...) 
                    return lhs(...) == rhs 
                end 
            end, 
}
    
function foreach(tt)
    tbl = tt[1]
    action = tt[2]
    what = tt[3]
    
    local true_action = action
    if what == 'key' then
        true_action = function (key) action(key) end
    elseif what == 'value' then
        true_action = function (_, value) action(value) end
    end
    
    local foreach_action = true_action
    if tt.filter ~= nil then
        local filter = tt.filter
        foreach_action = function (k, v) 
                            if filter(k, v) == true then 
                                true_action(k, v) 
                            end 
                        end
    end

    table.foreach(tbl, foreach_action)
end

function only_arg(indx, func) 
    return  function (...) 
                print(func, unpack(arg), arg.n, indx, arg[indx])
                func(arg[indx]) 
            end 
end 

--[[ 
Generates a function which, given two arguments, tests whether its 
second parameter is of type = typename. Simplest case if typename is 
the name of the type ('function', 'table', etc). But typename can be 
an array of type names, in which case the generated function tests 
whether the second argument is of a type in array. 
]]
function genfn_istype_value(typename)
    local argType = type(typename)
    if argType == 'string' then
        return  function (_, v) 
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

function isstring(obj)
    return type(obj) == 'string'
end

function isnumber(obj)
    return type(obj) == 'number'
end

function gen_indent_print(count)
    return function (...) 
                value = arg[2]
                if value == nil then
                    print( string.rep(' ', count), arg[1])
                else
                    if type(value) ~= 'number' and type(value) ~= 'boolean' then 
                        value = "'" .. tostring(value) .. "'" 
                    end
                    print( string.rep(' ', count), arg[1], '=', value)
                end
            end
end


-- Taken from metalua stdlib 
-- Courtesy of lua-users.org
function string.split(str, pat)
   local t = {} 
   local fpat = "(.-)" .. pat
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
                    return function(self, ...) return string[name](self.value, ...) end
                end,
        __tostring = function (self) 
                    trace ('Converting env var '.. self.name .. ' to string')
                    return self.name .. ': ' .. self.value 
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