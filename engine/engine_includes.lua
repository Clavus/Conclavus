
require("engine/constants")

require("engine/extend/package")
require("engine/extend/math")
require("engine/extend/table")
require("engine/extend/string")
require("engine/extend/debug")

-- Loading order of elements is important!
local toload = {
	-- Libraries from others
	{ lovebird =		"engine/lib/lovebird/lovebird" },
	{ class = 			"engine/lib/middleclass/middleclass" },
	{ timer = 			"engine/lib/hump/timer" },
	{ signal = 			"engine/lib/hump/signal" },
	{ gamestate = 	"engine/lib/hump/gamestate" },
	{ mlib = 			"engine/lib/mlib/mlib" },
	{ tlib =				"engine/lib/tlib/tlib" },
	
	-- Utility libraries
	{ angle = 		"engine/util/angle" },
	{ util = 			"engine/util/util" },
	{ easing = 	"engine/util/easing" },
	{ resource = "engine/util/resource" },
	
	-- Mixins
	{ CollisionResolver = 	"engine/classes/mixins/collisionresolver" },
	{ PhysicsActor = 			"engine/classes/mixins/physicsactor" },
	
	-- Classes
	{ Vector = 					"engine/classes/vector" },
	{ Color = 						"engine/classes/color" },
	{ Sprite = 					"engine/classes/sprite" },
	{ SpriteData = 				"engine/classes/spritedata" },
	{ StateAnimatedSprite = "engine/classes/stateanimatedsprite" },
	{ InputController = 		"engine/classes/input" },
	{ LevelData = 				"engine/classes/leveldata" },
	{ TiledLevelData = 		"engine/classes/tiledleveldata" },
	{ CustomLevelData = 	"engine/classes/customleveldata" },
	{ Level = 						"engine/classes/level" },
	{ EntityManager = 			"engine/classes/entitymanager" },
	{ GUI = 						"engine/classes/gui" },
	{ FiniteStateMachine = 	"engine/classes/finitestatemachine" },
	
	-- Entity classes
	{ Entity = 		"engine/classes/entity/entity" },
	{ Wall = 		"engine/classes/entity/wall" },
	{ Trigger = 	"engine/classes/entity/trigger" },
	{ Camera = 	"engine/classes/entity/camera" },
}
package.loadSwappable( toload )