Welcome to bluash (pron. Blue Ash)! This is a small Open Source project aimed at developing a simple 
Lua-based shell scriping module that can be used instead of Windows Batch scripting. I.e., a Lua module 
that will provide various Lua "classes", functions and globals that will make it really easy to do what 
is so excruciatingly painful and annoying in Batch scripting. 

Before deciding to develop bluash, I looked at various other options:

* PowerShell: 
  * very nice object-oriented shell, integrates with .NET, powerful piping
  * a huge advancement over Batch, 
  * ugly syntax almost like Perl (verbose and clunky with $_ and such) 
  * Microsoft Windows only
* Javascript: 
  * nice balance between simplicity and power 
  * but because of its origin as a web browser based language, it is much more cumbersome to make 
    available as a command line tool than it is to install Lua (on Mac and Linux); 
  * On Windows, WSH (Windows Scripting Host) made it straightforward to use, in principle, but I 
    was never able to make it work, which indicates that WSH is again not as simple as "download 
	and install". Also WSH is no longer supported.
* Python: 
  * nice simple syntax, powerful standard library, many platforms
  * seems comparable scope of capabilities to PowerShell (especially if combined with a module 
    that interfaces to .NET), but not enough experience with PowerShell to say for sure
  * slower startup time, makes installation much bigger
* Bash: 
  * the most popular shell on Linux is available on Windows
  * but none of the standalone distributions are maintained, they are out of date and way behind the 
    current bash development
  * and environments like cygwin or msys have much too large a footprint, just want one easy-to-install  
    package
* Luash and Grunt: 
  * both open-source "shells" that appear incomplete and unmaintained.

Why use Lua for shell scripting? Lua

* Has a small memory footprint
* Has a small disk footprint: not "batteries included" like Python, but has enough to get you started
* Is easy to install on Windows and Linux platforms
* Has an easy syntax
* Supports powerful concepts of objects, dynamic typing, duck typing, functional programming, coroutines
* Is easily extended with C/C++ so any standard C++ lib can be used to extend stock Lua installation
* Has .NET integration module (which might come in handy)
* Is fun to program in

Here are some things I have needed to do with Batch files: 

1. branch on conditions, call "sub procedures", loop over lists (filenames, etc)
1. use command line arguments given to script
1. read and modify environment variables
1. combine character strings and numbers into other strings, parse strings to variables
1. copy or move files, list files in a folder, walk filesystem, find all files that satisfy some 
   condition on filename or content, etc
1. start and stop processes, capture and parse their output, send them input created in script, 
   branch based on exit code of process
1. get history of commands issued (as you can in bash)
1. get help on most commands (as you can in Python)

Bluash might eventually provide a full shell (where the command line has command completion, and commands 
can be re-used). But it is first and foremost an easy way to perform command-level tasks in the operating 
system, without having to fight with Windows Batch scripting, quoting and escaping, or invest a significant 
amount of time learning a platform specific language like PowerShell. Could it ever be a replacement for 
bash or PowerShell? Certainly not, but for many developers it will probably be sufficient. 

With the above tasks as a primary goal, are there any significant limitations of Lua that will have to be 
overcome: only one right now, namely the lack of a "setenv" function to set environment variables. 

Other than OS commands that are platform specific, bluash should work on Windows or Linux (or any other OS 
that has command shell and Lua): same language syntax (although with bash, who would need something like 
bluash on Linux? Maybe for cross-platform scripting?)

[Examples of shell scripting operations](docs/UsageByExample) are the starting point for specification and 
design of bluash. Some [detailed design](wiki/Basic-design) ideas are available too. 