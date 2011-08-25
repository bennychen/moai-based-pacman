--
--------------------------------------------------------------------------------
--         FILE:  Animatable.lua
--        USAGE:  ./Animatable.lua 
--  DESCRIPTION:  class for managing animations
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/22/2011 14:34:52 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

Animatable = class()

function Animatable:init( tileDeck2D, spriteNum )
	self.prop = MOAIProp2D.new()
	self.prop:setDeck( tileDeck2D )

	self.animRemapper = MOAIDeckRemapper.new()
	self.spriteNum = spriteNum
	self.animRemapper:reserve( spriteNum )
	self.prop:setRemapper( self.animRemapper )
	
	self.animationGroup = {}
	self.currentAnim = nil
end

function Animatable:addAnimation( animName, animBeginDeckIndex, animEndDeckIndex,
		animIntervalSeconds, moaiEaseType, animMode )
	if ( self.animationGroup[animName] ~= nil )
	then
		print( "ERROR @ Animatable:addAnimation - animation [" 
				.. animName .. "] already exists." )
		return
	end

	local animFrameNum = animEndDeckIndex - animBeginDeckIndex + 1 

	local animCurve = MOAIAnimCurve.new()
	if ( animMode == MOAITimer.LOOP )
	then
		animCurve:reserveKeys( animFrameNum + 1 )
	else
		animCurve:reserveKeys( animFrameNum )
	end

	for frame = 1, animFrameNum
	do
		animCurve:setKey( frame, ( frame - 1 ) * animIntervalSeconds, 
				animBeginDeckIndex + frame - 1, moaiEaseType )
	end

	if ( animMode == MOAITimer.LOOP )
	then
		animCurve:setKey( animFrameNum + 1, animFrameNum * animIntervalSeconds,
				animBeginDeckIndex, moaiEaseType )
	end

	anim = MOAIAnim.new()
	anim:reserveLinks( 1 )
	anim:setLink( 1, animCurve, self.animRemapper, animBeginDeckIndex )
	anim:setMode( animMode )
	anim.beginDeckIndex = animBeginDeckIndex
	anim.endDeckIndex = animEndDeckIndex
	anim.intervalSeconds = animIntervalSeconds

	self.animationGroup[ animName ] = anim
end

function Animatable:removeAnimation( animName )
	if ( self.animationGroup[animName] == nil ) then
		print( "ERROR @ Animatable:removeAnimation - animation [" 
				.. animName .. "] doesn't exists." )
		return false
	end
	self.animationGroup[animName] = nil
end

function Animatable:getAnimation( animName )
	return self.animationGroup[animName]
end

function Animatable:startAnimation( animName )
	self:setCurrentAnimation( animName )
	self.animationGroup[animName]:start()
end

function Animatable:setCurrentAnimation( animName )
	if ( self.animationGroup[animName] == nil ) then
		print( "ERROR @ Animatable:startAnimation - animation [" 
				.. animName .. "] doesn't exists." )
		return false
	end
	self:stopCurrentAnimation()
	self.prop:setIndex( self.animationGroup[animName].beginDeckIndex )
	self.currentAnim = animName
end

function Animatable:stopAnimation( animName )
	if ( self.animationGroup[animName] == nil ) then
		print( "ERROR @ Animatable:stopAnimation - animation [" 
				.. animName .. "] doesn't exists." )
		return false
	end
	self.animationGroup[animName]:stop()
end

function Animatable:startCurentAnimation()
	if ( self.currentAnim ~= nil )
	then
		self:startAnimation( self.currentAnim )
	end
end

function Animatable:stopCurrentAnimation()
	if ( self.currentAnim ~= nil )
	then
		self:stopAnimation( self.currentAnim )
	end
end
