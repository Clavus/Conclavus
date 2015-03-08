
-- Example of a menu gamestate.

local menu = gamestate.new()

function menu:init()
	
end

function menu:update(dt)
	if (input:keyIsPressed("y") and self._frame) then
		self._frame:Center()
	end
end

function menu:enter()
		local parentframe = loveframes.Create("frame")
		-- method 1 using loveframes.Create
		local button1 = loveframes.Create("button", parentframe)
		button1:SetPos(5, 35)
		self._frame = parentframe
		self._frame.OnClose = function(object)
			game.closeMenu()
		end
end

function menu:leave()

end

return menu