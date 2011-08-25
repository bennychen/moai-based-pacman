--
--------------------------------------------------------------------------------
--         FILE:  Pacman.lua
--        USAGE:  ./Pacman.lua 
--  DESCRIPTION:  class for handling Pacman controlled by user
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/14/2011 18:16:47 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

require "GameEntity"
require "Vector2"

Pacman = class( GameEntity )

Pacman.ANIM_DYING = "dying"

function Pacman:init( parentTransform, spawnPoint, spawnDirection, 
		speed, tileDeck2D, spriteNum )
	GameEntity.init( self, parentTransform, spawnPoint, spawnDirection, 0, tileDeck2D, spriteNum )

	self.movingSpeed = speed
	self:initAnimation()
end

function Pacman:initAnimation()
	for direction = DIRECTION_LEFT, DIRECTION_DOWN
	do
		local animStartDeckIndex = self:getMovingAnimStartDeckIndex( direction ) 
		self.animatable:addAnimation( direction, animStartDeckIndex, animStartDeckIndex + 1,
				0.30, MOAIEaseType.FLAT, MOAITimer.LOOP )
	end
	self.animatable:addAnimation( Pacman.ANIM_DYING, 9, 13, 
			0.50, MOAIEaseType.FLAT, MOAITimer.NORMAL )
end

function Pacman:setDirectionWithAnimation( direction )
	if ( Velocity.isValidDirection( direction ) )
	then
		if ( direction == self.velocity.direction )
		then
			return
		end

		self.velocity:setDirection( direction )
		self.animatable:startAnimation( direction )
	else
		print( "ERROR @ Pacman:setDirectionWithAnimation - failed, invalid direction" )
	end
end

function Pacman:setDirection( direction )
	if ( Velocity.isValidDirection( direction ) )
	then
		if ( direction == self.velocity.direction )
		then
			return
		end

		self.velocity:setDirection( direction )
		self.animatable:setCurrentAnimation( direction )
	else
		print( "ERROR @ Pacman:setDirectionWithAnimation - failed, invalid direction" )
	end
end

function Pacman:startMoving()
	self.velocity.speed = self.movingSpeed
	self.animatable:startAnimation( self.velocity.direction )
end

function Pacman:stopMoving()
	self.velocity.speed = 0
	self.animatable:stopAnimation( self.velocity.direction )
end

function Pacman:setDead()
	self.velocity.speed = 0
	self.animatable:startAnimation( Pacman.ANIM_DYING )
end

function Pacman:getMovingAnimStartDeckIndex( direction )
	return ( direction * 2 - 1 )
end
