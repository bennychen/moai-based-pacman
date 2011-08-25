--
--------------------------------------------------------------------------------
--         FILE:  Ghost.lua
--        USAGE:  ./Ghost.lua 
--  DESCRIPTION:  class for handling ghost 
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 14:15:05 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--
require "GameEntity"

Ghost = class( GameEntity )

Ghost.ANIM_PURSUE = "pursue"
Ghost.ANIM_EVADE = "evade"
Ghost.ANIM_BLINK = "blink"
Ghost.ANIM_DYING = "dying"

Ghost.STATE_NONE = 0
Ghost.STATE_STANDBY = 1
Ghost.STATE_PURSUE = 2
Ghost.STATE_EVADE = 3
Ghost.STATE_DEAD = 4

function Ghost:init( parentTransform, spawnPoint, spawnDirection, 
		pursueSpeed, evadeSpeed, tileDeck2D, spriteNum )
	GameEntity.init( self, parentTransform, spawnPoint, spawnDirection, 0, tileDeck2D, spriteNum )
	self.pursueSpeed = pursueSpeed
	self.evadeSpeed = evadeSpeed
	self:initAnimation()

	self.state = Ghost.STATE_NONE
end

function Ghost:initAnimation()
	self.animatable:addAnimation( Ghost.ANIM_PURSUE, 1, 2, 0.30, MOAIEaseType.FLAT, MOAITimer.LOOP )
	self.animatable:addAnimation( Ghost.ANIM_BLINK, 2, 3, 0.20, MOAIEaseType.FLAT, MOAITimer.LOOP )
	self.animatable:addAnimation( Ghost.ANIM_EVADE, 3, 4, 0.30, MOAIEaseType.FLAT, MOAITimer.LOOP )
	self.animatable:addAnimation( Ghost.ANIM_DYING, 5, 7, 0.30, MOAIEaseType.FLAT, MOAITimer.NORMAL )
end

function Ghost:setStandBy()
	self.state = Ghost.STATE_STANDBY
	self.velocity.speed = 0
	self.animatable:startAnimation( Ghost.ANIM_PURSUE )
	self.canCrossBar = true
end

function Ghost:startPursuing()
	self.state = Ghost.STATE_PURSUE
	self.velocity.speed = self.pursueSpeed
	self.animatable:startAnimation( Ghost.ANIM_PURSUE )
	self:adjustPosition()
end

function Ghost:startBlinking()
	if ( self.animatable.currentAnim ~= Ghost.ANIM_BLINK )
	then
		self.animatable:startAnimation( Ghost.ANIM_BLINK )
	end
end

function Ghost:startEvading( evadeDuration )
	self.state = Ghost.STATE_EVADE
	self.velocity.speed = self.evadeSpeed
	self.animatable:startAnimation( Ghost.ANIM_EVADE )
	self.animatable:startAnimation( Ghost.ANIM_BLINK )

	self.evadeDuration = evadeDuration
	self.evadeStartTime = MOAISim:getElapsedTime()
end

function Ghost:setDead()
	self.state = Ghost.STATE_DEAD
	self.velocity.speed = 0
	self.animatable:startAnimation( Ghost.ANIM_DYING )
end

function Ghost:isActive()
	return self.state == Ghost.STATE_PURSUE or self.state == Ghost.STATE_EVADE
end

function Ghost:setAIStrategy( strategy )
	if ( strategy:is_a( GhostAIStrategy ) )
	then
		self.aiStrategy = strategy
	else
		print( "ERROR @ Ghost:setAIStrategy - " ..
			   "param [strategy] is not a type of GhostAIStrategy" )
	end
end

function Ghost:doPathFinding()
	if ( self.state == Ghost.STATE_PURSUE )
	then
		self:setPursueDirection()
	elseif ( self.state == Ghost.STATE_EVADE )
	then
		local currentTime = MOAISim:getElapsedTime()
		local evadeElapsedTime = currentTime - self.evadeStartTime
		if ( evadeElapsedTime > self.evadeDuration )
		then
			self:startPursuing()
		else
			local evadeRemainingTime = self.evadeDuration - evadeElapsedTime
			if ( math.abs( evadeRemainingTime - 5 ) < FRAME_TIME )
			then
				self:startBlinking()
			end
			self:setEvadeDirection()
		end
	end
end

function Ghost:setPursueDirection()
	if ( self.aiStrategy ~= nil )
	then
		local direction = self.aiStrategy:getPursueDirection( self )
		self:setDirection( direction )
	end
end

function Ghost:setEvadeDirection()
	if ( self.aiStrategy ~= nil )
	then
		local direction = self.aiStrategy:getPursueDirection( self )
		self:setDirection( direction )
	end
end

--this function is used when changing speed
function Ghost:adjustPosition()
	local ghostX
	local ghostY
	ghostX, ghostY = self:getLeftTopLoc()
	--printVar( ghostX, "current ghost x" )
	--printVar( ghostY, "current ghost y" )
	local pursueSpeedPerFrame = self.pursueSpeed / FRAMES_PER_SECOND
	local fractionX = math.fmod( ghostX, pursueSpeedPerFrame )
	local fractionY = math.fmod( ghostY, pursueSpeedPerFrame )
	--printVar( pursueSpeedPerFrame, "pursueSpeedPerFrame" )
	--printVar( fractionX, "fractionX" )
	--printVar( fractionY, "fractionY" )
	self.prop:addLoc( -fractionX, -fractionY )
	ghostX, ghostY = self:getLeftTopLoc()
	--printVar( ghostX, "adjusted ghost x" )
	--printVar( ghostY, "adjusted ghost y" )
end
