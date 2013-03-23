***Usage examples focused on Iterating through arrays and maps.***

Iterations are a pain in Windows command shells; not so in Lua. Find item in a table; 'Values' is a Lua class: 

    found = nil
    for ii in Values('debug', 'release', 'none') do
        if configName == ii then 
            found='hello'
            break 
        end
    end

'Values' could be a functor: an object with methods, and a 'call' method which returns iterator as above, 
thus allowing:

    > key = Values('debug', 'release', 'none'):find(configName)
    > print('Item was at index=' .. key)
    2

Another option; is this better? (but rather not have too many global functions)

    key = find(configName, {'debug', 'release', 'none'))

In many cases what we want is to do something on all items of a table that
satisfy some condition until some other condition occurs. Generically: 

    foreach(tableRef, itemAction, filter, untilCondition)

For instance 

    foreach({1,2,3,4,5,6,7,8,9}, print, 
        function (ii) return ii % 2 == 0 end, 
        function (ii) return ii < 7 end
        )
    
or

    Values(1,2,3,4,5,6,7,8,9):foreach(
        print, 
        function (ii) return ii % 2 == 0 end, 
        function (ii) return ii < 7 end
        )
    
