--
--------------------------------------------------------------------------------
--         FILE:  GhostScheduler.lua
--        USAGE:  ./GhostScheduler.lua 
--  DESCRIPTION:  
--      OPTIONS:  ---
-- REQUIREMENTS:  ---
--         BUGS:  ---
--        NOTES:  ---
--       AUTHOR:   (), <>
--      COMPANY:  
--      VERSION:  1.0
--      CREATED:  08/25/2011 14:56:31 CST
--     REVISION:  ---
--------------------------------------------------------------------------------
--

GhostScheduler = class()

function GhostScheduler:init()
	self.scheduleGroup = {}
end

function GhostScheduler:addSchedule( ghostId, launchInSeconds )
	if ( self.scheduleGroup[ghostId] == nil )
	then
		self.scheduleGroup[ghostId] = {}
		self.scheduleGroup[ghostId].insertionTime = GAME_TIME.elapsedTime 
		self.scheduleGroup[ghostId].launchInSeconds = launchInSeconds
	else
		print( "ERROR @ GhostScheduler:addSchedule - " ..
			   "ghostId [" .. ghostId .. "] already exists" )
	end
end

function GhostScheduler:updateSchedules()
	local currentTime = GAME_TIME.elapsedTime
	local toBeRemovedSchedule = {}

	for ghostId, schedule in pairs( self.scheduleGroup )
	do
		local elapsedTime = currentTime - schedule.insertionTime
		--printVar( elapsedTime, "elapsedTime" )
		--printVar( schedule, "schedule" )
		if ( elapsedTime > schedule.launchInSeconds )
		then
			local ghost = ENTITY_MANAGER:getEntity( ghostId )
			if ( ghost == nil )
			then
				print( "ERROR @ GhostScheduler:updateSchedules - " ..
					   "ghost [" .. ghostId .. "] doesn't exist." )
			else
				toBeRemovedSchedule[ghostId] = schedule
				ghost:launch()
			end
		end
	end

	for ghostId, schedule in pairs( toBeRemovedSchedule )
	do
		--print( "remove ghost [" ..ghostId .. "] from scheduler" )
		self.scheduleGroup[ghostId] = nil
	end
end

function GhostScheduler:clearSchedules()
	local toBeRemovedSchedule = {}
	for ghostId, schedule in pairs( self.scheduleGroup )
	do
		toBeRemovedSchedule[ghostId] = schedule
	end
	for ghostId, schedule in pairs( toBeRemovedSchedule )
	do
		self.scheduleGroup[ghostId] = nil
	end
end

-- singleton
GHOST_SCHEDULER = nil
