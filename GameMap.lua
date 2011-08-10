--
--------------------------------------------------------------------------------
--         FILE:  GameMap.lua
--        USAGE:  ./GameMap.lua 
--  DESCRIPTION:  Handle game map of Pacman
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/10/2011 14:31:02 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "class"
require "Utility"

MAP_ITEM_EMPTY = 0
MAP_ITEM_WALL = 1
MAP_ITEM_BEAN = 2
MAP_ITEM_SUPER_BEAN = 3

GameMap = class()

GameMap.MAP_WIDTH = 28
GameMap.MAP_HEIGHT = 31

function GameMap:init( fileName )
	self:initMapFromFile( fileName )
end

function GameMap:initMapFromFile( fileName )
	print( "initializing game map..." )
	self.mapData = {}
	self.mapProps = {}
	local file = io.open( fileName, 'r' )
	local gridY = 0
	for line in file:lines()
	do
		print( line )
		if ( gridY > GameMap.MAP_HEIGHT or line:len() < GameMap.MAP_WIDTH )
		then
			print( "ERROR @ GameMap::init - wrong map data" )
			return false
		end
		self.mapData[gridY] = {}
		for gridX = 0, GameMap.MAP_WIDTH - 1 
		do
			local gridData = line:sub( gridX + 1, gridX + 1 )
			self:initMapGrid( gridData, gridX, gridY )
		end
		gridY = gridY + 1
	end
	file:close()

	--printVar( self.mapData, "GameMap.mapData" )

	return true
end

function GameMap:initMapGrid( gridData, gridX, gridY )
	local gridPosX = gridX * gridWidth - 135
	local gridPosY = 150 - gridY * gridHeight
	if ( self.mapProps[gridY] == nil )
	then
		self.mapProps[gridY] = {}
	end
	if ( gridData == '*' )
	then
		self.mapData[gridY][gridX] = MAP_ITEM_WALL
		self.mapProps[gridY][gridX] = MOAIProp2D.new()
		self.mapProps[gridY][gridX]:setDeck( QUAD_2D_WALL )
		self.mapProps[gridY][gridX]:setLoc( gridPosX, gridPosY )
	elseif ( gridData == 'o' )
	then
		self.mapData[gridY][gridX] = MAP_ITEM_BEAN
		self.mapProps[gridY][gridX] = MOAIProp2D.new()
		self.mapProps[gridY][gridX]:setDeck( QUAD_2D_BEAN )
		self.mapProps[gridY][gridX]:setLoc( gridPosX, gridPosY )
	elseif ( gridData == 'O' )
	then
		self.mapData[gridY][gridX] = MAP_ITEM_SUPER_BEAN
		self.mapProps[gridY][gridX] = MOAIProp2D.new()
		self.mapProps[gridY][gridX]:setDeck( QUAD_2D_SUPER_BEAN )
		self.mapProps[gridY][gridX]:setLoc( gridPosX, gridPosY )
	else
		self.mapData[gridY][gridX] = MAP_ITEM_EMPTY
	end
end

function GameMap:drawMap( layer )
	local n = 0
	for gridY = 0, 23--GameMap.MAP_HEIGHT - 1
	do
		for gridX = 0, GameMap.MAP_WIDTH - 1
		do
			if ( self:IsGridEmpty( gridX, gridY ) == false )
			then
				layer:insertProp( self.mapProps[gridY][gridX] )
				n = n + 1
				print( "draw [" .. n .. "]" )
				if ( n == 512 ) then return end
			end
		end
	end
end

function GameMap:clearMap( layer )
	for gridY = 0, GameMap.MAP_HEIGHT - 1
	do
		for gridX = 0, GameMap.MAP_WIDTH - 1
		do
			if ( self:IsGridEmpty( gridX, gridY ) == false )
			then
				layer:removeProp( self.mapProps[gridY][gridX] )
			end
		end
	end
end

function GameMap:IsGridEmpty( gridX, gridY )
	if ( gridX >= GameMap.MAP_WIDTH or gridY >= GameMap.MAP_HEIGHT )
	then
		print( "ERROR @ GameMap::IsGridEmpty - grid x or y is overflowed!!!" )
		return
	end
	return self.mapData[gridY][gridX] == MAP_ITEM_EMPTY
end
