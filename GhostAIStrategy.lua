--
--------------------------------------------------------------------------------
--         FILE:  GhostAIStrategy.lua
--        USAGE:  ./GhostAIStrategy.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/23/2011 15:22:40 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

GhostAIStrategy = class()

function GhostAIStrategy:init( gameMap, pacman )
	self.gameMap = gameMap
	self.pacman = pacman
end

function GhostAIStrategy:getPursueDirection( ghost )
end

function GhostAIStrategy:getEvadeDirection( ghost )
end
