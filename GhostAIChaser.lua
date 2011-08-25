--
--------------------------------------------------------------------------------
--         FILE:  GhostAIChaser.lua
--        USAGE:  ./GhostAIChaser.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/23/2011 16:37:44 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

GhostAIChaser = class( GhostAIStrategy )

function GhostAIChaser:init( gameMap, pacman )
	GhostAIStrategy.init( self, gameMap, pacman )
end

function GhostAIChaser:getPursueDirection( ghost )
	local ghostDirection = ghost.velocity.direction

	local highPrioDirections = {}
	local highPrioNum = 0
	local lowPrioDirections = {}
	local lowPrioNum = 0

	for direction = DIRECTION_LEFT, DIRECTION_DOWN
	do
		if ( ( not Velocity.isReversedDirection( direction, ghostDirection ) ) and
			 ( not CollisionDetection.willGhostCollideBarrier( self.gameMap, ghost, direction ) ) )
		then
			if ( self:isDirectionApproachignPacman( direction, ghost ) )
			then
				highPrioNum = highPrioNum + 1
				highPrioDirections[highPrioNum] = direction
			else
				lowPrioNum = lowPrioNum + 1
				lowPrioDirections[lowPrioNum] = direction
			end
		end
	end
	
	if ( highPrioNum == 1 )
	then
		return highPrioDirections[1]
	elseif ( highPrioNum > 1 )
	then
		local index = math.random( 1, highPrioNum )
		return highPrioDirections[index]
	else
		if ( lowPrioNum == 0 )
		then
			print( "ERROR @ GhostAIStupid:getStupidDirection - not possible to be here" )
			return Velocity.getReversedDirection( ghostDirection )
		end
		return lowPrioDirections[1]
	end
end

function GhostAIChaser:getEvadeDirection( ghost )
	local ghostDirection = ghost.velocity.direction

	local highPrioDirections = {}
	local highPrioNum = 0
	local lowPrioDirections = {}
	local lowPrioNum = 0

	for direction = DIRECTION_LEFT, DIRECTION_DOWN
	do
		if ( ( not Velocity.isReversedDirection( direction, ghostDirection ) ) and
			 ( not CollisionDetection.willGhostCollideBarrier( self.gameMap, ghost, direction ) ) )
		then
			if ( self:isDirectionLeavingPacman( direction, ghost ) )
			then
				highPrioNum = highPrioNum + 1
				highPrioDirections[highPrioNum] = direction
			else
				lowPrioNum = lowPrioNum + 1
				lowPrioDirections[lowPrioNum] = direction
			end
		end
	end
	
	if ( highPrioNum == 1 )
	then
		return highPrioDirections[1]
	elseif ( highPrioNum > 1 )
	then
		local index = math.random( 1, highPrioNum )
		return highPrioDirections[index]
	else
		if ( lowPrioNum == 0 )
		then
			print( "ERROR @ GhostAIStupid:getStupidDirection - not possible to be here" )
			return Velocity.getReversedDirection( ghostDirection )
		end
		return lowPrioDirections[1]
	end
end

function GhostAIChaser:isDirectionApproachignPacman( direction, ghost )
	local displacementX
	local displacementY
	local vel = Velocity( 10, direction )
	displacementX, displacementY = vel:getDisplacement( direction, 1 )
	
	local pacmanX
	local pacmanY
	local ghostX
	local ghostY
	pacmanX, pacmanY = self.pacman:getLeftTopLoc()
	ghostX, ghostY = ghost:getLeftTopLoc()
	local distanceX = pacmanX - ghostX
	local distanceY = pacmanY - ghostY
	return ( distanceX * displacementX > 0 or distanceY * displacementY > 0 )
end

function GhostAIChaser:isDirectionLeavingPacman( direction, ghost )
	local displacementX
	local displacementY
	local vel = Velocity( 10, direction )
	displacementX, displacementY = vel:getDisplacement( direction, 1 )
	
	local pacmanX
	local pacmanY
	local ghostX
	local ghostY
	pacmanX, pacmanY = self.pacman:getLeftTopLoc()
	ghostX, ghostY = ghost:getLeftTopLoc()
	local distanceX = pacmanX - ghostX
	local distanceY = pacmanY - ghostY
	return ( distanceX * displacementX < 0 or distanceY * displacementY < 0 )
end

GHOST_AI_CHASER = nil
