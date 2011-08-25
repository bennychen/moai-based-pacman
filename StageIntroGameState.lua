--
--------------------------------------------------------------------------------
--         FILE:  StageIntroGameState.lua
--        USAGE:  ./StageIntroGameState.lua 
--  DESCRIPTION:  game state before a stage starts
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 22:52:59 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

StageIntroGameState = class( State ) 

StageIntroGameState.duration = 1

function StageIntroGameState:init( layer )
	State.init( self, "StageIntroGameState" )

	self.layer = layer
	self.gameMap = GAME_MAP
	self.pacman = ENTITY_MANAGER:getEntity( PACMAN_ID )
	self.blueGhost = ENTITY_MANAGER:getEntity( GHOST_ID_BLUE )
	self.redGhost = ENTITY_MANAGER:getEntity( GHOST_ID_RED )
	self.greenGhost = ENTITY_MANAGER:getEntity( GHOST_ID_GREEN )
	self.yellowGhost = ENTITY_MANAGER:getEntity( GHOST_ID_YELLOW )

	self.readyProp = MOAIProp2D.new()
	self.readyProp:setDeck( QUAD_2D_READY )
	self.readyProp:setLoc( BASE_LOCATION_X, BASE_LOCATION_Y )
end

function StageIntroGameState:enter()
	self.gameMap:show( self.layer )

	self.pacman:resetToSpawn()
	self.pacman:show( self.layer )

	self.blueGhost:resetToSpawn()
	self.blueGhost:show( self.layer )
	self.redGhost:resetToSpawn()
	self.redGhost:show( self.layer )
	self.greenGhost:resetToSpawn()
	self.greenGhost:show( self.layer )
	self.yellowGhost:resetToSpawn()
	self.yellowGhost:show( self.layer )

	self.layer:insertProp( self.readyProp )
	self.entryTime = MOAISim:getElapsedTime()
end

function StageIntroGameState:onUpdate()
	local currentTime = MOAISim:getElapsedTime()
	if ( currentTime - self.entryTime > StageIntroGameState.duration )
	then
		GAME_STATE_MACHINE:setCurrentState( INPLAY_GAME_STATE )
	end
end

function StageIntroGameState:exit()
	self.layer:removeProp( self.readyProp )
end

--singleton
STAGE_INTRO_GAME_STATE = nil
