Design principles: 

* Re-use as much of what already exists as possible
* Access the re-used parts via API so can be easily replaced 
* Support integration to Lua's string, io, os, etc tables but only if desired
* Minimally pollute global table
* Support blush configuration module (like .bashrc on linux)

Main components: 

* string generation from templates (aka placeholders a la printf in C): support use of parameter dict, globals, and environment variables
* string parsing via builtin 
* easy access to filesystem: drives, paths, folders, files, extensions (file types)
* easy access to read system environment variables: extend builtin
* easy access to set system environment variables: find setenv module (penlight)
* easily execute OS commands, pipe data between commands, capture stdout and stderr, feed to stdin
* helper functions to loop over arrays and dicts (maps)


Detailed design:

* [string templating](detailed_design/string_formatting.md)


