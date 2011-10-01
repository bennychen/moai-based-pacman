--
--------------------------------------------------------------------------------
--         FILE:  GhostKilledGameState.lua
--        USAGE:  ./GhostKilledGameState.lua 
--  DESCRIPTION:  game state when a ghost is killed
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/25/2011 14:26:57 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "State"
require "StateMachine"
require "GameStage"

GhostKilledGameState = class( State )

function GhostKilledGameState:init( layer )
	State.init( self, "GhostKilledGameState" )

	self.layer = layer
	self.gameMap = GAME_MAP

	self.pacman = ENTITY_MANAGER:getEntity( PACMAN_ID )
	self.blueGhost = ENTITY_MANAGER:getEntity( GHOST_ID_BLUE )
	self.redGhost = ENTITY_MANAGER:getEntity( GHOST_ID_RED )
	self.greenGhost = ENTITY_MANAGER:getEntity( GHOST_ID_GREEN )
	self.yellowGhost = ENTITY_MANAGER:getEntity( GHOST_ID_YELLOW )
end

function GhostKilledGameState:setCurrentKilledGhost( ghost )
	self.killedGhost = ghost
end

function GhostKilledGameState:enter()
	GAME_TIME:pause()
	self.gameMap:show( self.layer )
	self.pacman:show( self.layer )
	self.blueGhost:show( self.layer )
	self.redGhost:show( self.layer )
	self.greenGhost:show( self.layer )
	self.yellowGhost:show( self.layer )

	if ( self.killedGhost ~= nil )
	then
		ghostDeadSound:play()
		self.killedGhost:setDead()
		--self.entryTime = MOAISim:getElapsedTime()
	end
end

function GhostKilledGameState:onUpdate()
	if ( self.killedGhost ~= nil )
	then
		--local currentTime = MOAISim:getElapsedTime()
		--local elapsedTime = currentTime - self.entryTime
		local dyingAnim = self.killedGhost.animatable:getAnimation( Ghost.ANIM_DYING )
		if ( dyingAnim:isDone() and not ghostDeadSound:isPlaying() )--and elapsedTime > GHOST_DEAD_DURATION )
		then
			GAME_STATE_MACHINE:setCurrentState( INPLAY_GAME_STATE )
		end
	end
end

function GhostKilledGameState:exit()
	self.killedGhost:resetToSpawn()
	self.killedGhost:setStandBy()
	GHOST_SCHEDULER:addSchedule( self.killedGhost.id, GHOST_STANDBY_TIME_AFTER_RESPAWN )
	self.killedGhost = nil
end

GHOST_KILLED_GAME_STATE = nil
