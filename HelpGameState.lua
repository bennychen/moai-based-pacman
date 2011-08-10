--
--------------------------------------------------------------------------------
--         FILE:  HelpGameState.lua
--        USAGE:  ./HelpGameState.lua 
--  DESCRIPTION:  
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

function MenuState:enter()
	print( "entering HelpGameState..." )
	self.layer:insertProp( self.help )
end

function MenuState:exit()
	print( "exiting HelpGameState..." )
	self.layer:removeProp( self.help )
end

-- singleton
HELP_GAME_STATE = nil
