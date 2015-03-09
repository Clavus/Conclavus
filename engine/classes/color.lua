------------------------
-- Color class.
-- For bringing color to your life.
-- 
-- Derived from @{Object}.
-- @cl Color

local Color = class('Color')

function Color:initialize( r, g, b, a )
	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255
end

function Color:copy()
	return Color( self.r, self.g, self.b, self.a )
end

 local RGBtoHSV = function(r, g, b, a)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max
	local d = max - min
	if max == 0 then s = 0 else s = d / max end
	
	if max == min then
		h = 0 -- achromatic
	else
		if max == r then
			h = (g - b) / d
			if g < b then h = h + 6 end
		elseif max == g then 
			h = (b - r) / d + 2
		elseif max == b then 
			h = (r - g) / d + 4
		end
		h = h / 6
	end
	return h * 255, s * 255, v * 255, a
 end
 
local HSVtoRGB = function(h, s, v, a)
	local h, s, v = h / 255, s / 255, v / 255
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	
	i = i % 6
	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end
	return r * 255, g * 255, b * 255, a
 end

function Color:toHex()
	
	local hexadecimal = "" --'0X'
	for key, value in pairs({self.r, self.g, self.b}) do
		local hex = ''
		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end
		
		if(string.len(hex) == 0)then 
			hex = '00'
		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end
	return hexadecimal
end

function Color:toHexNumber()
	return self.r * 0x10000 + self.g * 0x100 + self.b
end

function Color:getTable()
	return { self.r, self.g, self.b, self.a }
end

function Color:unpack()
	return self.r, self.g, self.b, self.a
end

function Color:negative()
	self.r = 255 - self.r
	self.g = 255 - self.g
	self.b = 255 - self.b
	return self
end

function Color:invert()
	local h, s, v = Color:getHSV()
	self.r, self.g, self.b = Color.HSVtoRGB( 255 - h, s, v )
	return self
end

function Color:getHSV()
	return RGBtoHSV( self.r, self.g, self.b, self.a )
end

function Color:__concat( a )
	return tostring(self)..tostring(a)
end

function Color:__tostring()
	return "Color( "..self.r..", "..self.g..", "..self.b..", "..self.a.." )"
end

-- credits to ivan from Love2D forum
Color.static.fromHexNumber = function( rgb )
  -- clamp between 0x000000 and 0xffffff
  rgb = rgb % 0x1000000 -- 0xffffff + 1
  -- extract each color
  local b = rgb % 0x100 -- 0xff + 1 or 256
  local g = (rgb - b) % 0x10000 -- 0xffff + 1
  local r = (rgb - g - b)
  -- shift right
  g = g / 0x100 -- 0xff + 1 or 256
  r = r / 0x10000 -- 0xffff + 1
  return r, g, b
end

Color.static.fromHex = function( hex )
	hex = hex:gsub("#","")
	assert(string.len(hex) == 6, "Invalid hexadecimal color value!")
	--return Color(tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)))
	return Color.fromHexNumber( tonumber(hex) )
end

Color.static.fromHSV = function(h, s, v, a)
	return Color(HSVtoRGB(h, s, v, a))
end

Color.static.lerp = function( color1, color2, frac )
	local new_r = color1.r + (color2.r - color1.r) * frac
	local new_g = color1.g + (color2.g - color1.g) * frac
	local new_b = color1.b + (color2.b - color1.b) * frac
	local new_a = color1.a + (color2.a - color1.a) * frac
	return Color(new_r, new_g, new_b, new_a)
end

