***These examples focus on Operating System commands (cd, dir, ipconfig, etc).***

OS shell commands are in the os table; it has predefined commands:

    print( os:isCmd('dir') ) -- prints true
    print( os.dir )    -- prints 'function: ....'
    print( os.getcwd ) -- prints 'function: ....'

Note that interrogating the OS directly uses methods, to distinguish from 
'properties' such as executables which are table entries

If it doesn't know the command, it will assume it is an executable
so it will create an entry in 'os' table:

    print( os:isCmd('yourCmd') ) -- prints false
    yourCmd = os.yourCmd 
    print( yourCmd ) -- prints 'function: ....'

Such "sweetener" is not always desirable, so it can be turned off:

    os:setNewCmdOnDemand(false)


Commmands are objects: os.Cmd. It can be anything that can be run by a shell; 

    yb = os.Cmd ('your_batch.exe /n debug') -- 

This defines a command but does not execute it. The above will eventually run correctly if your_batch is on PATH and working dir is CWD. Otherwise, easiest is to switch to table call: 

    yb = os.Cmd {'your_batch.exe /n debug', path='/some/path', workDir='/some/other/path'}

Use a method call to run, ignoring any stdout/err output: 

    yb:run() 

This blocks till run() returns; output goes to stdout, stderr too but prefixed with marker. Can run again: 

    yb:run() 

Note that os:run(...) is short for os.Cmd(...):run()

Common need is command line args easy to create from script data; this will use 

    out, err = os:run(yb)

The return is the stdout and stderr of the process once it has exited

    print('stdout: ' .. out)
    print('stderr: ' .. err)

Now for command line args via string substitutions:

    mycmd2 = os.Cmd {'your_batch.exe /n {CONFIG} /m {USERNAME}', path='/a/b/c', workDir='/d/e/f'}
    os:run(mycmd2, {CONFIG=something, USERNAME=somethingElse})

or should it be 

    os:run {mycmd2, CONFIG=something, USERNAME=somethingElse}

Also have a "start": run, background, return:

    os:start('vmt_cpp.sln') -- will open Visual Studio if installed

Parametric commands: 

    xcopy2 = os.xcopy('{file1} {file2} /D/Y/{exec}')

Then to run it: 
 
    xcopy2 {file1='file1.txt', file2='file2.log'} :run()

or 

    os:run {xcopy2, file1='file1.txt', file2='file2.log'}
