--
--------------------------------------------------------------------------------
--         FILE:  Pacman.lua
--        USAGE:  ./Pacman.lua 
--  DESCRIPTION:  class for handling Pacman controlled by user
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/14/2011 18:16:47 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "Velocity"
require "Vector2"

Pacman = class()

function Pacman:init( parentTransform, spawnPoint, spawnDirection, speed )
	self.stateMachine = StateMachine()

	self.prop = MOAIProp2D.new()
	self.prop:setDeck( TILE_DECK_2D_PACMAN )
	self.animRemapper = MOAIDeckRemapper.new()
	self.animRemapper:reserve( pacmanSpriteNum )
	self.prop:setRemapper( self.animRemapper )
	self.prop:setParent( parentTransform )

	self:initAnimation()

	self.spawnPoint = spawnPoint
	self.spawnDirection = spawnDirection
	self.velocity = Velocity( speed, spawnDirection )
end

function Pacman:initAnimation()
	self:initMovingAnimations()
	self:initDyingAnimation()
end

function Pacman:setDirection( direction )
	if ( direction > DIRECTION_LOWER_BOUND and direction < DIRECTION_UPPER_BOUND )
	then
		if ( direction == self.velocity.direction )
		then
			return
		end

		self:stopMovingAnimation()
		self.velocity:setDirection( direction )
		self:startMovingAnimation()
	else
		print( "ERROR @ Pacman:setDirection - failed, invalid direction" )
	end
end

function Pacman:startMovingAnimation()
	local direction = self.velocity.direction
	self.prop:setIndex( self:getMovingAnimStartDeckIndex( direction ) )
	self.movingAnim[direction]:start()
end

function Pacman:stopMovingAnimation()
	self.movingAnim[self.velocity.direction]:stop()
end

function Pacman:moveOneFrameBySpeed()
	local displacementX = 0
	local displacementY = 0
	displacementX, displacementY = self.velocity:getDisplacement( FRAME_TIME )
	self.prop:addLoc( displacementX, displacementY )
end

function Pacman:revertOneFrameBySpeed()
	local displacementX = 0
	local displacementY = 0
	displacementX, displacementY = self.velocity:getDisplacement( FRAME_TIME )
	self.prop:addLoc( -displacementX, -displacementY )
end

function Pacman:getLeftTopLoc()
	return self.prop:getLoc()
end

function Pacman:getCenterLoc( leftTopX, leftTopY )
	if ( leftTopX == nil or leftTopY == nil )
	then
		leftTopX, leftTopY = self:getLeftTopLoc()
	end
	return leftTopX + pacmanWidth / 2, leftTopY + pacmanHeight / 2
end

function Pacman:getRightBottomLoc( leftTopX, leftTopY )
	if ( leftTopX == nil or leftTopY == nil )
	then
		leftTopX, leftTopY = self:getLeftTopLoc()
	end
	return leftTopX + pacmanWidth, leftTopY + pacmanHeight
end

function Pacman:show( layer )
	layer:insertProp( self.prop )
end

function Pacman:hide( layer )
	layer:removeProp( self.prop )
end

function Pacman:setCurrentState( state )
	self.stateMachine:setCurrentState( state )
end

function Pacman:initMovingAnimations()
	self.movingAnim = {}
	for direction = DIRECTION_LEFT, DIRECTION_DOWN
	do
		self:initMovingAnimation( direction )
	end
end

function Pacman:initMovingAnimation( direction )
	local animStartDeckIndex = self:getMovingAnimStartDeckIndex( direction ) 

	local moveCurve = MOAIAnimCurve.new()
	moveCurve:reserveKeys( 3 )
	moveCurve:setKey( 1, 0.00, animStartDeckIndex, MOAIEaseType.FLAT )
	moveCurve:setKey( 2, 0.20, animStartDeckIndex + 1, MOAIEaseType.FLAT )
	moveCurve:setKey( 3, 0.40, animStartDeckIndex, MOAIEaseType.FLAT )

	self.movingAnim[direction] = MOAIAnim:new()
	self.movingAnim[direction]:reserveLinks( 1 )
	self.movingAnim[direction]:setLink( 1, moveCurve, self.animRemapper, animStartDeckIndex )
	self.movingAnim[direction]:setMode( MOAITimer.LOOP )
end

function Pacman:initDyingAnimation()
	local dyingAnimBeginDeckIndex = 9
	local dyingAnimEndDeckIndex = 13
	local dyingAnimFrameNum = dyingAnimEndDeckIndex - dyingAnimBeginDeckIndex + 1 

	local dyingCurve = MOAIAnimCurve.new()
	dyingCurve:reserveKeys( dyingAnimEndDeckIndex - dyingAnimBeginDeckIndex + 1 )
	for frame = 1, dyingAnimEndDeckIndex
	do
		dyingCurve:setKey( frame, ( frame - 1 ) * 0.30, 
				dyingAnimBeginDeckIndex + frame - 1, MOAIEaseType.FLAT )
	end

	self.dyingAnim = MOAIAnim.new()
	self.dyingAnim:reserveLinks( 1 )
	self.dyingAnim:setLink( 1, dyingCurve, self.animRemapper, dyingAnimBeginDeckIndex )
	self.dyingAnim:setMode( MOAITimer.NORMAL )
end

function Pacman:getMovingAnimStartDeckIndex( direction )
	return ( direction * 2 - 1 )
end

function Pacman:resetToSpawn( layer )
	self.prop:setLoc( tileSize * ( self.spawnPoint.x - 1 ),
				      tileSize * ( self.spawnPoint.y - 1 ) )
	self:setDirection( self.spawnDirection )
end
