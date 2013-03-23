These usage examples focus on producing strings and parsing strings into variables. 
 
# String substitutions

String substitutions are essential, must have easy way to put data into 
file names, command lines args, etc to be given to OS commands. The string type provide a % (__mod) operation which
using a "dictionary" table would allow to express the following: 

    mycmdStr = 'your_batch.exe /n {CONFIG} /m {USERNAME}' % {CONFIG=configName, USERNAME=yourName}

Can't use > or < because used for string comparison. A shorter form, but have to count args so not as clear

    mycmdStr = 'your_batch.exe /n {1} /m {2}' % {configName, yourName}

Shorter still, but reader must count # args:

    mycmd = 'your_batch.exe /n {} /m {}' % {configName, yourName}

The modulo operator works with os.EnvVar and fs.Path as well. Will also be a method on strings:

    string.formatx(format-string, items)

will do same as format-string % items. Could be useful to use with table of format strings too:

    list1 = {'{1}\\a\\b', '{2}\\a\\c', '{1}\\b\\d', '{2}\\a\\b'} % Values (a,b,c)
    list2 = {'{DIR1}\\a\\b', '{DIR2}\\a\\c', '{DIR1}\\b\\d', '{DIR2}\\a\\b'}
                    % Dict {DIR1='..', DIR2=os.env.SOME_ENV_VAR}

but this requires a "class" (like Vales o Dict) since tables can't be extended to support modulo operator (they probably can but then all types of Lua objects wll support it, which would not make sense). It would be quite easy to achieve same with 

    local strings = {'{1}\\a\\b', '{2}\\a\\c', '{1}\\b\\d', '{2}\\a\\b'}
    list1 = foreachi { strings, string.FormatToList {a,b,c} }

where string.FormatToList(table) generates a functor (an object that behaves as a function) which will create a new table containing formatted items from input table (strings), and will return the new list (the foreachi returns the result of calling the action's __foreach metamethod if it exists, or nil otherwise). 

In general: 

    string % string => string
    string % table (array or map) => string
    string % List => string
    string % Dict => string
    table % string => table
    table % List => table
    table % Dict => table

# Pattern input

Inverse operation of formatted output is pattern input like string.capture():

    a, b = string.capture(destPath, '(%a)\\(%a)')

or shorter:

    a, b = destPath:capture('(%a)\\(%a)')

The regexp equivalent would be, if such library exists for Lua and is imported:

    a, b = destPath:capturex('([:alpha:])\\([:alpha:])')