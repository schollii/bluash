***Usage examples focused on Iterating through arrays and maps.***

Iterations are a pain in Windows Batch; not so in Lua. Find index of item in a table:

    found = nil
    for ii, val in ipairs {'debug', 'release', 'none'} do
        if configName == val then 
            found = ii
            break 
        end
    end
	
An Array class will have an index() method: 

    found = Array{'debug', 'release', 'none'} :index('release')
	print(found) -- prints '2'
	
Same for maps: 

	key = Dict{a=1, b=2, c=4} :find(4)
	print(key) -- prints 'c'
	
Note that technically, an Array is a Dict where key is index: 

	key = Dict{1, 4, a=1, b=2, c=4} :find(4)
	print(key) -- prints '2'
	keys = Dict{1, 4, a=1, b=2, c=4} :find_all(4)
	print(keys) -- prints {2,c}

But Array is likely to be optimized for sequential memory and O(1) random access
(whereas Dict likely has O(log2 n) access).

In many cases what we want is to do something on all items of a table that
satisfy some condition, until some other condition occurs. Generically: 

    foreach(table, iterator, itemAction, itemFilter, untilCondition)

would iterate over given table's items, using given iterator. 
For instance 

	tbl = {1,2,3,4,5,6,7,8,9}
    foreach(tbl, ipairs, print, 
        function (ii) return ii % 2 == 0 end, 
        function (ii) return ii < 7 end
        )
    
Note: This is one example where support for lambda syntax in Lua would be nice, such as

	tbl = {1,2,3,4,5,6,7,8,9}
    foreach(tbl, ipairs, print, 
        \(ii) { ii % 2 == 0 }, 
        \(ii) { ii < 7 }
        )

Since most often the iterator will be either ipairs or pairs, two utility functions 
could be available: foreachi and foreachkv. When there are lots of parameters, and some 
are optional, it helps to have named arguments: 

	foreachi {tbl, print, filter=\(ii) { ii%2==0 }, until=\(ii) { ii < 7 } }
	
Note that ipairs produces the subset of 
pairs that form a continuous sequence from index 1 to N with no null values. 