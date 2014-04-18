
local mlib = {
	line = {
		segment = {}, 
		func = {}, 
	}, 
	polygon = {}, 
	circle = {}, 
	stats = {}, 
	shape = {
		user = {}
	}, 
}
mlib.math = {}
mlib.shape.__index = mlib.shape

-- Line
function mlib.line.length( x1, y1, x2, y2 )
	return math.sqrt( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 )
end

function mlib.line.midpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

function mlib.line.slope( x1, y1, x2, y2 )
	if x1 == x2 then return false end
	return ( y1 - y2 ) / ( x1 - x2 )
end

function mlib.line.perpendicularSlope( ... )
	local tab = {}
	local slope = false
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab ~= 1 then 
		slope = mlib.line.slope( unpack( tab ) ) 
	else
		slope = unpack( tab ) 
	end
	
	if slope == 0 then return false end
	if not slope then return 0 end
	return -1 / slope 
end

function mlib.line.perpendicularBisector( x1, y1, x2, y2 )
	local slope = mlib.line.slope( x1, y1, x2, y2 )
	return mlib.line.perpendicularSlope( slope ), mlib.line.midpoint( x1, y1, x2, y2 )
end

function mlib.line.intercept( x, y, ... )
	local tab = {}
	local slope = false
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab == 1 then 
		slope = tab[1] 
	else
		slope = mlib.line.slope( x, y, unpack( tab ) ) 
	end
	
	if not slope then return false end
	return y - slope * x
end

function mlib.line.draw( slope, y_intercept )
	love.graphics.line( 0, y_intercept, screen.getRenderWidth(), slope * screen.getRenderWidth() + y_intercept )
end

function mlib.line.drawStandard( slope, y_intercept )
	local slope = slope * -1
	local y_intercept = y_intercept + screen.getRenderHeight()
	love.graphics.line( 0, y_intercept, screen.getRenderWidth(), slope * screen.getRenderWidth() + y_intercept )
end

function mlib.line.intersect( ... )
	local tab = {}
	local x1, y1, x2, y2
	local x3, y3, x4, y4
	local m1, b1
	local m2, b2
	local x, y
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab == 4 then 
		m1, b1, m2, b2 = unpack( tab ) 
		y1, y2, y3, y4 = m1 * 1 + b1, m1 * 2 + b1, m2 * 1 + b2, m2 * 2 + b2
		x1, x2, x3, x4 = ( y1 - b1 ) / m1, ( y2 - b1 ) / m1, ( y3 - b1 ) / m1, ( y4 - b1 ) / m1
	elseif #tab == 6 then 
		m1, m2, m2, b2 = tab[1], tab[2], mlib.line.slope( tab[3], tab[4], tab[5], tab[6] ), mlib.line.intercept( tab[3], tab[4], tab[5], tab[6] ) 
		y1, y2, y3, y4 = m1 * 1 + b1, m1 * 2 + b1, tab[4], tab[6]
		x1, x2, x3, x4 = ( y1 - b1 ) / m1, ( y2 - b1 ) / m1, tab[3], tab[5]
	elseif #tab == 8 then 
		m1, b1, m2, b2 = mlib.line.slope( tab[1], tab[2], tab[3], tab[4] ), mlib.line.intercept( tab[1], tab[2], tab[3], tab[4] ), mlib.line.slope( tab[5], tab[6], tab[7], tab[8] ), mlib.line.intercept( tab[5], tab[6], tab[7], tab[8] ) 
		x1, y1, x2, y2, x3, y3, x4, y4 = unpack( tab )
	end
	
	if not m1 then 
		x = x1
		y = m2 * x + b2
	elseif not m2 then
		x = x3
		y = m1 * x + b1
	elseif m1 == m2 then 
		return false
	else
		x = ( -b1 + b2 ) / ( m1 - m2 )
		y = m1 * x + b1
	end
	
	return x, y
end

