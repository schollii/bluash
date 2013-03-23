***These examples focus on interacting with the file system.***

Use the fs object: 

    for ii in fs.dirs() do -- fs.dirs() defaults to cwd of current drive
        -- do something with ii
    end

    fs.setcwd('..')
    dDrive = fs.d
    dDrive:setcwd('..') -- does it on drive 'd:'; every drive available
    fs.d:goto() -- like "d:" at command line: switches to that drive
    fs.pushcwd()
    fs.setcwd(parentdir) -- pre-defined global
    fs.getcwd() -- shows cwd on current drive
    fs.popcwd() -- same as fs:setcwd( fs.dirstack:pop() )

    os.env.VMT_HOME = fs.getcwd()

A file is an object: 

    f = fs.File('somefile.txt', 'w')
    f:write('something')
    f:writeline('something')

    destdir = dir1 .. '\\' .. dir2 .. '\\' .. dir3 -- destdir is a plain string
    destdir = fs.Path(dir1, dir2, dir3) -- now an object representing dir1\dir2\dir3
    print(destdir) -- uses tostring()

Use fs:catpath(...) for file path manip: 

    fs:concat(targetdir, targetname .. targetext)

