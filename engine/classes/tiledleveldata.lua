
TiledLevelData = class('TiledLevelData', LevelData)

local OPTIMIZE_TILESET = true

function TiledLevelData:initialize( file_path )
	
	LevelData.initialize(self)
	
	local succ, tab = pcall(function() return require(file_path) end)
	assert(succ and type(tab) == "table", "Failed to load Tiled table "..tostring(file_path))
	
	self._file_dir = util.getPathFromFilename(file_path)
	self:processTiledData( tab )
	
	--print(table.toString(self.tilesets, "tilesets", true))
	--print(table.toString(self.layers, "layers", true))
	--print(table.toString(self.objects, "objects", true))
	
end

function TiledLevelData:processTiledData( data )

	--print(table.toString(data, "TileLevelData", true, 40))
	
	self.level_width = data.width or self.level_width
	self.level_height = data.height or self.level_height
	self.level_tilewidth =  data.tilewidth or self.level_tilewidth 
	self.level_tileheight = data.tileheight or self.level_tileheight
	
	assert(data.orientation == "orthogonal", "Only orthogonal maps are supported right now")
	
	local tilesetcache = {}
	
	-- parse tilesets
	for k, tileset in ipairs(data.tilesets) do
		
		local newtileset = {}
		newtileset.name = tileset.name
		newtileset.tilewidth = tileset.tilewidth or 32
		newtileset.tileheight = tileset.tileheight or 32
		newtileset.tilemargin = tileset.margin or 0
		newtileset.tilespacing = tileset.spacing or 0
		newtileset.properties = tileset.properties or {}
		newtileset.image = resource.getImage( self._file_dir..tileset.image, "repeat" )
		newtileset.imagewidth = tileset.imagewidth
		newtileset.imageheight = tileset.imageheight
		
		local tiles_per_row = 0
		local tiles_per_column = 0
		local iw, ih = (tileset.imagewidth - tileset.margin), (tileset.imageheight - tileset.margin)
		
		while(iw >= tileset.tilewidth) do
			tiles_per_row = tiles_per_row + 1
			iw = iw - tileset.tilewidth - tileset.spacing
		end
		
		while(ih >= tileset.tileheight) do
			tiles_per_column = tiles_per_column + 1
			ih = ih - tileset.tileheight - tileset.spacing
		end
		
		newtileset.tiles_per_row = tiles_per_row
		newtileset.tiles_per_column = tiles_per_column
		
		tilesetcache[tileset.name] = { 
			firstgid = tileset.firstgid,
			lastgid = tileset.firstgid + (tiles_per_row * tiles_per_column) - 1,
			tab = newtileset
		}
		
		table.insert(self.tilesets, newtileset)
		
	end	
	
	local function getTileSetFromID( id )
		for k, v in pairs( tilesetcache ) do
			if (id >= v.firstgid and id <= v.lastgid) then
				return v.tab
			end
		end		
	end
	
	-- parse tile and object layers
	for k, layer in ipairs(data.layers) do
		
		if (layer.type == "tilelayer") then
		
			local newlayer = {}
			local shiftx = layer.x or 0
			local shifty = layer.y or 0
			
			newlayer.name = layer.name or "noname"
			newlayer.type = LAYER_TYPE_BATCH
			newlayer.opacity = layer.opacity or 1
			newlayer.properties = layer.properties or {}
			newlayer.x = shiftx
			newlayer.y = shifty
			newlayer.angle = 0
			newlayer.parallax = newlayer.properties.parallax or 1
			newlayer.scale = Vector(1,1)
			
			--newlayer.tiles = {}
			newlayer.batches = {}
			
			-- parse all the tiles
			local row = 0
			local column = 0
			local tid, batch, tx, ty, cn, rn, ay
			
			for i, id in ipairs(layer.data) do
				
				-- if space is not empy
				if (id > 0) then
					local newtile = {}
					local tset = getTileSetFromID( id )
					if (tset ~= nil) then
						if (not newlayer.batches[tset.name]) then
							local size = self.level_width * self.level_height
							newlayer.batches[tset.name] = love.graphics.newSpriteBatch( tset.image, size, "static")
							newlayer.batches[tset.name]:bind()
						end
						
						batch = newlayer.batches[tset.name]
						
						tx, ty, cn, rn = 0, 0, 0, 0
						tid = (id - tilesetcache[tset.name].firstgid) -- index relative to tileset
						cn = tid % tset.tiles_per_row -- column number
						rn = math.floor(tid / tset.tiles_per_row) -- row number
						tx = tset.tilemargin + (cn * (tset.tilewidth + tset.tilespacing)) -- tile x coord on tileset
						ty = tset.tilemargin + (rn * (tset.tileheight + tset.tilespacing)) -- tile y coord on tileset
						newtile.tileset = tset
						
						newtile.draw_quad = love.graphics.newQuad( tx, ty, tset.tilewidth, tset.tileheight, tset.imagewidth, tset.imageheight )
						
						ay = 0  -- we need to adjust the y coord for different sized tiles. TileD scales them from the bottom left while we expect top left.
						ay = self.level_tileheight - tset.tileheight
						
						newtile.x = shiftx + column * self.level_tilewidth -- x coord in world
						newtile.y = shifty + row * self.level_tileheight + ay -- y coord in world
						
						batch:addq( newtile.draw_quad, newtile.x, newtile.y )
						--table.insert(newlayer.tiles, newtile)
					end
				end
				
				for _, batch in pairs(newlayer.batches) do
					batch:unbind()
				end
				
				column = column + 1
				if (column >= layer.width) then
					column = 0
					row = row + 1
				end
				
			end			
			
			table.insert(self.layers, newlayer)
			
		elseif (layer.type == "objectgroup") then
		
			local shiftx = layer.x or 0
			local shifty = layer.y or 0			
			
			for i, obj in ipairs(layer.objects) do
				local newobject = {}
				newobject.type = obj.type
				newobject.x = obj.x + shiftx
				newobject.y = obj.y + shifty
				
				if (obj.polygon) then
					newobject.polygon = obj.polygon
				else
					newobject.w = obj.width
					newobject.h = obj.height
				end
				
				newobject.properties = obj.properties or {}
				
				table.insert(self.objects, newobject)
			end	
			
		else
			print("TiledLevelData parsing: unhandled layer type "..layer.type)
		end		
		
	end
	
end