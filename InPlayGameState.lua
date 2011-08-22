
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
	local pacmanSpeed = tileSize * 5
	self.pacman = Pacman( self.gameMap.leftTopCorner, 
			pacmanSpawnPoint, pacmanSpawnDirection, pacmanSpeed )
end

function InPlayGameState:enter()
	print( "entering InPlayGameState..." )

	self.gameMap:drawMap( self.layer )
	self.pacman:resetToSpawn()
	self.pacman:show( self.layer )
	self.pacman:startMovingAnimation()

	MOAIInputMgr.device.keyboard:setCallback( InPlayGameState.onKeyboardEvent )
end

function InPlayGameState:exit()
	print( "exiting InPlayGameState..." )

	self.gameMap:clearMap( self.layer )	
	self.pacman:hide( self.layer )
	self.pacman:stopMovingAnimation()

	MOAIInputMgr.device.keyboard:setCallback( nil )
end

function InPlayGameState:onUpdate()
	if ( not self:willPacmanCollideWall( self.pacman.velocity.direction ) )
	then
		self.pacman:moveOneFrameBySpeed()
		self:pacmanTryEatBean()
		self:pacmanTryEatSuperBean()
	end

	if ( self.pacman.isSeekingPath == true )
	then
		self:seekPathForPacman( self.pacman.desiredDirection )
	end
end

function InPlayGameState:seekPathForPacman( desiredDirection )
	if ( not self:willPacmanCollideWall( self.pacman.desiredDirection ) )
	then
		self.pacman:setDirection( self.pacman.desiredDirection )
		self.pacman.isSeekingPath = false
	elseif ( self:willPacmanCollideWall( self.pacman.velocity.direction ) )
	then
		print( "seek path failed, both current direction and desired direction are not passable" )
		self.pacman.isSeekingPath = false
	end
end

function InPlayGameState:willPacmanCollideWall( direction )
	local pacmanLeftTopX = 0
	local pacmanLeftTopY = 0
	local pacmanRightBottomX = 0
	local pacmanRightBottomY = 0
	pacmanLeftTopX, pacmanLeftTopY = self.pacman:getLeftTopLoc() 
	pacmanRightBottomX, pacmanRightBottomY = 
		self.pacman:getRightBottomLoc( pacmanLeftTopX, pacmanLeftTopY )

	pacmanSpeed = self.pacman.velocity.speed
	local displacementX = 0
	local displacementY = 0
	local vel = Velocity( pacmanSpeed, direction )
	displacementX, displacementY = vel:getDisplacement( FRAME_TIME )
	pacmanLeftTopX = pacmanLeftTopX + displacementX
	pacmanLeftTopY = pacmanLeftTopY + displacementY
	pacmanRightBottomX = pacmanRightBottomX + displacementX
	pacmanRightBottomY = pacmanRightBottomY + displacementY

	return self.gameMap:isCollidingWall( pacmanLeftTopX, pacmanLeftTopY, 
			pacmanRightBottomX, pacmanRightBottomY )
end

function InPlayGameState:isPacmanCollidingWall()
	local pacmanLeftTopX = 0
	local pacmanLeftTopY = 0
	local pacmanRightBottomX = 0
	local pacmanRightBottomY = 0
	pacmanLeftTopX, pacmanLeftTopY = self.pacman:getLeftTopLoc() 
	pacmanRightBottomX, pacmanRightBottomY = 
		self.pacman:getRightBottomLoc( pacmanLeftTopX, pacmanLeftTopY )
	return self.gameMap:isCollidingWall( pacmanLeftTopX, pacmanLeftTopY, 
			pacmanRightBottomX, pacmanRightBottomY )
end

function InPlayGameState:pacmanTryEatBean()
	local pacmanCenterX = 0
	local pacmanCenterY = 0
	pacmanCenterX, pacmanCenterY = self.pacman:getCenterLoc()
	self.gameMap:clearTileBean( 
			self.gameMap:getTileIndex( pacmanCenterX, pacmanCenterY ) )
end

function InPlayGameState:pacmanTryEatSuperBean()
	local pacmanCenterX = 0
	local pacmanCenterY = 0
	pacmanCenterX, pacmanCenterY = self.pacman:getCenterLoc()
	self.gameMap:clearTileSuperBean( 
			self.gameMap:getTileIndex( pacmanCenterX, pacmanCenterY ) )
end

function InPlayGameState:tryChangePacmanDirection( direction )
	if ( direction == self.pacman.velocity.direction )
	then
		return
	end

	if ( self:willPacmanCollideWall( direction ) )
	then
		self.pacman.desiredDirection = direction
		self.pacman.isSeekingPath = true
	else
		self.pacman:setDirection( direction )
	end
end

-- singleton, will be initialized when initializing game
INPLAY_GAME_STATE = nil

function InPlayGameState.onKeyboardEvent( key, down )
	if ( INPLAY_GAME_STATE == nil or up )
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
