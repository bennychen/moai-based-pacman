--
--------------------------------------------------------------------------------
--         FILE:  GhostAIStupid.lua
--        USAGE:  ./GhostAIStupid.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/23/2011 15:55:49 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

--DO NOT USE THIS STRATEGY, THE STRATEGY ITSELF IS STUPID

require "GhostAIStrategy"

GhostAIStupid = class( GhostAIStrategy )

GhostAIStupid.TARGET_LEFT_TOP = 1
GhostAIStupid.TARGET_RIGHT_BOTTOM = 2
GhostAIStupid.TARGET_RIGHT_TOP = 3
GhostAIStupid.TARGET_LEFT_BOTTOM = 4

function GhostAIStupid:init( gameMap, pacman )
	GhostAIStrategy.init( self, gameMap, pacman )
	self.leftTopCornerX, self.leftTopCornerY = 
							gameMap:getLeftTopEmptyTileIndex()
	self.rightBottomCornerX, self.rightBottomCornerY = 
							gameMap:getRightBottomEmptyTileIndex()
	self:setTarget( GhostAIStupid.TARGET_LEFT_TOP )
end

function GhostAIStupid:getPursueDirection( ghost )
	return self:getStupidDirection( ghost )
end

function GhostAIStupid:getEvadeDirection( ghost )
	return self:getStupidDirection( ghost )
end

function GhostAIStupid:setTarget( target )
	self.target = target
	if ( target == GhostAIStupid.TARGET_LEFT_TOP )
	then
		self.currentTargetX = self.leftTopCornerX
		self.currentTargetY = self.leftTopCornerY
	elseif ( target == GhostAIStupid.TARGET_RIGHT_BOTTOM )
	then
		self.currentTargetX = self.rightBottomCornerX
		self.currentTargetY = self.rightBottomCornerY
	elseif ( target == GhostAIStupid.TARGET_RIGHT_TOP )
	then
		self.currentTargetX = self.rightBottomCornerX
		self.currentTargetY = self.leftTopCornerY
	elseif ( target == GhostAIStupid.TARGET_LEFT_BOTTOM )
	then
		self.currentTargetX = self.leftTopCornerX
		self.currentTargetY = self.rightBottomCornerY
	end
end

function GhostAIStupid:getNextTarget( target )
	target = target + 1
	if ( target > GhostAIStupid.TARGET_LEFT_BOTTOM )
	then
		target = GhostAIStupid.TARGET_LEFT_TOP 
	end
	return target
end

function GhostAIStupid:hasArrivedAtTarget( ghost )
	local ghostTileX
	local ghostTileY
	ghostTileX, ghostTileY = self.gameMap:getTileIndex( ghost:getCenterLoc() )
	if ( ghostTileX == self.currentTargetX and ghostTileY == self.currentTargetY )
	then
		return true
	end
	return false
end

function GhostAIStupid:isTargetedDirection( direction )
	if ( self.target == GhostAIStupid.TARGET_LEFT_TOP )
	then
		return direction == DIRECTION_LEFT or direction == DIRECTION_UP
	elseif ( self.target == GhostAIStupid.TARGET_RIGHT_BOTTOM )
	then
		return direction == DIRECTION_RIGHT or direction == DIRECTION_DOWN
	elseif ( self.target == GhostAIStupid.TARGET_RIGHT_TOP )
	then
		return direction == DIRECTION_RIGHT or direction == DIRECTION_UP
	elseif ( self.target == GhostAIStupid.TARGET_LEFT_BOTTOM )
	then
		return direction == DIRECTION_LEFT or direction == DIRECTION_DOWN
	end
end

function GhostAIStupid:getStupidDirection( ghost )
	if ( self:hasArrivedAtTarget( ghost ) )
	then
		self:setTarget( self:getNextTarget( self.target ) )
	end

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
			if ( self:isTargetedDirection( direction ) )
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
			--print( "ERROR @ GhostAIStupid:getStupidDirection - not possible to be here" )
			return Velocity.getReversedDirection( ghostDirection )
		end
		return lowPrioDirections[1]
	end
end

GHOST_AI_STUPID = nil
