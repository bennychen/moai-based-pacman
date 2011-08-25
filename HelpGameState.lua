--
--------------------------------------------------------------------------------
--         FILE:  HelpGameState.lua
--        USAGE:  ./HelpGameState.lua 
--  DESCRIPTION:  Game State for Help Window
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/10/2011 00:04:08 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--
require "State"

HelpGameState = class( State )

function HelpGameState:init( layer )
	self.layer = layer
		
	self.help = MOAIProp2D.new()
	self.help:setDeck( QUAD_2D_HELP_WINDOW )
	self.help:setLoc( BASE_LOCATION_X, BASE_LOCATION_Y )
end

function HelpGameState:enter()
	GAME_TIME:pause()
	self.layer:insertProp( self.help )
end

function HelpGameState:exit()
	self.layer:removeProp( self.help )
end

-- singleton
HELP_GAME_STATE = nil
