--
--------------------------------------------------------------------------------
--         FILE:  GameEntity.lua
--        USAGE:  ./GameEntity.lua 
--  DESCRIPTION:  base class for game entity of Pacman
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 15:45:46 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "Animatable"
require "Velocity"

GameEntity = class()

function GameEntity:init( parentTransform, spawnPoint, spawnDirection, speed, tileDeck2D, spriteNum )
	self.animatable = Animatable( tileDeck2D, spriteNum )
	self.prop = self.animatable.prop
	self.prop:setParent( parentTransform )

	self.spawnPoint = spawnPoint
	self.spawnDirection = spawnDirection
	self.velocity = Velocity( speed, spawnDirection )
end

function GameEntity:moveOneFrameBySpeed()
	local displacementX = 0
	local displacementY = 0
	displacementX, displacementY = self.velocity:getDisplacement( FRAME_TIME )
	self.prop:addLoc( displacementX, displacementY )
end

function GameEntity:revertOneFrameBySpeed()
	local displacementX = 0
	local displacementY = 0
	displacementX, displacementY = self.velocity:getDisplacement( FRAME_TIME )
	self.prop:addLoc( -displacementX, -displacementY )
end

function GameEntity:getLeftTopLoc()
	return self.prop:getLoc()
end

function GameEntity:getCenterLoc( leftTopX, leftTopY )
	if ( leftTopX == nil or leftTopY == nil )
	then
		leftTopX, leftTopY = self:getLeftTopLoc()
	end
	return leftTopX + GAME_ENTITY_SIZE / 2, leftTopY + GAME_ENTITY_SIZE / 2
end

function GameEntity:getRightBottomLoc( leftTopX, leftTopY )
	if ( leftTopX == nil or leftTopY == nil )
	then
		leftTopX, leftTopY = self:getLeftTopLoc()
	end
	return leftTopX + GAME_ENTITY_SIZE, leftTopY + GAME_ENTITY_SIZE
end

function GameEntity:show( layer )
	layer:insertProp( self.prop )
	self.visible = true
end

function GameEntity:hide( layer )
	layer:removeProp( self.prop )
	self.visible = true
end

function GameEntity:setDirection( direction )
	self.velocity:setDirection( direction )
end

function GameEntity:resetToSpawn( layer )
	self.prop:setLoc( TILE_SIZE * ( self.spawnPoint.x - 1 ),
				      TILE_SIZE * ( self.spawnPoint.y - 1 ) )
	self:setDirection( self.spawnDirection )
end

function GameEntity:startCurentAnimation()
	self.animatable:startCurentAnimation()
end

function GameEntity:stopCurrentAnimation()
	self.animatable:stopCurrentAnimation()
end
