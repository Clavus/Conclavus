
-- https://github.com/davisdude/mlib
-- Functions are renamed as:
--[[
mlib.line.getLength( x1, y1, x2, y2 )
mlib.line.getMidpoint( x1, y1, x2, y2 )
mlib.line.getSlope( x1, y1, x2, y2 )
mlib.line.getPerpendicularSlope( ... )
mlib.line.getPerpendicularBisector( x1, y1, x2, y2 )
mlib.line.getIntercept( x, y, ... )
mlib.line.getIntersection( ... )
mlib.line.getClosestPoint( px, py, ... )
mlib.line.getsegmentIntersection( x1, y1, x2, y2, ... )
mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 )
mlib.line.segment.getIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )

mlib.polygon.getTriangleHeight( base, ... )
mlib.polygon.getSignedArea( ... ) 
mlib.polygon.getArea( ... ) 
mlib.polygon.getCentroid( ... ) 
mlib.polygon.checkPoint( PointX, PointY, ... )
mlib.polygon.lineIntersects( x1, y1, x2, y2, ... )
mlib.polygon.polygonIntersects( polygon1, polygon2 )
mlib.polygon.circleIntersects( x, y, Radius, ... )

mlib.circle.getArea( Radius )
mlib.circle.checkPoint( circleX, circleY, Radius, x, y )
mlib.circle.getCircumference( Radius )
mlib.circle.isLineSecant( circleX, circleY, Radius, ... )
mlib.circle.isSegmentSecant( circleX, circleY, Radius, x1, y1, x2, y2 )
mlib.circle.circleIntersects( circle1CenterX, circle1CenterY, Radius1, circle2CenterX, circle2CenterY, Radius2 )
mlib.circle.isPointIncircle( circleX, circleY, Radius, x, y )

mlib.statistics.getMean( ... )
mlib.statistics.getMedian( ... )
mlib.statistics.getMode( ... ) 
mlib.statistics.getRange( ... )

mlib.math.getRoot( Number, Root )
mlib.math.isPrime( Number )	
mlib.math.round( Number, DecimalPlace )
mlib.math.getSummation( Start, Stop, Function )
mlib.math.getPercentOfChange( Old, New )
mlib.math.getPercent( Percent, Number )
mlib.math.getRootsOfQuadratic( a, b, c )
mlib.math.getAngle( ... )

mlib.shape.newShape( ... )
mlib.shape:checkCollisions( ... )
mlib.shape:remove( ... )
]]--

local mlib = {
	line = {
		segment = {}, 
	}, 
	polygon = {}, 
	circle = {}, 
	statistics = {}, 
	math = {}, 
	shape = {
		user = {}, 
	}, 
}
mlib.shape.__index = mlib.shape

-- Local utility functions
local function checkUserdata( ... )
	local userdata = {}
	if type( ... ) ~= 'table' then userdata = { ... } else userdata = ... end
	return userdata
end

local function sortWithReference( Table, Function )
    if #Table == 0 then return nil, nil end
    local Key, Value = 1, Table[1]
    for i = 2, #Table do
        if Function( Value, Table[i] ) then
            Key, Value = i, Table[i]
        end
    end
    return Value, Key
end

-- lines
function mlib.line.getLength( x1, y1, x2, y2 )
	return math.sqrt( ( x1 - x2 ) ^ 2 + ( y1 - y2 ) ^ 2 )
end

function mlib.line.getMidpoint( x1, y1, x2, y2 )
	return ( x1 + x2 ) / 2, ( y1 + y2 ) / 2
end

function mlib.line.getSlope( x1, y1, x2, y2 )
	if x1 == x2 then return false end -- Technically it's infinity, but that's irrelevant. 
	return ( y1 - y2 ) / ( x1 - x2 )
end

function mlib.line.getPerpendicularSlope( ... )
	local userdata = checkUserdata( ... )
	
	if #userdata ~= 1 then 
		Slope = mlib.line.getSlope( unpack( userdata ) ) 
	else
		Slope = unpack( userdata ) 
	end
	
	if Slope == 0 then return false end 
	if not Slope then return 0 end
	return -1 / Slope 
end

function mlib.line.getPerpendicularBisector( x1, y1, x2, y2 )
	local Slope = mlib.line.getSlope( x1, y1, x2, y2 )
	return mlib.line.getMidpoint( x1, y1, x2, y2 ), mlib.line.getPerpendicularSlope( Slope )
end

function mlib.line.getIntercept( x, y, ... )
	local userdata = checkUserdata( ... )
	local Slope = false
	
	if #userdata == 1 then 
		Slope = userdata[1] 
	else
		Slope = mlib.line.getSlope( x, y, unpack( userdata ) ) 
	end
	
	if not Slope then return false end
	return y - Slope * x
end