function mlib.line.closestPoint( px, py, ... )
	local tab = {}
	local x1, y1, x2, y2, m, b
	local x, y
	
	if type ( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab == 4 then
		x1, y1, x2, y2 = unpack( tab )
		m, b = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	elseif #tab == 2 then
		m, b = unpack( tab )
	end
	
	if not m then
		x, y = x1, py
	elseif m == 0 then
		x, y = px, y1
	else
		pm = mlib.line.perpendicularSlope( m )
		pb = mlib.line.intercept( px, py, pm )
		x, y = mlib.line.intersect( m, b, pm, pb )
	end
	
	return x, y
end

function mlib.line.segmentIntersects( x1, y1, x2, y2, ... )
	local tab = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end 
	
	local m1, m2
	local m2, b2 = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	local x, y
	
	if #tab == 2 then 
		m1, b1 = tab[1], tab[2]
	else
		m1, b1 = mlib.line.slope( unpack( tab ) ), mlib.line.intercept( unpack( tab ) )
	end
	
	if not m1 then
		x, y = tab[1], m2 * tab[1] + b2
	elseif not m2 then
		x, y = x1, m1 * x1 + b1
	else
		x, y = mlib.line.intersect( m1, b1, m2, b2 )
	end
	
	local l1, l2 = mlib.line.length( x1, y1, x, y ), mlib.line.length( x2, y2, x, y )
	local d = mlib.line.length( x1, y1, x2, y2 )
	
	if l1 <= d and l2 <= d then return x, y else return false end
end

-- Line Function
function mlib.line.func.get( x1, y1, x2, y2 ) 
	if y1 <= 0 or y2 <= 0 then return false end
	local x, y = x1 - x2, y1 / y2 
	
	if x == 0 then return false end
	
	local b = y ^ ( 1 / x ) 
	local a = y1 / ( b ^ x1 ) 
	
	return a, b
end

function mlib.line.func.draw( a, b )
	for i = 0, width do
		love.graphics.line( i, a * ( b ) ^ i, i + 1, a * ( b ) ^ ( i + 1 ) )
	end
end

function mlib.line.func.drawStandard( a, b )
	for i = 0, width do
		love.graphics.line( i, height - ( a * ( b ) ^ i ), i + 1, height - ( a * ( b ) ^ ( i + 1 ) ) )
	end
end

-- Line Segment
function mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 )
	local m, b = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	
	if not m then
		if x1 ~= x3 then return false end
		local l = mlib.line.length( x1, y1, x2, y2 )
		local d1 = mlib.line.length( x1, y1, x3, y3 )
		local d2 = mlib.line.length( x2, y2, x3, y3 )
		if d1 > l or d2 > l then return false end
		return true
	elseif y3 == m * x3 + b then
		local l = mlib.line.length( x1, y1, x2, y2 )
		local d1 = mlib.line.length( x1, y1, x3, y3 )
		local d2 = mlib.line.length( x2, y2, x3, y3 )
		if d1 > l or d2 > l then return false end
		return true
	else
		return false
	end
end

