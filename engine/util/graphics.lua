
local graphics = {}
local lg = love.graphics

-- http://love2d.org/forums/viewtopic.php?f=4&t=77599
function graphics.roundRectangle(mode, x, y, w, h, rd, s)

	local r, g, b, a = lg.getColor()
	local rd = rd or math.min(w, h)/4
	local s = s or 32
	local l = lg.getLineWidth()

	local corner = 1
	local function mystencil()
		lg.setColor(255, 255, 255, 255)
		if corner == 1 then
			lg.rectangle("fill", x-l, y-l, rd+l, rd+l)
		elseif corner == 2 then
			lg.rectangle("fill", x+w-rd+l, y-l, rd+l, rd+l)
		elseif corner == 3 then
			lg.rectangle("fill", x-l, y+h-rd+l, rd+l, rd+l)
		elseif corner == 4 then
			lg.rectangle("fill", x+w-rd+l, y+h-rd+l, rd+l, rd+l)
		elseif corner == 0 then
			lg.rectangle("fill", x+rd, y-l, w-2*rd+l, h+2*l)
			lg.rectangle("fill", x-l, y+rd, w+2*l, h-2*rd+l)
		end
	end

	lg.setStencil(mystencil)
	lg.setColor(r, g, b, a)
	lg.circle(mode, x+rd, y+rd, rd, s)
	lg.setStencil()
	corner = 2
	lg.setStencil(mystencil)
	lg.setColor(r, g, b, a)
	lg.circle(mode, x+w-rd, y+rd, rd, s)
	lg.setStencil()
	corner = 3
	lg.setStencil(mystencil)
	lg.setColor(r, g, b, a)
	lg.circle(mode, x+rd, y+h-rd, rd, s)
	lg.setStencil()
	corner = 4
	lg.setStencil(mystencil)
	lg.setColor(r, g, b, a)
	lg.circle(mode, x+w-rd, y+h-rd, rd, s)
	lg.setStencil()
	corner = 0
	lg.setStencil(mystencil)
	lg.setColor(r, g, b, a)
	lg.rectangle(mode, x, y, w, h)
	lg.setStencil()
	
end

function graphics.ellipse( mode, x, y, rx, ry, angle, ox, oy )
	
	-- x & y are upper left corner
	-- for centering  ox = rx/2 & oy = ry/2
	ry = ry or rx
	ox = ox or 0
	oy = oy or 0
	angle = angle or 0
	lg.push()
	lg.translate( x, y )
	lg.rotate( angle )
	local segments = ( rx + ry ) / 10
	local vertices = {}
	for i = 0, 2 * math.pi * ( 1 - 1 / segments ), 2 * math.pi / segments do
		vertices[#vertices+1] = rx * (1 + math.cos(i) ) / 2 - ox
		vertices[#vertices+1] = ry * (1 + math.sin(i) ) / 2 - oy
	end
	lg.polygon( mode, vertices )
	lg.pop()
	
end

function graphics.arrow( x1, y1, x2, y2, arrow_head_length, arrow_head_width )
	
	local v1 = Vector(x1, y1)
	local v2 = Vector(x2, y2)
	
	local lv = v2 - v1
	lv:trim( lv:length() - arrow_head_length )
	
	local bv = Vector(v1.x+lv.x, v1.y+lv.y)
	local pv = lv:normalize():perpendicular()
	local t1x, t1y = (bv + (pv * (arrow_head_width / 2))):unpack()
	local t2x, t2y = (bv - (pv * (arrow_head_width / 2))):unpack()
	
	lg.line(v1.x, v1.y, bv.x, bv.y)
	lg.polygon("fill", t1x, t1y, t2x, t2y, x2, y2)

end

return graphics