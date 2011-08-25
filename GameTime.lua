--
--------------------------------------------------------------------------------
--         FILE:  GameTime.lua
--        USAGE:  ./GameTime.lua 
--  DESCRIPTION:  class for managing game time  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (Benny Chen), <rockerbenny@gmail.com>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/25/2011 16:53:50 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

GameTime = class()

function GameTime:init()
	self.startTime = nil
	self.elapsedTime = nil
	self.pauseTime = nil
	self.isPaused = true
	self.thread = MOAIThread.new()
end

function GameTime:start()
	self.startTime = MOAISim:getElapsedTime()
	self.elapsedTime = 0
	self.thread:run( self.update, self )
end

function GameTime:stop()
	self.thread:stop()
end

function GameTime:pause()
	self.pauseTime = self.elapsedTime
	self.isPaused = true
end

function GameTime:resume()
	self.isPaused = false
end

function GameTime:update()
	while ( true )
	do
		if ( self.isPaused == false )
		then
			self.elapsedTime = self.elapsedTime + FRAME_TIME
		end
		coroutine.yield()
	end
end

--singleton
GAME_TIME = nil