function mlib.line.getIntersection( ... )
	local userdata = checkUserdata( ... )
	local x1, y1, x2, y2, x3, y3, x4, y4
	local Slope1, Intercept1
	local Slope2, Intercept2
	local x, y
	
	if #userdata == 4 then -- Given Slope1, Intercept1, Slope2, Intercept2. 
		Slope1, Intercept1, Slope2, Intercept2 = unpack( userdata ) 
		y1, y2, y3, y4 = Slope1 * 1 + Intercept1, Slope1 * 2 + Intercept1, Slope2 * 1 + Intercept2, Slope2 * 2 + Intercept2
		x1, x2, x3, x4 = ( y1 - Intercept1 ) / Slope1, ( y2 - Intercept1 ) / Slope1, ( y3 - Intercept1 ) / Slope1, ( y4 - Intercept1 ) / Slope1
	elseif #userdata == 6 then -- Given Given Slope1, Intercept1, and 2 points on the line. 
		Slope1, Intercept1, Slope2, Intercept2 = userdata[1], userdata[2], mlib.line.getSlope( userdata[3], userdata[4], userdata[5], userdata[6] ), mlib.line.getIntercept( userdata[3], userdata[4], userdata[5], userdata[6] ) 
		y1, y2, y3, y4 = Slope1 * 1 + Intercept1, Slope1 * 2 + Intercept1, userdata[4], userdata[6]
		x1, x2, x3, x4 = ( y1 - Intercept1 ) / Slope1, ( y2 - Intercept1 ) / Slope1, userdata[3], userdata[5]
	elseif #userdata == 8 then -- Given 2 points on line 1 and 2 points on line 2.
		Slope1, Intercept1, Slope2, Intercept2 = mlib.line.getSlope( userdata[1], userdata[2], userdata[3], userdata[4] ), mlib.line.getIntercept( userdata[1], userdata[2], userdata[3], userdata[4] ), mlib.line.getSlope( userdata[5], userdata[6], userdata[7], userdata[8] ), mlib.line.getIntercept( userdata[5], userdata[6], userdata[7], userdata[8] ) 
		x1, y1, x2, y2, x3, y3, x4, y4 = unpack( userdata )
	end
	
	if not Slope1 then 
		x = x1
		y = Slope2 * x + Intercept2
	elseif not Slope2 then
		x = x3
		y = Slope1 * x + Intercept1
	elseif Slope1 == Slope2 then 
		return false
	else
		x = ( -Intercept1 + Intercept2 ) / ( Slope1 - Slope2 )
		y = Slope1 * x + Intercept1
	end
	
	return x, y
end

function mlib.line.getClosestPoint( px, py, ... )
	local userdata = checkUserdata( ... )
	local x1, y1, x2, y2, Slope, Intercept
	local x, y
	
	if #userdata == 4 then
		x1, y1, x2, y2 = unpack( userdata )
		Slope, Intercept = mlib.line.getSlope( x1, y1, x2, y2 ), mlib.line.getIntercept( x1, y1, x2, y2 )
	elseif #userdata == 2 then
		Slope, Intercept = unpack( userdata )
	end
	
	if not Slope then
		x, y = x1, PerpendicularY
	elseif Slope == 0 then
		x, y = PerpendicularX, y1
	else
		PerpendicularSlope = mlib.line.getPerpendicularSlope( Slope )
		PerpendicularIntercept = mlib.line.getIntercept( PerpendicularX, PerpendicularY, PerpendicularSlope )
		x, y = mlib.line.getIntersection( Slope, Intercept, PerpendicularSlope, PerpendicularIntercept )
	end
	
	return x, y
end

function mlib.line.getsegmentIntersection( x1, y1, x2, y2, ... )
	local userdata = checkUserdata( ... )
	
	local Slope1, Intercept1
	local Slope2, Intercept2 = mlib.line.getSlope( x1, y1, x2, y2 ), mlib.line.getIntercept( x1, y1, x2, y2 )
	local x, y
	
	if #userdata == 2 then 
		Slope1, Intercept1 = userdata[1], userdata[2]
	else
		Slope1, Intercept1 = mlib.line.getSlope( unpack( userdata ) ), mlib.line.getIntercept( unpack( userdata ) )
	end
	
	if not Slope1 then
		x, y = userdata[1], Slope2 * userdata[1] + Intercept2
	elseif not Slope2 then
		x, y = x1, Slope1 * x1 + Intercept1
	else
		x, y = mlib.line.getIntersection( Slope1, Intercept1, Slope2, Intercept2 )
	end
	
	local Length1, Length2 = mlib.line.getLength( x1, y1, x, y ), mlib.line.getLength( x2, y2, x, y )
	local Distance = mlib.line.getLength( x1, y1, x2, y2 )
	
	if Length1 <= Distance and Length2 <= Distance then return x, y else return false end
end

-- line segment
function mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 )
	local Slope, Intercept = mlib.line.getSlope( x1, y1, x2, y2 ), mlib.line.getIntercept( x1, y1, x2, y2 )
	
	if not Slope then
		if x1 ~= x3 then return false end
		local Length = mlib.line.getLength( x1, y1, x2, y2 )
		local Distance1 = mlib.line.getLength( x1, y1, x3, y3 )
		local Distance2 = mlib.line.getLength( x2, y2, x3, y3 )
		if Distance1 > Length or Distance2 > Length then return false end
		return true
	elseif y3 == Slope * x3 + Intercept then
		local Length = mlib.line.getLength( x1, y1, x2, y2 )
		local Distance1 = mlib.line.getLength( x1, y1, x3, y3 )
		local Distance2 = mlib.line.getLength( x2, y2, x3, y3 )
		if Distance1 > Length or Distance2 > Length then return false end
		return true
	else
		return false
	end
end

