------------------------
-- Level class. Parent class: @{Object}.
-- Manages your game scene.
-- 
-- Derived from @{Object}.
-- @cl Level

--- @type Level
local Level = class('Level')

local lg = love.graphics

function Level:initialize( leveldata )
	self._leveldata = leveldata
	self._camera = Camera()
	self._entManager = EntityManager(self)
	self._physics_system = nil
	if (leveldata.physics.active) then
		self._physics_system = PhysicsSystem()
		self._pixels_per_meter = leveldata.physics.pixels_per_meter
		love.physics.setMeter(self._pixels_per_meter)
	end
end

--- Spawn all objects passed with the @{LevelData} provided during creation.
-- Emits the "SpawnLevelObject" signal with signature *function( (Level) level, (table) objectData )* for every loaded object.
function Level:spawnObjects()
	if (self._leveldata) then
		for k, v in pairs( self._leveldata.objects ) do
			signal.emit( "SpawnLevelObject", self, v )
		end
	end
end

--- Updates level camera, physics and all entities.
-- @number dt delta time
function Level:update( dt )
	self._camera:update(dt)
	if (self._physics_system) then
		self._physics_system:update(dt)
	end
	self._entManager:update(dt)
end

--- Draw all level layers and entities.
function Level:draw()
	self._camera:attach()
	self._entManager:preDraw()
	local cx, cy = self._camera:getPos()
	local cw, ch = self._camera:getWidth(), self._camera:getHeight()
	local ca = self._camera:getAngle()
	local csx, csy = self._camera:getScale()
	local cbw, cbh = self._camera:getBackgroundQuadWidth(), self._camera:getBackgroundQuadHeight()
	
	for k, layer in ipairs( self._leveldata:getLayers() ) do
		lg.setColor(255,255,255,255*layer.opacity)
		if (layer.type == LAYER_TYPE.IMAGES) then -- draw image layer (usually background objects)
			for i, img in pairs(layer.images) do
				if (img.quad) then
					lg.drawq(img.image, img.quad, img.x, img.y, img.angle, img.scale.x, img.scale.y, img.origin.x, img.origin.y )
				else
					lg.draw(img.image, img.x, img.y, img.angle, img.scale.x, img.scale.y, img.origin.x, img.origin.y )
				end
			end
			self._entManager:draw(layer.name) -- draw entities that are to be drawn on this layer
		elseif (layer.type == LAYER_TYPE.BATCH) then -- draw spritebatch layer (usually for tiles)
			for i, batch in pairs(layer.batches) do
				lg.draw(batch)
			end
			self._entManager:draw(layer.name) -- draw entities that are to be drawn on this layer
		elseif (layer.type == LAYER_TYPE.BACKGROUND) then -- draw repeating background layer
			-- disable camera transform for this
			self._camera:detach()
			-- reconstruct quad if camera scale changes
			if (layer.background_quad == nil or layer.background_cam_diagonal ~= self._camera:getDiagonal()) then
				layer.background_quad = lg.newQuad(0, 0, cbw, cbh, layer.background_view_w, layer.background_view_h)
				background_cam_diagonal = self._camera:getDiagonal()
			end
			local image = layer.background_image
			local quad = layer.background_quad
			local x, y, w, h = quad:getViewport()
			local scalar = layer.background_cam_scalar
			local tx, ty = cw/2*csx, ch/2*csy
			lg.push()
			lg.translate( tx, ty )
			lg.rotate( ca )
			lg.translate( -tx, -ty )
			
			quad:setViewport((cx + layer.x) * csx * layer.parallax, (cy + layer.y) * csy * layer.parallax, w, h)
			lg.drawq(image, quad, cw*csx, ch*csy, 0, 1, 1, cbw/2, cbh/2)
			self._entManager:draw(layer.name) -- draw entities that are to be drawn on this layer
			lg.pop()
			self._camera:attach()
		elseif (layer.type == LAYER_TYPE.CUSTOM) then
			lg.push()
			lg.translate(cx*(1-layer.parallax), cy*(1-layer.parallax))
			layer:drawFunc(self._camera)
			lg.pop()
		end
	end
	
	lg.setColor(255,255,255,255)
	self._entManager:postDraw()
	self._camera:detach()
end

--- Get the properties table from the @{LevelData} provided during creation.
-- @treturn table leveldata properties
function Level:getProperties()
	return self._leveldata.properties
end

--- Get the physics world. Requires the physics system to be active in this level.
-- @treturn World world physics world
function Level:getPhysicsWorld()
	assert(self._physics_system ~= nil, "Physics world not active!")
	return self._physics_system:getWorld()
end

--- Get pixels per meter of the physics world.
-- @treturn number pixels per meter
function Level:getPixelsPerMeter()
	return self._pixels_per_meter
end

--- Get camera object.
-- @treturn Camera camera
function Level:getCamera()
	return self._camera
end

--- Create an entity.
-- @string class entity class name
-- @treturn Entity entity
function Level:createEntity( class, ... )
	return self._entManager:createEntity( class, ...)
end

--- Get entities by class.
-- @string class class name
-- @treturn table table of entities
function Level:getEntitiesByClass( class )
	return self._entManager:getEntitiesByClass( class )
end

--- Get entities by mixin.
-- @tparam table mixin mixin table
-- @treturn table table of entities
function Level:getEntitiesByMixin( mixin )
	return self._entManager:getEntitiesByMixin( mixin )
end

--- Get entities by function filter.
-- @func func filter function (returns true or false)
-- @treturn table table of entities
function Level:getEntitiesWhere( func )
	return self._entManager:getEntitiesWhere( func )
end

--- Get all entities.
-- @treturn table table of entities
function Level:getAllEntities()
	return self._entManager:getAllEntities()
end

return Level