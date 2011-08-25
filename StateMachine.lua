require "State"

StateMachine = class()

function StateMachine:init()
	self.currentState = nil
	self.lastState = nil
end

function StateMachine:run()
	if ( self.mainThread == nil )
	then
		self.mainThread = MOAIThread.new()
		self.mainThread:run( self.updateState, self )
	end
end

function StateMachine:stop()
	if ( self.mainThread )
	then
		self.mainThread:stop()
	end
end

function StateMachine:setCurrentState( state )
	if ( state and state:is_a( State ) )
	then
		if ( state == self.currentState )
		then
			print( "WARNING @ StateMachine::setCurrentState - " ..
				   "var state [" .. state.name .. "] is the same as current state" )
			return
		end
		self.lastState = self.currentState
		self.currentState = state
		if ( self.lastState )
		then
			print( "exiting state [" .. self.lastState.name .. "]" )
			self.lastState:exit()
		end
		print( "entering state [" .. self.currentState.name .. "]" )
		self.currentState:enter()
	else
		print( "ERROR @ StateMachine::setCurrentState - " ..
			   "var [state] is not a class type of State" )
	end
end

function StateMachine:updateState()
	while ( true )
	do
		if ( self.currentState ~= nil )
		then
			self.currentState:onUpdate()
		end
		coroutine.yield()
	end
end
