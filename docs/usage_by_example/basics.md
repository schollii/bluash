  
  
***Usage examples for basic use of the bluash, ie focus on capabilities/syntax arising from use of 
Lua as the scripting environment: module required, use command line arguments given to script, call 
"sub procedures", branch on conditions, pretty print, help, etc.***

Basic functionality: 

    > require('bluash') -- lua-based shell environment

Will provide bluash.os, bluash.fs, bluash.io, etc. These can also be "merged" into global env: 

    > bluash.install_global()

Shell creates the 'script' struct, containing:

    script.args -- table of args given to script
    script.name -- arg[0] ie name of script
    script.workdir -- cwd for script
    script.path -- path to where script located
    script.stdout
    script.stdin
    script.stderr

No need for echo, use print() function instead.
To print tables use pprint; items on separate lines

    > pprint (123, 456, 789)
    1: 123
    2: 456
    3: 789

    > pprint {a=1, b=2, c=4}
    a: 1
    b: 2
    c: 4

and table (array) of tables (arrays) as a traditional table

    > tt = {
        {123, 'abc'}, 
        {456, 'def'}, 
        {789, 'ghi'},
        }
    > printFormat = {
        formats=('{-10}', '{=15}'), 
        headers=('header1', 'header2'), 
        index=true }
    > pprint (tt, printFormat)
       header1  header2
    1: 123        abc
    2: 456        def
    3: 789        ghi

Use Lua's builtin var assignment to get cmd line args:

    configName, yourName = unpack(script.args)

Premature exit has to use "return" for now (could create an exit() function via C extension?):

    if configName == nil then 
        error("missing args")
        return
    end

Procedures are straightforward: 

    function yourProcedure(a,b,c)
       blabla
       return answer
    end

Doing help(something) will look for the __doc member of something and print it, if it exists. 

    help(os)       -- help on 'os': will print the different methods and commands
    help(os.dir)   -- help on 'dir' cmd: will print __doc if exists, otherwise output from "dir /?"
    help(yourCmd)  -- help on 'yourCmd'; assumes on path, will output __doc if exists, otherwise "yourCmd /?" or "yourCmd /h"

Doing vars(something) will print the items of the table (same as old foreach(table, print)).

