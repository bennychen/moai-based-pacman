require "State"
require "StateMachine"
require "Quad2DRepository"

MenuState = class( State )

MenuState.MENU_ITEM_START_GAME = 0
MenuState.MENU_ITEM_HELP = 1
MenuState.MENU_ITEM_QUIT = 2

function MenuState:init( layer )
	self.layer = layer

	self.menu = MOAIProp2D.new()
	self.menu:setDeck( QUAD_2D_MENU )
	self.menu:setLoc( BASE_LOCATION_X, BASE_LOCATION_Y )

	self.cursor = MOAIProp2D.new()
	self.cursor:setDeck( QUAD_2D_BEAN )
end

function MenuState:enter()
	print( "entering MenuState..." )
	self.layer:insertProp( self.menu )
	self.layer:insertProp( self.cursor )
	self.cursorIndex = MenuState.MENU_ITEM_START_GAME
	self:updateCursorLocation()
	MOAIInputMgr.device.keyboard:setCallback ( MenuState.onKeyboardEvent )
end

function MenuState:exit()
	print( "exiting MenuState..." )
	self.layer:removeProp( self.menu )
	self.layer:removeProp( self.cursor )
end

function MenuState:incrementCursorIndex()
	if ( self.cursorIndex == MenuState.MENU_ITEM_QUIT )
	then
		self.cursorIndex = MenuState.MENU_ITEM_START_GAME
	else
		self.cursorIndex = self.cursorIndex + 1
	end
end

function MenuState:updateCursorLocation()
	local cursorX = BASE_LOCATION_X - 30
	local cursorY = BASE_LOCATION_Y - 20 - self.cursorIndex * 30
	self.cursor:setLoc( cursorX, cursorY )
end

function MenuState:onMenuSelected()
	if ( self.cursorIndex == MenuState.MENU_ITEM_START_GAME )
	then
	elseif ( self.cursorIndex == MenuState.MENU_ITEM_HELP )
	then
		STATE_MACHINE:setCurrentState( HELP_GAME_STATE )
	elseif ( self.cursorIndex == MenuState.MENU_ITEM_QUIT )
	then
	end
end

-- singleton, will be initialized when initializing game
MENU_STATE = nil

KEYBOARD_SPACE = 32
KEYBOARD_ENTER = 13

function MenuState.onKeyboardEvent( key, down )
	if ( MENU_STATE == nil or down )
	then
		return
	end

	if ( key == 32 )
	then
		MENU_STATE:incrementCursorIndex()
		MENU_STATE:updateCursorLocation()
	elseif ( key == 13 )
	then
		MENU_STATE:onMenuSelected()
	end
end

