
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

-- the module
local function new()
	local registry = setmetatable({}, Registry)

	return setmetatable({
		new            = new,
		register       = function(...) return registry:register(...) end,
		emit           = function(...) registry:emit(...) end,
		remove         = function(...) registry:remove(...) end,
		clear          = function(...) registry:clear(...) end,
		emit_pattern   = function(...) registry:emit_pattern(...) end,
		remove_pattern = function(...) registry:remove_pattern(...) end,
		clear_pattern  = function(...) registry:clear_pattern(...) end,
	}, {__call = new})
end

return new()