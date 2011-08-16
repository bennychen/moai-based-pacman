--
--------------------------------------------------------------------------------
--         FILE:  InPlayGameState.lua
--        USAGE:  ./InPlayGameState.lua 
--  DESCRIPTION:  Game State of playing Pacman game
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/10/2011 14:21:44 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "State"
require "GameMap"
require "Pacman"

InPlayGameState = class( State )

function InPlayGameState:init( layer )
	self.layer = layer
	self.gameMap = GameMap()
	local pacmanSpawnPoint = Vector2( 14, 24 )
	local pacmanSpawnDirection = DIRECTION_LEFT
	self.pacman = Pacman( self.gameMap.leftTopCorner, pacmanSpawnPoint, pacmanSpawnDirection )
end

function InPlayGameState:enter()
	print( "entering InPlayGameState..." )

	self.gameMap:drawMap( self.layer )
	self.pacman:resetToSpawn()

	self.pacman:show( self.layer )
	self.pacman:startMovingWithAnimation()

	if ( self.collisionDetectThread == nil )
	then
		self.collisionDetectThread = MOAIThread.new()
	end
	self.collisionDetectThread:run( InPlayGameState.collisionDetect, self )

	MOAIInputMgr.device.keyboard:setCallback( InPlayGameState.onKeyboardEvent )
end

function InPlayGameState:exit()
	print( "exiting InPlayGameState..." )

	self.gameMap:clearMap( self.layer )	
	self.pacman:hide( self.layer )
	self.pacman:stopMovingWithAnimation()

	MOAIInputMgr.device.keyboard:setCallback( nil )
end

function InPlayGameState:collisionDetect()
	while ( true )
	do
		if ( self:isPacmanCollidingWall() )
		then
			self.pacman:stopMoving()
		end

		coroutine.yield()
	end
end

function InPlayGameState:isPacmanCollidingWall()
	local pacmanLeftTopX = 0
	local pacmanLeftTopY = 0
	local pacmanRightBottomX = 0
	local pacmanRightBottomY = 0
	--local position relative to parent transform
	pacmanLeftTopX, pacmanLeftTopY = self.pacman.prop:getLoc() 
	pacmanLeftTopY = -pacmanLeftTopY
	pacmanCenterX = pacmanLeftTopX + pacmanWidth / 2
	pacmanCenterY = pacmanLeftTopY + pacmanHeight / 2
	pacmanRightBottomX = pacmanLeftTopX + pacmanWidth
	pacmanRightBottomY = pacmanLeftTopY + pacmanHeight

	local pacmanDirection = self.pacman.velocity.direction
	local basePointX = 0
	local basePointY = 0
	if ( pacmanDirection == DIRECTION_LEFT )
	then
		basePointX = pacmanLeftTopX
		basePointY = pacmanCenterY
	elseif ( pacmanDirection == DIRECTION_UP )
	then
		basePointX = pacmanCenterX
		basePointY = pacmanLeftTopY
	elseif ( pacmanDirection == DIRECTION_RIGHT )
	then
		basePointX = pacmanRightBottomX
		basePointY = pacmanCenterY
	elseif ( pacmanDirection == DIRECTION_DOWN )
	then
		basePointX = pacmanCenterX
		basePointY = pacmanRightBottomY
	end

	local gridX = basePointX / gridSize
	local gridY = basePointY / gridSize
	gridX = math.floor( gridX ) + 1
	gridY = math.floor( gridY ) + 1
	return self.gameMap:isGridWall( gridX, gridY )
end

function InPlayGameState:tryChangePacmanDirection( direction )
	local pacmanLeftTopX = 0
	local pacmanLeftTopY = 0
	pacmanLeftTopX, pacmanLeftTopY = self.pacman.prop:getLoc()
	pacmanLeftTopY = -pacmanLeftTopY

	local pacmanDirection = self.pacman.velocity.direction
	if ( Velocity.isReversedDirection( direction, pacmanDirection ) or
		 self.pacman.isMoving == false )
	then
		self:changePacmanDirection( direction )	
	else
		self.pacman.potentialDirection = direction
	end

	--TODO: finish this function
end

function InPlayGameState:changePacmanDirection( direction )
	self.pacman:setDirection( direction )
	if ( INPLAY_GAME_STATE.pacman.isMoving == false )
	then
		INPLAY_GAME_STATE.pacman:startMoving()
	end
end

-- singleton, will be initialized when initializing game
INPLAY_GAME_STATE = nil

function InPlayGameState.onKeyboardEvent( key, down )
	if ( INPLAY_GAME_STATE == nil or down )
	then
		return
	end

	if ( key == KEYBOARD_I )
	then
		INPLAY_GAME_STATE:tryChangePacmanDirection( DIRECTION_UP )
	elseif ( key == KEYBOARD_J )
	then
		INPLAY_GAME_STATE:tryChangePacmanDirection( DIRECTION_LEFT )
	elseif ( key == KEYBOARD_K )
	then
		INPLAY_GAME_STATE:tryChangePacmanDirection( DIRECTION_DOWN )
	elseif ( key == KEYBOARD_L )
	then
		INPLAY_GAME_STATE:tryChangePacmanDirection( DIRECTION_RIGHT )
	end

end
