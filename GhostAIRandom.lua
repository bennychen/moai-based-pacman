--
--------------------------------------------------------------------------------
--         FILE:  GhostAIRandom.lua
--        USAGE:  ./GhostAIRandom.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/23/2011 16:32:12 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

GhostAIRandom = class( GhostAIStrategy )

function GhostAIRandom:init( gameMap, pacman )
	GhostAIStrategy.init( self, gameMap, pacman )
end

function GhostAIRandom:getPursueDirection( ghost )
	return self:getRandomDirection( ghost )
end

function GhostAIRandom:getEvadeDirection( ghost )
	return self:getRandomDirection( ghost )
end

function GhostAIRandom:getRandomDirection( ghost )
	local ghostDirection = ghost.velocity.direction

	local directions = {}
	local directionNum = 0

	for direction = DIRECTION_LEFT, DIRECTION_DOWN
	do
		if ( ( not Velocity.isReversedDirection( direction, ghostDirection ) ) and
			 ( not CollisionDetection.willGhostCollideBarrier( self.gameMap, ghost, direction ) ) )
		then
			directionNum = directionNum + 1
			directions[directionNum] = direction
		end
	end
	
	if ( directionNum == 1 )
	then
		return directions[1]
	elseif ( directionNum > 1 )
	then
		local index = math.random( 1, directionNum )
		--print( "ghost's current direction - " .. Velocity.getDirectionString( ghostDirection ) )
		--printVar( directionNum, 'directionNum')
		--for i = 1, directionNum do print( "["..i.."] - direction is " .. Velocity.getDirectionString( directions[i] ) ) end
		--print( "need a choice for direction, choose - " .. Velocity.getDirectionString( directions[index] ) )
		return directions[index]
	elseif ( directionNum == 0 )
	then
		--print( "ghost's current direction - " .. Velocity.getDirectionString( ghostDirection ) )
		return Velocity.getReversedDirection( ghostDirection )
	end
end

GHOST_AI_RANDOM = nil
