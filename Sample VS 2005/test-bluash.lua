print 'Test bluash' 

package.path = '../?.lua' .. package.path
print ('LUA PATH is ' .. package.path)

require 'bluash'
require 'lfs'

lfs.pi = 3.141592
lfs.tt = {a=123,b='456'}
sh.dir(lfs, 'LuaFileSystem')

print ('cwd is ', lfs.currentdir())
--lfs.chdir '..'
print ('cwd is ', lfs.currentdir())

print ('LUA PATH is ' .. package.path)

print( tostring(sh.env.PATH) )

paths = sh.env.PATH:split(';')
tprint('paths')

ok = io.read()