function mlib.line.segment.intersect( x1, y1, x2, y2, x3, y3, x4, y4 )
	local m1, b1 = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	local m2, b2 = mlib.line.slope( x3, y3, x4, y4 ), mlib.line.intercept( x3, y3, x4, y4 )
	
	if m1 == m2 and m1 then 
		if b1 == b2 then 
			local x = { x1, x2, x3, x4 }
			local y = { y1, y2, y3, y4 }
			local oy = { y1, y2, y3, y4 }
			
			local l1, l2 = mlib.line.length( x[1], y[1], x[2], y[2] ), mlib.line.length( x[3], y[3], x[4], y[4] )
			local largex, smallx = math.max( unpack( x ) ), math.min( unpack( x ) )
			local largey, smally = math.max( unpack( y ) ), math.min( unpack( y ) )
			local lx, sx, ly, sy = nil, nil, nil, nil
			
			for a = 1, #x do if x[a] == largex then lx = a end end
			for a = 1, #x do if x[a] == smallx then sx = a end end
			for a = 1, #y do if y[a] == largey then ly = a end end
			for a = 1, #y do if y[a] == smally then sy = a end end
			
			table.remove( x, lx )
			table.remove( x, sx )
			table.remove( y, ly )
			table.remove( y, sy )
			
			local d = mlib.line.length( x[1], y[1], x[2], y[2] )
			if d > l1 or d > l2 then return false end
			
			local l1 = mlib.line.length( x[1], oy[1], x[1], oy[2] )
			local l2 = mlib.line.length( x[1], oy[3], x[1], oy[4] )
			local l3 = mlib.line.length( x[1], y[1], x[2], y[2] )
			
			if l3 >= l1 or l3 >= l2 then return false end
			return x[1], y[1], x[2], y[2]
		else
			return false
		end
	end
	
	local x, y
	
	if not m1 and not m2 then
		if x1 ~= x3 then return false end
		
		local x = { x1, x2, x3, x4 }
		local y = { y1, y2, y3, y4 }
		local oy = { y1, y2, y3, y4 }
		
		local l1, l2 = mlib.line.length( x[1], y[1], x[2], y[2] ), mlib.line.length( x[3], y[3], x[4], y[4] )
		local largex, smallx = math.max( unpack( x ) ), math.min( unpack( x ) )
		local largey, smally = math.max( unpack( y ) ), math.min( unpack( y ) )
		local lx, sx, ly, sy
		
		for a = 1, #x do if x[a] == largex then lx = a end end
		for a = 1, #x do if x[a] == smallx then sx = a end end
		for a = 1, #y do if y[a] == largey then ly = a end end
		for a = 1, #y do if y[a] == smally then sy = a end end
		
		table.remove( x, lx )
		table.remove( x, sx )
		table.remove( y, ly )
		table.remove( y, sy )
		
		local d = mlib.line.length( x[1], y[1], x[2], y[2] )
		if d > l1 or d > l2 then return false end
		
		local l1 = mlib.line.length( x[1], oy[1], x[1], oy[2] )
		local l2 = mlib.line.length( x[1], oy[3], x[1], oy[4] )
		local l3 = mlib.line.length( x[1], y[1], x[2], y[2] )
		
		if l3 >= l1 or l3 >= l2 then return false end
		return x[1], y[1], x[2], y[2]
	elseif not m1 then
		x = x2
		y = m2 * x + b2
		
		local l1 = mlib.line.length( x1, y1, x2, y2 )
		local l2 = mlib.line.length( x3, y3, x4, y4 )
		local d1 = mlib.line.length( x1, y1, x, y )
		local d2 = mlib.line.length( x2, y2, x, y )
		local d3 = mlib.line.length( x3, y3, x, y )
		local d4 = mlib.line.length( x4, y4, x, y )
		
		if ( d1 > l1 ) or ( d2 > l1 ) or ( d3 > l2 ) or ( d4 > l2 ) then 
			return false 
		end
	elseif not m2 then
		x = x4
		y = m1 * x + b1
		
		local l1 = mlib.line.length( x1, y1, x2, y2 )
		local l2 = mlib.line.length( x3, y3, x4, y4 )
		local d1 = mlib.line.length( x1, y1, x, y )
		local d2 = mlib.line.length( x2, y2, x, y )
		local d3 = mlib.line.length( x3, y3, x, y )
		local d4 = mlib.line.length( x4, y4, x, y )
		
		if ( d1 > l1 ) or ( d2 > l1 ) or ( d3 > l2 ) or ( d4 > l2 ) then return false end
	else
		x, y = mlib.line.intersect( m1, b1, m2, b2 )
		if not x then return false end
		
		local l1, l2 = mlib.line.length( x1, y1, x2, y2 ), mlib.line.length( x3, y3, x4, y4 )
		local d1 = mlib.line.length( x1, y1, x, y )
		if d1 > l1 then return false end
		
		local d2 = mlib.line.length( x2, y2, x, y )
		if d2 > l1 then return false end
		
		local d3 = mlib.line.length( x3, y3, x, y )
		if d3 > l2 then return false end
		
		local d4 = mlib.line.length( x4, y4, x, y )
		if d4 > l2 then return false end
	end
	return x, y
end

-- Polygon
function mlib.polygon.triangleHeight( base, ... )
	local tab = {}
	local area = 0
	local b = 0
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if #tab == 1 then area = tab[1] else area = mlib.polygon.area( tab ) end
	
	return ( 2 * area ) / base, area
end

function mlib.polygon.area( ... ) 
	local tab = {}
	local points = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	for a = 1, #tab, 2 do
		table.insert( points, { tab[a], tab[a+1] } )
	end
	
	points[#points + 1] = {}
	points[#points][1], points[#points][2] = points[1][1], points[1][2]
	return ( .5 * math.abs( mlib.math.summation( 1, #points, 
		function( i ) 
			if points[i + 1] then 
				return ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) 
			else 
				return ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) )
			end 
		end 
	) ) )
end

