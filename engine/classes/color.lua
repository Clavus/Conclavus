
local Color = class('Color')

function Color:initialize( r, g, b, a )

	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255
	
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

function Color:unpackRGB()
	
	return self.r, self.g, self.b
	
end

function Color:unpackRGBA()
	
	return self.r, self.g, self.b, self.a
	
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

-- HTML colors: http://www.w3schools.com/html/html_colornames.asp --

Color.static.Aliceblue = Color( 240, 248, 255 )
Color.static.Antiquewhite = Color( 250, 235, 215 )
Color.static.Aqua = Color( 0, 255, 255 )
Color.static.Aquamarine = Color( 127, 255, 212 )
Color.static.Azure = Color( 240, 255, 255 )
Color.static.Beige = Color( 245, 245, 220 )
Color.static.Bisque = Color( 255, 228, 196 )
Color.static.Black = Color( 0, 0, 0 )
Color.static.Blanchedalmond = Color( 255, 235, 205 )
Color.static.Blue = Color( 0, 0, 255 )
Color.static.Blueviolet = Color( 138, 43, 226 )
Color.static.Brown = Color( 165, 42, 42 )
Color.static.Burlywood = Color( 222, 184, 135 )
Color.static.Cadetblue = Color( 95, 158, 160 )
Color.static.Chartreuse = Color( 127, 255, 0 )
Color.static.Chocolate = Color( 210, 105, 30 )
Color.static.Coral = Color( 255, 127, 80 )
Color.static.Cornflowerblue = Color( 100, 149, 237 )
Color.static.Cornsilk = Color( 255, 248, 220 )
Color.static.Crimson = Color( 220, 20, 60 )
Color.static.Cyan = Color( 0, 255, 255 )
Color.static.Darkblue = Color( 0, 0, 139 )
Color.static.Darkcyan = Color( 0, 139, 139 )
Color.static.Darkgoldenrod = Color( 184, 134, 11 )
Color.static.Darkgray = Color( 169, 169, 169 )
Color.static.Darkgreen = Color( 0, 100, 0 )
Color.static.Darkgrey = Color( 169, 169, 169 )
Color.static.Darkkhaki = Color( 189, 183, 107 )
Color.static.Darkmagenta = Color( 139, 0, 139 )
Color.static.Darkolivegreen = Color( 85, 107, 47 )
Color.static.Darkorange = Color( 255, 140, 0 )
Color.static.Darkorchid = Color( 153, 50, 204 )
Color.static.Darkred = Color( 139, 0, 0 )
Color.static.Darksalmon = Color( 233, 150, 122 )
Color.static.Darkseagreen = Color( 143, 188, 143 )
Color.static.Darkslateblue = Color( 72, 61, 139 )
Color.static.Darkslategray = Color( 47, 79, 79 )
Color.static.Darkslategrey = Color( 47, 79, 79 )
Color.static.Darkturquoise = Color( 0, 206, 209 )
Color.static.Darkviolet = Color( 148, 0, 211 )
Color.static.Deeppink = Color( 255, 20, 147 )
Color.static.Deepskyblue = Color( 0, 191, 255 )
Color.static.Dimgray = Color( 105, 105, 105 )
Color.static.Dimgrey = Color( 105, 105, 105 )
Color.static.Dodgerblue = Color( 30, 144, 255 )
Color.static.Firebrick = Color( 178, 34, 34 )
Color.static.Floralwhite = Color( 255, 250, 240 )
Color.static.Forestgreen = Color( 34, 139, 34 )
Color.static.Fuchsia = Color( 255, 0, 255 )
Color.static.Gainsboro = Color( 220, 220, 220 )
Color.static.Ghostwhite = Color( 248, 248, 255 )
Color.static.Gold = Color( 255, 215, 0 )
Color.static.Goldenrod = Color( 218, 165, 32 )
Color.static.Gray = Color( 128, 128, 128 )
Color.static.Green = Color( 0, 128, 0 )
Color.static.Greenyellow = Color( 173, 255, 47 )
Color.static.Grey = Color( 128, 128, 128 )
Color.static.Honeydew = Color( 240, 255, 240 )
Color.static.Hotpink = Color( 255, 105, 180 )
Color.static.Indianred = Color( 205, 92, 92 )
Color.static.Indigo = Color( 75, 0, 130 )
Color.static.Ivory = Color( 255, 255, 240 )
Color.static.Khaki = Color( 240, 230, 140 )
Color.static.Lavender = Color( 230, 230, 250 )
Color.static.Lavenderblush = Color( 255, 240, 245 )
Color.static.Lawngreen = Color( 124, 252, 0 )
Color.static.Lemonchiffon = Color( 255, 250, 205 )
Color.static.Lightblue = Color( 173, 216, 230 )
Color.static.Lightcoral = Color( 240, 128, 128 )
Color.static.Lightcyan = Color( 224, 255, 255 )
Color.static.Lightgoldenrodyellow = Color( 250, 250, 210 )
Color.static.Lightgray = Color( 211, 211, 211 )
Color.static.Lightgreen = Color( 144, 238, 144 )
Color.static.Lightgrey = Color( 211, 211, 211 )
Color.static.Lightpink = Color( 255, 182, 193 )
Color.static.Lightsalmon = Color( 255, 160, 122 )
Color.static.Lightseagreen = Color( 32, 178, 170 )
Color.static.Lightskyblue = Color( 135, 206, 250 )
Color.static.Lightslategray = Color( 119, 136, 153 )
Color.static.Lightslategrey = Color( 119, 136, 153 )
Color.static.Lightsteelblue = Color( 176, 196, 222 )
Color.static.Lightyellow = Color( 255, 255, 224 )
Color.static.Lime = Color( 0, 255, 0 )
Color.static.Limegreen = Color( 50, 205, 50 )
Color.static.Linen = Color( 250, 240, 230 )
Color.static.Magenta = Color( 255, 0, 255 )
Color.static.Maroon = Color( 128, 0, 0 )
Color.static.Mediumaquamarine = Color( 102, 205, 170 )
Color.static.Mediumblue = Color( 0, 0, 205 )
Color.static.Mediumorchid = Color( 186, 85, 211 )
Color.static.Mediumpurple = Color( 147, 112, 219 )
Color.static.Mediumseagreen = Color( 60, 179, 113 )
Color.static.Mediumslateblue = Color( 123, 104, 238 )
Color.static.Mediumspringgreen = Color( 0, 250, 154 )
Color.static.Mediumturquoise = Color( 72, 209, 204 )
Color.static.Mediumvioletred = Color( 199, 21, 133 )
Color.static.Midnightblue = Color( 25, 25, 112 )
Color.static.Mintcream = Color( 245, 255, 250 )
Color.static.Mistyrose = Color( 255, 228, 225 )
Color.static.Moccasin = Color( 255, 228, 181 )
Color.static.Navajowhite = Color( 255, 222, 173 )
Color.static.Navy = Color( 0, 0, 128 )
Color.static.Oldlace = Color( 253, 245, 230 )
Color.static.Olive = Color( 128, 128, 0 )
Color.static.Olivedrab = Color( 107, 142, 35 )
Color.static.Orange = Color( 255, 165, 0 )
Color.static.Orangered = Color( 255, 69, 0 )
Color.static.Orchid = Color( 218, 112, 214 )
Color.static.Palegoldenrod = Color( 238, 232, 170 )
Color.static.Palegreen = Color( 152, 251, 152 )
Color.static.Paleturquoise = Color( 175, 238, 238 )
Color.static.Palevioletred = Color( 219, 112, 147 )
Color.static.Papayawhip = Color( 255, 239, 213 )
Color.static.Peachpuff = Color( 255, 218, 185 )
Color.static.Peru = Color( 205, 133, 63 )
Color.static.Pink = Color( 255, 192, 203 )
Color.static.Plum = Color( 221, 160, 221 )
Color.static.Powderblue = Color( 176, 224, 230 )
Color.static.Purple = Color( 128, 0, 128 )
Color.static.Red = Color( 255, 0, 0 )
Color.static.Rosybrown = Color( 188, 143, 143 )
Color.static.Royalblue = Color( 65, 105, 225 )
Color.static.Saddlebrown = Color( 139, 69, 19 )
Color.static.Salmon = Color( 250, 128, 114 )
Color.static.Sandybrown = Color( 244, 164, 96 )
Color.static.Seagreen = Color( 46, 139, 87 )
Color.static.Seashell = Color( 255, 245, 238 )
Color.static.Sienna = Color( 160, 82, 45 )
Color.static.Silver = Color( 192, 192, 192 )
Color.static.Skyblue = Color( 135, 206, 235 )
Color.static.Slateblue = Color( 106, 90, 205 )
Color.static.Slategray = Color( 112, 128, 144 )
Color.static.Slategrey = Color( 112, 128, 144 )
Color.static.Snow = Color( 255, 250, 250 )
Color.static.Springgreen = Color( 0, 255, 127 )
Color.static.Steelblue = Color( 70, 130, 180 )
Color.static.Tan = Color( 210, 180, 140 )
Color.static.Teal = Color( 0, 128, 128 )
Color.static.Thistle = Color( 216, 191, 216 )
Color.static.Tomato = Color( 255, 99, 71 )
Color.static.Turquoise = Color( 64, 224, 208 )
Color.static.Violet = Color( 238, 130, 238 )
Color.static.Wheat = Color( 245, 222, 179 )
Color.static.White = Color( 255, 255, 255 )
Color.static.Whitesmoke = Color( 245, 245, 245 )
Color.static.Yellow = Color( 255, 255, 0 )
Color.static.Yellowgreen = Color( 154, 205, 50 )

return Color