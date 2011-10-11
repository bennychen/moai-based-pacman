function printf ( ... )
	return io.stdout:write ( string.format ( ... ) )
end 

local function _printBreakpoint( level )
    level = level + 1
    local info = debug.getinfo( level, "Sl" )
    if info
    then
        print( string.format( "[breakpoint] at (%s):%d", info.short_src, info.currentline ) )
    end
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

local function _printLocalVars( level, varName )
    print( "=============local variables=============" )
    level = level + 1
    local n = 1
    local localVars
    while ( true ) do
        local name, value = debug.getlocal( level, n )
        if not name then break end
        --localVars[name] = value
		if ( varName == nil )
		then
        	printVar( value, name )
		elseif ( name == varName )
		then
			printVar( value, name )
		end
			
        n = n + 1
    end
    return localVars
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

function eval( str )
    if ( str == "bp()" ) 
    then         
        print( "calling bp() from console is prohibited!!!" )
        return 
    end
    return loadstring( "return " .. str )()
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
	print( "=========================================" )
end


function bp()
    -- level 1: db.breakpoint
    -- level 2: the calling function
    local curLevel = 2
    _printBreakpoint( curLevel )
    
    while ( true ) 
    do
		io.write( "==>" )
        local input = io.read()
        if ( input == "p" )
        then 
            _printLocalVars( curLevel )
        elseif ( input == "q" or input == "quit" )
        then
            break
        elseif ( input == "cs" or input == "callstack" )
        then
            printCallStack( curLevel )
        elseif ( input ~= "" )
        then
			_printLocalVars( curLevel, input )
--            -- TODO: setfenv()  getfenv()
--            local succeeded, returnValue = pcall( eval, input )
--            if ( succeeded == false )
--            then
--                print( "commond error: " .. returnValue )
--            else 
--                if ( returnValue ~= nil )
--                then print( returnValue )
--                end
--            end
        end
    end
end
