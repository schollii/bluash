These usage examples focus on producing strings and parsing strings into variables. 
 
# String substitutions

String substitutions are essential, must have easy way to put data into 
file names, command lines args, etc to be given to OS commands. The string type provides a % (__mod) 
operator which could take an array to allow index-based substitution:

    mycmd = 'your_batch.exe /n {} /m {}' % {configName, yourName}
    mycmd = fill {'your_batch.exe /n {} /m {}', configName, yourName}

In above, the first {} gets first item, etc. Explicit numbering should also be supported: 

    mycmdStr = 'your_batch.exe /n {2} /m {1}' % {configName, yourName}
    mycmdStr = fill {'your_batch.exe /n {2} /m {1}', configName, yourName}

which can be useful in some cases. Instead of indices, the keys could be strings:

    mycmdStr = 'your_batch.exe /n {CONFIG} /m {USERNAME}' % {CONFIG=configName, USERNAME=yourName}
    mycmdStr = fill {'your_batch.exe /n {CONFIG} /m {USERNAME}', CONFIG=configName, USERNAME=yourName}
    mycmdStr = 'your_batch.exe /n {CONFIG} /m {USERNAME}' % Array(_G)

The modulo operator should work with any object that can be converted to a string (such 
as os.EnvVar and fs.Path). BUT it wont' work with literals: 

    'abc' % 123
	
will fail because the literal can't be extended to include modulo operator. 

Often, a method equivalent to an operator is useful (makes it easy to pass
as callback -- can be done with metamethods but looks awkward):

    string.formatx(format_string, items)

will do same as 

	format_string % items 
	
and 
	
	format_string:formatx(items)
	
If items is a table rather than a string or a list of objects, you could also write

	format_string:formatx itemsTable

Any items in itemsTable that are of type table will get searched as well. 

In general: 

    string % string => string
    string % table (array or map) => string
    string % Array => string
    string % Dict => string

# Pattern input

Inverse operation of formatted output is pattern input; use Lua's builtin string.capture():

    a, b = string.capture(destPath, '(%a),(%a)')

or shorter:

    a, b = destPath:capture('(%a),(%a)')

The regexp equivalent would be, if such library exists for Lua and is imported:

    a, b = destPath:capturex('([:alpha:])\\([:alpha:])')