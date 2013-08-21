
Trigger = class("Trigger", Wall)
Trigger:include(mixin.CollisionResolver)

function Trigger:initialize( world, properties )
	
	assert(properties ~= nil, "Trigger has no properties!")
	
	Wall.initialize(self, world)
	
	self._type = properties.type
	self._params = { properties.param1, properties.param2, properties.param3 }
	self._disabled = false
	
end

function Trigger:buildFromSquare(w, h)

	Wall.buildFromSquare(self, w, h)
	self._fixture:setSensor(true)
	
end

function Trigger:buildFromPolygon(pol)

	Wall.buildFromPolygon(self, pol)
	self._fixture:setSensor(true)
	
end

function Trigger:resolveCollisionWith( other, contact )
	
	contact:setEnabled( false )
	
	if (not self._disabled) then
		if (game.handleTrigger( other, contact, self._type, unpack(self._params))) then
			self._disabled = true
		end
	end

end