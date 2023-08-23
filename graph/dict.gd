extends Node

var functions = {
	"sin": {
		"label": "sin(x)",
		"func": func(x): return sin(x),
		"scale_x": [-PI, -PI * 0.5, PI * 0.5, PI],
		"scale_y": [-1, 1]
	},
	"cos": {
		"label": "cos(x)",
		"func": func(x): return cos(x),
		"scale_x": [-PI, -PI * 0.5, PI * 0.5, PI],
		"scale_y": [-1, 1]
	},
	"tan": {
		"label": "tan(x)",
		"func": func(x): return tan(x),
		"scale_x": [-PI, -PI * 0.5, PI * 0.5, PI],
		"scale_y": [-1, 1]
	},
	"asin": {
		"label": "asin(x)",
		"func": func(x): return asin(x),
		"scale_x": [-1, 1],
		"scale_y": [-PI * 0.5, PI * 0.5]
	},
	"acos": {
		"label": "acos(x)",
		"func": func(x): return acos(x),
	},
	"atan": {
		"label": "atan(x)",
		"func": func(x): return atan(x),
	},
	"sinh": {
		"label": "sinh(x)",
		"func": func(x): return sinh(x),
	},
	"cosh": {
		"label": "cosh(x)",
		"func": func(x): return cosh(x),
	},
	"tanh": {
		"label": "tanh(x)",
		"func": func(x): return tanh(x),
	},
	"randf": {
		"label": "randf()",
		"func": func(_x): return randf(),
		"scale_y": [1.0],
	},
	"lerp": {
		"label": "lerp(-0.5, 0.5, x)",
		"func": func(x): return lerp(-0.5, 0.5, x),
		"scale_x": [1],
		"scale_y": [-0.5, 0.5],
	},
	"fmod": {
		"label": "fmod(x, 1.0)",
		"func": func(x): return fmod(x, 1.0),
		"scale_x": [-1, 1],
		"scale_y": [-1.0, 1.0],
	},
	"abs": {
		"label": "abs(x)",
		"func": func(x): return abs(x),
		"scale_x": [-3, 3],
		"scale_y": [3],
	},
	"inverse_lerp": {
		"label": "inverse_lerp(-0.5, 0.5, x)",
		"func": func(x): return inverse_lerp(-0.5, 0.5, x),
		"scale_x": [-0.5, 0.5],
		"scale_y": [1],
	},
	"smoothstep": {
		"label": "smoothstep(-0.5, 0.5, x)",
		"func": func(x): return smoothstep(-0.5, 0.5, x),
		"scale_x": [-0.5, 0.5],
		"scale_y": [1],
	},
	"clamp": {
		"label": "clamp(x, -0.5, 0.5)",
		"func": func(x): return clamp(x, -0.5, 0.5),
	},
	"min": {
		"label": "min(0.5, x)",
		"func": func(x): return min(0.5, x),
		"scale_x": [0.5],
		"scale_y": [0.5],
	},
	"max": {
		"label": "max(0.5, x)",
		"func": func(x): return max(0.5, x),
		"scale_x": [0.5],
		"scale_y": [0.5],
	},
	"ceil": {
		"label": "ceil(x)",
		"func": func(x): return ceil(x),
		"scale_x": [-1, 1],
		"scale_y": [-1, 1],
	},
	"floor": {
		"label": "floor(x)",
		"func": func(x): return floor(x),
		"scale_x": [-1, 1],
		"scale_y": [-1, 1],
	},
	"round": {
		"label": "round(x)",
		"func": func(x): return round(x),
		"scale_x": [-1, 1],
		"scale_y": [-1, 1],
	},
	"sign": {
		"label": "sign(x)",
		"func": func(x): return sign(x),
		"scale_x": [-1, 1],
		"scale_y": [-1, 1],
	},
	"pingpong": {
		"label": "pingpong(x, 1.0)",
		"func": func(x): return pingpong(x, 1.0),
		"scale_x": [-1, 1],
		"scale_y": [1],
	},
	"snapped": {
		"label": "snapped(x, 0.3)",
		"func": func(x): return snapped(x, 0.3),
		"scale_x": [-1, 1],
		"scale_y": [-1, 1],
	},
	"move_toward": {
		"label": "move_toward(5, 10, x)",
		"func": func(x): return move_toward(1, 5, x),
	},
	"linear_to_db": {
		"label": "linear_to_db(x)",
		"func": func(x): return linear_to_db(x),
		"scale_x": [1],
	},
	"cubic_interpolate": {
		"label": "cubic_interpolate(0, 1, 0, 0, x)",
		"func": func(x): return cubic_interpolate(0, 1, 0, 0, x),
	},
	"hash": {
		"label": "hash(x)",
		"func": func(x): return hash(x),
	},
	"fposmod": {
		"label": "fposmod(x, 1.0)",
		"func": func(x): return fposmod(x, 1.0),
		"scale_x": [-1, 1],
		"scale_y": [1],
	},
	"wrap": {
		"label": "wrap(x, 1, 3)",
		"func": func(x): return wrap(x, 1, 3),
		"scale_x": [-3, 3],
		"scale_y": [-3, 3],
	},
	"rad_to_deg": {
		"label": "rad_to_deg(x)",
		"func": func(x): return rad_to_deg(x),
		"scale_x": [-PI , PI ],
		"scale_y": [-180, -90, 90, 180],
	}

}