function mlib.polygon.centroid( ... ) 
	local tab = {}
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	local points = {}
	for a = 1, #tab, 2 do
		table.insert( points, { tab[a], tab[a+1] } )
	end
	points[#points + 1] = {}
	points[#points][1], points[#points][2] = points[1][1], points[1][2]
	local area = .5 * mlib.math.summation( 1, #points, -- Need to signed area here, in case coordinates are arranged counter-clockwise.
		function( i ) 
			if points[i + 1] then 
				return ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) 
			else 
				return ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) )
			end 
		end 
	) 
	
	local cx = ( 1 / ( 6 * area ) ) * ( mlib.math.summation( 1, #points, 
		function( i ) 
			if points[i + 1] then
				return ( ( points[i][1] + points[i + 1][1] ) * ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) )
			else
				return ( ( points[i][1] + points[1][1] ) * ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) ) )
			end
		end
	) )
	
	local cy = ( 1 / ( 6 * area ) ) * ( mlib.math.summation( 1, #points, 
		function( i ) 
			if points[i + 1] then
				return ( ( points[i][2] + points[i + 1][2] ) * ( ( points[i][1] * points[i + 1][2] ) - ( points[i + 1][1] * points[i][2] ) ) )
			else
				return ( ( points[i][2] + points[1][2] ) * ( ( points[i][1] * points[1][2] ) - ( points[1][1] * points[i][2] ) ) )
			end
		end 
	) )
	
	return cx, cy
end

