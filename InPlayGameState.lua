
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
require "Ghost"
require "CollisionDetection"

InPlayGameState = class( State )

function InPlayGameState:init( layer )
	State.init( self, "InPlayGameState" )

	self.layer = layer
	self.gameMap = GAME_MAP
	self.pacman = ENTITY_MANAGER:getEntity( PACMAN_ID )
	self.blueGhost = ENTITY_MANAGER:getEntity( GHOST_ID_BLUE )
	self.redGhost = ENTITY_MANAGER:getEntity( GHOST_ID_RED )
	self.greenGhost = ENTITY_MANAGER:getEntity( GHOST_ID_GREEN )
	self.yellowGhost = ENTITY_MANAGER:getEntity( GHOST_ID_YELLOW )
end

function InPlayGameState:enter()
	GAME_TIME:resume()
	self.gameMap:show( self.layer )
	
	self.pacman:show( self.layer )
	self.pacman:startMoving()

	self.blueGhost:show( self.layer )
	self.blueGhost:startCurentAnimation()
	self.redGhost:show( self.layer )
	self.redGhost:startCurentAnimation()
	self.greenGhost:show( self.layer )
	self.greenGhost:startCurentAnimation()
	self.yellowGhost:show( self.layer )
	self.yellowGhost:startCurentAnimation()

	self.entryTime = MOAISim:getElapsedTime()
	MOAIInputMgr.device.keyboard:setCallback( InPlayGameState.onKeyboardEvent )
end

function InPlayGameState:exit()
	self.gameMap:hide( self.layer )	
	self.pacman:hide( self.layer )
	self.pacman:stopCurrentAnimation()

	self.blueGhost:hide( self.layer )
	self.blueGhost:stopCurrentAnimation()
	self.redGhost:hide( self.layer )
	self.redGhost:stopCurrentAnimation()
	self.greenGhost:hide( self.layer )
	self.greenGhost:stopCurrentAnimation()
	self.yellowGhost:hide( self.layer )
	self.yellowGhost:stopCurrentAnimation()

	MOAIInputMgr.device.keyboard:setCallback( nil )
end

function InPlayGameState:onUpdate()
	GHOST_SCHEDULER:updateSchedules()
	self:updatePacman()
	self:updateGhosts()
	self:detectPacmanGhostsCollision()
	--print( MOAISim:getPerformance() )
end

function InPlayGameState:updatePacman()
	if ( not CollisionDetection.willPacmanCollideBarrier( self.gameMap, 
				self.pacman, self.pacman.velocity.direction ) )
	then
		if ( self:willPacmanOverBound( self.pacman.velocity.direction ) )
		then
			self:crossBound( self.pacman )
		end

		self.pacman:moveOneFrameBySpeed()

		if ( self:pacmanTryEatBean() )
		then
			self:onBeanEatten()
		end

		if ( self:pacmanTryEatSuperBean() )
		then
			self:onSuperBeanEatten()
		end
	end

	if ( self.pacman.isSeekingPath == true )
	then
		self:seekPathForPacman( self.pacman.desiredDirection )
	end
end

function InPlayGameState:updateGhosts()
	self:updateGhost( self.blueGhost )
	self:updateGhost( self.redGhost )
	self:updateGhost( self.greenGhost )
	self:updateGhost( self.yellowGhost )
end

function InPlayGameState:updateGhost( ghost )
	if ( not ghost:isActive() )
	then
		return
	end
	
	if ( self:willGhostOverBound( ghost, ghost.velocity.direction ) )
	then
		self:crossBound( ghost )
	else
		ghost:update()
	end
	if ( self:willGhostCrossBar( ghost, ghost.velocity.direction ) )
	then
		ghost.canCrossBar = false
	end
	ghost:moveOneFrameBySpeed()
end

function InPlayGameState:onBeanEatten()
	if ( self.gameMap:isAllBeansCleared() )
	then
		GAME_STATE_MACHINE:setCurrentState( STAGE_CLEARED_GAME_STATE )
	end
end

function InPlayGameState:onSuperBeanEatten()
	self.blueGhost:performSpell( GHOST_EVADE_DURATION )
	self.redGhost:performSpell( GHOST_EVADE_DURATION )
	self.greenGhost:performSpell( GHOST_EVADE_DURATION )
	self.yellowGhost:performSpell( GHOST_EVADE_DURATION )
end

