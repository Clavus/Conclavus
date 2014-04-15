--[[
	Alterted by Clavus
	
	Format info table accepts tables or Color class because it now checks for 
	tab.r, tab.g, tab.b and tab.a for color definitions.
]]

local tlib = { texts = {} }
tlib.__index = tlib

function tlib.new( text, info )
	local lines = tlib.parse( text )
	local formatted = tlib.format( lines, info )
	local positions = tlib.position( formatted, info.x, info.y )
	for a = 1, #formatted do
		formatted[a].x = positions[a].x
		formatted[a].y = positions[a].y 
	end
	
	local t = { formatted = formatted, info = info, x = info.x, y = info.y }
	
	if love.graphics.isSupported( 'canvas' ) then
		local width, height = positions.width, positions.height
		if not love.graphics.isSupported( 'npot' ) then
			width, height = tlib.formatPO2( positions.width, positions.height )
		end
		t.width, t.height = width, height
		t.canvas = love.graphics.newCanvas( width, height )
		love.graphics.setCanvas( t.canvas )
			local prevBlendMode = love.graphics.getBlendMode()
			t.canvas:clear()
			t.blendMode = info.blendMode or 'alpha'
			love.graphics.setBlendMode( t.blendMode )
			
			local pr, pg, pb, pa = love.graphics.getColor()
			local prevFont = love.graphics.getFont()
			love.graphics.setColor( 255, 255, 255, 255 )
			
			for a = 1, #t.formatted do
				love.graphics.setColor( t.formatted[a].color )
				if not t.formatted[a].image then
					love.graphics.setFont( t.formatted[a].font )
					love.graphics.print( t.formatted[a].text, ( t.formatted[a].x - t.formatted[1].x ) + 1, 1 )
				else
					love.graphics.draw( t.formatted[a].image, ( t.formatted[a].x - t.formatted[1].x ) + 1, 1 + tlib.getTextHeight( formatted[a].text, formatted[a].font ) - formatted[a].image:getHeight() )
				end
			end
			love.graphics.setBlendMode( prevBlendMode )
		love.graphics.setCanvas()
		
		love.graphics.setFont( prevFont )
		love.graphics.setColor( pr, pg, pb, pa )
	else
		t.canvas = false
	end
	
	setmetatable( t, tlib )
	table.insert( tlib.texts, t )	
	return t
end

function tlib:draw( ... )
	local pr, pg, pb, pa = love.graphics.getColor()
	local prevFont = love.graphics.getFont()
	love.graphics.setColor( 255, 255, 255, 255 )
	
	if ... then
		local tab = {}
		if self then tab = { self, ... } else tab = { ... } end
		for a = 1, #tab do
			if tab[a].canvas then
				local prevBlendMode = love.graphics.getBlendMode()
				
				love.graphics.setBlendMode( tab[a].blendMode )
				love.graphics.draw( tab[a].canvas, tab[a].x, tab[a].y )
				
				love.graphics.setBlendMode( prevBlendMode )
			else
				for e = 1, #tab[a].formatted do
					love.graphics.setColor( tab[a].formatted[e].color )
					if not tab[a].formatted[e].image then
						love.graphics.setFont( tab[a].formatted[e].font )
						love.graphics.print( tab[a].formatted[e].text, tab[a].formatted[e].x, tab[a].formatted[e].y )
					else
						love.graphics.draw( tab[a].formatted[e].image, tab[a].formatted[e].x, tab[a].formatted[e].y )
					end
				end
			end
		end
	else
		if self.canvas then
			local prevBlendMode = love.graphics.getBlendMode()
			
			love.graphics.setBlendMode( self.blendMode )
			love.graphics.draw( self.canvas, self.x, self.y )
			
			love.graphics.setBlendMode( prevBlendMode )
		else
			for a = 1, #self.formatted do
				love.graphics.setColor( self.formatted[a].color )
				if not self.formatted[a].image then
					love.graphics.setFont( self.formatted[a].font )
					love.graphics.print( self.formatted[a].text, self.formatted[a].x, self.formatted[a].y )
				else
					love.graphics.draw( self.formatted[a].image, self.formatted[a].x, self.formatted[a].y )
				end
			end
		end
	end
	
	love.graphics.setFont( prevFont )
	love.graphics.setColor( pr, pg, pb, pa )
end

function tlib.formatPO2( width, height )
	local a = 1
	local b = 1
	while a < width do
		a = a * 2
	end
	while b < height do
		b = b * 2
	end
end