function mlib.polygon.checkPoint( px, py, ... )
	local tab = {}
	local x = {}
	local y = {}
	local m = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	for a = 1, #tab, 2 do
		table.insert( x, tab[a] )
		table.insert( y, tab[a + 1] )
	end
	
	for a = 1, #x do
		local slope = nil
		if a ~= #x then
			slope = ( y[a] - y[a + 1] ) / ( x[a] - x[a + 1] )
		else 
			slope = ( y[a] - y[1] ) / ( x[a] - x[1] )
		end
		table.insert( m, slope )
	end
	
	local lowx = math.min( unpack( x ) )
	local largex = math.max( unpack( x ) )
	local lowy = math.min( unpack( y ) )
	local largey = math.max( unpack( y ) )
	
	if px < lowx or px > largex or py < lowy or py > largey then return false end
	
	local count = 0
	
	local function loop( num, large )
		if num > large then return num - large end
		return num
	end
	
	for a = 1, #m do
		if a ~= #m then
			local x1, x2 = x[a], x[a + 1]
			local y1, y2 = y[a], y[a + 1]
			if py == y1 or py == y2 then 
				if y[loop( a + 2, #y )] ~= py and y[loop( a + 3, #y )] ~= py then
					count = count + 1
				end
			elseif mlib.line.segment.intersect( x1, y1, x2, y2, px, py, lowx, py ) then 
				count = count + 1 
			end
		else
			local x1, x2 = x[a], x[1]
			local y1, y2 = y[a], y[1]
			if py == y1 or py == y2 then 
				if y[loop( a + 2, #y )] ~= py and y[loop( a + 3, #y )] ~= py then
					count = count + 1
				end
			elseif mlib.line.segment.intersect( x1, y1, x2, y2, px, py, lowx, py ) then 
				count = count + 1 
			end
		end
	end
	
	if math.floor( count / 2 ) ~= count / 2 then return true end
	return false	
end

function mlib.polygon.lineIntersects( x1, y1, x2, y2, ... )
	local tab = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	if mlib.polygon.checkPoint( x1, y1, tab ) then return true end
	if mlib.polygon.checkPoint( x2, y2, tab ) then return true end
	
	for a = 1, #tab, 2 do
		if mlib.line.segment.checkPoint( x1, y1, x2, y2, tab[a], tab[a + 1] ) then return true end
		if tab[a + 2] then
			if mlib.line.segment.intersect( tab[a], tab[a + 1], tab[a + 2], tab[a + 3], x1, y1, x2, y2 ) then return true end
		else
			if mlib.line.segment.intersect( tab[a], tab[a + 1], tab[1], tab[2], x1, y1, x2, y2 ) then return true end
		end
	end
	
	return false
end

function mlib.polygon.polygonIntersects( polygon1, polygon2 )
	for a = 1, #polygon1, 2 do
		if polygon1[a + 2] then
			if mlib.polygon.lineIntersects( polygon1[a], polygon1[a + 1], polygon1[a + 2], polygon1[a + 3], polygon2 ) then return true end
		else
			if mlib.polygon.lineIntersects( polygon1[a], polygon1[a + 1], polygon1[1], polygon1[2], polygon2 ) then return true end
		end
	end
	
	for a = 1, #polygon2, 2 do
		if polygon2[a + 2] then
			if mlib.polygon.lineIntersects( polygon2[a], polygon2[a + 1], polygon2[a + 2], polygon2[a + 3], polygon1 ) then return true end
		else
			if mlib.polygon.lineIntersects( polygon2[a], polygon2[a + 1], polygon2[1], polygon2[2], polygon1 ) then return true end
		end
	end	
	
	return false
end

function mlib.polygon.circleIntersects( x, y, r, ... )
	local tab = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if mlib.polygon.checkPoint( x, y, tab ) then return true end
	
	for a = 1, #tab, 2 do
		if tab[a + 2] then 
			if mlib.circle.segmentSecant( x, y, r, tab[a], tab[a + 1], tab[a + 2], tab[a + 3] ) then return mlib.circle.segmentSecant( x, y, r, tab[a], tab[a + 1], tab[a + 2], tab[a + 3] ) end
		else
			if mlib.circle.segmentSecant( x, y, r, tab[a], tab[a + 1], tab[1], tab[2] ) then return mlib.circle.segmentSecant( x, y, r, tab[a], tab[a + 1], tab[1], tab[2] ) end
		end
	end
	
	return false
end

-- Circle
function mlib.circle.area( r )
	return math.pi * ( r ^ 2 )
end

function mlib.circle.checkPoint( cx, cy, r, x, y )
	return ( x - cx ) ^ 2 + ( y - cy ) ^ 2 == r ^ 2 
end

function mlib.circle.circumference( r )
	return 2 * math.pi * r
end

function mlib.circle.secant( cx, cy, r, ... )
	local tab = {}
	
	local m, b = 0, 0
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab == 2 then m, b = tab[1], tab[2] else m = mlib.line.slope( tab[1], tab[2], tab[3], tab[4] ) b = mlib.line.intercept( tab[1], tab[2], m ) end
	
	local x1, y1, x2, y2 = nil, nil, nil, nil
	if #tab == 4 then x1, y1, x2, y2 = unpack( tab ) end
	
	if m then 
		local a1 = ( 1 + m ^ 2 )
		local b1 = ( -2 * ( cx ) + ( 2 * m * b ) - ( 2 * cy * m ) )
		local c1 = ( cx ^ 2 + b ^ 2 - 2 * ( cy ) * ( b ) + cy ^ 2 - r ^ 2 )
		
		x1, x2 = mlib.math.quadraticFactor( a1, b1, c1 )
		
		if not x1 then return false end
		
		y1 = m * x1 + b
		y2 = m * x2 + b
		
		if x1 == x2 and y1 == y2 then 
			return 'tangent', x1, y1
		else 
			return 'secant', x1, y1, x2, y2 
		end
	else
		-- Theory: *see circle.png for information on how it works.
		local j = cx - x1
		local k = j - r
		local b = math.sqrt( -( j ^ 2 - r ^ 2 ) )
		
		if -( j ^ 2 - r ^ 2 ) < 0 then return false end
		
		local px, py = x1, cy - b
		local qx, qy = x1, cy + b
		
		if qy ~= py then 
			return 'secant', qx, qy, px, py 
		else 
			return 'tangent', qx, qy 
		end
	end
end

function mlib.circle.segmentSecant( cx, cy, r, x1, y1, x2, y2 )
	local Type, x3, y3, x4, y4 = mlib.circle.secant( cx, cy, r, x1, y1, x2, y2 )
	if not Type then return false end
	
	local m, b = mlib.line.slope( x1, y1, x2, y2 ), mlib.line.intercept( x1, y1, x2, y2 )
	
	if m then 
		if mlib.circle.inCircle( cx, cy, r, x1, y1 ) and mlib.circle.inCircle( cx, cy, r, x2, y2 ) then -- Line-segment is fully in circle. 
			return true
		elseif x3 and x4 then
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 ) and mlib.line.segment.checkPoint( x1, y1, x2, y2, x4, y4 ) then -- Both points are on line-segment. 
				return x3, y3, x4, y4
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 ) then -- Only the first of the points is on the line-segment. 
				return x3, y3
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, x4, y4 ) then -- Only the second of the points is on the line-segment. 
				return x4, y4
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle)
				local l = mlib.line.length( x1, y1, x2, y2 )
				
				local d1 = mlib.line.length( x1, y1, x3, y3 )
				local d2 = mlib.line.length( x2, y2, x3, y3 )
				local d3 = mlib.line.length( x1, y1, x4, y4 )
				local d4 = mlib.line.length( x2, y3, x4, y4 )
				
				if l > d1 or l > d2 or l > d3 or l > d4 then
					return false
				elseif l < d1 and l < d2 and l < d3 and l < d4 then 
					return false 
				else
					return true
				end
			end
		elseif not x4 then -- Is a tangent. 
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 ) then
				return x3, y3
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle).
				local l = mlib.line.length( x1, y1, x2, y2 )
				local d1 = mlib.line.length( x1, y1, x3, y3 )
				local d2 = mlib.line.length( x2, y2, x3, y3 )
				
				if l > d1 or l > d2 then 
					return false
				elseif l < d1 and l < d2 then 
					return false 
				else
					return true
				end
			end
		end
	else
		-- Theory: *see circle.png for information on how it works.
		local j = cx - x1
		local k = j - r
		local b = math.sqrt( -( j ^ 2 - r ^ 2 ) )
		
		if -( j ^ 2 - r ^ 2 ) < 0 then return false end
		
		local px, py = x1, cy - b
		local qx, qy = x1, cy + b
		
		local l = mlib.line.length( x1, y1, x2, y2 )
		local d1 = mlib.line.length( x1, y1, px, py )
		local d2 = mlib.line.length( x2, y2, px, py )
		
		if qy ~= py then 
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, px, py ) and mlib.line.segment.checkPoint( x1, y1, x2, y2, qx, qy ) then
				return px, py, qx, qy
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, px, py ) then
				return px, px
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, qx, qy ) then
				return qx, qy
			else
				return false
			end
		else 
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, px, py ) then
				return px, py
			else
				return false
			end
		end
	end
