--
--------------------------------------------------------------------------------
--         FILE:  PauseGameState.lua
--        USAGE:  ./PauseGameState.lua 
--  DESCRIPTION:  game state when game is paused
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/25/2011 20:07:26 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

PauseGameState = class( State )

function PauseGameState:init( layer )
	State.init( self, "PauseGameState" )

	self.layer = layer
	self.gameMap = GAME_MAP
	self.pacman = ENTITY_MANAGER:getEntity( PACMAN_ID )
	self.blueGhost = ENTITY_MANAGER:getEntity( GHOST_ID_BLUE )
	self.redGhost = ENTITY_MANAGER:getEntity( GHOST_ID_RED )
	self.greenGhost = ENTITY_MANAGER:getEntity( GHOST_ID_GREEN )
	self.yellowGhost = ENTITY_MANAGER:getEntity( GHOST_ID_YELLOW )

	self.pauseProp = MOAIProp2D.new()
	self.pauseProp:setDeck( QUAD_2D_PAUSE )
	self.pauseProp:setLoc( BASE_LOCATION_X, BASE_LOCATION_Y )
end

function PauseGameState:enter()
	GAME_TIME:pause()
	self.layer:insertProp( self.pauseProp )
	self.gameMap:show( self.layer )
	self.pacman:show( self.layer )
	self.blueGhost:show( self.layer )
	self.redGhost:show( self.layer )
	self.greenGhost:show( self.layer )
	self.yellowGhost:show( self.layer )
	
	MOAIInputMgr.device.keyboard:setCallback( PauseGameState.onKeyboardEvent )
end

function PauseGameState:exit()
	self.layer:removeProp( self.pauseProp )
	self.gameMap:hide( self.layer )
	self.pacman:hide( self.layer )
	self.blueGhost:hide( self.layer )
	self.redGhost:hide( self.layer )
	self.greenGhost:hide( self.layer )
	self.yellowGhost:hide( self.layer )

	MOAIInputMgr.device.keyboard:setCallback( nil )
end

--singleton
PAUSE_GAME_STATE = nil

function PauseGameState.onKeyboardEvent( key, down )
	if ( PAUSE_GAME_STATE == nil or down == false )
	then
		return
	end

	if ( key == KEYBOARD_ESC )
	then
		GAME_STATE_MACHINE:setCurrentState( INPLAY_GAME_STATE )
	end

end
