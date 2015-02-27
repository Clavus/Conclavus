
local GUI = class("GUI")
GUI:include( Positional )
GUI:include( Rotatable )
GUI:include( Scalable )

local lg = love.graphics

function GUI:initialize()	
	Positional.initialize( self )
	Rotatable.initialize( self )
	Scalable.initialize( self )	
	self._elements = {}
end

function GUI:addSimpleElement( id, depth, x, y, imagef )
	local img = imagef
	if (type(imagef) == "string") then
		img = resource.getImage( imagef )
	end		
	table.insert(self._elements, { depth = depth, pos = { x = x, y = y }, draw_func = function(x, y) lg.draw(img, x, y) end, id = id })
	table.sort(self._elements, function(a, b) return a.depth > b.depth end) -- sort by depth	
end

function GUI:addDynamicElement( id, depth, x, y, func )
	table.insert(self._elements, { depth = depth, pos = { x = x, y = y }, draw_func = func, id = id })
	table.sort(self._elements, function(a, b) return a.depth > b.depth end) -- sort by depth	
end

function GUI:update( dt )

end

function GUI:draw()	
	local px, py = self:getPos()
	lg.push()
	lg.scale( self:getScale() )
	lg.rotate( self:getAngle() )
	lg.translate( -px, -py )	
	for k, v in ipairs(self._elements) do
		v.draw_func(v.pos.x, v.pos.y)
	end	
	lg.pop()	
end

function GUI:removeElement( id )
	table.removeByFilter( self._elements, function( k, v )
		return v.id == id
	end)	
end

function GUI:clear()
	self._elements = {}
end

return GUI