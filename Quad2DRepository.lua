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

require "media/tiledmap2"

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

	readyPicWidth = 200
	readyPicHeight = 40
	QUAD_2D_READY = MOAIGfxQuad2D.new()
	QUAD_2D_READY:setTexture( "media/ready.png" )
	QUAD_2D_READY:setRect( -readyPicWidth / 2, readyPicHeight / 2, 
							readyPicWidth / 2, -readyPicHeight / 2 )

	winPicWidth = 500
	winPicHeight = 50
	QUAD_2D_WIN = MOAIGfxQuad2D.new()
	QUAD_2D_WIN:setTexture( "media/win.png" )
	QUAD_2D_WIN:setRect( -winPicWidth / 2, winPicHeight / 2,
						  winPicWidth / 2, -winPicHeight / 2 )

	beanWidth = TILE_SIZE
	beanHeight = TILE_SIZE
	QUAD_2D_BEAN = MOAIGfxQuad2D.new()
	QUAD_2D_BEAN:setTexture( "media/bean.png" )
	QUAD_2D_BEAN:setRect( -beanWidth/2, beanHeight/2, beanWidth/2, -beanHeight/2 )

	tileMapSpriteSheetWidth = 64
	tileMapSpriteSheetHeight = 64
	tileMapSpriteSheetNumColumn = 3
	tileMapSpriteSheetNumRow = 3
	TILE_DECK_2D_MAP = MOAITileDeck2D.new()
	TILE_DECK_2D_MAP:setTexture( "media/" .. map.tilesets[1].image )
	TILE_DECK_2D_MAP:setSize( tileMapSpriteSheetNumColumn, tileMapSpriteSheetNumRow, 
			map.tilewidth / tileMapSpriteSheetWidth, map.tileheight / tileMapSpriteSheetHeight )
	TILE_DECK_2D_MAP:setRect( -0.5, 0.5, 0.5, -0.5 )

	pacmanSpriteSheetNumColumn = 13
	pacmanSpriteSheetNumRow = 1
	pacmanSpriteNum = pacmanSpriteSheetNumColumn * pacmanSpriteSheetNumRow
	TILE_DECK_2D_PACMAN = MOAITileDeck2D.new()
	TILE_DECK_2D_PACMAN:setTexture( "media/pacman.png" )
	TILE_DECK_2D_PACMAN:setSize( pacmanSpriteSheetNumColumn, pacmanSpriteSheetNumRow )
	TILE_DECK_2D_PACMAN:setRect( 0, GAME_ENTITY_SIZE, GAME_ENTITY_SIZE, 0 ) -- make pacman's origin at left-top corner

	ghostSpriteSheetNumColumn = 7 
	ghostSpriteSheetNumRow = 1
	ghostSpriteNum = ghostSpriteSheetNumColumn * ghostSpriteSheetNumRow

	TILE_DECK_2D_BLUE = MOAITileDeck2D.new()
	TILE_DECK_2D_BLUE:setTexture( "media/bluemonster.png" )
	TILE_DECK_2D_BLUE:setSize( ghostSpriteSheetNumColumn, ghostSpriteSheetNumRow )
	TILE_DECK_2D_BLUE:setRect( 0, GAME_ENTITY_SIZE, GAME_ENTITY_SIZE, 0 ) 

	TILE_DECK_2D_GREEN = MOAITileDeck2D.new()
	TILE_DECK_2D_GREEN:setTexture( "media/greenmonster.png" )
	TILE_DECK_2D_GREEN:setSize( ghostSpriteSheetNumColumn, ghostSpriteSheetNumRow )
	TILE_DECK_2D_GREEN:setRect( 0, GAME_ENTITY_SIZE, GAME_ENTITY_SIZE, 0 ) 

	TILE_DECK_2D_RED = MOAITileDeck2D.new()
	TILE_DECK_2D_RED:setTexture( "media/redmonster.png" )
	TILE_DECK_2D_RED:setSize( ghostSpriteSheetNumColumn, ghostSpriteSheetNumRow )
	TILE_DECK_2D_RED:setRect( 0, GAME_ENTITY_SIZE, GAME_ENTITY_SIZE, 0 ) 

	TILE_DECK_2D_YELLOW = MOAITileDeck2D.new()
	TILE_DECK_2D_YELLOW:setTexture( "media/yellowmonster.png" )
	TILE_DECK_2D_YELLOW:setSize( ghostSpriteSheetNumColumn, ghostSpriteSheetNumRow )
	TILE_DECK_2D_YELLOW:setRect( 0, GAME_ENTITY_SIZE, GAME_ENTITY_SIZE, 0 ) 
end
