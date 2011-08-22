require "common"
require "MenuGameState"
require "HelpGameState"
require "InPlayGameState"
require "StateMachine"
require "Quad2DRepository"

g_viewport = nil
g_layer = nil

function initMOAISim()
	MOAISim.openWindow( GAME_NAME, SCREEN_WIDTH, SCREEN_HEIGHT )

	g_viewport = MOAIViewport.new()
	g_viewport:setScale( SCREEN_UNITS_X, -SCREEN_UNITS_Y )
	g_viewport:setSize( SCREEN_WIDTH, SCREEN_HEIGHT )

	g_layer = MOAILayer2D.new()
	g_layer:setViewport( g_viewport )

	MOAISim.pushRenderPass( g_layer )
end

function runGame()
	MOAILogMgr.log( "game [" .. GAME_NAME .. "] is starting\n" )

	QUAD_2D_REPOSITORY.init()
	GAME_STATE_MACHIEN = StateMachine()
	MENU_GAME_STATE = MenuGameState( g_layer )
	HELP_GAME_STATE = HelpGameState( g_layer )
	INPLAY_GAME_STATE = InPlayGameState( g_layer )

	GAME_STATE_MACHIEN:run()
	GAME_STATE_MACHIEN:setCurrentState( MENU_GAME_STATE )
end

function main()
	initMOAISim()	
	runGame()
end

main()
