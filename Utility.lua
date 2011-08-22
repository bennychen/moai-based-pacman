function printf ( ... )
	return io.stdout:write ( string.format ( ... ) )
end 

local function _printNontableVar( varValue, varName, indentLevel, printedTables )
    local indent = string.rep( "    ", indentLevel )
    if ( varName == "" )
    then
        print( indent .. tostring( varValue ) )
    else
        print( string.format( "%s%s = %s", indent, varName, tostring( varValue ) ) )
    end
end

local function _printTableVar( tableValue, tableName, indentLevel, printedTables )
    local indent = string.rep( "    ", indentLevel )
    if ( printedTables[tableValue] ~= nil ) 
    then
        local tableAddress = tostring( tableValue )
        print( string.format( "%s%s = %s", indent, tableName, tableAddress ) )
    else
        printedTables[tableValue] = true
        print( indent .. tableName .. "{" )
        for key, value in pairs( tableValue ) do
            if string.sub( key, 1, 1 ) ~= "_"
            then
                printVar( value, key, indentLevel + 1, printedTables )
            end
        end
        print( indent .. "}" )
    end
end

function printVar( varValue, varName, indentLevel, printedTables )
    if ( indentLevel == nil )
    then
        indentLevel = 0
    end
    if ( printedTables == nil )
    then
        printedTables = {}
    end
    if ( varName == nil )
    then
        varName = ""
    end
    
    local indent = string.rep( "    ", indentLevel )
    local varType = type( varValue )
    if ( varType == "table" )
    then
        _printTableVar( varValue, varName, indentLevel, printedTables )
    else
        _printNontableVar( varValue, varName, indentLevel, printedTables )
    end
end

function printCallStack( level )
    level = level + 1
    local n = 1;
    print( "================call stack================" )
    while ( true ) do
        local info = debug.getinfo( level, "Sln" )
        if not info then break end
        if info.what == "Lua" then
            if ( info.name == nil ) then info.name = "Event Handler" end
            print( string.format( "%d: [%s@%d]:%s", n, info.short_src, info.currentline, info.name ) )
        end
        level = level + 1
        n = n + 1
    end
end