-- HTML colors: http://www.w3schools.com/html/html_colornames.asp --
local colors = {}
colors.AliceBlue = { 240, 248, 255 }
colors.AntiqueWhite = { 250, 235, 215 }
colors.Aqua = { 0, 255, 255 }
colors.Aquamarine = { 127, 255, 212 }
colors.Azure = { 240, 255, 255 }
colors.Beige = { 245, 245, 220 }
colors.Bisque = { 255, 228, 196 }
colors.Black = { 0, 0, 0 }
colors.BlanchedAlmond = { 255, 235, 205 }
colors.Blue = { 0, 0, 255 }
colors.BlueViolet = { 138, 43, 226 }
colors.Brown = { 165, 42, 42 }
colors.Burlywood = { 222, 184, 135 }
colors.CadetBlue = { 95, 158, 160 }
colors.Chartreuse = { 127, 255, 0 }
colors.Chocolate = { 210, 105, 30 }
colors.Coral = { 255, 127, 80 }
colors.CornflowerBlue = { 100, 149, 237 }
colors.Cornsilk = { 255, 248, 220 }
colors.Crimson = { 220, 20, 60 }
colors.Cyan = { 0, 255, 255 }
colors.DarkBlue = { 0, 0, 139 }
colors.DarkCyan = { 0, 139, 139 }
colors.DarkGoldenrod = { 184, 134, 11 }
colors.DarkGray = { 169, 169, 169 }
colors.DarkGreen = { 0, 100, 0 }
colors.DarkGrey = { 169, 169, 169 }
colors.DarkKhaki = { 189, 183, 107 }
colors.DarkMagenta = { 139, 0, 139 }
colors.DarkOliveGreen = { 85, 107, 47 }
colors.Darkorange = { 255, 140, 0 }
colors.DarkOrchid = { 153, 50, 204 }
colors.DarkRed = { 139, 0, 0 }
colors.Darksalmon = { 233, 150, 122 }
colors.DarkSeaGreen = { 143, 188, 143 }
colors.DarkSlateBlue = { 72, 61, 139 }
colors.DarkSlateGray = { 47, 79, 79 }
colors.DarkSlateGrey = { 47, 79, 79 }
colors.DarkTurquoise = { 0, 206, 209 }
colors.DarkViolet = { 148, 0, 211 }
colors.DeepPink = { 255, 20, 147 }
colors.DeepSkyBlue = { 0, 191, 255 }
colors.DimGray = { 105, 105, 105 }
colors.DimGrey = { 105, 105, 105 }
colors.DodgerBlue = { 30, 144, 255 }
colors.Firebrick = { 178, 34, 34 }
colors.FloralWhite = { 255, 250, 240 }
colors.ForestGreen = { 34, 139, 34 }
colors.Fuchsia = { 255, 0, 255 }
colors.Gainsboro = { 220, 220, 220 }
colors.GhostWhite = { 248, 248, 255 }
colors.Gold = { 255, 215, 0 }
colors.Goldenrod = { 218, 165, 32 }
colors.Gray = { 128, 128, 128 }
colors.Green = { 0, 128, 0 }
colors.GreenYellow = { 173, 255, 47 }
colors.Grey = { 128, 128, 128 }
colors.Honeydew = { 240, 255, 240 }
colors.HotPink = { 255, 105, 180 }
colors.IndianRed = { 205, 92, 92 }
colors.Indigo = { 75, 0, 130 }
colors.Ivory = { 255, 255, 240 }
colors.Khaki = { 240, 230, 140 }
colors.Lavender = { 230, 230, 250 }
colors.LavenderBlush = { 255, 240, 245 }
colors.LawnGreen = { 124, 252, 0 }
colors.LemonChiffon = { 255, 250, 205 }
colors.LightBlue = { 173, 216, 230 }
colors.Lightcoral = { 240, 128, 128 }
colors.LightCyan = { 224, 255, 255 }
colors.LightGoldenrodYellow = { 250, 250, 210 }
colors.LightGray = { 211, 211, 211 }
colors.LightGreen = { 144, 238, 144 }
colors.LightGrey = { 211, 211, 211 }
colors.LightPink = { 255, 182, 193 }
colors.Lightsalmon = { 255, 160, 122 }
colors.LightSeaGreen = { 32, 178, 170 }
colors.LightSkyBlue = { 135, 206, 250 }
colors.LightSlateGray = { 119, 136, 153 }
colors.LightSlateGrey = { 119, 136, 153 }
colors.LightsteelBlue = { 176, 196, 222 }
colors.LightYellow = { 255, 255, 224 }
colors.Lime = { 0, 255, 0 }
colors.LimeGreen = { 50, 205, 50 }
colors.Linen = { 250, 240, 230 }
colors.Magenta = { 255, 0, 255 }
colors.Maroon = { 128, 0, 0 }
colors.MediumAquamarine = { 102, 205, 170 }
colors.MediumBlue = { 0, 0, 205 }
colors.MediumOrchid = { 186, 85, 211 }
colors.MediumPurple = { 147, 112, 219 }
colors.MediumSeaGreen = { 60, 179, 113 }
colors.MediumSlateBlue = { 123, 104, 238 }
colors.MediumSpringGreen = { 0, 250, 154 }
colors.MediumTurquoise = { 72, 209, 204 }
colors.MediumVioletRed = { 199, 21, 133 }
colors.MidnightBlue = { 25, 25, 112 }
colors.MintCream = { 245, 255, 250 }
colors.MistyRose = { 255, 228, 225 }
colors.Moccasin = { 255, 228, 181 }
colors.NavajoWhite = { 255, 222, 173 }
colors.Navy = { 0, 0, 128 }
colors.OldLace = { 253, 245, 230 }
colors.Olive = { 128, 128, 0 }
colors.OliveDrab = { 107, 142, 35 }
colors.Orange = { 255, 165, 0 }
colors.OrangeRed = { 255, 69, 0 }
colors.Orchid = { 218, 112, 214 }
colors.PaleGoldenrod = { 238, 232, 170 }
colors.PaleGreen = { 152, 251, 152 }
colors.PaleTurquoise = { 175, 238, 238 }
colors.PaleVioletRed = { 219, 112, 147 }
colors.Papayawhip = { 255, 239, 213 }
colors.Peachpuff = { 255, 218, 185 }
colors.Peru = { 205, 133, 63 }
colors.Pink = { 255, 192, 203 }
colors.Plum = { 221, 160, 221 }
colors.PowderBlue = { 176, 224, 230 }
colors.Purple = { 128, 0, 128 }
colors.Red = { 255, 0, 0 }
colors.RosyBrown = { 188, 143, 143 }
colors.RoyalBlue = { 65, 105, 225 }
colors.SaddleBrown = { 139, 69, 19 }
colors.Salmon = { 250, 128, 114 }
colors.SandyBrown = { 244, 164, 96 }
colors.SeaGreen = { 46, 139, 87 }
colors.Seashell = { 255, 245, 238 }
colors.Sienna = { 160, 82, 45 }
colors.Silver = { 192, 192, 192 }
colors.SkyBlue = { 135, 206, 235 }
colors.SlateBlue = { 106, 90, 205 }
colors.SlateGray = { 112, 128, 144 }
colors.SlateGrey = { 112, 128, 144 }
colors.Snow = { 255, 250, 250 }
colors.SpringGreen = { 0, 255, 127 }
colors.SteelBlue = { 70, 130, 180 }
colors.Tan = { 210, 180, 140 }
colors.Teal = { 0, 128, 128 }
colors.Thistle = { 216, 191, 216 }
colors.Tomato = { 255, 99, 71 }
colors.Turquoise = { 64, 224, 208 }
colors.Violet = { 238, 130, 238 }
colors.Wheat = { 245, 222, 179 }
colors.White = { 255, 255, 255 }
colors.WhiteSmoke = { 245, 245, 245 }
colors.Yellow = { 255, 255, 0 }
colors.YellowGreen = { 154, 205, 50 }

Color.static.get = function( name )
	assert(colors[name] ~= nil, "Color does not exist in this list, use the HTML color table!")
	return Color(unpack(colors[name]))
end

Color.static.getRGB = function( name )
	assert(colors[name] ~= nil, "Color does not exist in this list, use the HTML color table!")
	return unpack(colors[name])
end

return Color