end

function mlib.circle.circlesIntersect( p0x, p0y, r0, p1x, p1y, r1 )
	local d = mlib.line.length( p0x, p0y, p1x, p1y )
	if d > r0 + r1 then return false end
	if d == 0 and r0 == r1 then return true end
	
	local a = ( r0 ^ 2 - r1 ^ 2 + d ^ 2 ) / ( 2 * d )
	local h = math.sqrt( r0 ^ 2 - a ^ 2 )
	
	local p2x = p0x + a * ( p1x - p0x ) / d
	local p2y = p0y + a * ( p1y - p0y ) / d
	local p3x = p2x + h * ( p1y - p0y ) / d
	local p3y = p2y - h * ( p1x - p0x ) / d
	local p4x = p2x - h * ( p1y - p0y ) / d
	local p4y = p2y + h * ( p1x - p0x ) / d
	
	if d == r0 + r1 then return p3x, p3y end
	return p3x, p3y, p4x, p4y 
end

function mlib.circle.inCircle( cx, cy, r, x, y )
	return mlib.line.length( cx, cy, x, y ) <= r
end

-- Statistics
function mlib.stats.mean( ... )
	local name = {}
	
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	
	local mean = 0
	for i = 1, #name do
		mean = mean + name[i]
	end
	mean = mean / #name
	
	return mean
end

