require "media/tiledmap"

QUAD_2D_REPOSITORY = {}

function QUAD_2D_REPOSITORY.init()
	menuWidth = 560 / 2
	menuHeight = 560 / 2
	QUAD_2D_MENU = MOAIGfxQuad2D.new()
	QUAD_2D_MENU:setTexture( "media/mainmenu.png" )
	QUAD_2D_MENU:setRect( -menuWidth/2, -menuHeight/2, menuWidth/2, menuHeight/2 )

	helpWindowWidth = 400 / 2
	helpWindowHeight = 300 / 2
	QUAD_2D_HELP_WINDOW = MOAIGfxQuad2D.new()
	QUAD_2D_HELP_WINDOW:setTexture( "media/helpmenu.png" )
	QUAD_2D_HELP_WINDOW:setRect( -helpWindowWidth/2, -helpWindowHeight/2, 
			helpWindowWidth/2, helpWindowHeight/2 )

	gridSize = SCREEN_WIDTH / map.width
	--gridSize = 10

	beanWidth = gridSize
	beanHeight = gridSize
	QUAD_2D_BEAN = MOAIGfxQuad2D.new()
	QUAD_2D_BEAN:setTexture( "media/bean.png" )
	QUAD_2D_BEAN:setRect( -beanWidth/2, -beanHeight/2, beanWidth/2, beanHeight/2 )

	wallWidth = gridSize
	wallHeight = gridSize
	QUAD_2D_WALL = MOAIGfxQuad2D.new()
	QUAD_2D_WALL:setTexture( "media/wall.png" )
	QUAD_2D_WALL:setRect( -wallWidth/2, -wallHeight/2, wallWidth/2, wallHeight/2 )

	superBeanWidth = gridSize
	superBeanHeight = gridSize
	QUAD_2D_SUPER_BEAN = MOAIGfxQuad2D.new()
	QUAD_2D_SUPER_BEAN:setTexture( "media/superbean.png" )
	QUAD_2D_SUPER_BEAN:setRect( -superBeanWidth/2, -superBeanHeight/2, superBeanWidth/2, superBeanHeight/2 )

	tileMapSpriteSheetWidth = 64
	tileMapSpriteSheetHeight = 64
	tileMapSpriteSheetNumColumn = 3
	tileMapSpriteSheetNumRow = 2
	TILE_DECK_2D_MAP = MOAITileDeck2D.new()
	TILE_DECK_2D_MAP:setTexture( "media/" .. map.tilesets[1].image )
	TILE_DECK_2D_MAP:setSize( tileMapSpriteSheetNumColumn, tileMapSpriteSheetNumRow, 
			map.tilewidth / tileMapSpriteSheetWidth, map.tileheight / tileMapSpriteSheetHeight )

	pacmanWidth = gridSize
	pacmanHeight = gridSize
	pacmanSpriteSheetNumColumn = 13
	pacmanSpriteSheetNumRow = 1
	pacmanSpriteNum = pacmanSpriteSheetNumColumn * pacmanSpriteSheetNumRow
	TILE_DECK_2D_PACMAN = MOAITileDeck2D.new()
	TILE_DECK_2D_PACMAN:setTexture( "media/pacman.png" )
	TILE_DECK_2D_PACMAN:setSize( pacmanSpriteSheetNumColumn, pacmanSpriteSheetNumRow )
	--TILE_DECK_2D_PACMAN:setRect( 0, 0, pacmanWidth, pacmanHeight )
	TILE_DECK_2D_PACMAN:setRect( 0, -pacmanHeight, pacmanWidth, 0 ) -- make pacman's origin at left-top corner
end
