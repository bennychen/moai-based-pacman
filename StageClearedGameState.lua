--
--------------------------------------------------------------------------------
--         FILE:  StageClearedGameState.lua
--        USAGE:  ./StageClearedGameState.lua 
--  DESCRIPTION:  game state when a stage is finished
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/23/2011 11:28:38 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

StageClearedGameState = class( State ) 

StageClearedGameState.duration = 3

function StageClearedGameState:init( layer )
	State.init( self, "StageClearedGameState" )

	self.layer = layer
	self.gameMap = GAME_MAP

	self.winProp = MOAIProp2D.new()
	self.winProp:setDeck( QUAD_2D_WIN )
	self.winProp:setLoc( BASE_LOCATION_X, BASE_LOCATION_Y )
end

function StageClearedGameState:enter()
	GAME_TIME:pause()
	self.gameMap:show( self.layer )
	self.layer:insertProp( self.winProp )
	self.entryTime = MOAISim:getElapsedTime()

	backgroundMusic:stop()
	winSound:play()
end

function StageClearedGameState:onUpdate()
	local currentTime = MOAISim:getElapsedTime()
	if ( not winSound:isPlaying() and 
		 currentTime - self.entryTime > StageClearedGameState.duration )
	then
		self.gameMap:resetMap()
		GAME_STATE_MACHINE:setCurrentState( STAGE_INTRO_GAME_STATE )
	end
end

function StageClearedGameState:exit()
	self.layer:removeProp( self.winProp )
end

--singleton
STAGE_CLEARED_GAME_STATE = nil
