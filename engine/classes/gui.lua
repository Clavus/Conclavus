
GUI = class("GUI")

function GUI:initialize()

	self._elements = {}

	self._angle = 0
	self._scale = Vector(1,1)
	self._pos = Vector(0,0)
	
end

function GUI:addSimpleElement( depth, pos, image_file, id )
	
	local img = resource.getImage( image_file )
	table.insert(self._elements, { depth = depth, pos = pos, draw_func = function(pos) love.graphics.draw(img, pos.x, pos.y) end, id = id })
	table.sort(self._elements, function(a, b) return a.depth > b.depth end) -- sort by depth
	
end

function GUI:addDynamicElement( depth, pos, func, id )
	
	table.insert(self._elements, { depth = depth, pos = pos, draw_func = func, id = id })
	table.sort(self._elements, function(a, b) return a.depth > b.depth end) -- sort by depth
	
end

function GUI:update( dt )

end

function GUI:draw()
	
	love.graphics.push()
	love.graphics.scale( self._scale.x, self._scale.y )
	love.graphics.rotate( self._angle )
	love.graphics.translate( -self._pos.x, -self._pos.y )
	
	for k, v in ipairs(self._elements) do
		v.draw_func(v.pos)
	end
	
	love.graphics.pop()
	
end

function GUI:removeElement( id )
	
	local new_el = {}
	for k, v in ipairs( self._elements ) do
		if (v.id ~= id) then
			table.insert(new_el, v)
		end
	end
	self._elements = new_el
	
end