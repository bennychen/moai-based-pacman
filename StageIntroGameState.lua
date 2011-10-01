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
	GAME_TIME:pause()

	self.gameMap:show( self.layer )

	self.pacman:resetToSpawn()
	self.pacman:show( self.layer )

	self.blueGhost:setAIStrategy( GHOST_AI_RANDOM )
	self.redGhost:setAIStrategy( GHOST_AI_RANDOM )
	self.greenGhost:setAIStrategy( GHOST_AI_CHASER )
	self.yellowGhost:setAIStrategy( GHOST_AI_CHASER )

	self.blueGhost:resetToSpawn()
	self.blueGhost:show( self.layer )
	self.redGhost:resetToSpawn()
	self.redGhost:show( self.layer )
	self.greenGhost:resetToSpawn()
	self.greenGhost:show( self.layer )
	self.yellowGhost:resetToSpawn()
	self.yellowGhost:show( self.layer )
	self.blueGhost:setStandBy()
	self.redGhost:setStandBy()
	self.greenGhost:setStandBy()
	self.yellowGhost:setStandBy()

	GHOST_SCHEDULER:clearSchedules()
	GHOST_SCHEDULER:addSchedule( GHOST_ID_BLUE, GHOST_BLUE_STANDBY_TIME )
	GHOST_SCHEDULER:addSchedule( GHOST_ID_RED, GHOST_RED_STANDBY_TIME )
	GHOST_SCHEDULER:addSchedule( GHOST_ID_GREEN, GHOST_GREEN_STANDBY_TIME )
	GHOST_SCHEDULER:addSchedule( GHOST_ID_YELLOW, GHOST_YELLOW_STANDBY_TIME )

	backgroundMusic:stop()
	stageIntroSound:play()

	self.layer:insertProp( self.readyProp )
	self.entryTime = MOAISim:getElapsedTime()
end

function StageIntroGameState:onUpdate()
	--local currentTime = MOAISim:getElapsedTime()
	--if ( currentTime - self.entryTime > StageIntroGameState.duration )
	--then
		--GAME_STATE_MACHINE:setCurrentState( INPLAY_GAME_STATE )
	--end
	if ( not stageIntroSound:isPlaying() )
	then
		GAME_STATE_MACHINE:setCurrentState( INPLAY_GAME_STATE )
	end
end

function StageIntroGameState:exit()
	self.layer:removeProp( self.readyProp )
end

--singleton
STAGE_INTRO_GAME_STATE = nil
