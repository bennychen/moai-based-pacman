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
require "media/tiledmap"

TILE_MAP_ITEM_EMPTY = 0
TILE_MAP_ITEM_BEAN = 1
TILE_MAP_ITEM_SUPER_BEAN_1 = 2
TILE_MAP_ITEM_SUPER_BEAN_2 = 3
TILE_MAP_ITEM_WALL_1 = 4
TILE_MAP_ITEM_WALL_2 = 5
TILE_MAP_ITEM_WALL_3 = 6

GameMap = class()

function GameMap:init( fileName )
	local tileImageWidth = 64
	local tileImageHeight = 64
	local tileNumColumn = 3
	local tileNumRow = 2
	self.tileDeck = MOAITileDeck2D.new()
	self.tileDeck:setTexture( "media/" .. map.tilesets[1].image )
	self.tileDeck:setSize( tileNumColumn, tileNumRow, 
			map.tilewidth / tileImageWidth, map.tileheight / tileImageHeight )

	self.tileGrid = MOAIGrid.new()
	local drawTileWidth = SCREEN_WIDTH / map.width
	local drawTileHeight = drawTileWidth 
	self.tileGrid:setSize( map.width, map.height, drawTileWidth, drawTileHeight )
	self.mapData = map.layers[1].data
	for i = 1, map.height
	do
		for j = 1, map.width
		do
			self.tileGrid:setTileFlags( j, map.height - i + 1, self.mapData[( i - 1 ) * map.width + j] )
		end
	end

	self.remapper = MOAIDeckRemapper.new()
	self.remapper:reserve ( map.width * map.height )

	self.tileMap = MOAIProp2D.new()
	self.tileMap:setDeck( self.tileDeck )
	self.tileMap:setGrid( self.tileGrid )
	self.tileMap:setLoc( -drawTileWidth * map.width / 2, -drawTileHeight * map.height / 2 )
end

function GameMap:drawMap( layer )
	layer:insertProp( self.tileMap )
end

function GameMap:clearMap( layer )
	layer:removeProp( self.tileMap )
end

function GameMap:IsGridEmpty( gridX, gridY )
	if ( gridX <= 0 or gridY <= 0 or 
		 gridX > map.width or gridY > map.height )
	then
		print( "ERROR @ GameMap::IsGridEmpty - grid x or y is overflowed!!!" )
		return
	end
	return self.mapData[( gridY - 1 ) * map.width + gridX] == TILE_MAP_ITEM_EMPTY
end
