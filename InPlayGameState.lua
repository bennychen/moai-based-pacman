--
--------------------------------------------------------------------------------
--         FILE:  InPlayGameState.lua
--        USAGE:  ./InPlayGameState.lua 
--  DESCRIPTION:  Game State of playing Pacman game
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/10/2011 14:21:44 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "State"
require "GameMap"

InPlayGameState = class( State )

function InPlayGameState:init( layer )
	self.layer = layer
	self.gameMap = GameMap( "media/map" )
end

function InPlayGameState:enter()
	print( "entering InPlayGameState..." )
	self.gameMap:drawMap( self.layer )
	--self.layer:insertProp( MENU_GAME_STATE.menu )
end

function InPlayGameState:exit()
	print( "exiting InPlayGameState..." )
	self.gameMap:clearMap( self.layer )	
end

-- singleton
INPLAY_GAME_STATE = nil
