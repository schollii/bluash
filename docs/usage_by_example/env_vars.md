***These examples focus on the Operating System's environment variables: set, get, clear, etc.***

Anything under os.env is automatically created via __newindex which 
returns os.EnvVar object:

    os.env.VAR1 = '..\\a\\b'
    os.env.VAR2 = 'seomthing'

will set VAR1 and VAR2 if they don't exist, otherwise will overwrite existing values. The type of 
os.env.SOMETHING is os.EnvVar. 

String concat with os.EnvVar works:

    os.env.PATH= SOME_DIR .. '\\aa\\bb;' .. SOME_DIR .. '\\aa\\cc'

Substitution too (will work with strings, ENV vars, commands, etc). The 
following converts os.EnvVar obj to string, creating new env var SOME_VAR: 
os.env.SOME_VAR = '{1} {2}' % {os.env.VAR1, SOME_DIR}

Environment variables can also be patterned: 

    var = os.env.SOME_VAR:split(';') -- split into list of items using ';' as separator
    var = os.env.SOME_VAR:split(' ') -- using space as separator
    a,b = os.env.SOME_VAR:capture('%a, %b') -- like string.capture

Could export some of the ones mentioned in http://windows7tips.com/environment-variables-windows-vista-7.html by default so vars(os.env) would show them. 

EnvVar can also be un/set with un/set(), particularly useful when setting to 
something that is not a string: set() knows how to convert it to string 

    os.env.PATH:set(path)
    os.env.SOME_DIR:unset() 

PATH manipulation; 

    path = os.env.PATH:split(';')
    print( type(path) ) -- prints 'Values'
    path:insert(yourPath)
    path:append(yourPath)
    path:prepend(yourPath)
    os.env.Path = path:join(';')
