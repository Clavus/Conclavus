------------------------
-- Extensions to the math module.
-- @extend math

-- cache functions
local math = math
local sqrt, pi, random, floor, abs = math.sqrt, math.pi, math.random, math.floor, math.abs

function math.distance( x1, y1, x2, y2 )
	local xd = x2-x1
	local yd = y2-y1
	return sqrt( xd*xd + yd*yd )
end

function math.deg2rad( deg )
	return deg / 180 * pi
end

function math.rad2deg( rad )
	return rad / pi * 180
end

function math.clamp( num, low, high )
	return num < low and low or (num > high and high or num)
end

function math.randomRange( low, high )
	return low + (random() * (high-low))
end

function math.sign( x )
	return x < 0 and -1 or 1
end

function math.round( i, decimals )
	local mul = 10^(decimals or 0)
  return floor(i * mul + 0.5) / mul
end

function math.approach( cur, target, inc ) -- sets <inc> step from <cur> to <target>
	inc = abs( inc )
	if (cur < target) then
		return math.clamp( cur + inc, cur, target )
	elseif (cur > target) then
		return math.clamp( cur - inc, target, cur )
	end
	return target
end

function math.lerp(a, b, frac) -- <frac> is in the range of 0 to 1
	assert(frac <= 1 and frac >= 0, "Lerp fraction has to be between 0 and 1")
	return a + (b - a) * frac
end

function math.smooth(a, b, frac) -- same as math.lerp but with cosine interpolation
	local m = (1 - math_cos(lume.clamp(frac, 0, 1) * math_pi)) / 2
	return a + (b - a) * m
end


