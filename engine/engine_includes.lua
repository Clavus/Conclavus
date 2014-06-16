
require("engine/constants")

require("engine/extend/package")
require("engine/extend/math")
require("engine/extend/table")
require("engine/extend/string")
require("engine/extend/global")
require("engine/extend/debug")

-- Loading order of elements is important!
local toload = {
	-- Libraries from others
	{ lovebird =	"engine/lib/lovebird/lovebird" },
	{ class = 		"engine/lib/middleclass/middleclass" },
	{ timer = 		"engine/lib/hump/timer" },
	{ signal = 		"engine/lib/hump/signal" },
	{ gamestate = 	"engine/lib/hump/gamestate" },
	{ mlib = 		"engine/lib/mlib/mlib" },
	{ tlib =		"engine/lib/tlib/tlib" },
	{ loveframes =	"engine/lib/loveframes/loveframes" },
	
	-- Utility libraries
	{ screen =	"engine/util/screen" },
	{ angle = 	"engine/util/angle" },
	{ util = 	"engine/util/util" },
	{ easing = 	"engine/util/easing" },
	{ resource = "engine/util/resource" },
	{ graphics = "engine/util/graphics" },
	
	-- Mixins
	{ CollisionResolver = 	"engine/classes/mixins/collisionresolver" },
	{ PhysicsActor = 		"engine/classes/mixins/physicsactor" },
	{ Positional =			"engine/classes/mixins/positional" },
	{ Rotatable =			"engine/classes/mixins/rotatable" },
	{ Scalable =			"engine/classes/mixins/scalable" },
	
	-- Classes
	{ Vector = 				"engine/classes/vector" },
	{ Color = 				"engine/classes/color" },
	{ Sprite = 				"engine/classes/sprite/sprite" },
	{ SpriteData = 			"engine/classes/sprite/spritedata" },
	{ StateAnimatedSprite = "engine/classes/sprite/stateanimatedsprite" },
	{ InputController = 	"engine/classes/input" },
	{ LevelData = 			"engine/classes/level/leveldata" },
	{ TiledLevelData = 		"engine/classes/level/tiledleveldata" },
	{ CustomLevelData = 	"engine/classes/level/customleveldata" },
	{ Level = 				"engine/classes/level/level" },
	{ EntityManager = 		"engine/classes/entitymanager" },
	{ GUI = 				"engine/classes/gui" },
	{ FiniteStateMachine = 	"engine/classes/finitestatemachine" },
	{ PhysicsSystem =		"engine/classes/physics/physicssystem" },
	{ Box2DPhysicsSystem =	"engine/classes/physics/box2dphysicssystem" },
	
	-- Entity classes
	{ Entity = 		"engine/classes/entity/entity" },
	{ Wall = 		"engine/classes/entity/wall" },
	{ Trigger = 	"engine/classes/entity/trigger" },
	{ Camera = 		"engine/classes/entity/camera" },
}
package.loadSwappable( toload )