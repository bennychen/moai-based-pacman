--
--------------------------------------------------------------------------------
--         FILE:  EntityManager.lua
--        USAGE:  ./EntityManager.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 23:07:26 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

EntityManager = class()

function EntityManager:init()
	self.entityGroup = {}
end

function EntityManager:addEntity( id, entity )
	self.entityGroup[id] = entity
	entity.id = id
end

function EntityManager:getEntity( id )
	return self.entityGroup[id]
end

-- singleton class
ENTITY_MANAGER = nil