function tlib.position( formatted, x, y )
	local positions = { width = 0, height = {} }
	
	local nx = x
	for a = 1, #formatted do
		table.insert( positions, { x = nx, y = y } )
		if formatted[a].image then 
			nx = nx + formatted[a].image:getWidth()
			positions[#positions].y = y + tlib.getTextHeight( formatted[a].text, formatted[a].font ) - formatted[a].image:getHeight()
			table.insert( positions.height, formatted[a].image:getHeight() )
		end
		nx = nx + tlib.getTextWidth( formatted[a].text, formatted[a].font )
		table.insert( positions.height, tlib.getTextHeight( formatted[a].text, formatted[a].font ) )
	end
	positions.width = nx + tlib.getTextWidth( formatted[#formatted].text )
	positions.height = math.max( unpack( positions.height ) )
	
	return positions
end

function tlib.format( lines, info )
	local formatted = {}
	
	for a = 1, #lines do
		if lines[a]:sub( 1, 1 ) ~= '{' then
			local color = { 255, 255, 255, 255 }
			local font = love.graphics.getFont()
			if formatted[#formatted] then 
				if formatted[#formatted].font then
					font = formatted[#formatted].font
				end
				if formatted[#formatted].color then
					color = formatted[#formatted].color 
				end
			end
			if lines[a - 1] then 
				if not lines[a - 1]:find( '{', 2 ) then
					if lines[a - 1]:sub( 2, 2 ) ~= '/' then
						for e, i in pairs( info ) do
							if lines[a - 1] == '{'..e..'}' then
								if type( i ) == 'table' then
									if (i.r and i.g and i.b) then -- Clavus: added check for Color class and { r = .., g = .., b = .., [a = ..] } tables
										color = { i.r, i.g, i.b, i.a or 255 }
									else
										color = i
									end
								elseif i:type() then
									if i:type() == 'Font' then
										font = i
									elseif i:type() == 'Image' then
										if lines[a - 2] then 
											color = formatted[#formatted].color 
										else 
											color = { 255, 255, 255, 255 }
										end
										table.insert( formatted, { text = '', color = color, image = i } )
									end
								end
							else
							end
						end
					else
						for e, i in pairs( info ) do
							if lines[a - 1] == '{/'..e..'}' or lines[a - 1]:lower() == '{/color}' or lines[a - 1]:lower() == '{/font}' then
								if type( i ) == 'table' or lines[a - 1]:lower() == '{/color}' then
									color = { 255, 255, 255, 255 }
								elseif lines[a - 1]:lower() == '{/font}' or i:type() == 'Font' then
									font = love.graphics.getFont()
								end
							end
						end
					end
				else
					local mode = lines[a - 1]:sub( 2, lines[a - 1]:find( ':' ) - 1 )
					local inf = lines[a - 1]:sub( lines[a - 1]:find( '{', 2 ), lines[a - 1]:find( '}' ) )
					local subinf = inf:sub( 2, #inf - 1 )
					mode = mode:lower()
					if mode == 'color' then
						local colors = {}
						while inf:find( ',' ) do
							table.insert( colors, inf:sub( 1, inf:find( ',' ) - 1 ) )
							inf = inf:sub( inf:find( ',' ) + 1 )
						end
						table.insert( colors, inf:sub( 1, #inf - 1 ) )
						
						for a = 1, #colors do
							while colors[a]:sub( 1, 1 ) == ' ' or colors[a]:sub( 1, 1 ) == '{' or colors[a]:sub( 1, 1 ) == ',' do
								colors[a] = colors[a]:sub( 2 )
							end
						end
						
						while #colors < 3 do
							table.insert( colors, 255 )
						end
						color = colors
					elseif mode == 'font' then
						font = love.graphics.newFont( subinf:sub( 1, subinf:find( ',' ) - 1 ), subinf:sub( subinf:find( ',' ) + 1 ) )
					elseif mode == 'picture' or mode == 'pic' or mode == 'image' then
						print('a')
						if lines[a - 2] then 
							color = formatted[#formatted].color 
						else 
							color = { 255, 255, 255, 255 }
						end
						table.insert( formatted, { text = '', color = color, image = love.graphics.newImage( subinf ) } )
					end
				end
			end
			table.insert( formatted, { text = lines[a], color = color, font = font } )
		end	
	end
	
	return formatted
end

function tlib.parse( text )
	local lines = {}
	
	local function work( text, start, stop )
		table.insert( lines, text:sub( 1, start - 1 ) )
		table.insert( lines, text:sub( start, stop ) )
		return text:sub( stop + 1 )
	end
	
	while text:find( '{' ) do
		local start = text:find( '{' )
		local stop = text:find( '}' )
		local colon = text:find( ':' )
		
		if colon then 
			if colon <= stop then
				local firstStart = start
				local secondStart = text:find( '{', firstStart + 1 )
				local firstStop = stop
				local secondStop = text:find( '}', firstStop + 1 )
				table.insert( lines, text:sub( 1, start - 1 ) )
				table.insert( lines, text:sub( firstStart, secondStop ) )
				text = text:sub( secondStop + 1 )
			else
				text = work( text, start, stop )
			end
		else
			text = work( text, start, stop )
		end
	end
	table.insert( lines, text )
	
	return lines
end

function tlib.getTextWidth( text, font )
	local f = nil
	
	if font then 
		f = font 
	else
		f = love.graphics.getFont() or love.graphics.setNewFont() 
	end
	
	return f:getWidth( text )
end

function tlib.getTextHeight( text, font )
	local f = nil
	
	if font then 
		f = font 
	else
		f = love.graphics.getFont() or love.graphics.setNewFont() 
	end
	
	return f:getHeight( text )
end

return tlib