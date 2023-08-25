extends Control

const GRID_SIZE := 28.0
const PIXEL_RECT := Rect2(0, 0, 392, 280)

@export var f := "cos(x)"
@export var POSITION_NORMAL := Vector2(0.5, 0.5) 
@export var X_MIN := -5.5 * PI  * 0.5
@export var X_MAX := 5.5 * PI * 0.5
@export var Y_MIN := -1.0
@export var Y_MAX := 1.0
@export var GRAPH_RESOLUTION := 100
@export var GRID_WIDTH := 1.0
@export var GRID_COLOR := Color.GRAY * 0.5
@export var AXIS_WIDTH := 2.0
@export var AXIS_COLOR := Color.GRAY * 0.9
@export var SCALE_X := [-1.0, 1.0]
@export var SCALE_Y := [-1.0, 1.0]

@onready var expression = Expression.new()

func _ready():
	var error = expression.parse(f, ["x"])
	assert(error == OK, "expression error %s" % error)
	draw_grid()
	draw_graph()
	draw_scale()

func draw_grid() -> void:
	var p_origin = PIXEL_RECT.size * POSITION_NORMAL
	var pos_xs = range(fmod(p_origin.x, GRID_SIZE) * 0.5, PIXEL_RECT.size.x, GRID_SIZE)
	var pos_ys = range(fmod(p_origin.y, GRID_SIZE) * 0.5, PIXEL_RECT.size.y, GRID_SIZE)
	pos_xs.map(func(x): _draw_grid(GRID_WIDTH, GRID_COLOR, [Vector2(x, 0), Vector2(x, PIXEL_RECT.size.y)]))
	pos_ys.map(func(y): _draw_grid(GRID_WIDTH, GRID_COLOR, [Vector2(0, y), Vector2(PIXEL_RECT.size.x, y)]))
	_draw_grid(AXIS_WIDTH, AXIS_COLOR, [Vector2(p_origin.x, 0), Vector2(p_origin.x, PIXEL_RECT.size.y)])
	_draw_grid(AXIS_WIDTH, AXIS_COLOR, [Vector2(0, p_origin.y), Vector2(PIXEL_RECT.size.x, p_origin.y)])

func draw_graph():
	var nxs = range(0, GRAPH_RESOLUTION + 1).map(func(x): return float(x) / GRAPH_RESOLUTION)
	var vxs = nxs.map(func(weight): return lerp(X_MIN, X_MAX, weight))
	var vys = vxs.map(func(x): 
		var y = expression.execute([x])
		assert(!expression.has_execute_failed(), "関数がダメ %s" % f)
		return y)
	var pxs = nxs.map(func(value): return lerp(0.0, PIXEL_RECT.size.x, value))
	var nys = vys.map(func(y): return inverse_lerp(Y_MIN, Y_MAX, y))
	var pys = nys.map(func(value): return lerp(PIXEL_RECT.size.y, 0.0, value))
	var points = range(nxs.size()).map(func(i): return Vector2(pxs[i], pys[i]))
		
	var segments = []
	var prev = 0
	for i in points.size():
		if prev == 0 && PIXEL_RECT.has_point(points[i]):
			segments.push_back(["in", i])
			prev = 1
		elif prev == 1 && !PIXEL_RECT.has_point(points[i]):
			segments.push_back(["out", i])
			prev = 0

	var _g: Line2D = null
	var _in = 0
	for segment in segments:
		if segment[0] == "in":
			_g = $Panel/Graph.duplicate()
			_in = max(0, segment[1] - 1)
		elif segment[0] == "out":
			_g.points = points.slice(_in, min(points.size() - 1, segment[1] + 1))
			$Panel.add_child(_g)
			$Panel.move_child(_g, -1)
	$Panel/Graph.visible = false

func draw_scale():
	var origin = PIXEL_RECT.size * POSITION_NORMAL
	for x in SCALE_X:
		var _s = $Panel/ScaleX.duplicate()
		_s.position = Vector2(PIXEL_RECT.size.x * inverse_lerp(X_MIN, X_MAX, x), origin.y)
		_s.get_node("Label").text = _format_label(x)
		$Panel.add_child(_s)
	for y in SCALE_Y:
		var _s = $Panel/ScaleY.duplicate()
		_s.position = Vector2(origin.x, PIXEL_RECT.size.y * inverse_lerp(Y_MAX, Y_MIN, y))
		_s.get_node("Label").text = _format_label(y)
		$Panel.add_child(_s)
		
	$Panel/Zero.position = PIXEL_RECT.size * POSITION_NORMAL
	$Panel/ScaleX.visible = false
	$Panel/ScaleY.visible = false
	$Label.text = f 

func _format_label(_f: float) -> String:
	var _str = "%.2f" % _f
	var dict = {
		"-6.28": "-2π", "-4.71": "-3π/2", "-3.14": "-π", "-1.57": "-π/2",
		"3.14": "π", "6.28": "2π", "4.71": "3π/2", "1.57": "π/2",
	}
	return dict[_str] if dict.has(_str) else _str

func _draw_grid(width: float, color: Color, points: Array) -> void:
	var _l = Line2D.new()
	_l.width = width
	_l.default_color = color
	_l.points = points
	$Panel.add_child(_l)
