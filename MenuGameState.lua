--
--------------------------------------------------------------------------------
--         FILE:  MenuGameState.lua
--        USAGE:  ./InPlayGameState.lua 
--  DESCRIPTION:  Game State of menu selecting 
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/09/2011 21:21:44 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "State"
require "StateMachine"
require "Quad2DRepository"

MenuGameState = class( State )

MenuGameState.MENU_ITEM_START_GAME = 0
MenuGameState.MENU_ITEM_HELP = 1
MenuGameState.MENU_ITEM_QUIT = 2

function MenuGameState:init( layer )
	State.init( self, "MenuGameState" )

	self.layer = layer

	self.menu = MOAIProp2D.new()
	self.menu:setDeck( QUAD_2D_MENU )
	self.menu:setLoc( BASE_LOCATION_X, BASE_LOCATION_Y )

	--self.cursor = MOAIProp2D.new()
	--self.cursor:setDeck( QUAD_2D_BEAN )
end

function MenuGameState:enter()
	GAME_TIME:pause()
	self.layer:insertProp( self.menu )
	--self.layer:insertProp( self.cursor )
	--self.cursorIndex = MenuGameState.MENU_ITEM_START_GAME
	--self:updateCursorLocation()
	--MOAIInputMgr.device.keyboard:setCallback( MenuGameState.onKeyboardEvent )
	MOAIInputMgr.device.touch:setCallback( MenuGameState.onTouchEvent )
end

function MenuGameState:exit()
	self.layer:removeProp( self.menu )
	--self.layer:removeProp( self.cursor )
	--MOAIInputMgr.device.keyboard:setCallback( nil )
	MOAIInputMgr.device.touch:setCallback( nil )
end

function MenuGameState:incrementCursorIndex()
	if ( self.cursorIndex == MenuGameState.MENU_ITEM_QUIT )
	then
		self.cursorIndex = MenuGameState.MENU_ITEM_START_GAME
	else
		self.cursorIndex = self.cursorIndex + 1
	end
end

function MenuGameState:updateCursorLocation()
	local cursorX = BASE_LOCATION_X - 30
	local cursorY = BASE_LOCATION_Y + 20 + self.cursorIndex * 30
	self.cursor:setLoc( cursorX, cursorY )
end

function MenuGameState:onMenuSelected()
	if ( self.cursorIndex == MenuGameState.MENU_ITEM_START_GAME )
	then
		GAME_STATE_MACHINE:setCurrentState( STAGE_INTRO_GAME_STATE )
	elseif ( self.cursorIndex == MenuGameState.MENU_ITEM_HELP )
	then
		GAME_STATE_MACHINE:setCurrentState( HELP_GAME_STATE )
	elseif ( self.cursorIndex == MenuGameState.MENU_ITEM_QUIT )
	then
	end
end

-- singleton, will be initialized when initializing game
MENU_GAME_STATE = nil

function MenuGameState.onKeyboardEvent( key, down )
	if ( MENU_GAME_STATE == nil or down )
	then
		return
	end

	if ( key == KEYBOARD_SPACE )
	then
		MENU_GAME_STATE:incrementCursorIndex()
		MENU_GAME_STATE:updateCursorLocation()
	elseif ( key == KEYBOARD_ENTER )
	then
		MENU_GAME_STATE:onMenuSelected()
	end
end

function MenuGameState.onTouchEvent( eventType, idx, x, y, tapCount )
	if ( MENU_GAME_STATE == nil or down )
	then
		return
	end

	GAME_STATE_MACHINE:setCurrentState( STAGE_INTRO_GAME_STATE )
end
