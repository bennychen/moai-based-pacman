--
--------------------------------------------------------------------------------
--         FILE:  Ghost.lua
--        USAGE:  ./Ghost.lua 
--  DESCRIPTION:  class for handling ghost 
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
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
	self.animatable:addAnimation( Ghost.ANIM_BLINK, 2, 3, 0.30, MOAIEaseType.FLAT, MOAITimer.LOOP )
	self.animatable:addAnimation( Ghost.ANIM_EVADE, 3, 4, 0.30, MOAIEaseType.FLAT, MOAITimer.LOOP )
	self.animatable:addAnimation( Ghost.ANIM_DYING, 5, 7, 0.30, MOAIEaseType.FLAT, MOAITimer.NORMAL )
end

function Ghost:setStandBy()
	self.state = Ghost.STATE_STANDBY
	self.velocity.speed = 0
	self.animatable:startAnimation( Ghost.ANIM_PURSUE )
	self.canCrossBar = true
	self.isSpelled = false
end

function Ghost:launch()
	if ( self.state == Ghost.STATE_STANDBY )
	then
		if ( self.animatable.currentAnim == Ghost.ANIM_PURSUE )
		then
			self:startPursuing()
		elseif ( self.animatable.currentAnim == Ghost.ANIM_EVADE )
		then
			self:startEvading()
		end
	end
end

function Ghost:performSpell( spellTime )
	if ( self.state == Ghost.STATE_STANDBY )
	then
		self:startEvadeAnimation()
	else
		self:startEvading()
	end
	self:startSpellTiming( spellTime )
end

function Ghost:startPursuing()
	self.state = Ghost.STATE_PURSUE
	self.velocity.speed = self.pursueSpeed
	self:adjustPosition()
	self:startPursueAnimation()
end

function Ghost:startEvading( evadeDuration )
	self.state = Ghost.STATE_EVADE
	self.velocity.speed = self.evadeSpeed
	--self:adjustPosition()
	self:startEvadeAnimation()
end

function Ghost:startBlinking()
	if ( self.animatable.currentAnim ~= Ghost.ANIM_BLINK )
	then
		self.animatable:startAnimation( Ghost.ANIM_BLINK )
	end
end

function Ghost:startPursueAnimation()
	self.animatable:startAnimation( Ghost.ANIM_PURSUE )
end

function Ghost:startEvadeAnimation()
	self.animatable:startAnimation( Ghost.ANIM_EVADE )
end

function Ghost:startSpellTiming( spellDuration )
	self.isSpelled = true
	self.spellDuration = spellDuration
	self.spellStartTime = GAME_TIME.elapsedTime
end

function Ghost:stopSpellTimng()
	self.isSpelled = false
end

function Ghost:isDead()
	return self.state == Ghost.STATE_DEAD
end

function Ghost:setDead()
	print( "ghost ["..self.id.."] is dead" )
	self.state = Ghost.STATE_DEAD
	self.velocity.speed = 0
	self.animatable:startAnimation( Ghost.ANIM_DYING )
	self:stopSpellTimng()
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

function Ghost:update()
	self:updateSpellTiming()
	self:doPathFinding()
end

function Ghost:updateSpellTiming()
	if ( self.isSpelled == true )
	then
		local currentTime = GAME_TIME.elapsedTime
		local spellElapsedTime = currentTime - self.spellStartTime
		if ( spellElapsedTime > self.spellDuration )
		then
			if ( self.state == Ghost.STATE_STANDBY )
			then
				self:startPursueAnimation()
			elseif ( self.state == Ghost.STATE_EVADE )
			then
				self:startPursuing()
			end
			self:stopSpellTimng()
		else
			local spellRemainingTime = self.spellDuration - spellElapsedTime
			if ( math.abs( spellRemainingTime - 5 ) < FRAME_TIME )
			then
				self:startBlinking()
			end
		end
	end
end

function Ghost:doPathFinding()
	if ( self.aiStrategy == nil )
	then
		return
	end
	if ( self.state == Ghost.STATE_PURSUE )
	then
		self:setDirection( self.aiStrategy:getPursueDirection( self ) )
	elseif ( self.state == Ghost.STATE_EVADE )
	then
		self:setDirection( self.aiStrategy:getEvadeDirection( self ) )
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
