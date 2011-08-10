require "State"

StateMachine = class()

function StateMachine:init()
	self.currentState = nil
	self.lastState = nil
end

function StateMachine:setCurrentState( state )
	print( "StateMachine::setCurrentState" )
	if ( state and state:is_a( State ) and state ~= self.lastState )
	then
		self.lastState = self.currentState
		self.currentState = state
		if ( self.lastState )
		then
			self.lastState:exit()
		end
		self.currentState:enter()
	else
		print( "ERROR @ StateMachine::setCurrentState: " ..
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
