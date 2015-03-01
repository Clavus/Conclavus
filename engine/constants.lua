------------------------
-- Constant definitions.
-- @other constants

--- Some pre-defined folder locations.
FOLDER = {
	ASSETS = "game/assets/", -- default asset folder location
	PARTICLESYSTEMS = "game/assets/particlesystems/", -- default particle system asset folder location
}

--- Mouse input constants.
-- @see InputController
MOUSE = {
	LEFT = "l", -- mouse left button
	RIGHT = "r", -- mouse right button
	MIDDLE = "m", -- mouse middle button
	WHEELDOWN = "wd", -- mouse wheel down
	WHEELUP = "wu", -- mouse wheel up
	BUTTON4 = "x1", -- mouse 4
	BUTTON5 = "x2", -- mouse 5
}

--- Pre-defined draw layer ordering.
DRAW_LAYER = {
	TOP = -1, -- top layer
	BOTTOM = 99999, -- bottom layer
}

--- Draw layer types.
LAYER_TYPE = {
	NONE = 0,
	IMAGES = 1,
	BATCH = 2,
	BACKGROUND = 3,
	CUSTOM = 4,
}

--- Screen scaling types.
SCREEN_SCALE = {
	CENTER = 0,
	STRETCH = 1,
	FIT_LETTERBOX = 2,
	FIT_CLIPEDGES = 3,
	FIT_HEIGHT = 4,
	FIT_WIDTH = 5,
}