function mlib.line.segment.getIntersection( x1, y1, x2, y2, x3, y3, x4, y4 )
	local Slope1, Intercept1 = mlib.line.getSlope( x1, y1, x2, y2 ), mlib.line.getIntercept( x1, y1, x2, y2 )
	local Slope2, Intercept2 = mlib.line.getSlope( x3, y3, x4, y4 ), mlib.line.getIntercept( x3, y3, x4, y4 )
	
	if Slope1 == Slope2 and Slope1 then 
		if Intercept1 == Intercept2 then 
			local x = { x1, x2, x3, x4 }
			local y = { y1, y2, y3, y4 }
			local OriginalY = { y1, y2, y3, y4 }
			
			local Length1, Length2 = mlib.line.getLength( x[1], y[1], x[2], y[2] ), mlib.line.getLength( x[3], y[3], x[4], y[4] )
			
			local LargestX, LargestXReference = sortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			local LargestY, LargestYReference = sortWithReference( y, function ( Value1, Value2 ) return Value1 > Value2 end ) 
			local SmallestX, SmallestXReference = sortWithReference( x, function ( Value1, Value2 ) return Value1 < Value2 end ) 
			local SmallestY, SmallestYReference = sortWithReference( y, function ( Value1, Value2 ) return Value1 < Value2 end ) 
			
			table.remove( x, LargestXReference )
			table.remove( x, SmallestXReference )
			table.remove( y, LargestYReference )
			table.remove( y, SmallestYReference )
			
			local Distance = mlib.line.getLength( x[1], y[1], x[2], y[2] )
			if Distance > Length1 or Distance > Length2 then return false end
			
			local Length1 = mlib.line.getLength( x[1], OriginalY[1], x[1], OriginalY[2] )
			local Length2 = mlib.line.getLength( x[1], OriginalY[3], x[1], OriginalY[4] )
			local Length3 = mlib.line.getLength( x[1], y[1], x[2], y[2] )
			
			if Length3 >= Length1 or Length3 >= Length2 then return false end
			return x[1], y[1], x[2], y[2]
		else
			return false
		end
	end
	
	local x, y
	
	if not Slope1 and not Slope2 then
		if x1 ~= x3 then return false end
		
		local x = { x1, x2, x3, x4 }
		local y = { y1, y2, y3, y4 }

		local OriginalY = { y1, y2, y3, y4 }
		
		local Length1, Length2 = mlib.line.getLength( x[1], y[1], x[2], y[2] ), mlib.line.getLength( x[3], y[3], x[4], y[4] )
		
		local LargestX, LargestXReference = sortWithReference( x, function ( Value1, Value2 ) return Value1 > Value2 end ) 
		local LargestY, LargestYReference = sortWithReference( y, function ( Value1, Value2 ) return Value1 > Value2 end ) 
		local SmallestX, SmallestXReference = sortWithReference( x, function ( Value1, Value2 ) return Value1 < Value2 end ) 
		local SmallestY, SmallestYReference = sortWithReference( y, function ( Value1, Value2 ) return Value1 < Value2 end ) 
		
		table.remove( x, LargestXReference )
		table.remove( x, SmallestXReference )
		table.remove( y, LargestYReference )
		table.remove( y, SmallestYReference )
		
		local Distance = mlib.line.getLength( x[1], y[1], x[2], y[2] )
		if Distance > Length1 or Distance > Length2 then return false end
		
		local Length1 = mlib.line.getLength( x[1], OriginalY[1], x[1], OriginalY[2] )
		local Length2 = mlib.line.getLength( x[1], OriginalY[3], x[1], OriginalY[4] )
		local Length3 = mlib.line.getLength( x[1], y[1], x[2], y[2] )
		
		if Length3 >= Length1 or Length3 >= Length2 then return false end
		return x[1], y[1], x[2], y[2]
	elseif not Slope1 then
		x = x2
		y = Slope2 * x + Intercept2
		
		local Length1 = mlib.line.getLength( x1, y1, x2, y2 )
		local Length2 = mlib.line.getLength( x3, y3, x4, y4 )
		local Distance1 = mlib.line.getLength( x1, y1, x, y )
		local Distance2 = mlib.line.getLength( x2, y2, x, y )
		local Distance3 = mlib.line.getLength( x3, y3, x, y )
		local Distance4 = mlib.line.getLength( x4, y4, x, y )
		
		if ( Distance1 > Length1 ) or ( Distance2 > Length1 ) or ( Distance3 > Length2 ) or ( Distance4 > Length2 ) then 
			return false 
		end
	elseif not Slope2 then
		x = x4
		y = Slope1 * x + Intercept1
		
		local Length1 = mlib.line.getLength( x1, y1, x2, y2 )
		local Length2 = mlib.line.getLength( x3, y3, x4, y4 )
		local Distance1 = mlib.line.getLength( x1, y1, x, y )
		local Distance2 = mlib.line.getLength( x2, y2, x, y )
		local Distance3 = mlib.line.getLength( x3, y3, x, y )
		local Distance4 = mlib.line.getLength( x4, y4, x, y )
		
		if ( Distance1 > Length1 ) or ( Distance2 > Length1 ) or ( Distance3 > Length2 ) or ( Distance4 > Length2 ) then return false end
	else
		x, y = mlib.line.getIntersection( Slope1, Intercept1, Slope2, Intercept2 )
		if not x then return false end
		
		local Length1, Length2 = mlib.line.getLength( x1, y1, x2, y2 ), mlib.line.getLength( x3, y3, x4, y4 )
		local Distance1 = mlib.line.getLength( x1, y1, x, y )
		if Distance1 > Length1 then return false end
		
		local Distance2 = mlib.line.getLength( x2, y2, x, y )
		if Distance2 > Length1 then return false end
		
		local Distance3 = mlib.line.getLength( x3, y3, x, y )
		if Distance3 > Length2 then return false end
		
		local Distance4 = mlib.line.getLength( x4, y4, x, y )
		if Distance4 > Length2 then return false end
	end
	
	return x, y
end

-- polygon
function mlib.polygon.getTriangleHeight( base, ... )
	local userdata = checkUserdata( ... )
	local Area = 0
	local Intercept = 0

	if #userdata == 1 then Area = userdata[1] else Area = mlib.polygon.getArea( userdata ) end
	
	return ( 2 * Area ) / base, Area
end

function mlib.polygon.getSignedArea( ... ) 
	local userdata = checkUserdata( ... )
	local Points = {}
	
	for Index = 1, #userdata, 2 do
		Points[#Points + 1] = { userdata[a], userdata[Index + 1] } 
	end
	
	Points[#Points + 1] = {}
	Points[#Points][1], Points[#Points][2] = Points[1][1], Points[1][2]
	return ( .5 * mlib.math.getSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then 
				return ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) 
			else 
				return ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) )
			end 
		end 
	) )
end

function mlib.polygon.getArea( ... ) 
	return math.abs( mlib.polygon.getSignedArea( ... ) )
end

