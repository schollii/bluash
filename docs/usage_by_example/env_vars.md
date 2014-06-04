***These examples focus on the Operating System's environment variables: set, get, clear, etc.***

Anything under os.env is automatically created via __newindex which 
returns os.EnvVar object:

    os.env.VAR1 = '..\\a\\b'
    os.env.VAR2 = 'something'

will set VAR1 and VAR2 if they don't exist, otherwise will overwrite existing values. The type of 
os.env.SOMETHING is os.EnvVar. 

String concat with os.EnvVar works:

    os.env.PATH = SOME_DIR .. '\\aa\\bb;' .. SOME_DIR .. '\\aa\\cc'

Substitution too (will work with strings, ENV vars, commands, etc). The 
following converts os.EnvVar obj to string, creating new environment variable SOME_VAR: 

    os.env.SOME_VAR = '{1};{2}' % {os.env.VAR1, SOME_DIR}

Environment variables can also be patterned: 

    paths = os.env.SOME_VAR:split(';') -- split into list of items using ';' as separator
    files = os.env.SOME_VAR:split(',') -- using comma as separator
    a,b = os.env.SOME_VAR:capture('%a, %a') -- like string.capture

Could export some of the environment variables mentioned in 
http://windows7tips.com/environment-variables-windows-vista-7.html by default, so that vars(os.env) 
would show them. It would be nice if members(os.env) returned a table of all environment variables, 
but this will require a C extension. 

EnvVar can also be set with set(), and can be unset with unset() or nil. 

    os.env.PATH:set(path)
    os.env.SOME_DIR:unset() 
	os.env.SOME_DIR = nil

PATH manipulation: the Array "class" that has insert, append, prepend; the string class has split() 
which creates Array, and join() which converts Array to string:

    path = os.env.PATH:split(';')
    print( type(path) ) -- prints 'Array'
    path:insert(yourPath)
    path:append(yourPath)
    path:prepend(yourPath)
    os.env.Path = path:join(';')
