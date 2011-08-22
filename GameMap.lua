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
	self.tileGrid:setSize( map.width, map.height, tileSize, tileSize )
	self.mapData = map.layers[1].data
	for i = 1, map.height
	do
		for j = 1, map.width
		do
			self.tileGrid:setTile( j, i, self.mapData[( i - 1 ) * map.width + j] )
		end
	end

	self.remapper = MOAIDeckRemapper.new()
	self.remapper:reserve ( map.width * map.height )

	self.width = tileSize * map.width
	self.height = tileSize * map.height

	self.tileMap = MOAIProp2D.new()
	self.tileMap:setDeck( TILE_DECK_2D_MAP )
	self.tileMap:setGrid( self.tileGrid )
	self.tileMap:setLoc( -self.width / 2, -self.height / 2 )

	self.leftTopCorner = MOAITransform.new()
	self.leftTopCorner:setLoc( -self.width / 2, -self.height / 2 )
end

function GameMap:drawMap( layer )
	layer:insertProp( self.tileMap )
end

function GameMap:clearMap( layer )
	layer:removeProp( self.tileMap )
end

function GameMap:getTileIndex( posX, posY )
	local tileX = math.floor( posX / tileSize ) + 1
	local tileY = math.floor( posY / tileSize ) + 1
	return tileX, tileY
end

function GameMap:isCollidingWall( leftTopX, leftTopY, rightBottomX, rightBottomY, printInfo )
	local EPSILON = tileSize / 50
	leftTopX = leftTopX + EPSILON
	leftTopY = leftTopY + EPSILON
	rightBottomX = rightBottomX - EPSILON
	rightBottomY = rightBottomY - EPSILON

	local leftTopTileX
	local leftTopTileY
	local rightBottomTileX
	local rightBottomTileY
	leftTopTileX, leftTopTileY = self:getTileIndex( leftTopX, leftTopY )
	rightBottomTileX, rightBottomTileY = self:getTileIndex( rightBottomX, rightBottomY )

	if ( printInfo ~= nil )
	then
		printVar( leftTopX, "leftTopXofPacman" )
		printVar( leftTopY, "leftTopYofPacman" )
		printVar( rightBottomX, "rightBottomXofPacman" )
		printVar( rightBottomY, "rightBottomYofPacman" )
		printVar( leftTopTileX, "leftTopTileX" )
		printVar( leftTopTileY, "leftTopTileY" )
		printVar( rightBottomTileX, "rightBottomTileX" )
		printVar( rightBottomTileY, "rightBottomTileY" )
	end

	if ( self:isTileWall( leftTopTileX, leftTopTileY ) or
		 self:isTileWall( rightBottomTileX, leftTopTileY ) or
		 self:isTileWall( leftTopTileX, rightBottomTileY ) or
		 self:isTileWall( rightBottomTileX, rightBottomTileY ) ) 
	then
		if ( printInfo )
		then
			print( '----- hitting wall -----')
		end
		return true
	else
		return false
	end
end

function GameMap:clearTileBean( tileX, tileY )
	if ( self:isTileBean( tileX, tileY ) )
	then
		self.tileGrid:setTile( tileX, tileY, TILE_MAP_ITEM_EMPTY )
		return true
	else
		return false
	end
end

function GameMap:clearTileSuperBean( tileX, tileY )
	if ( self:isTileSuperBean( tileX, tileY ) )
	then
		self.tileGrid:setTile( tileX, tileY, TILE_MAP_ITEM_EMPTY )
		return true
	else
		return false
	end
end

function GameMap:isTileBean( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		print( "ERROR @ GameMap::isTileBean - tile x[" .. tileX .. 
				"] or y[" .. tileY .. "] is overflowed!!!" )
		return
	end
	return self.mapData[( tileY - 1 ) * map.width + tileX] == TILE_MAP_ITEM_BEAN
end

function GameMap:isTileSuperBean( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		print( "ERROR @ GameMap::isTileSuperBean - tile x[" .. tileX .. 
				"] or y[" .. tileY .. "] is overflowed!!!" )
		return
	end
	local tileData = self.mapData[( tileY - 1 ) * map.width + tileX]
	return tileData == TILE_MAP_ITEM_SUPER_BEAN_1 or
		   tileData == TILE_MAP_ITEM_SUPER_BEAN_2
end

function GameMap:isTileWall( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		print( "ERROR @ GameMap::isTileWall - tile x[" .. tileX .. 
				"] or y[" .. tileY .. "] is overflowed!!!" )
		return
	end
	local tileData = self.mapData[( tileY - 1 ) * map.width + tileX]
	return tileData == TILE_MAP_ITEM_WALL_1 or
		   tileData == TILE_MAP_ITEM_WALL_2 or 
		   tileData == TILE_MAP_ITEM_WALL_3
end

function GameMap:isTileEmpty( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		print( "ERROR @ GameMap::isTileEmpty - tile x[" .. tileX .. 
				"] or y[" .. tileY .. "] is overflowed!!!" )
		return
	end
	return self.mapData[( tileY - 1 ) * map.width + tileX] == TILE_MAP_ITEM_EMPTY
end