function mlib.polygon.getCentroid( ... ) 
	local userdata = checkUserdata( ... )
	
	local Points = {}
	for Index = 1, #userdata, 2 do
		table.insert( Points, { userdata[Index], userdata[Index + 1] } )
	end
	
	Points[#Points + 1] = {}
	Points[#Points][1], Points[#Points][2] = Points[1][1], Points[1][2]
	
	local Area = GetSignedArea( userdata ) -- Needs to be signed here in case points are counter-clockwise. 
	
	local CentroidX = ( 1 / ( 6 * Area ) ) * ( mlib.math.getSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then
				return ( ( Points[Index][1] + Points[Index + 1][1] ) * ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) )
			else
				return ( ( Points[Index][1] + Points[1][1] ) * ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) ) )
			end
		end
	) )
	
	local CentroidY = ( 1 / ( 6 * Area ) ) * ( mlib.math.getSummation( 1, #Points, 
		function( Index ) 
			if Points[Index + 1] then
				return ( ( Points[Index][2] + Points[Index + 1][2] ) * ( ( Points[Index][1] * Points[Index + 1][2] ) - ( Points[Index + 1][1] * Points[Index][2] ) ) )
			else
				return ( ( Points[Index][2] + Points[1][2] ) * ( ( Points[Index][1] * Points[1][2] ) - ( Points[1][1] * Points[Index][2] ) ) )
			end
		end 
	) )

	return CentroidX, CentroidY
end

