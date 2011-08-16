--
--------------------------------------------------------------------------------
--         FILE:  GameMap.lua
--        USAGE:  ./GameMap.lua 
--  DESCRIPTION:  Handle game map of Pacman
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
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

function GameMap:init()
	self.tileGrid = MOAIGrid.new()
	self.tileGrid:setSize( map.width, map.height, gridSize, gridSize )
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

	self.width = gridSize * map.width
	self.height = gridSize * map.height

	self.tileMap = MOAIProp2D.new()
	self.tileMap:setDeck( TILE_DECK_2D_MAP )
	self.tileMap:setGrid( self.tileGrid )
	self.tileMap:setLoc( -self.width / 2, -self.height / 2 )

	self.leftTopCorner = MOAITransform.new()
	self.leftTopCorner:setLoc( -self.width / 2, self.height / 2 )
end

function GameMap:drawMap( layer )
	layer:insertProp( self.tileMap )
end

function GameMap:clearMap( layer )
	layer:removeProp( self.tileMap )
end

function GameMap:getGridIndex( posX, posY )
end

function GameMap:isGridBean( gridX, gridY )
	if ( gridX <= 0 or gridY <= 0 or 
		 gridX > map.width or gridY > map.height )
	then
		print( "ERROR @ GameMap::isGridBean - grid x[" .. gridX .. 
				"] or y[" .. gridY .. "] is overflowed!!!" )
		return
	end
	return gridData == self.mapData[( gridY - 1 ) * map.width + gridX] == TILE_MAP_ITEM_BEAN
end

function GameMap:isGridSuperBean( gridX, gridY )
	if ( gridX <= 0 or gridY <= 0 or 
		 gridX > map.width or gridY > map.height )
	then
		print( "ERROR @ GameMap::isGridSuperBean - grid x[" .. gridX .. 
				"] or y[" .. gridY .. "] is overflowed!!!" )
		return
	end
	local gridData = self.mapData[( gridY - 1 ) * map.width + gridX]
	return gridData == TILE_MAP_ITEM_SUPER_BEAN_1 or
		   gridData == TILE_MAP_ITEM_SUPER_BEAN_2
end

function GameMap:isGridWall( gridX, gridY )
	if ( gridX <= 0 or gridY <= 0 or 
		 gridX > map.width or gridY > map.height )
	then
		print( "ERROR @ GameMap::isGridWall - grid x[" .. gridX .. 
				"] or y[" .. gridY .. "] is overflowed!!!" )
		return
	end
	local gridData = self.mapData[( gridY - 1 ) * map.width + gridX]
	return gridData == TILE_MAP_ITEM_WALL_1 or
		   gridData == TILE_MAP_ITEM_WALL_2 or 
		   gridData == TILE_MAP_ITEM_WALL_3
end

function GameMap:isGridEmpty( gridX, gridY )
	if ( gridX <= 0 or gridY <= 0 or 
		 gridX > map.width or gridY > map.height )
	then
		print( "ERROR @ GameMap::isGridEmpty - grid x[" .. gridX .. 
				"] or y[" .. gridY .. "] is overflowed!!!" )
		return
	end
	return self.mapData[( gridY - 1 ) * map.width + gridX] == TILE_MAP_ITEM_EMPTY
end
