
require("engine/constants")

require("engine/extend/package")
require("engine/extend/math")
require("engine/extend/table")
require("engine/extend/string")
require("engine/extend/global")
require("engine/extend/debug")

-- Loading order of elements is important!
local toload = {
	-- Base libraries
	{ class = 					"engine/lib/middleclass/middleclass" },
	{ timer = 					"engine/lib/hump/timer" },
	{ signal = 					"engine/lib/hump/signal" },
	{ mlib = 						"engine/lib/mlib/mlib" },
	{ noise =						"engine/lib/lovenoise/lovenoise" },
	
	-- Utility libraries
	{ screen =					"engine/util/screen" },
	{ vector2d = 				"engine/util/vector2d" },
	{ angle = 					"engine/util/angle" },
	{ util = 						"engine/util/util" },
	{ easing = 					"engine/util/easing" },
	{ resource = 				"engine/util/resource" },
	{ graphics = 				"engine/util/graphics" },
	{ steering = 				"engine/util/steering" },
	{ gamestate = 			"engine/util/gamestate" },
	
	-- Other libraries
	{ lovebird =				"engine/lib/lovebird/lovebird" },
	{ loveframes =			"engine/lib/loveframes/loveframes" },
	{ tlib =						"engine/lib/tlib/tlib" },
	
	-- Mixins
	{ CollisionResolver = 	"engine/classes/mixins/collisionresolver" },
	{ PhysicsBody = 				"engine/classes/mixins/physicsbody" },
	{ Positional =					"engine/classes/mixins/positional" },
	{ Rotatable =						"engine/classes/mixins/rotatable" },
	{ Scalable =						"engine/classes/mixins/scalable" },
	
	-- Classes
	{ Vector = 							"engine/classes/vector" },
	{ Color = 							"engine/classes/color" },
	{ Sprite = 							"engine/classes/sprite/sprite" },
	{ SpriteData = 					"engine/classes/sprite/spritedata" },
	{ StateAnimatedSprite = "engine/classes/sprite/stateanimatedsprite" },
	{ InputController = 		"engine/classes/inputcontroller" },
	{ LevelData = 					"engine/classes/level/leveldata" },
	{ TiledLevelData = 			"engine/classes/level/tiledleveldata" },
	{ CustomLevelData = 		"engine/classes/level/customleveldata" },
	{ Level = 							"engine/classes/level/level" },
	{ EntityManager = 			"engine/classes/entitymanager" },
	{ GUI = 								"engine/classes/gui" },
	{ FiniteStateMachine = 	"engine/classes/finitestatemachine" },
	{ PhysicsSystem =				"engine/classes/physics/physicssystem" },
	
	-- Entity classes
	{ Entity = 							"engine/classes/entity/entity" },
	{ Wall = 								"engine/classes/entity/wall" },
	{ Trigger = 						"engine/classes/entity/trigger" },
	{ Camera = 							"engine/classes/entity/camera" },
}
package.loadSwappable( toload )

Object = class.Object -- make middleclass Object global