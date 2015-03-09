------------------------
-- CustomLevelData class.
-- Custom level data, pass layers, objects and tilesets as parameters.
-- 
-- Derived from @{LevelData}.
-- @cl CustomLevelData

local CustomLevelData = class('CustomLevelData', LevelData)

function CustomLevelData:initialize(layers, objects, tilesets)
	LevelData.initialize(self)
	self.layers = layers or {}
	self.objects = objects or {}
	self.tilesets = tilesets or {}
	print(table.toString(layers, "layers", true))
end

return CustomLevelData