function InPlayGameState:seekPathForPacman( desiredDirection )
	if ( self:willPacmanOverBound( self.pacman.velocity.direction ) )
	then
		return
	end
	if ( not CollisionDetection.willPacmanCollideBarrier( self.gameMap, 
				self.pacman, self.pacman.desiredDirection ) )
	then
		self.pacman:setDirectionWithAnimation( self.pacman.desiredDirection )
		self.pacman.isSeekingPath = false
	elseif ( CollisionDetection.willPacmanCollideBarrier( self.gameMap, 
				self.pacman, self.pacman.velocity.direction ) )
	then
		print( "seek path failed, both current direction and desired direction are not passable" )
		self.pacman.isSeekingPath = false
	end
end

function InPlayGameState:detectPacmanGhostsCollision()
	self:detectPacmanGhostCollision( self.blueGhost )
	self:detectPacmanGhostCollision( self.redGhost )
	self:detectPacmanGhostCollision( self.greenGhost )
	self:detectPacmanGhostCollision( self.yellowGhost )
end

function InPlayGameState:detectPacmanGhostCollision( ghost )
	if ( ghost:isActive() and self:isPacmanCollidingGhost( ghost ) )
	then
		if ( ghost.state == Ghost.STATE_PURSUE )
		then
			GAME_STATE_MACHINE:setCurrentState( PACMAN_KILLED_GAME_STATE )
		elseif ( ghost.state == Ghost.STATE_EVADE )
		then
			GHOST_KILLED_GAME_STATE:setCurrentKilledGhost( ghost )
			GAME_STATE_MACHINE:setCurrentState( GHOST_KILLED_GAME_STATE )
		end
	end
end

function InPlayGameState:willGhostCollideWall( ghost, direction )
	return CollisionDetection.willCollideWall( self.gameMap, ghost, direction )
end

function InPlayGameState:willPacmanOverBound( direction )
	return CollisionDetection.willOverBound( self.gameMap, self.pacman, direction )
end

function InPlayGameState:willGhostCrossBar( ghost, direction )
	if ( CollisionDetection.isCollidingBar( self.gameMap, ghost ) and 
		 not CollisionDetection.willCollideBar( self.gameMap, ghost, direction ) )
	then
		return true
	end
	return false
end

function InPlayGameState:willGhostOverBound( ghost, direction )
	return CollisionDetection.willOverBound( self.gameMap, ghost, direction )
end

function InPlayGameState:isPacmanCollidingGhost( ghost )
	return CollisionDetection.isEntityColliding( self.pacman, ghost )
end

function InPlayGameState:pacmanTryEatBean()
	local pacmanCenterX = 0
	local pacmanCenterY = 0
	pacmanCenterX, pacmanCenterY = self.pacman:getCenterLoc()
	return self.gameMap:clearTileBean( 
			self.gameMap:getTileIndex( pacmanCenterX, pacmanCenterY ) )
end

function InPlayGameState:pacmanTryEatSuperBean()
	local pacmanCenterX = 0
	local pacmanCenterY = 0
	pacmanCenterX, pacmanCenterY = self.pacman:getCenterLoc()
	return self.gameMap:clearTileSuperBean( 
			self.gameMap:getTileIndex( pacmanCenterX, pacmanCenterY ) )
end

function InPlayGameState:crossBound( entity )
	local leftTopX
	local leftTopY
	local rightBottomX
	local rightBottomY
	
	leftTopX, leftTopY = entity:getLeftTopLoc()
	rightBottomX, rightBottomY = entity:getRightBottomLoc( leftTopX, leftTopY )

	if ( rightBottomX < 0 )
	then
		entity.prop:addLoc( self.gameMap.width + GAME_ENTITY_SIZE )
	elseif ( leftTopX > self.gameMap.width )
	then
		entity.prop:addLoc( -self.gameMap.width - GAME_ENTITY_SIZE )
	elseif ( rightBottomY < 0 )
	then
		entity.prop:addLoc( self.gameMap.height + GAME_ENTITY_SIZE )
	elseif ( leftTopY > self.gameMap.height )
	then
		entity.prop:addLoc( -self.gameMap.height - GAME_ENTITY_SIZE )
	end
end

function InPlayGameState:tryChangePacmanDirection( direction )
	if ( direction == self.pacman.velocity.direction )
	then
		return
	end

	if ( CollisionDetection.willPacmanCollideBarrier( self.gameMap, 
				self.pacman, direction ) )
	then
		self.pacman.desiredDirection = direction
		self.pacman.isSeekingPath = true
	else
		self.pacman:setDirectionWithAnimation( direction )
	end
end

-- singleton, will be initialized when initializing game
INPLAY_GAME_STATE = nil

function InPlayGameState.onKeyboardEvent( key, down )
	if ( INPLAY_GAME_STATE == nil or down == false )
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
	elseif ( key == KEYBOARD_ESC )
	then
		GAME_STATE_MACHINE:setCurrentState( PAUSE_GAME_STATE )
	end

end

