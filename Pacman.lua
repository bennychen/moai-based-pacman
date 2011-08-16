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

function Pacman:init( parentTransform, spawnPoint, spawnDirection )
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
	--TODO: pass speed from param
	self.velocity = Velocity( 50, spawnDirection )
	self.isMoving = false
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

		if ( self.isMoving )
		then
			self:stopMovingWithAnimation()
			self.velocity:setDirection( direction )
			self:startMovingWithAnimation()
		else
			self:stopMovingAnimation()
			self.velocity:setDirection( direction )
			self:startMovingAnimation()
		end
	else
		print( "ERROR @ Pacman:setDirection - failed, invalid direction" )
	end
end

function Pacman:startMovingWithAnimation()
	self:startMovingAnimation()
	self:startMoving()
end

function Pacman:stopMovingWithAnimation()
	self:stopMoving()
	self:stopMovingAnimation()
end

function Pacman:startMovingAnimation()
	local direction = self.velocity.direction
	self.prop:setIndex( self:getMovingAnimStartDeckIndex( direction ) )
	self.movingAnim[direction]:start()
end

function Pacman:stopMovingAnimation()
	self.movingAnim[self.velocity.direction]:stop()
end

function Pacman:startMoving()
	if ( self.isMoving == nil or self.isMoving == false )
	then
		self.isMoving = true
		if ( self.movingThread == nil )
		then
			self.movingThread = MOAIThread.new()
		end
		self.movingThread:run( Pacman.movingThreadMain, self )
	end
end

function Pacman:stopMoving()
	if ( self.isMoving == nil or self.isMoving == true )
	then
		self.isMoving = false
		self.movingAction:stop()
		self.movingThread:stop()
	end
end

function Pacman:movingThreadMain()
	local deltaX = nil
	local deltaY = nil
	while ( self.isMoving == true )
	do
		MOVE_ANIMATION_UPDATE_TIME = 100
		deltaX, deltaY = self.velocity:getDisplacement( MOVE_ANIMATION_UPDATE_TIME )
		self.movingAction = self.prop:moveLoc( deltaX, deltaY, MOVE_ANIMATION_UPDATE_TIME, MOAIEaseType.LINEAR )
		while ( self.movingAction:isBusy() )
		do
			coroutine.yield()
		end
	end
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
	self.prop:setLoc( gridSize * ( self.spawnPoint.x - 1 ),
				       -gridSize * ( self.spawnPoint.y - 1 ) )
	self:setDirection( self.spawnDirection )
end
