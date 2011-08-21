--
--------------------------------------------------------------------------------
--         FILE:  Quad2DRepository.lua
--        USAGE:  ./Quad2DRepository.lua 
--  DESCRIPTION:  declare all the needed 2d resources
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/14/2011 16:38:49 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "media/tiledmap"

QUAD_2D_REPOSITORY = {}

function QUAD_2D_REPOSITORY.init()
	menuWidth = 560 / 2
	menuHeight = 560 / 2
	QUAD_2D_MENU = MOAIGfxQuad2D.new()
	QUAD_2D_MENU:setTexture( "media/mainmenu.png" )
	QUAD_2D_MENU:setRect( -menuWidth/2, menuHeight/2, menuWidth/2, -menuHeight/2 )

	helpWindowWidth = 400 / 2
	helpWindowHeight = 300 / 2
	QUAD_2D_HELP_WINDOW = MOAIGfxQuad2D.new()
	QUAD_2D_HELP_WINDOW:setTexture( "media/helpmenu.png" )
	QUAD_2D_HELP_WINDOW:setRect( -helpWindowWidth/2, helpWindowHeight/2, 
			helpWindowWidth/2, -helpWindowHeight/2 )

	tileSize = SCREEN_WIDTH / map.width
	--tileSize = 10

	beanWidth = tileSize
	beanHeight = tileSize
	QUAD_2D_BEAN = MOAIGfxQuad2D.new()
	QUAD_2D_BEAN:setTexture( "media/bean.png" )
	QUAD_2D_BEAN:setRect( -beanWidth/2, beanHeight/2, beanWidth/2, -beanHeight/2 )

	tileMapSpriteSheetWidth = 64
	tileMapSpriteSheetHeight = 64
	tileMapSpriteSheetNumColumn = 3
	tileMapSpriteSheetNumRow = 2
	TILE_DECK_2D_MAP = MOAITileDeck2D.new()
	TILE_DECK_2D_MAP:setTexture( "media/" .. map.tilesets[1].image )
	TILE_DECK_2D_MAP:setSize( tileMapSpriteSheetNumColumn, tileMapSpriteSheetNumRow, 
			map.tilewidth / tileMapSpriteSheetWidth, map.tileheight / tileMapSpriteSheetHeight )

	pacmanWidth = tileSize
	pacmanHeight = tileSize
	pacmanSpriteSheetNumColumn = 13
	pacmanSpriteSheetNumRow = 1
	pacmanSpriteNum = pacmanSpriteSheetNumColumn * pacmanSpriteSheetNumRow
	TILE_DECK_2D_PACMAN = MOAITileDeck2D.new()
	TILE_DECK_2D_PACMAN:setTexture( "media/pacman.png" )
	TILE_DECK_2D_PACMAN:setSize( pacmanSpriteSheetNumColumn, pacmanSpriteSheetNumRow )
	TILE_DECK_2D_PACMAN:setRect( 0, pacmanHeight, pacmanWidth, 0 ) -- make pacman's origin at left-top corner
end
