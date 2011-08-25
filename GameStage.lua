--
--------------------------------------------------------------------------------
--         FILE:  GameStage.lua
--        USAGE:  ./GameStage.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/24/2011 17:27:00 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

GameStage = class()

function GameStage:init( ghostEvadeDuration, ghostDeadDuration, 
		ghostStrategy)
end

GHOST_EVADE_DURATION = 10
GHOST_DEAD_DURATION = 1

GHOST_BLUE_STRATEGY = GHOST_AI_RANDOM
GHOST_RED_STRATEGY = GHOST_AI_RANDOM
GHOST_GREEN_STRATEGY = GHOST_AI_RANDOM
GHOST_RED_STRATEGY = GHOST_AI_RANDOM
