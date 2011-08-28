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

TILE_MAP_ITEM_EMPTY = 0
TILE_MAP_ITEM_BEAN = 1
TILE_MAP_ITEM_SUPER_BEAN_1 = 2
TILE_MAP_ITEM_SUPER_BEAN_2 = 3
TILE_MAP_ITEM_SUPER_BEAN = TILE_MAP_ITEM_SUPER_BEAN_2 -- currently using
TILE_MAP_ITEM_WALL_1 = 4
TILE_MAP_ITEM_WALL_2 = 5
TILE_MAP_ITEM_WALL_3 = 6
TILE_MAP_ITEM_WALL = TILE_MAP_ITEM_WALL_3
TILE_MAP_ITEM_BAR = 7

GameMap = class()

function GameMap:init()
	self.tileGrid = MOAIGrid.new()
	self.tileGrid:setSize( map.width, map.height, TILE_SIZE, TILE_SIZE )
	self.mapData = map.layers[1].data
	self.itemNum = {}

	self:resetMap()

	self.remapper = MOAIDeckRemapper.new()
	self.remapper:reserve ( map.width * map.height )

	self.width = TILE_SIZE * map.width
	self.height = TILE_SIZE * map.height

	self.tileMap = MOAIProp2D.new()
	self.tileMap:setDeck( TILE_DECK_2D_MAP )
	self.tileMap:setGrid( self.tileGrid )
	self.tileMap:setLoc( -self.width / 2, -self.height / 2 )

	self.leftTopCorner = MOAITransform.new()
	self.leftTopCorner:setLoc( -self.width / 2, -self.height / 2 )
end

function GameMap:resetMap()
	for i = TILE_MAP_ITEM_EMPTY, TILE_MAP_ITEM_BAR
	do
		self.itemNum[i] = 0
	end

	for i = 1, map.height
	do
		for j = 1, map.width
		do
			local tileData = self.mapData[( i - 1 ) * map.width + j]
			self.tileGrid:setTile( j, i, tileData )
			self.itemNum[tileData] = self.itemNum[tileData] + 1
		end
	end
end

function GameMap:show( layer )
	layer:insertProp( self.tileMap )
end

function GameMap:hide( layer )
	layer:removeProp( self.tileMap )
end

function GameMap:getTileIndex( posX, posY )
	local tileX = math.floor( posX / TILE_SIZE ) + 1
	local tileY = math.floor( posY / TILE_SIZE ) + 1
	return tileX, tileY
end

function GameMap:getLeftTopEmptyTileIndex()
	return 2, 2
end

function GameMap:getRightBottomEmptyTileIndex()
	return map.width - 1, map.height - 1
end

function GameMap:getTileLeftTopLoc( tileX, tileY )
	return TILE_SIZE * ( tileX - 1 ), TILE_SIZE * ( tileY - 1 )
end

function GameMap:getTileCenterLoc( tileX, tileY )
	return TILE_SIZE * ( tileX - 0.5 ), TILE_SIZE * ( tileY - 0.5 )
end

function GameMap:getTileRightBottomLoc( tileX, tileY )
	return TILE_SIZE * tileX, TILE_SIZE * tileY
end

function GameMap:isCollidingBar( leftTopX, leftTopY, rightBottomX, rightBottomY )
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

	if ( self:isTileBar( leftTopTileX, leftTopTileY ) or
		 self:isTileBar( rightBottomTileX, leftTopTileY ) or
		 self:isTileBar( leftTopTileX, rightBottomTileY ) or
		 self:isTileBar( rightBottomTileX, rightBottomTileY ) ) 
	then
		return true
	else
		return false
	end
end

function GameMap:isCollidingWall( leftTopX, leftTopY, rightBottomX, rightBottomY )
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

	if ( self:isTileWall( leftTopTileX, leftTopTileY ) or
		 self:isTileWall( rightBottomTileX, leftTopTileY ) or
		 self:isTileWall( leftTopTileX, rightBottomTileY ) or
		 self:isTileWall( rightBottomTileX, rightBottomTileY ) ) 
	then
		return true
	else
		return false
	end
end

function GameMap:isOverBound( leftTopX, leftTopY, rightBottomX, rightBottomY )
	local EPSILON = TILE_SIZE / 50
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

	return self:isPositionOverBound( leftTopX, leftTopY ) or 
		   self:isPositionOverBound( rightBottomX, rightBottomY )
end

function GameMap:isPositionOverBound( posX, posY )
	return self:isTileOverBound( self:getTileIndex( posX, posY ) )
end

function GameMap:isTileOverBound( tileX, tileY )
	return ( tileX <= 0 or tileY <= 0 or 
			 tileX > map.width or tileY > map.height )
end

function GameMap:isAllBeansCleared()
	return self.itemNum[ TILE_MAP_ITEM_BEAN ] <= 0
end

function GameMap:clearTileBean( tileX, tileY )
	if ( self:isTileBean( tileX, tileY ) )
	then
		self.tileGrid:setTile( tileX, tileY, TILE_MAP_ITEM_EMPTY )
		self.itemNum[ TILE_MAP_ITEM_BEAN ] = self.itemNum[ TILE_MAP_ITEM_BEAN ] - 1
		return true
	else
		return false
	end
end

function GameMap:clearTileSuperBean( tileX, tileY )
	if ( self:isTileSuperBean( tileX, tileY ) )
	then
		self.tileGrid:setTile( tileX, tileY, TILE_MAP_ITEM_EMPTY )
		self.itemNum[ TILE_MAP_ITEM_SUPER_BEAN ] = self.itemNum[ TILE_MAP_ITEM_SUPER_BEAN ] - 1
		return true
	else
		return false
	end
end

function GameMap:isTileBean( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		return false
	end
	return self.tileGrid:getTile( tileX, tileY ) == TILE_MAP_ITEM_BEAN
end

function GameMap:isTileSuperBean( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		return false
	end
	return self.tileGrid:getTile( tileX, tileY ) == TILE_MAP_ITEM_SUPER_BEAN
end

function GameMap:isTileBar( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or
		 tileX > map.width or tileY > map.height )
	then
		return false
	end
	return self.tileGrid:getTile( tileX, tileY ) == TILE_MAP_ITEM_BAR
end

function GameMap:isTileWall( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		return false
	end
	return self.tileGrid:getTile( tileX, tileY ) == TILE_MAP_ITEM_WALL
end

function GameMap:isTileEmpty( tileX, tileY )
	if ( tileX <= 0 or tileY <= 0 or 
		 tileX > map.width or tileY > map.height )
	then
		return false
	end
	return self.tileGrid:getTile( tileX, tileY ) == TILE_MAP_ITEM_EMPTY
end

--singleton
GAME_MAP = nil
