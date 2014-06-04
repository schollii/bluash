***These examples focus on interacting with the file system.***

Use the fs object: 

    for ii in fs.dirs() do -- fs.dirs() defaults to cwd of current drive
        -- do something with ii
    end

    fs.setcwd '..' -- works on current drive, C:
    dDrive = fs.d
    dDrive:setcwd '..' -- does it on drive 'd:'; every drive a-z available
    fs.d:goto() -- like "d:" at command line: switches fs to that drive as current
    fs.pushcwd()
    fs.setcwd(parentdir) -- parentdir is pre-defined global for '..'
    fs.getcwd() -- shows cwd on current drive
    fs.popcwd() -- same as fs:setcwd( fs.dirstack:pop() )

    os.env.VMT_HOME = fs.getcwd()

Files and paths are objects: 

    f = fs.File('somefile.txt', 'w').open()
	if f ~= nil then
		f:write('something')
		f:writeline('something')
		f:close()
	end

    destdir = dir1 .. '\\' .. dir2 .. '\\' .. dir3 -- destdir is a plain string
    destdir = fs.Path(dir1, dir2, dir3) -- now an object representing dir1\dir2\dir3
    print(destdir) -- uses tostring()

Use fs.Path(path1, path2, ...) for file path manip: 

    path = fs.Path(path1, path2, file .. ".obj")
	print(path)
	

