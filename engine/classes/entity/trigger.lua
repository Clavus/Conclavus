------------------------
-- Trigger class. Derived from @{Wall}, but turns the physics bodies into sensors.
-- Emits the "Trigger" signal with signature *function( (Trigger) trigger, (object) other, (Contact) contact)* when another object collides with it.
-- @cl Trigger

--- @type Trigger
local Trigger = class("Trigger", Wall)
Trigger:include(CollisionResolver)

function Trigger:initialize( world, properties )
	assert(properties ~= nil, "Trigger has no properties!")
	Wall.initialize(self, world)
	self._properties = properties
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

function Trigger:setEnabled( b )
	self._disabled = (b == false)
end

function Trigger:getProperties()
	return properties
end

function Trigger:beginContactWith( other, contact, myFixture, otherFixture, selfIsFirst )
	contact:setEnabled( false )
	if (not self._disabled) then
		signal.emit( "Trigger", self, other, contact)
	end
end

return Trigger