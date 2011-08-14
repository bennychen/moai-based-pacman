require "State"

StateMachine = class()

function StateMachine:init()
	self.currentState = nil
	self.lastState = nil
end

function StateMachine:setCurrentState( state )
	if ( state and state:is_a( State ) )
	then
		if ( state == self.lastState )
		then
			print( "WARNING @ StateMachine::setCurrentState - " ..
				   "var [state] is the same as current state" )
			return
		end
		self.lastState = self.currentState
		self.currentState = state
		if ( self.lastState )
		then
			self.lastState:exit()
		end
		self.currentState:enter()
	else
		print( "ERROR @ StateMachine::setCurrentState - " ..
			   "var [state] is not a class type of State" )
	end
end

function StateMachine:updateState()
	if ( self.currentState )
	then
		self.currentState:execute()
	end
end

--singleton
STATE_MACHINE = StateMachine()
