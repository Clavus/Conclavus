
local Registry = {}
Registry.__index = function(self, key)
	return Registry[key] or (function()
		local t = {}
		rawset(self, key, t)
		return t
	end)()
end

function Registry:register(s, f)
	self[s][f] = f
	return f
end

function Registry:emit(s, ...)
	for f in pairs(self[s]) do
		f(...)
	end
end

function Registry:remove(s, ...)
	local f = {...}
	for i = 1,select('#', ...) do
		self[s][f[i]] = nil
	end
end

function Registry:clear(...)
	local s = {...}
	for i = 1,select('#', ...) do
		self[s[i]] = {}
	end
end

function Registry:emit_pattern(p, ...)
	for s in pairs(self) do
		if s:match(p) then self:emit(s, ...) end
	end
end

function Registry:remove_pattern(p, ...)
	for s in pairs(self) do
		if s:match(p) then self:remove(s, ...) end
	end
end

function Registry:clear_pattern(p)
	for s in pairs(self) do
		if s:match(p) then self[s] = {} end
	end
end

local function new()
	return setmetatable({}, Registry)
end
local default = new()

return setmetatable({
	new            = new,
	register       = function(...) return default:register(...) end,
	emit           = function(...) default:emit(...) end,
	remove         = function(...) default:remove(...) end,
	clear          = function(...) default:clear(...) end,
	emit_pattern   = function(...) default:emit_pattern(...) end,
	remove_pattern = function(...) default:remove_pattern(...) end,
	clear_pattern  = function(...) default:clear_pattern(...) end,
}, {__call = new})