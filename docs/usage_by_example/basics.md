  
  
***Usage examples for basic use of the bluash: capabilities & syntax arising from use of 
Lua as the scripting environment: module required, use command line arguments given to script, call 
"sub procedures", branch on conditions, pretty print, help, etc.***

Basic functionality: 

    > require 'bluash' -- lua-based shell environment

Will provide bluash.os, bluash.fs, bluash.io, etc. These can also be "merged" into global env: 

    > bluash.install_global {}

Shell creates the 'script' struct, containing:

    script.args -- table of args given to script
    script.name -- arg[0] ie name of script
    script.workdir -- cwd for script
    script.path -- path to where script located

No need for echo, use print() function instead.

In Lua the types are: nil, boolean, number, string, function, thread, userdata, table. Objects, classes, 
data structure are all represented via tables and metatables. 

To print tables use pprint:

    > pprint (123, 456, 789)
    1: 123
    2: 456
    3: 789

    > pprint {a=1, b=2, c=4}
    a: 1
    b: 2
    c: 4

Use Lua's builtin var assignment to get cmd line args into variables:

    local configName, yourName = unpack {script.args}

will unpack the first two command line arguments given to script into the configName and yourName
local variables. 

Might be able to use builtin error() to flag errors, but likely need an exit() function so OS gets
an exit code. For now, premature exit has to use "return":

    if configName == nil then 
        error "missing args"
        return
    end

Procedures, unlike Batch, are straightforward: 

    function yourProcedure(args)
       blabla using args
       return answer
    end

Issueing help {something} will attempt to find docs for the item: look for the __doc member of something 
and print it or call it; if something is an OS command, try to issue /? to get the doc string. Examples: 

    help {os}       -- help on 'os': will print the different methods and commands
    help {os.dir}   -- help on 'dir' cmd: will print __doc if exists, otherwise output from "dir /?"
    help {yourCmd}  -- help on 'yourCmd'; assumes on path, will output __doc if exists, otherwise "yourCmd /?" or "yourCmd /h"

Doing members(something) will print the fields of the table (same as old foreach(table, print)).

