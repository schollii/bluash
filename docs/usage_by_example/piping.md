***These examples focus on piping output from one command as input to another.***

Pipe command output to stdout: 

    os.dir() > stdout

This implicitely means "run the command". Piping can involve any object that takes 
an os:IOStruct as input and returns one as output:

    function ioStructProc(inStruct) return someNewStruct end
    xcopy3 > os.grep('/f') > ioStructProc > 'somefile.txt'
    
Indeed, piping an IOStruct to a string saves it to the file of that name. 

Can capture the output into local var for processing; must be of type os.IoStruct

    result = IoStruct()
    xcopy3 > result
    print(result)

An example uses a lot of what shown already: 

    function copyFiles(fsTreeRoot, extensions, destPath)
        extensions = extensions:split(' ')
        xcopy = os.Cmd('xcopy %3% %1% %2%' % {destPath, xcopyArgs}
        for dir in fs.walkTree(fsTreeRoot) do 
            for ext in items(extensions) do 
                files = fs.glob(dir, ext) -- array of fs.File objects
                xcopy:run(files) -- gives args to cmd stringno output
            end
        end
    end

    for ii in items(someVar) do
        folder, typeA, typeB, typeC = ii:capture('(%a),(%a),(%a),(%a)')
        copyFiles(fs.Path(folder, typeA), ".EXE .EXE.CONFIG .DLL", destPath)
        copyFiles(fs.Path(folder, typeB), ".EXE .EXE.CONFIG .DLL", destPath)
        copyFiles(fs.Path(folder, typeC), ".EXE .EXE.CONFIG .DLL", destPath)
    end

Will the following work? 

    os.help 
        > function (ios)
            ...do stuff...
            return newIos
          end
        > os.more


