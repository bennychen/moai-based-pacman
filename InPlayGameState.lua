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
	local pacmanSpeed = tileSize * 5
	self.pacman = Pacman( self.gameMap.leftTopCorner, 
			pacmanSpawnPoint, pacmanSpawnDirection, pacmanSpeed )
end

function InPlayGameState:enter()
	print( "entering InPlayGameState..." )

	self.gameMap:drawMap( self.layer )
	self.pacman:resetToSpawn()

	self.pacman:show( self.layer )

	if ( self.mainThread == nil )
	then
		self.mainThread = MOAIThread.new()
	end
	self.mainThread:run( InPlayGameState.onUpdate, self )

	self.pacman:startMovingWithAnimation()

	MOAIInputMgr.device.keyboard:setCallback( InPlayGameState.onKeyboardEvent )
end

function InPlayGameState:exit()
	print( "exiting InPlayGameState..." )

	self.gameMap:clearMap( self.layer )	
	self.pacman:hide( self.layer )
	self.pacman:stopMovingWithAnimation()

	self.mainThread:stop()
	MOAIInputMgr.device.keyboard:setCallback( nil )
end

function InPlayGameState:onUpdate()
	while ( true )
	do
		local x
		local y
		if ( self.pacman.isMoving == true )
		then
			if ( self:isPacmanCollidingWall() )
			then
				--x, y = self.pacman:getAbsolutePosition()
				--printVar( x, "pacmanLeftTopX before stop moving" )
				--printVar( y, "pacmanLeftTopY before stop moving" )
				self.pacman:stopMoving()
				self.pacman:revertOneFrameBySpeed()
			end
--		else
--			if ( printed == nil )
--			then
--				x, y = self.pacman:getAbsolutePosition()
--				printVar( x, "pacmanLeftTopX after stop moving" )
--				printVar( y, "pacmanLeftTopY after stop moving" )
--				printed = true
--			end
		end

		if ( self.pacman.isSeekingPath == true )
		then
			self:seekPathForPacman( self.pacman.desiredDirection )
		end

		coroutine.yield()
	end
end

function InPlayGameState:seekPathForPacman( desiredDirection )
	if ( not self:willPacmanCollideWall( self.pacman.desiredDirection ) )
	then
		self:changePacmanDirection( self.pacman.desiredDirection )
		self.pacman.isSeekingPath = false
	elseif ( self:willPacmanCollideWall( self.pacman.velocity.direction ) )
	then
		--print( "seek path failed, both current direction and desired direction are not passable" )
		self.pacman.isSeekingPath = false
	end
end

function InPlayGameState:willPacmanCollideWall( direction )
	local pacmanLeftTopX = 0
	local pacmanLeftTopY = 0
	local pacmanRightBottomX = 0
	local pacmanRightBottomY = 0
	pacmanLeftTopX, pacmanLeftTopY = self.pacman:getAbsolutePosition() 
	pacmanRightBottomX = pacmanLeftTopX + pacmanWidth
	pacmanRightBottomY = pacmanLeftTopY + pacmanHeight

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
	pacmanLeftTopX, pacmanLeftTopY = self.pacman:getAbsolutePosition() 
	pacmanRightBottomX = pacmanLeftTopX + pacmanWidth
	pacmanRightBottomY = pacmanLeftTopY + pacmanHeight
	return self.gameMap:isCollidingWall( pacmanLeftTopX, pacmanLeftTopY, 
			pacmanRightBottomX, pacmanRightBottomY )
end

function InPlayGameState:tryChangePacmanDirection( direction )
	printed = nil --TODO:remove this
	local pacmanLeftTopX = 0
	local pacmanLeftTopY = 0
	pacmanLeftTopX, pacmanLeftTopY = self.pacman:getAbsolutePosition() 

	if ( self:willPacmanCollideWall( direction ) )
	then
		self.pacman.desiredDirection = direction
		self.pacman.isSeekingPath = true
	else
		self:changePacmanDirection( direction )	
	end
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
