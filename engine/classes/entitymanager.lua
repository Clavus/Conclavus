
EntityManager = class("EntityManager")

function EntityManager:initialize()
	
	self._entities = {}
	--print(table.toString(self._entities, "entities", true))
	self._drawlist = {}
	self._update_drawlist = true
	
end

function EntityManager:loadLevelObjects( level, levelobjects )
	
	self._level = level
	
	if (levelobjects and game.createLevelEntity) then
	
		for i,v in ipairs(levelobjects) do
			game.createLevelEntity(level, v)
		end
		
	end
	
end

function EntityManager:createEntity( class, ...)
	
	--print("Creating entity of "..tostring(class))
	
	local ent
	if (_G[class] and subclassOf(Entity, _G[class])) then
		ent = _G[class](...)
	end
	
	if (ent ~= nil and instanceOf(_G[class], ent)) then
		table.insert(self._entities, ent)
		--print("Created entity, new list:\n"..table.toString(self._entities,"self._entities",true))
		self._update_drawlist = true
		return ent
	else
		return nil
	end
	
end

function EntityManager:removeEntity( ent )
	
	table.removeByValue(self._entities, ent)
	ent:onRemove()
	
	self._update_drawlist = true
	
end

function EntityManager:update( dt )
	
	for k, v in ipairs( self._entities ) do
		local mul = v:getUpdateRateMultiplier() or 1
		v:update( dt * mul )
	end
	
end

function EntityManager:preDraw()
	
	-- created sorted drawing lists per layer for entities
	if (self._update_drawlist) then
		
		local level = self._level
		
		self._drawlist = { _first = {}, _final = {} }
		local layername
		local campos = Vector(level:getCamera():getTargetPos())
		
		for k, ent in pairs( self._entities ) do
			
			if (level:isRectInActiveArea(campos, ent:getDrawBoundingBox())) then
				layername = ent:getDrawLayer()
				if (layername == DRAW_LAYER_BOTTOM) then
					table.insert(self._drawlist._first, ent)
				elseif (layername == DRAW_LAYER_TOP) then
					table.insert(self._drawlist._final, ent)
				else
					if not self._drawlist[layername] then
						self._drawlist[layername] = {} 
					end
					table.insert(self._drawlist[layername], ent)
				end
			end
			
		end
		
		self._update_drawlist = false
		--print("Updated draw list:\n"..table.toString(self._drawlist,"self._drawlist",true))
	end
	
	-- sort entities by depth
	for k, v in pairs( self._drawlist ) do
		table.sort( self._drawlist[k], function(a, b) return a:getDepth() > b:getDepth() end )
	end
	
	for i, ent in ipairs( self._drawlist._first ) do
		ent:draw()
	end
	
end

-- draw all entities in the given layer
function EntityManager:draw( layer )
	
	if (self._drawlist[layer]) then
		for i, ent in ipairs( self._drawlist[layer] ) do
			ent:draw()
		end
	end
	
end

-- draw all entities that want to be above everything else
function EntityManager:postDraw()
	
	for i, ent in ipairs( self._drawlist._final ) do
		ent:draw()
	end
	
end

function EntityManager:getEntitiesByClass( cl )

	local res = {}
	for k, v in ipairs( self._entities ) do
		if (instanceOf(cl, v)) then
			table.insert(res, v)
		end
	end
	return res
	
end

function EntityManager:getEntitiesByMixin( mixin )
	
	local res = {}
	for k, v in ipairs( self._entities ) do
		if (includes(mixin, v.class)) then
			table.insert(res, v)
		end
	end
	return res
	
end

