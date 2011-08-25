--
--------------------------------------------------------------------------------
--         FILE:  Velocity.lua
--        USAGE:  ./Velocity.lua 
--  DESCRIPTION:  base class for movable game entity
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

require "class" 

DIRECTION_LOWER_BOUND = 0
DIRECTION_LEFT = 1
DIRECTION_UP = 2
DIRECTION_RIGHT = 3
DIRECTION_DOWN = 4
DIRECTION_UPPER_BOUND = 5

Velocity = class()

function Velocity:init( speed, direction )
	self.speed = speed -- units/second
	self.direction = direction 
end

function Velocity:setDirection( direction )
	if ( Velocity.isValidDirection( direction ) )
	then
		self.direction = direction
	else
		print( "ERROR @ Velocity:setDirection - failed, invalid direction" )
	end
end

function Velocity:setSpeed( speed )
	if ( speed >= 0 )
	then
		self.speed = speed
	else
		print( "ERROR @ Velocity:setSpeed - failed, speed mustn't be less than 0" )
	end
end

function Velocity:getDisplacement( timeInSeconds )
	local delta = timeInSeconds * self.speed
	if ( self.direction == DIRECTION_UP )
	then
		return 0, -delta 
	elseif ( self.direction == DIRECTION_DOWN )
	then
		return 0, delta
	elseif ( self.direction == DIRECTION_LEFT )
	then
		return -delta, 0
	elseif ( self.direction == DIRECTION_RIGHT )
	then
		return delta, 0
	else
		print( "ERROR @ Velocity:getDisplacement - failed, unknow direction" )
	end
end

function Velocity.isValidDirection( direction )
	return direction > DIRECTION_LOWER_BOUND and direction < DIRECTION_UPPER_BOUND
end

function Velocity.isReversedDirection( direction1, direction2 )
	if ( Velocity.isValidDirection( direction1 ) and 
		 Velocity.isValidDirection( direction2 ) )
	then
		if ( direction1 == direction2 )
		then
			return false
		end
		return ( direction1 + direction2 == 4 or
			 direction1 + direction2 == 6 )
	else
		print( "ERROR @ Velocity:isReversedDirection - failed, invalid direction" )
	end
end

function Velocity.getReversedDirection( direction )
	if ( direction == DIRECTION_LEFT or direction == DIRECTION_RIGHT )
	then
		return 4 - direction
	elseif ( direction == DIRECTION_UP or direction == DIRECTION_DOWN )
	then
		return 6 - direction
	end
end

function Velocity.getDirectionString( direction )
	if ( direction == DIRECTION_LEFT )
	then
		return "left"
	elseif ( direction == DIRECTION_UP )
	then
		return "up"
	elseif ( direction == DIRECTION_RIGHT )
	then
		return "right"
	elseif ( direction == DIRECTION_DOWN )
	then
		return "down"
	end
	return "unknow"
end
