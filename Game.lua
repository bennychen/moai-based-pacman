--
--------------------------------------------------------------------------------
--         FILE:  Game.lua
--        USAGE:  ./Game.lua 
--  DESCRIPTION:  Game class
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 23:44:54 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "GameConfig"
require "GameTime"
require "MenuGameState"
require "HelpGameState"
require "StageIntroGameState"
require "InPlayGameState"
require "PauseGameState"
require "PacmanKilledGameState"
require "GhostKilledGameState"
require "StageClearedGameState"
require "StateMachine"
require "Quad2DRepository"
require "AudioRepository"
require "EntityManager"
require "GameMap"
require "GhostScheduler"
require "GhostAIStupid"
require "GhostAIRandom"
require "GhostAIChaser"

Game = {}

function Game.init()
	GAME_TIME = GameTime()

	QUAD_2D_REPOSITORY.init()
	AUDIO_REPOSITORY.init()
	GAME_MAP = GameMap()
	ENTITY_MANAGER = EntityManager()
	GHOST_SCHEDULER = GhostScheduler()
	Game.initGameEntities()

	local pacman = ENTITY_MANAGER:getEntity( PACMAN_ID )
	GHOST_AI_STUPID = GhostAIStupid( GAME_MAP, pacman )
	GHOST_AI_RANDOM = GhostAIRandom( GAME_MAP, pacman )
	GHOST_AI_CHASER = GhostAIChaser( GAME_MAP, pacman )

	GAME_STATE_MACHINE = StateMachine()
	MENU_GAME_STATE = MenuGameState( RENDER_SYSTEM.layer )
	HELP_GAME_STATE = HelpGameState( RENDER_SYSTEM.layer )
	STAGE_INTRO_GAME_STATE = StageIntroGameState( RENDER_SYSTEM.layer )
	INPLAY_GAME_STATE = InPlayGameState( RENDER_SYSTEM.layer )
	PACMAN_KILLED_GAME_STATE = PacmanKilledGameState( RENDER_SYSTEM.layer )
	GHOST_KILLED_GAME_STATE = GhostKilledGameState( RENDER_SYSTEM.layer )
	STAGE_CLEARED_GAME_STATE = StageClearedGameState( RENDER_SYSTEM.layer )
	PAUSE_GAME_STATE = PauseGameState( RENDER_SYSTEM.layer )
end

function Game.run()
	MOAILogMgr.log( "game [" .. GAME_NAME .. "] is starting\n" )
	GAME_TIME:start()
	GAME_STATE_MACHINE:run()
	GAME_STATE_MACHINE:setCurrentState( MENU_GAME_STATE )
end

function Game.initGameEntities()
	local pacman = Pacman( GAME_MAP.leftTopCorner, 
			PACMAN_SPAWN_POINT, PACMAN_SPAWN_DIRECTION, PACMAN_SPEED,
			TILE_DECK_2D_PACMAN, pacmanSpriteNum )
	ENTITY_MANAGER:addEntity( PACMAN_ID, pacman )

	local blueGhost = Ghost( GAME_MAP.leftTopCorner,
			GHOST_BLUE_SPAWN_POINT, GHOST_BLUE_SPAWN_DIRECTION, 
			GHOST_PURSUE_SPEED, GHOST_EVADE_SPEED,
			TILE_DECK_2D_BLUE, ghostSpriteNum )
	ENTITY_MANAGER:addEntity( GHOST_ID_BLUE, blueGhost )

	local redGhost = Ghost( GAME_MAP.leftTopCorner,
			GHOST_RED_SPAWN_POINT, GHOST_RED_SPAWN_DIRECTION,
			GHOST_PURSUE_SPEED, GHOST_EVADE_SPEED,
			TILE_DECK_2D_RED, ghostSpriteNum )
	ENTITY_MANAGER:addEntity( GHOST_ID_RED, redGhost )

	local greenGhost = Ghost( GAME_MAP.leftTopCorner,
			GHOST_GREEN_SPAWN_POINT, GHOST_GREEEN_SPAWN_DIRECTION,
			GHOST_PURSUE_SPEED, GHOST_EVADE_SPEED,
			TILE_DECK_2D_GREEN, ghostSpriteNum )
	ENTITY_MANAGER:addEntity( GHOST_ID_GREEN, greenGhost )

	local yellowGhost = Ghost( GAME_MAP.leftTopCorner,
			GHOST_YELLOW_SPAWN_POINT, GHOST_YELLOW_SPAWN_DIRECTION, 
			GHOST_PURSUE_SPEED, GHOST_EVADE_SPEED,
			TILE_DECK_2D_YELLOW, ghostSpriteNum )
	ENTITY_MANAGER:addEntity( GHOST_ID_YELLOW, yellowGhost )
end

function Game.isValidSpeed( speedPerSecond )
	local speedPerFrame = speedPerSecond / ( 1 / FRAME_TIME )
	local fraction = TILE_SIZE / speedPerFrame
	fraction = fraction - math.floor( fraction + 0.5 )
	if ( math.abs( fraction ) < 0.001 )
	then
		return true
	end
	return false
end
