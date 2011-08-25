require "common"
require "Game"

RENDER_SYSTEM = {}

function RENDER_SYSTEM.init()
	MOAISim.openWindow( GAME_NAME, SCREEN_WIDTH, SCREEN_HEIGHT )

	RENDER_SYSTEM.viewport = MOAIViewport.new()
	RENDER_SYSTEM.viewport:setScale( SCREEN_UNITS_X, -SCREEN_UNITS_Y )
	RENDER_SYSTEM.viewport:setSize( SCREEN_WIDTH, SCREEN_HEIGHT )

	RENDER_SYSTEM.layer = MOAILayer2D.new()
	RENDER_SYSTEM.layer:setViewport( RENDER_SYSTEM.viewport )

	MOAISim.pushRenderPass( RENDER_SYSTEM.layer )
end

function main()
	RENDER_SYSTEM.init()	
	Game.init()
	Game.run()
end

main()
