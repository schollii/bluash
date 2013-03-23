Pseudo code: 

    string.formatx(format, table):
        items = Format.GetItems(format)
        return foreachi(items, new.Format.Converter(table))

    Format.GetItems(formatString):
        formatString has pattern "[anything]{scope:name:spec}[anything]..." with:
            scope is immediate (args), global, environment, determine object created
            name is given to object; if no name, then position integer (1 for first anonymous object etc)
            spec is flags like "float with precision X" etc
            must not be required to give correct type flag; for instance no need to specify f for number and s for string, object can determine this when converts
        each format item in formatString is an object that knows how to interpret relevant parts of {}
        return array of items in format (string, formatItem, string, formatItem, formatItem, ...)

    new.Format.Converter(table):
        converter = { str = "", dict = table }
        converter.meta.__call = function(self, formatItem)
            if type(formatItem) == string then self.str += formatItem
            else
                self.str += formatItem.convert(self.dict)
        converter.meta.__tostring(self) => self.str
        return converter