function mlib.polygon.checkPoint( PointX, PointY, ... )
	local userdata = {}
	local x = {}
	local y = {}
	local Slopes = {}
	
	if type( ... ) ~= 'table' then userdata = { ... } else userdata = ... end
	
	for Index = 1, #userdata, 2 do
		table.insert( x, userdata[Index] )
		table.insert( y, userdata[Index + 1] )
	end
	
	for Index = 1, #x do
		local Slope
		if Index ~= #x then
			Slope = ( y[Index] - y[Index + 1] ) / ( x[Index] - x[Index + 1] )
		else 
			Slope = ( y[Index] - y[1] ) / ( x[Index] - x[1] )
		end
		Slopes[#Slopes + 1] = Slope
	end
	
	local LowestX = math.min( unpack( x ) )
	local LargestX = math.max( unpack( x ) )
	local LowestY = math.min( unpack( y ) )
	local LargestY = math.max( unpack( y ) )
	
	if PointX < LowestX or PointX > LargestX or PointY < LowestY or PointY > LargestY then return false end
	
	local Count = 0
	
	function Wrap( Number, Limit )
		if Number > Limit then return Number - Limit end
		return Number
	end
	
	for Index = 1, #Slopes do
		if Index ~= #Slopes then
			local x1, x2 = x[Index], x[Index + 1]
			local y1, y2 = y[Index], y[Index + 1]
			if PointY == y1 or PointY == y2 then 
				if y[ Wrap( Index + 2, #y ) ] ~= PointY and y[Wrap( Index + 3, #y )] ~= PointY then
					Count = Count + 1
				end
			elseif mlib.line.segment.getIntersection( x1, y1, x2, y2, PointX, PointY, LowestX, PointY ) then 
				Count = Count + 1 
			end
		else
			local x1, x2 = x[Index], x[1]
			local y1, y2 = y[Index], y[1]
			if PointY == y1 or PointY == y2 then 
				if y[Wrap( Index + 2, #y )] ~= PointY and y[Wrap( Index + 3, #y )] ~= PointY then
					Count = Count + 1
				end
			elseif mlib.line.segment.getIntersection( x1, y1, x2, y2, PointX, PointY, LowestX, PointY ) then 
				Count = Count + 1 
			end
		end
	end

	return math.floor( Count / 2 ) ~= Count / 2 and true
end

function mlib.polygon.lineIntersects( x1, y1, x2, y2, ... )
	local userdata = checkUserdata( ... )
	local Choices = {}

	if mlib.polygon.checkPoint( x1, y1, userdata ) then Choices[#Choices + 1] = { x1, y1 } end
	if mlib.polygon.checkPoint( x2, y2, userdata ) then Choices[#Choices + 1] = { x2, y2 } end
	
	for Index = 1, #userdata, 2 do
		-- if mlib.line.segment.checkPoint( x1, y1, x2, y2, userdata[Index], userdata[Index + 1] ) then return true end
		if userdata[Index + 2] then
			local x1, y1, x2, y2 = mlib.line.segment.getIntersection( userdata[Index], userdata[Index + 1], userdata[Index + 2], userdata[Index + 3], x1, y1, x2, y2 )
			if x2 then Choices[#Choices + 1] = { x1, y1, x2, y2 } 
			elseif x1 then Choices[#Choices + 1] = { x1, y1 } end
		else
			local x1, y1, x2, y2 = mlib.line.segment.getIntersection( userdata[Index], userdata[Index + 1], userdata[1], userdata[2], x1, y1, x2, y2 )
			if x2 then Choices[#Choices + 1] = { x1, y1, x2, y2 } 
			elseif x1 then Choices[#Choices + 1] = { x1, y1 } end
		end
	end
	
	return #Choices > 0 and Choices or false
end

function mlib.polygon.polygonIntersects( polygon1, polygon2 )
	local Choices = {}
	
	for Index = 1, #polygon1, 2 do
		if polygon1[Index + 2] then
			local Intersections = mlib.polygon.lineIntersects( polygon1[Index], polygon1[Index + 1], polygon1[Index + 2], polygon1[Index + 3], polygon2 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		else
			local Intersections = mlib.polygon.lineIntersects( polygon1[Index], polygon1[Index + 1], polygon1[1], polygon1[2], polygon2 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		end
	end
	
	for Index = 1, #polygon2, 2 do
		if polygon2[Index + 2] then
			local Intersections = mlib.polygon.lineIntersects( polygon2[Index], polygon2[Index + 1], polygon2[Index + 2], polygon2[Index + 3], polygon1 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		else
			local Intersections = mlib.polygon.lineIntersects( polygon2[Index], polygon2[Index + 1], polygon2[1], polygon2[2], polygon1 )
			if Intersections and #Intersections > 0 then
				for Index2 = 1, #Intersections do
					Choices[#Choices + 1] = { unpack( Intersections[Index2] ) }
				end
			end
		end
	end	
	
	function RemoveDuplicates( Table ) -- Local because it is very custom-coded. 
		for Index1 = #Table, 1, -1 do
			local First = Table[Index1]
			for Index2 = #Table, 1, -1 do
				local Second = Table[Index2]
				if Index1 ~= Index2 then
					if First[1] == Second[1] and First[2] == Second[2] then
						table.remove( Table, Index1 )
					end
				end
			end
		end
		return Table
	end
	
	local Final = RemoveDuplicates( Choices )
	
	return #Final > 0 and Final or false 
end

function mlib.polygon.circleIntersects( x, y, Radius, ... )
	local userdata = checkUserdata( ... )
	local Choices = {}
	
	if mlib.polygon.checkPoint( x, y, userdata ) then Choices[#Choices + 1] = { x, y } end
	
	for Index = 1, #userdata, 2 do
		if userdata[Index + 2] then 
			local x1, y1, x2, y2 = mlib.circle.isSegmentSecant( x, y, Radius, userdata[Index], userdata[Index + 1], userdata[Index + 2], userdata[Index + 3] )
			if x2 then 
				Choices[#Choices + 1] = { x1, y1 } 
				Choices[#Choices + 1] = { x2, y2 }
			elseif x1 then Choices[#Choices + 1] = { x1, y1 } end
		else
			local x1, y1, x2, y2 = mlib.circle.isSegmentSecant( x, y, Radius, userdata[Index], userdata[Index + 1], userdata[1], userdata[2] )
			if x2 then 
				Choices[#Choices + 1] = { x1, y1 } 
				Choices[#Choices + 1] = { x2, y2 }
			elseif x1 then Choices[#Choices + 1] = { x1, y1 } end
		end
	end
	
	return #Choices > 0 and Choices or false
end

-- circle
function mlib.circle.getArea( Radius )
	return math.pi * ( Radius ^ 2 )
end

function mlib.circle.checkPoint( circleX, circleY, Radius, x, y )
	return ( x - circleX ) ^ 2 + ( y - circleY ) ^ 2 == Radius ^ 2 
end

function mlib.circle.getCircumference( Radius )
	return 2 * math.pi * Radius
end

function mlib.circle.isLineSecant( circleX, circleY, Radius, ... )
	local userdata = checkUserdata( ... )
	
	local Slope, Intercept = 0, 0
	
	if #userdata == 2 then 
		Slope, Intercept = userdata[1], userdata[2] 
	else 
		Slope = mlib.line.getSlope( userdata[1], userdata[2], userdata[3], userdata[4] ) 
		Intercept = mlib.line.getIntercept( userdata[1], userdata[2], Slope ) 
	end
	
	local x1, y1, x2, y2
	if #userdata == 4 then x1, y1, x2, y2 = unpack( userdata ) end
	
	if Slope then 
		local a = ( 1 + Slope ^ 2 )
		local b = ( -2 * ( circleX ) + ( 2 * Slope * Intercept ) - ( 2 * circleY * Slope ) )
		local c = ( circleX ^ 2 + Intercept ^ 2 - 2 * ( circleY ) * ( Intercept ) + circleY ^ 2 - Radius ^ 2 )
		
		x1, x2 = mlib.math.getRootsOfQuadratic( a, b, c )
		
		if not x1 then return false end
		
		y1 = Slope * x1 + Intercept
		y2 = Slope * x2 + Intercept
		
		if x1 == x2 and y1 == y2 then 
			return 'Tangent', x1, y1
		else 
			return 'Secant', x1, y1, x2, y2 
		end
	else
		-- Theory: *see Reference Pictures/circle.png for information on how it works.
		local LengthToPoint1 = circleX - x1
		local RemainingDistance = LengthToPoint1 - Radius
		local Intercept = math.sqrt( -( LengthToPoint1 ^ 2 - Radius ^ 2 ) )
		
		if -( LengthToPoint1 ^ 2 - Radius ^ 2 ) < 0 then return false end
		
		local BottomX, BottomY = x1, circleY - Intercept
		local TopX, TopY = x1, circleY + Intercept
		
		if TopY ~= BottomY then 
			return 'Secant', TopX, TopY, BottomX, BottomY 
		else 
			return 'Tangent', TopX, TopY 
		end
	end
end

function mlib.circle.isSegmentSecant( circleX, circleY, Radius, x1, y1, x2, y2 )
	local Type, x3, y3, x4, y4 = mlib.circle.isLineSecant( circleX, circleY, Radius, x1, y1, x2, y2 )
	if not Type then return false end
	
	local Slope, Intercept = mlib.line.getSlope( x1, y1, x2, y2 ), mlib.line.getIntercept( x1, y1, x2, y2 )
	
	if Slope then 
		if mlib.circle.isPointIncircle( circleX, circleY, Radius, x1, y1 ) and mlib.circle.isPointIncircle( circleX, circleY, Radius, x2, y2 ) then -- line-segment is fully in circle. 
			return x1, y1, x2, y2
		elseif x3 and x4 then
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 ) and mlib.line.segment.checkPoint( x1, y1, x2, y2, x4, y4 ) then -- Both points are on line-segment. 
				return x3, y3, x4, y4
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 ) then -- Only the first of the points is on the line-segment. 
				return x3, y3
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, x4, y4 ) then -- Only the second of the points is on the line-segment. 
				return x4, y4
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle)
				local Length = mlib.line.getLength( x1, y1, x2, y2 )
				
				local Distance1 = mlib.line.getLength( x1, y1, x3, y3 )
				local Distance2 = mlib.line.getLength( x2, y2, x3, y3 )
				local Distance3 = mlib.line.getLength( x1, y1, x4, y4 )
				local Distance4 = mlib.line.getLength( x2, y3, x4, y4 )
				
				if Length > Distance1 or Length > Distance2 or Length > Distance3 or Length > Distance4 then
					return false
				elseif Length < Distance1 and Length < Distance2 and Length < Distance3 and Length < Distance4 then 
					return false 
				else
					return true
				end
			end
		elseif not x4 then -- Is a tangent. 
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, x3, y3 ) then
				return x3, y3
			else -- Neither of the points are on the line-segment (means that the segment is not on the circle or "encasing" the circle).
				local Length = mlib.line.getLength( x1, y1, x2, y2 )
				local Distance1 = mlib.line.getLength( x1, y1, x3, y3 )
				local Distance2 = mlib.line.getLength( x2, y2, x3, y3 )
				
				if Length > Distance1 or Length > Distance2 then 
					return false
				elseif Length < Distance1 and Length < Distance2 then 
					return false 
				else
					return true
				end
			end
		end
	else
		-- Theory: *see Reference Images/circle.png for information on how it works.
		local LengthToPoint1 = circleX - x1
		local RemainingDistance = LengthToPoint1 - Radius
		local Intercept = math.sqrt( -( LengthToPoint1 ^ 2 - Radius ^ 2 ) )
		
		if -( LengthToPoint1 ^ 2 - Radius ^ 2 ) < 0 then return false end
		
		local TopX, TopY = x1, circleY - Intercept
		local BottomX, BottomY = x1, circleY + Intercept
		
		local Length = mlib.line.getLength( x1, y1, x2, y2 )
		local Distance1 = mlib.line.getLength( x1, y1, TopX, TopY )
		local Distance2 = mlib.line.getLength( x2, y2, TopX, TopY )
		
		if BottomY ~= TopY then 
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, TopX, TopY ) and mlib.line.segment.checkPoint( x1, y1, x2, y2, BottomX, BottomY ) then
				return TopX, TopY, BottomX, BottomY
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, TopX, TopY ) then
				return TopX, TopX
			elseif mlib.line.segment.checkPoint( x1, y1, x2, y2, BottomX, BottomY ) then
				return BottomX, BottomY
			else
				return false
			end
		else 
			if mlib.line.segment.checkPoint( x1, y1, x2, y2, TopX, TopY ) then
				return TopX, TopY
			else
				return false
			end
		end
	end
end

function mlib.circle.circleIntersects( circle1CenterX, circle1CenterY, Radius1, circle2CenterX, circle2CenterY, Radius2 )
	local Distance = mlib.line.getLength( circle1CenterX, circle1CenterY, circle2CenterX, circle2CenterY )
	if Distance > Radius1 + Radius2 then return false end
	if Distance == 0 and Radius1 == Radius2 then return true end
	
	local a = ( Radius1 ^ 2 - Radius2 ^ 2 + Distance ^ 2 ) / ( 2 * Distance )
	local h = math.sqrt( Radius1 ^ 2 - a ^ 2 )
	
	local p2x = circle1CenterX + a * ( circle2CenterX - circle1CenterX ) / Distance
	local p2y = circle1CenterY + a * ( circle2CenterY - circle1CenterY ) / Distance
	local p3x = p2x + h * ( circle2CenterY - circle1CenterY ) / Distance
	local p3y = p2y - h * ( circle2CenterX - circle1CenterX ) / Distance
	local p4x = p2x - h * ( circle2CenterY - circle1CenterY ) / Distance
	local p4y = p2y + h * ( circle2CenterX - circle1CenterX ) / Distance
	
	if Distance == Radius1 + Radius2 then return p3x, p3y end
	return p3x, p3y, p4x, p4y 
end

function mlib.circle.isPointIncircle( circleX, circleY, Radius, x, y )
	return mlib.line.getLength( circleX, circleY, x, y ) <= Radius
end

-- statistics
function mlib.statistics.getMean( ... )
	local userdata = checkUserdata( ... )
	
	local Mean = 0
	for Index = 1, #userdata do
		Mean = Mean + userdata[Index]
	end
	Mean = Mean / #userdata
	
	return Mean
end

function mlib.statistics.getMedian( ... )
	local userdata = checkUserdata( ... )
	
	table.sort( userdata )
	
	if #userdata % 2 == 0 then
		userdata = ( userdata[math.floor( #userdata / 2 )] + userdata[math.floor( #userdata / 2 + 1 )] ) / 2
	else
		userdata =  userdata[#userdata / 2 + .5]
	end
	
	return userdata
end

function mlib.statistics.getMode( ... ) 
	local userdata = checkUserdata( ... )

	table.sort( userdata )
	local Number = { { userdata[1] } }
	for Index = 2, #userdata do
		if userdata[Index] == Number[#Number][1] then 
			table.insert( Number[#Number], userdata[Index] ) 
		else 
			table.insert( Number, { userdata[Index] } ) 
		end
	end
	
	local Large = { { #Number[1], Number[1][1] } }
	for Index = 2, #Number do
		if #Number[Index] > Large[1][1] then
			for NextIndex = #Large, 1, -1 do
				table.remove( Large, NextIndex )
			end
		table.insert( Large, { #Number[Index], Number[Index][1] } )
		elseif #Number[Index] == Large[1][1] then
			table.insert( Large, { #Number[Index], Number[Index][1] } )
		end
	end
	
	if #Large < 1 then 
		return false 
	elseif #Large > 1 then 
		return false 
	else 
		return Large[1][2], Large[1][1] 
	end
end

function mlib.statistics.getRange( ... )
	local userdata = {}
	
	local Upper, Lower = math.max( unpack( userdata ) ), math.min( unpack( userdata ) )
	
	return Upper - Lower
end

-- math (homeless functions)
function mlib.math.getRoot( Number, Root )
	return Number ^ ( 1 / Root )
end

function mlib.math.isPrime( Number )	
	if Number < 2 then return false end
		
	for Index = 2, math.sqrt( Number ) do
		if Number % Index == 0 then
			return false
		end
	end
	
	return true
end

function mlib.math.round( Number, DecimalPlace )
	local DecimalPlace, ReturnedValue = DecimalPlace and 10 ^ DecimalPlace or 1
	
	local UpperNumber = math.ceil( Number * DecimalPlace )
	local LowerNumber = math.floor( Number * DecimalPlace )
	
	local UpperDifferance = UpperNumber - ( Number * DecimalPlace ) 
	local LowerDifference = ( Number * DecimalPlace ) - LowerNumber
	
	if UpperNumber == Number then
		ReturnedValue = Number
	else
		if UpperDifferance <= LowerDifference then ReturnedValue = UpperNumber elseif LowerDifference < UpperDifferance then ReturnedValue = LowerNumber end
	end
	
	return ReturnedValue / DecimalPlace
end

function mlib.math.getSummation( Start, Stop, Function )
	if Stop == 1 / 0 or Stop == -1 / 0 then return false end
	
	local ReturnedValue = {}
	local Value = 0
	
	for Index = Start, Stop do
		local New = Function( Index, ReturnedValue )
		
		ReturnedValue[Index] = New
		Value = Value + New
	end
	
	return Value
end

function mlib.math.getPercentOfChange( Old, New )
	if Old == 0 then 
		return false
	else 
		return ( New - Old ) / math.abs( Old ) 
	end
end

function mlib.math.getPercent( Percent, Number )
	return Percent * math.abs( Number ) + Number 
end

function mlib.math.getRootsOfQuadratic( a, b, c )
	local Discriminant = b ^ 2 - ( 4 * a * c )
	if Discriminant < 0 then return false end
	
	Discriminant = math.sqrt( Discriminant )
	
	return ( -b - Discriminant ) / ( 2 * a ), ( -b + Discriminant ) / ( 2 * a )
end

function mlib.math.getAngle( ... )
	local userdata = checkUserdata( ... )
	local Angle = 0
	
	if #userdata <= 5 then
		local x1, y1, x2, y2, Direction = unpack( userdata )
		
		if not Direction or Direction == 'Up' then Direction = math.rad( 90 ) 
			elseif Direction == 'Right' then Direction = 0 
			elseif Direction == 'Down' then Direction = math.rad( -90 )
			elseif Direction == 'Left' then Direction = math.rad( -180 )
		end
		
		local dx, dy = x2 - x1, y2 - y1
		Angle = math.atan2( dy, dx ) + Direction
	elseif #userdata == 6 then
		local x1, y1, x2, y2, x3, y3 = unpack( userdata )
		
		local AB = mlib.line.getLength( x1, y1, x2, y2 )
		local BC = mlib.line.getLength( x2, y2, x3, y3 )
		local AC = mlib.line.getLength( x1, y1, x3, y3 )
		
		Angle = math.acos( ( BC * BC + AB * AB - AC * AC ) / ( 2 * BC * AB ) )
	end
	
	return Angle
end

-- shape
function mlib.shape.newShape( ... )
	local userdata = checkUserdata( ... )
	
	if #userdata == 3 then
		userdata.Type = 'circle'
		userdata.x, userdata.y, userdata.radius = unpack( userdata )
		userdata.Area = mlib.circle.getArea( userdata.radius )
	elseif #userdata == 4 then
		userdata.Type = 'line'
		userdata.x1, userdata.y1, userdata.x2, userdata.y2 = unpack( userdata )
		userdata.mlib.line.getSlope = mlib.line.getSlope( unpack( userdata ) )
		userdata.mlib.line.getIntercept = mlib.line.getIntercept( unpack( userdata ) )
	else
		userdata.Type = 'polygon'
		userdata.Area = mlib.polygon.getArea( userdata )
		userdata.Points = userdata
	end
	
	userdata.Collided = false
	userdata.Index = #mlib.shape.user + 1
	userdata.removed = false
	
	setmetatable( userdata, mlib.shape )
	table.insert( mlib.shape.user, userdata )
	
	return userdata
end

function mlib.shape.checkCollisions( self, ... )
	local userdata = { ... }
	
	if Type( self ) == 'table' then -- Using Index self:table. 
		if #userdata == 0 then -- No arguments (colliding with everything). 
			for Index = 1, #mlib.shape.user do
				if Index ~= self.Index then 
					local Collided = false
					local shape = mlib.shape.user[Index]
					if not shape.removed and not self.removed then 
						if self.Type == 'line' then 
							if shape.Type == 'line' then
								if mlib.line.segment.getIntersection( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true end
							elseif shape.Type == 'polygon' then
								if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
							elseif shape.Type == 'circle' then
								if mlib.circle.isSegmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then Collided, self.Collided, shape.Collided = true, true end
							end
						elseif self.Type == 'polygon' then
							if shape.Type == 'line' then
								if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.Points ) then Collided, self.Collided, shape.Collided = true, true end
							elseif shape.Type == 'polygon' then
								if mlib.polygon.polygonIntersects( self.Points, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
							elseif shape.Type == 'circle' then
								if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.Points ) then Collided, self.Collided, shape.Collided = true, true end
							end
						elseif self.Type == 'circle' then
							if shape.Type == 'line' then
								if mlib.circle.isSegmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true end
							elseif shape.Type == 'polygon' then
								if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
							elseif shape.Type == 'circle' then
								if mlib.circle.circleIntersects( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then Collided, self.Collided, shape.Collided = true, true end
							end
						end
					end
					if not Collided then self.Collided = false end
				end
			end
		else -- Colliding with only certain things. 
			for Index = 1, #userdata do
				local Collided = false
				local shape = userdata[Index]
				if not shape.removed and not self.removed then 
					if self.Type == 'line' then 
						if shape.Type == 'line' then
							if mlib.line.segment.getIntersection( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true end
						elseif shape.Type == 'polygon' then
							if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
						elseif shape.Type == 'circle' then
							if mlib.circle.isSegmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then Collided, self.Collided, shape.Collided = true, true end
						end
					elseif self.Type == 'polygon' then
						if shape.Type == 'line' then
							if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.Points ) then Collided, self.Collided, shape.Collided = true, true end
						elseif shape.Type == 'polygon' then
							if mlib.polygon.polygonIntersects( self.Points, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
						elseif shape.Type == 'circle' then
							if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.Points ) then Collided, self.Collided, shape.Collided = true, true end
						end
					elseif self.Type == 'circle' then
						if shape.Type == 'line' then
							if mlib.circle.isSegmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true end
						elseif shape.Type == 'polygon' then
							if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
						elseif shape.Type == 'circle' then
							if mlib.circle.circleIntersects( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then Collided, self.Collided, shape.Collided = true, true end
						end
					end
				end
				if not Collided then self.Collided = false end
			end
		end
	else -- Not using self:table. 
		local userdata = { unpack( userdata ) }
		if #userdata == 0 then -- Checking all collisions. 
			for Index = 1, #mlib.shape.user do
				local self = mlib.shape.user[Index]
				local Collided = false
				for Index2 = 1, #mlib.shape.user do
					if Index ~= Index2 then 
						local shape = mlib.shape.user[Index2]
						if not shape.removed and not self.removed then 
							if self.Type == 'line' then 
								if shape.Type == 'line' then
									if mlib.line.segment.getIntersection( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true, true end
								elseif shape.Type == 'polygon' then
									if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.Points ) then Collided, self.Collided, shape.Collided = true, true, true end
								elseif shape.Type == 'circle' then
									if mlib.circle.isSegmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then Collided, self.Collided, shape.Collided = true, true, true end
								end
							elseif self.Type == 'polygon' then
								if shape.Type == 'line' then
									if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.Points ) then Collided, self.Collided, shape.Collided = true, true, true end
								elseif shape.Type == 'polygon' then
									if mlib.polygon.polygonIntersects( self.Points, shape.Points ) then Collided, self.Collided, shape.Collided = true, true, true end
								elseif shape.Type == 'circle' then
									if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.Points ) then Collided, self.Collided, shape.Collided = true, true, true end
								end
							elseif self.Type == 'circle' then
								if shape.Type == 'line' then
									if mlib.circle.isSegmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true, true end
								elseif shape.Type == 'polygon' then
									if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.Points ) then self.Collided, Collided, self.Collided, shape.Collided = true, true, true end
								elseif shape.Type == 'circle' then
									if mlib.circle.circleIntersects( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then Collided, self.Collided, shape.Collided = true, true, true end
								end
							end
						end
					end
				end
				if not Collided then self.Collided = false end
			end
		else -- Checking only certain collisions
			for Index = 1, #userdata do
				local self = mlib.shape.user[Index]
				local Collided = false
				for Index2 = 1, #mlib.shape.user do
					if self.Index ~= userdata[Index2].Index then 
						local shape = mlib.shape.user[Index2]
						if not shape.removed and not self.removed then 
							if self.Type == 'line' then 
								if shape.Type == 'line' then
									if mlib.line.segment.getIntersection( self.x1, self.y1, self.x2, self.y2, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true end
								elseif shape.Type == 'polygon' then
									if mlib.polygon.lineIntersects( self.x1, self.y1, self.x2, self.y2, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
								elseif shape.Type == 'circle' then
									if mlib.circle.isSegmentSecant( shape.x, shape.y, shape.radius, self.x1, self.y1, self.x2, self.y2 ) then Collided, self.Collided, shape.Collided = true, true end
								end
							elseif self.Type == 'polygon' then
								if shape.Type == 'line' then
									if mlib.polygon.lineIntersects( shape.x1, shape.y1, shape.x2, shape.y2, self.Points ) then Collided, self.Collided, shape.Collided = true, true end
								elseif shape.Type == 'polygon' then
									if mlib.polygon.polygonIntersects( self.Points, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
								elseif shape.Type == 'circle' then
									if mlib.polygon.circleIntersects( shape.x, shape.y, shape.radius, self.Points ) then Collided, self.Collided, shape.Collided = true, true end
								end
							elseif self.Type == 'circle' then
								if shape.Type == 'line' then
									if mlib.circle.isSegmentSecant( self.x, self.y, self.radius, shape.x1, shape.y1, shape.x2, shape.y2 ) then Collided, self.Collided, shape.Collided = true, true end
								elseif shape.Type == 'polygon' then
									if mlib.polygon.circleIntersects( self.x, self.y, self.radius, shape.Points ) then Collided, self.Collided, shape.Collided = true, true end
								elseif shape.Type == 'circle' then
									if mlib.circle.circleIntersects( self.x, self.y, self.radius, shape.x, shape.y, shape.radius ) then Collided, self.Collided, shape.Collided = true, true end
								end
							end
						end
					end
				end
				if not Collided then self.Collided = false end
			end
		end
	end
end

function mlib.shape.remove( self, ... )
	local userdata = { ... }
	
	if Type( self ) == 'table' then
		mlib.shape.user[self.Index] = { Removed = false }
		
		if #userdata > 0 then
			for Index = 1, #userdata do
				mlib.shape.user[userdata[Index].Index] = { Removed = true }
			end
		end
	else
		if #userdata > 0 then
			for Index = 1, #userdata do
				mlib.shape.user[userdata[Index].Index] = { Removed = true }
			end
		else
			mlib.shape.user = {}
		end
	end
end

return mlib