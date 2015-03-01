------------------------
-- Extensions to the package module.
-- @extend package

local loaded_packages = {}

local autohotswap_enabled = true
local autohotswap_pollrate = 0.5
local next_poll = 0
local curtime = currentTime
local lastmodified = love.filesystem.getLastModified

function package.loadSwappable( packagetable )
	for k, packages in pairs(packagetable) do
		for name, path in pairs( packages ) do
			_G[name] = require(path)
			local fullpath = path..".lua"
			loaded_packages[name] = { path = path, fullpath = fullpath, last_modified = lastmodified( fullpath ) }
		end
	end
end

function package.hotswap( modref )
	assert(type(modref) == "string", "Package name needs to be a string!")
	assert(loaded_packages[modref] ~= nil, "Package "..tostring(modref).." is not loaded!")
	local modname = loaded_packages[modref].path
	local fullpath = loaded_packages[modref].fullpath
	local oldglobal = table.copy(_G)
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
	loaded_packages[modref].last_modified = lastmodified( fullpath )
	return oldmod
end

function package.autoHotswapEnabled( b )
	autohotswap_enabled = b
end

function package.autoHotswapUpdateRate( n )
	autohotswap_pollrate = tonumber( n )
end

function package.updatePackages()
	if autohotswap_enabled and (curtime() >= next_poll) then
		for k, v in pairs( loaded_packages ) do
			if (lastmodified(v.fullpath) ~= v.last_modified) then
				local ok, err = package.hotswap( k )
				if (ok) then
					print("Hotswapped "..k.." ("..v.fullpath..")")
				else
					print("Failed to swap "..k.." ("..v.fullpath.."): "..tostring(err))
					v.last_modified = lastmodified(v.fullpath)
				end	
			end
		end		
		next_poll = curtime() + autohotswap_pollrate
	end
end

