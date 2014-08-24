
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

Color.static.fromHex = function( hex )

	hex = hex:gsub("#","")
	assert(string.len(hex) == 6, "Invalid hexadecimal color value!")
    return Color(tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)))
	
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

Color.static.AliceBlue = Color( 240, 248, 255 )
Color.static.AntiqueWhite = Color( 250, 235, 215 )
Color.static.Aqua = Color( 0, 255, 255 )
Color.static.Aquamarine = Color( 127, 255, 212 )
Color.static.Azure = Color( 240, 255, 255 )
Color.static.Beige = Color( 245, 245, 220 )
Color.static.Bisque = Color( 255, 228, 196 )
Color.static.Black = Color( 0, 0, 0 )
Color.static.BlanchedAlmond = Color( 255, 235, 205 )
Color.static.Blue = Color( 0, 0, 255 )
Color.static.BlueViolet = Color( 138, 43, 226 )
Color.static.Brown = Color( 165, 42, 42 )
Color.static.Burlywood = Color( 222, 184, 135 )
Color.static.CadetBlue = Color( 95, 158, 160 )
Color.static.Chartreuse = Color( 127, 255, 0 )
Color.static.Chocolate = Color( 210, 105, 30 )
Color.static.Coral = Color( 255, 127, 80 )
Color.static.CornflowerBlue = Color( 100, 149, 237 )
Color.static.Cornsilk = Color( 255, 248, 220 )
Color.static.Crimson = Color( 220, 20, 60 )
Color.static.Cyan = Color( 0, 255, 255 )
Color.static.DarkBlue = Color( 0, 0, 139 )
Color.static.DarkCyan = Color( 0, 139, 139 )
Color.static.DarkGoldenrod = Color( 184, 134, 11 )
Color.static.DarkGray = Color( 169, 169, 169 )
Color.static.DarkGreen = Color( 0, 100, 0 )
Color.static.DarkGrey = Color( 169, 169, 169 )
Color.static.DarkKhaki = Color( 189, 183, 107 )
Color.static.DarkMagenta = Color( 139, 0, 139 )
Color.static.DarkOliveGreen = Color( 85, 107, 47 )
Color.static.Darkorange = Color( 255, 140, 0 )
Color.static.DarkOrchid = Color( 153, 50, 204 )
Color.static.DarkRed = Color( 139, 0, 0 )
Color.static.Darksalmon = Color( 233, 150, 122 )
Color.static.DarkSeaGreen = Color( 143, 188, 143 )
Color.static.DarkSlateBlue = Color( 72, 61, 139 )
Color.static.DarkSlateGray = Color( 47, 79, 79 )
Color.static.DarkSlateGrey = Color( 47, 79, 79 )
Color.static.DarkTurquoise = Color( 0, 206, 209 )
Color.static.DarkViolet = Color( 148, 0, 211 )
Color.static.DeepPink = Color( 255, 20, 147 )
Color.static.DeepSkyBlue = Color( 0, 191, 255 )
Color.static.DimGray = Color( 105, 105, 105 )
Color.static.DimGrey = Color( 105, 105, 105 )
Color.static.DodgerBlue = Color( 30, 144, 255 )
Color.static.Firebrick = Color( 178, 34, 34 )
Color.static.FloralWhite = Color( 255, 250, 240 )
Color.static.ForestGreen = Color( 34, 139, 34 )
Color.static.Fuchsia = Color( 255, 0, 255 )
Color.static.Gainsboro = Color( 220, 220, 220 )
Color.static.GhostWhite = Color( 248, 248, 255 )
Color.static.Gold = Color( 255, 215, 0 )
Color.static.Goldenrod = Color( 218, 165, 32 )
Color.static.Gray = Color( 128, 128, 128 )
Color.static.Green = Color( 0, 128, 0 )
Color.static.GreenYellow = Color( 173, 255, 47 )
Color.static.Grey = Color( 128, 128, 128 )
Color.static.Honeydew = Color( 240, 255, 240 )
Color.static.HotPink = Color( 255, 105, 180 )
Color.static.IndianRed = Color( 205, 92, 92 )
Color.static.Indigo = Color( 75, 0, 130 )
Color.static.Ivory = Color( 255, 255, 240 )
Color.static.Khaki = Color( 240, 230, 140 )
Color.static.Lavender = Color( 230, 230, 250 )
Color.static.LavenderBlush = Color( 255, 240, 245 )
Color.static.LawnGreen = Color( 124, 252, 0 )
Color.static.LemonChiffon = Color( 255, 250, 205 )
Color.static.LightBlue = Color( 173, 216, 230 )
Color.static.Lightcoral = Color( 240, 128, 128 )
Color.static.LightCyan = Color( 224, 255, 255 )
Color.static.LightGoldenrodYellow = Color( 250, 250, 210 )
Color.static.LightGray = Color( 211, 211, 211 )
Color.static.LightGreen = Color( 144, 238, 144 )
Color.static.LightGrey = Color( 211, 211, 211 )
Color.static.LightPink = Color( 255, 182, 193 )
Color.static.Lightsalmon = Color( 255, 160, 122 )
Color.static.LightSeaGreen = Color( 32, 178, 170 )
Color.static.LightSkyBlue = Color( 135, 206, 250 )
Color.static.LightSlateGray = Color( 119, 136, 153 )
Color.static.LightSlateGrey = Color( 119, 136, 153 )
Color.static.LightsteelBlue = Color( 176, 196, 222 )
Color.static.LightYellow = Color( 255, 255, 224 )
Color.static.Lime = Color( 0, 255, 0 )
Color.static.LimeGreen = Color( 50, 205, 50 )
Color.static.Linen = Color( 250, 240, 230 )
Color.static.Magenta = Color( 255, 0, 255 )
Color.static.Maroon = Color( 128, 0, 0 )
Color.static.MediumAquamarine = Color( 102, 205, 170 )
Color.static.MediumBlue = Color( 0, 0, 205 )
Color.static.MediumOrchid = Color( 186, 85, 211 )
Color.static.MediumPurple = Color( 147, 112, 219 )
Color.static.MediumSeaGreen = Color( 60, 179, 113 )
Color.static.MediumSlateBlue = Color( 123, 104, 238 )
Color.static.MediumSpringGreen = Color( 0, 250, 154 )
Color.static.MediumTurquoise = Color( 72, 209, 204 )
Color.static.MediumVioletRed = Color( 199, 21, 133 )
Color.static.MidnightBlue = Color( 25, 25, 112 )
Color.static.MintCream = Color( 245, 255, 250 )
Color.static.MistyRose = Color( 255, 228, 225 )
Color.static.Moccasin = Color( 255, 228, 181 )
Color.static.NavajoWhite = Color( 255, 222, 173 )
Color.static.Navy = Color( 0, 0, 128 )
Color.static.OldLace = Color( 253, 245, 230 )
Color.static.Olive = Color( 128, 128, 0 )
Color.static.OliveDrab = Color( 107, 142, 35 )
Color.static.Orange = Color( 255, 165, 0 )
Color.static.OrangeRed = Color( 255, 69, 0 )
Color.static.Orchid = Color( 218, 112, 214 )
Color.static.PaleGoldenrod = Color( 238, 232, 170 )
Color.static.PaleGreen = Color( 152, 251, 152 )
Color.static.PaleTurquoise = Color( 175, 238, 238 )
Color.static.PaleVioletRed = Color( 219, 112, 147 )
Color.static.Papayawhip = Color( 255, 239, 213 )
Color.static.Peachpuff = Color( 255, 218, 185 )
Color.static.Peru = Color( 205, 133, 63 )
Color.static.Pink = Color( 255, 192, 203 )
Color.static.Plum = Color( 221, 160, 221 )
Color.static.PowderBlue = Color( 176, 224, 230 )
Color.static.Purple = Color( 128, 0, 128 )
Color.static.Red = Color( 255, 0, 0 )
Color.static.RosyBrown = Color( 188, 143, 143 )
Color.static.RoyalBlue = Color( 65, 105, 225 )
Color.static.SaddleBrown = Color( 139, 69, 19 )
Color.static.Salmon = Color( 250, 128, 114 )
Color.static.SandyBrown = Color( 244, 164, 96 )
Color.static.SeaGreen = Color( 46, 139, 87 )
Color.static.Seashell = Color( 255, 245, 238 )
Color.static.Sienna = Color( 160, 82, 45 )
Color.static.Silver = Color( 192, 192, 192 )
Color.static.SkyBlue = Color( 135, 206, 235 )
Color.static.SlateBlue = Color( 106, 90, 205 )
Color.static.SlateGray = Color( 112, 128, 144 )
Color.static.SlateGrey = Color( 112, 128, 144 )
Color.static.Snow = Color( 255, 250, 250 )
Color.static.SpringGreen = Color( 0, 255, 127 )
Color.static.SteelBlue = Color( 70, 130, 180 )
Color.static.Tan = Color( 210, 180, 140 )
Color.static.Teal = Color( 0, 128, 128 )
Color.static.Thistle = Color( 216, 191, 216 )
Color.static.Tomato = Color( 255, 99, 71 )
Color.static.Turquoise = Color( 64, 224, 208 )
Color.static.Violet = Color( 238, 130, 238 )
Color.static.Wheat = Color( 245, 222, 179 )
Color.static.White = Color( 255, 255, 255 )
Color.static.WhiteSmoke = Color( 245, 245, 245 )
Color.static.Yellow = Color( 255, 255, 0 )
Color.static.YellowGreen = Color( 154, 205, 50 )

return Color