function mlib.stats.median( ... )
	local name = {}
	
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	
	table.sort( name )
	
	if #name % 2 == 0 then
		name = ( name[math.floor( #name / 2 )] + name[math.floor( #name / 2 + 1 )] ) / 2
	else
		name =  name[#name / 2 + .5]
	end
	
	return name
end

function mlib.stats.mode( ... ) 
	local name = {}
	
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	table.sort( name )
	local num = { { name[1] } }
	for i = 2, #name do
		if name[i] == num[#num][1] then table.insert( num[#num], name[i] ) 
		else table.insert( num, { name[i] } ) end
	end
	local large = { { #num[1], num[1][1] } }
	for i = 2, #num do
		if #num[i] > large[1][1] then
			for ii = #large, 1, -1 do
				table.remove( large, ii )
			end
		table.insert( large, { #num[i], num[i][1] } )
		elseif #num[i] == large[1][1] then
			table.insert( large, { #num[i], num[i][1] } )
		end
	end
	
	if #large < 1 then 
		return false 
	elseif #large > 1 then 
		return false 
	else 
		return large[1][2], large[1][1] 
	end
end

function mlib.stats.range( ... )
	local name = {}
	
	if type( ... ) ~= 'table' then name = { ... } else name = ... end
	
	local upper, lower = math.max( unpack( name ) ), math.min( unpack( name ) )
	
	return upper - lower
end

-- Math (homeless functions)
function mlib.math.root( number, root )
	return number ^ ( 1 / root )
end

function mlib.math.prime( ... )
	local num = 0
	local name = false
	
	if type( ... ) ~= 'table' then num = { ... } else num = ... end
	
	if #num == 1 then num = num[1] end
	
	if type( num ) == 'number' then
		if num < 2 then return false end
		
		for i = 2, math.sqrt( num ) do
			if num % i == 0 then
				return false
			end
		end
		
		return true
	end
end

function mlib.math.round( num )

	local name
	local up_num = math.ceil( num )
	local down_num = math.floor( num )
	
	local up_dif = up_num - num
	local down_dif = num - down_num
	
	if up_num == num then
		name = num
	else
		if up_dif <= down_dif then name = up_num elseif down_dif < up_dif then name = down_num end
	end
	
	return name
end

function mlib.math.log( number, base )
	base = base or 10
	return ( math.log( number ) ) / ( math.log( base ) )
end

function mlib.math.summation( start, stop, func )
	if stop == 1 / 0 or stop == -1 / 0 then return false end
	
	local ret = {}
	local val = 0
	
	for a = start, stop do
		local new = func( a, ret )
		
		ret[a] = new
		val = val + new
	end
	
	return val
end

function mlib.math.percentOfChange( old, new )
	if old == 0 then 
		return false
	else 
		return ( new - old ) / math.abs( old ) 
	end
end

function mlib.math.percent( percent, num )
	return percent * math.abs( num ) + num 
end

function mlib.math.quadraticFactor( a, b, c )
	local d = b ^ 2 - ( 4 * a * c )
	if d < 0 then return false end
	
	d = math.sqrt( d )
	
	return ( -b - d ) / ( 2 * a ), ( -b + d ) / ( 2 * a )
end

function mlib.math.getAngle( ... )
	local angle = 0
	local tab = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab <= 5 then
		local x1, y1, x2, y2, dir = unpack( tab )
		
		if not dir or dir == 'up' then dir = math.rad( 90 ) 
			elseif dir == 'right' then dir = 0 
			elseif dir == 'down' then dir = math.rad( -90 )
			elseif dir == 'left' then dir = math.rad( -180 )
		end
		
		local dx, dy = x2 - x1, y2 - y1
		
		angle = math.atan2( dy, dx ) + dir
	elseif #tab == 6 then
		local x1, y1, x2, y2, x3, y3 = unpack( tab )
		
		local AB = mlib.line.length( x1, y1, x2, y2 )
		local BC = mlib.line.length( x2, y2, x3, y3 )
		local AC = mlib.line.length( x1, y1, x3, y3 )
		
		angle = math.acos( ( BC * BC + AB * AB - AC * AC ) / ( 2 * BC * AB ) )
	end
	
	return angle
end

-- Shape
function mlib.shape.new( ... )
	local tab = {}
	
	if type( ... ) ~= 'table' then tab = { ... } else tab = ... end
	
	if #tab == 3 then
		tab.type = 'circle'
		tab.x, tab.y, tab.radius = unpack( tab )
		tab.area = mlib.circle.area( tab.radius )
	elseif #tab == 4 then
		tab.type = 'line'
		tab.x1, tab.y1, tab.x2, tab.y2 = unpack( tab )
		tab.slope = mlib.line.slope( unpack( tab ) )
		tab.intercept = mlib.line.intercept( unpack( tab ) )
	else
		tab.type = 'polygon'
		tab.area = mlib.polygon.area( tab )
		tab.points = tab
	end
	
	tab.collided = false
	tab.index = #mlib.shape.user + 1
	tab.removed = false
	
	setmetatable( tab, mlib.shape )
	table.insert( mlib.shape.user, tab )
	
	return tab
end

function mlib.shape:checkCollisions( ... )
	local tab = { ... }
	
	if type( self ) == 'table' then -- Using a self:table. 
		if #tab == 0 then -- No arguments (colliding with everything). 
			for a = 1, #mlib.shape.user do
				if a ~= self.index then 
					local collided = false
					local shape = mlib.shape.user[a]
					if not shape.removed and not self.removed then 
						if self.type == 'line' then 
							if shape.type == 'line' then
								if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then collided, self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.circle.segmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then collided, self.collided, shape.collided = true, true end
							end
						elseif self.type == 'polygon' then
							if shape.type == 'line' then
								if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then collided, self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.polygonIntersects( self.points, shape.points ) then collided, self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then collided, self.collided, shape.collided = true, true end
							end
						elseif self.type == 'circle' then
							if shape.type == 'line' then
								if mlib.circle.segmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true end
							elseif shape.type == 'polygon' then
								if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then collided, self.collided, shape.collided = true, true end
							elseif shape.type == 'circle' then
								if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then collided, self.collided, shape.collided = true, true end
							end
						end
					end
					if not collided then self.collided = false end
				end
			end
		else -- Colliding with only certain things. 
			for a = 1, #tab do
				local collided = false
				local shape = tab[a]
				if not shape.removed and not self.removed then 
					if self.type == 'line' then 
						if shape.type == 'line' then
							if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true end
						elseif shape.type == 'polygon' then
							if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then collided, self.collided, shape.collided = true, true end
						elseif shape.type == 'circle' then
							if mlib.circle.segmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then collided, self.collided, shape.collided = true, true end
						end
					elseif self.type == 'polygon' then
						if shape.type == 'line' then
							if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then collided, self.collided, shape.collided = true, true end
						elseif shape.type == 'polygon' then
							if mlib.polygon.polygonIntersects( self.points, shape.points ) then collided, self.collided, shape.collided = true, true end
						elseif shape.type == 'circle' then
							if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then collided, self.collided, shape.collided = true, true end
						end
					elseif self.type == 'circle' then
						if shape.type == 'line' then
							if mlib.circle.segmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true end
						elseif shape.type == 'polygon' then
							if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then collided, self.collided, shape.collided = true, true end
						elseif shape.type == 'circle' then
							if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then collided, self.collided, shape.collided = true, true end
						end
					end
				end
				if not collided then self.collided = false end
			end
		end
	else -- Not using self:table. 
		local tab = { unpack( tab ) }
		if #tab == 0 then -- Checking all collisions. 
			for a = 1, #mlib.shape.user do
				local self = mlib.shape.user[a]
				local collided = false
				for e = 1, #mlib.shape.user do
					if a ~= e then 
						local shape = mlib.shape.user[e]
						if not shape.removed and not self.removed then 
							if self.type == 'line' then 
								if shape.type == 'line' then
									if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true, true end
								elseif shape.type == 'polygon' then
									if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then collided, self.collided, shape.collided = true, true, true end
								elseif shape.type == 'circle' then
									if mlib.circle.segmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then collided, self.collided, shape.collided = true, true, true end
								end
							elseif self.type == 'polygon' then
								if shape.type == 'line' then
									if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then collided, self.collided, shape.collided = true, true, true end
								elseif shape.type == 'polygon' then
									if mlib.polygon.polygonIntersects( self.points, shape.points ) then collided, self.collided, shape.collided = true, true, true end
								elseif shape.type == 'circle' then
									if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then collided, self.collided, shape.collided = true, true, true end
								end
							elseif self.type == 'circle' then
								if shape.type == 'line' then
									if mlib.circle.segmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true, true end
								elseif shape.type == 'polygon' then
									if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then self.collided, collided, self.collided, shape.collided = true, true, true end
								elseif shape.type == 'circle' then
									if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then collided, self.collided, shape.collided = true, true, true end
								end
							end
						end
					end
				end
				if not collided then self.collided = false end
			end
		else -- Checking only certain collisions
			for a = 1, #tab do
				local self = mlib.shape.user[a]
				local collided = false
				for e = 1, #mlib.shape.user do
					if self.index ~= tab[e].index then 
						local shape = mlib.shape.user[e]
						if not shape.removed and not self.removed then 
							if self.type == 'line' then 
								if shape.type == 'line' then
									if mlib.line.segment.intersect( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true end
								elseif shape.type == 'polygon' then
									if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.points ) then collided, self.collided, shape.collided = true, true end
								elseif shape.type == 'circle' then
									if mlib.circle.segmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then collided, self.collided, shape.collided = true, true end
								end
							elseif self.type == 'polygon' then
								if shape.type == 'line' then
									if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.points ) then collided, self.collided, shape.collided = true, true end
								elseif shape.type == 'polygon' then
									if mlib.polygon.polygonIntersects( self.points, shape.points ) then collided, self.collided, shape.collided = true, true end
								elseif shape.type == 'circle' then
									if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.points ) then collided, self.collided, shape.collided = true, true end
								end
							elseif self.type == 'circle' then
								if shape.type == 'line' then
									if mlib.circle.segmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then collided, self.collided, shape.collided = true, true end
								elseif shape.type == 'polygon' then
									if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.points ) then collided, self.collided, shape.collided = true, true end
								elseif shape.type == 'circle' then
									if mlib.circle.circlesIntersect( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then collided, self.collided, shape.collided = true, true end
								end
							end
						end
					end
				end
				if not collided then self.collided = false end
			end
		end
	end
end

function mlib.shape:remove( ... )
	local tab = { ... }
	
	if type( self ) == 'table' then
		mlib.shape.user[self.index] = { removed = false }
		
		if #tab > 0 then
			for a = 1, #tab do
				mlib.shape.user[tab[a].index] = { removed = true }
			end
		end
	else
		if #tab > 0 then
			for a = 1, #tab do
				mlib.shape.user[tab[a].index] = { removed = true }
			end
		else
			mlib.shape.user = {}
		end
	end
end

return mlib