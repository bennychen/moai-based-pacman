QUAD_2D_REPOSITORY = {}

function QUAD_2D_REPOSITORY.init()
	menuWidth = 280
	menuHeight = 280
	QUAD_2D_MENU = MOAIGfxQuad2D.new()
	QUAD_2D_MENU:setTexture( "media/mainmenu.png" )
	QUAD_2D_MENU:setRect( -menuWidth/2, -menuHeight/2, menuWidth/2, menuHeight/2 )

	helpWindowWidth = 200
	helpWindowHeight = 150
	QUAD_2D_HELP_WINDOW = MOAIGfxQuad2D.new()
	QUAD_2D_HELP_WINDOW:setTexture( "media/helpmenu.png" )
	QUAD_2D_HELP_WINDOW:setRect( -helpWindowWidth/2, -helpWindowHeight/2, 
			helpWindowWidth/2, helpWindowHeight/2 )

	beanWidth = 10
	beanHeight = 10
	QUAD_2D_BEAN = MOAIGfxQuad2D.new()
	QUAD_2D_BEAN:setTexture( "media/bean.png" )
	QUAD_2D_BEAN:setRect( -beanWidth/2, -beanHeight/2, beanWidth/2, beanHeight/2 )
end
