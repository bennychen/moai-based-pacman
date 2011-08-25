
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
	self.gameMap:show( self.layer )

	self.pacman:startMoving()

	self.blueGhost:setAIStrategy( GHOST_AI_RANDOM )
	self.redGhost:setAIStrategy( GHOST_AI_RANDOM )
	self.greenGhost:setAIStrategy( GHOST_AI_CHASER )
	self.yellowGhost:setAIStrategy( GHOST_AI_CHASER )

	self.blueGhost:setStandBy()
	self.redGhost:setStandBy()
	self.greenGhost:setStandBy()
	self.yellowGhost:setStandBy()

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
	self:launchGhosts()
	self:updatePacman()
	self:updateGhosts()
	self:detectPacmanGhostsCollision()
	--print( MOAISim:getPerformance() )
end

function InPlayGameState:launchGhosts()
	local currentTime = MOAISim:getElapsedTime()
	local stateElapsedTime = currentTime - self.entryTime
	if ( self.blueGhost.state == Ghost.STATE_STANDBY and
		 stateElapsedTime > GHOST_BLUE_STANDBY_TIME )
	then
		self.blueGhost:startPursuing()
	end
	if ( self.redGhost.state == Ghost.STATE_STANDBY and
		 stateElapsedTime > GHOST_RED_STANDBY_TIME )
	then
		self.redGhost:startPursuing()
	end
	if ( self.greenGhost.state == Ghost.STATE_STANDBY and
		 stateElapsedTime > GHOST_GREEN_STANDBY_TIME )
	then
		self.greenGhost:startPursuing()
	end
	if ( self.yellowGhost.state == Ghost.STATE_STANDBY and
		 stateElapsedTime > GHOST_YELLOW_STANDBY_TIME )
	then
		self.yellowGhost:startPursuing()
	end
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
		ghost:doPathFinding()
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
	GHOST_EVADE_DURATION = 5 --TODO
	self.blueGhost:startEvading( GHOST_EVADE_DURATION )
	self.redGhost:startEvading( GHOST_EVADE_DURATION )
	self.greenGhost:startEvading( GHOST_EVADE_DURATION )
	self.yellowGhost:startEvading( GHOST_EVADE_DURATION )
end

function InPlayGameState:seekPathForPacman( desiredDirection )
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
			ghost:setDead()
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

