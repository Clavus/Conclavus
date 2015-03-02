------------------------
-- Extensions to the math module.
-- @extend math

-- cache functions
local math = math
local sqrt, pi, random, floor, abs, cos = math.sqrt, math.pi, math.random, math.floor, math.abs, math.cos

--- Converts degrees to radians.
-- @number deg angle in degrees
-- @treturn number angle in radians
function math.deg2rad( deg )
	return deg / 180 * pi
end

--- Converts radians to degrees.
-- @number rad angle in radians
-- @treturn number angle in degrees
function math.rad2deg( rad )
	return rad / pi * 180
end

--- Clamps a number between a minimum and maximum.
-- @number num input number
-- @number low minimum
-- @number high maximum
-- @treturn number clamped number
function math.clamp( num, low, high )
	return num < low and low or (num > high and high or num)
end
local clamp = math.clamp

--- Returns a random (rational) number between the given minimum and maximum.
-- @number low minimum
-- @number high maximum
-- @treturn number random number
function math.randomRange( low, high )
	return low + (random() * (high-low))
end

--- Returns the sign of the number. Meaning it returns -1 if the number < 0, otherwise returns 1.
-- @number x input number
-- @treturn number sign number (-1 or 1)
function math.sign( x )
	return x < 0 and -1 or 1
end

--- Rounds a number to the nearest given amount of decimals.
-- @number i input number
-- @number[opt=0] decimals amount of decimals
-- @treturn number rounded number
function math.round( i, decimals )
	local mul = 10^(decimals or 0)
  return floor(i * mul + 0.5) / mul
end

--- Approach target number from current number with a given increment.
-- @number cur input number
-- @number target target number
-- @number inc increment
-- @treturn number result
function math.approach( cur, target, inc )
	inc = abs( inc )
	if (cur < target) then
		return clamp( cur + inc, cur, target )
	elseif (cur > target) then
		return clamp( cur - inc, target, cur )
	end
	return target
end

--- Lerp between two numbers with a given fraction.
-- @number a first number
-- @number b second number
-- @number frac fraction
-- @treturn number result
function math.lerp(a, b, frac) -- <frac> is in the range of 0 to 1
	return a + (b - a) * clamp(frac, 0, 1)
end

--- Lerp using cosine interprolation between two numbers with a given fraction.
-- @number a first number
-- @number b second number
-- @number frac fraction
-- @treturn number result
function math.smooth(a, b, frac) -- same as math.lerp but with cosine interpolation
	local m = (1 - cos(clamp(frac, 0, 1) * pi)) / 2
	return a + (b - a) * m
end

