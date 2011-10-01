--
--------------------------------------------------------------------------------
--         FILE:  PacmanKilledGameState.lua
--        USAGE:  ./PacmanKilledGameState.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 22:48:19 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "State"
require "StateMachine"

PacmanKilledGameState = class( State )

function PacmanKilledGameState:init( layer )
	State.init( self, "PacmanKilledGameState" )

	self.layer = layer
	self.gameMap = GAME_MAP
	self.pacman = ENTITY_MANAGER:getEntity( PACMAN_ID )
end

function PacmanKilledGameState:enter()
	GAME_TIME:pause()
	self.gameMap:show( self.layer )
	self.pacman:show( self.layer )
	self.pacman:setDead()
	backgroundMusic:stop()
	pacmanDeadSound:play()
end

function PacmanKilledGameState:onUpdate()
	local dyingAnim = self.pacman.animatable:getAnimation( Pacman.ANIM_DYING )
	if ( dyingAnim:isDone() and not pacmanDeadSound:isPlaying() )
	then
		GAME_STATE_MACHINE:setCurrentState( STAGE_INTRO_GAME_STATE )
	end
end

function PacmanKilledGameState:exit()
	self.gameMap:hide( self.layer )
	self.pacman:hide( self.layer )
end

PACMAN_KILLED_GAME_STATE = nil
