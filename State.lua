require "class"

State = class()

function State:init( name )
	self.name = name
end

function State:enter()
end

function State:onUpdate()
end

function State:exit()
end
