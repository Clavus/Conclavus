------------------------
-- EntityManager class.
-- Handles all entities in the level and keeps em happy.
-- @cl EntityManager

local EntityManager = class("EntityManager")

function EntityManager:initialize( level )
	self._entities = {}
	self._drawlist = {}
	self._update_drawlist = true
	self._level = level
end

function EntityManager:loadLevelObjects( levelobjects )
	if (levelobjects and game.createLevelEntity) then
		for i,v in ipairs(levelobjects) do
			game.createLevelEntity(self._level, v)
		end
	end
end

function EntityManager:createEntity( class, ...)
	--print("Creating entity of "..tostring(class))
	local ent
	if (_G[class] and _G[class]:isSubclassOf(Entity)) then
		ent = _G[class](...)
	end
	
	if (ent ~= nil and ent:isInstanceOf(_G[class])) then
		table.insert(self._entities, ent)
		--print("Created entity, new list:\n"..table.toString(self._entities,"self._entities",true))
		self._update_drawlist = true
		return ent
	else
		return nil
	end
end

function EntityManager:update( dt )
	local ent
	-- traverse table in reverse order so we can safely remove entities while traversing
	for i = #self._entities, 1, -1 do
		ent = self._entities[i]
		ent:update( dt )
		if (ent._removeflag) then
			table.remove(self._entities, i)
			ent:onRemove()
			self._update_drawlist = true
		end		
	end
end

function EntityManager:preDraw()
	
	local level = self._level
	-- created sorted drawing lists per layer for entities
	if (self._update_drawlist) then
		self._drawlist = { _first = {}, _final = {} }
		local layername
		
		for k, ent in pairs( self._entities ) do
			layername = ent:getDrawLayer()
			if (layername == DRAW_LAYER.BOTTOM) then
				table.insert(self._drawlist._first, ent)
			elseif (layername == DRAW_LAYER.TOP) then
				table.insert(self._drawlist._final, ent)
			else
				if not self._drawlist[layername] then
					self._drawlist[layername] = {} 
				end
				table.insert(self._drawlist[layername], ent)
			end
		end
		self._update_drawlist = false
		--print("Updated draw list:\n"..table.toString(self._drawlist,"self._drawlist",true))
		-- sort entities by depth
		for k, v in pairs( self._drawlist ) do
			table.sort( self._drawlist[k], function(a, b) return a:getDrawDepth() > b:getDrawDepth() end )
		end
	end
	
	local cam = level:getCamera()
	for i, ent in ipairs( self._drawlist._first ) do
		if (cam:isEntityVisible( ent )) then
			ent:draw()
		end
	end
end

-- draw all entities in the given layer
function EntityManager:draw( layer )
	local cam = self._level:getCamera()
	if (self._drawlist[layer]) then
		for i, ent in ipairs( self._drawlist[layer] ) do
			if (cam:isEntityVisible( ent )) then
				ent:draw()
			end
		end
	end
end

-- draw all entities that want to be above everything else
function EntityManager:postDraw()
	local cam = self._level:getCamera()
	for i, ent in ipairs( self._drawlist._final ) do
		--print("Drawing "..tostring(ent)..": "..tostring(cam:isEntityVisible( ent )))
		if (cam:isEntityVisible( ent )) then
			ent:draw()
		end
	end
end

function EntityManager:getEntitiesByClass( cl )
	return self:getEntitiesWhere( function( ent ) 
		if ent:isInstanceOf(cl) then 
			return true
		end
	end )
end

function EntityManager:getEntitiesByMixin( mixin )
	return self:getEntitiesWhere( function( ent ) 
		if ent.class:includes(mixin) then 
			return true
		end
	end )
end

function EntityManager:getEntitiesWhere( func )
	assert(type(func) == "function", "Parameter is not a function")
	local res = {}
	for k, v in ipairs( self._entities ) do
		if (func(v) == true) then
			table.insert(res, v)
		end
	end
	return res
end

function EntityManager:getAllEntities()
	return table.copy( self._entities )
end

return EntityManager

