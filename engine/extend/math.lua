
function math.dist( x1, y1, x2, y2 )

	local xd = x2-x1
	local yd = y2-y1
	return math.sqrt( xd*xd + yd*yd )
	
end

math.distance = math.dist -- alias

function math.clamp( num, low, high )

	if (num < low ) then return low end
	if (num > high ) then return high end
	return num
	
end

function math.randRange( low, high )

	return low + (math.random() * (high-low))
	
end

function math.choose( ... )
	
	local arg = {...}
	return arg[math.random(1,#arg)]
	
end

function math.round( i )

	i = i or 0
	return math.floor( i + 0.5 )
	
end

function math.approach( cur, target, inc )

	inc = math.abs( inc )

	if (cur < target) then
		
		return math.clamp( cur + inc, cur, target )

	elseif (cur > target) then

		return math.clamp( cur - inc, target, cur )

	end

	return target
	
end

-- normalizes angle to be between 180 and -179 degrees
function math.normalizeAngle( a )

	while (a <= -math.pi) do
		a = a + math.pi*2
	end
	
	while (a > math.pi) do
		a = a - math.pi*2
	end

	return a
	
end


function math.angleDifference( a, b )

	local diff = math.normalizeAngle( a - b )
	
	if ( diff < math.pi ) then
		return diff
	end
	
	return diff - math.pi

end

function math.approachAngle( cur, target, inc )

	local diff = math.angleDifference( target, cur )
	return math.approach( cur, cur + diff, inc )
	
end

