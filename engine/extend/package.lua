
local loaded_packages = {}

function package.load( packagetable )
	
	for k, packages in pairs(packagetable) do
		for name, path in pairs( packages ) do
			
			print("Loaded "..name.." = "..path)
			_G[name] = require(path)
			loaded_packages[name] = path
			
		end
	end
	
end

function package.hotswap( modref )
	
	assert(type(modref) == "string", "Package name needs to be a string!")
	assert(loaded_packages[modref] ~= nil, "Package "..tostring(modref).." is not loaded!")
	
	local modname = loaded_packages[modref]	
	local oldglobal = table.clone(_G)
	local updated = {}
	local function update(old, new)
	
		if updated[old] then return end 
		updated[old] = true
		
		local oldmt, newmt = getmetatable(old), getmetatable(new)
		if oldmt and newmt then update(oldmt, newmt) end
		
		for k, v in pairs(new) do
			if type(v) == "table" then update(old[k], v) else old[k] = v end
		end
		
	end
	
	local err = nil
	local function onerror(e)
	
		for k, v in pairs(_G) do _G[k] = oldglobal[k] end
		err = string.trim(e)
		
	end
	
	local ok, oldmod = pcall(require, modname)
	oldmod = ok and oldmod or nil
	xpcall(function()
			package.loaded[modname] = nil
			local newmod = require(modname)
			if type(oldmod) == "table" then update(oldmod, newmod) end
			for k, v in pairs(oldglobal) do
				if v ~= _G[k] and type(v) == "table" then 
					update(v, _G[k])
					_G[k] = v
				end
			end
		end, onerror)
		
	package.loaded[modname] = oldmod
	if err then return nil, err end
	
	return oldmod
	
end