@tool
extends Control

const GRID_SIZE := 20.0
const PIXEL_RECT := Rect2(0, 0, 440, 280)

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

@onready var expression = Expression.new()

var grid_lines = []

func _ready():
	draw_all_item()

func draw_all_item():
	var error = expression.parse(f, ["x"])
	assert(error == OK, "expression error %s" % error)
	draw_grid()
	draw_graph()

func draw_grid() -> void:
	var p_origin = PIXEL_RECT.size * POSITION_NORMAL
	var pos_xs = range(int(p_origin.x) % int(GRID_SIZE), PIXEL_RECT.size.x, GRID_SIZE)
	var pos_ys = range(int(p_origin.y) % int(GRID_SIZE), PIXEL_RECT.size.y, GRID_SIZE)
	pos_xs.map(func(x): _draw_grid(GRID_WIDTH, GRID_COLOR, [Vector2(x, 0), Vector2(x, PIXEL_RECT.size.y)]))
	pos_ys.map(func(y): _draw_grid(GRID_WIDTH, GRID_COLOR, [Vector2(0, y), Vector2(PIXEL_RECT.size.x, y)]))
	_draw_grid(AXIS_WIDTH, AXIS_COLOR, [Vector2(p_origin.x, 0), Vector2(p_origin.x, PIXEL_RECT.size.y)])
	_draw_grid(AXIS_WIDTH, AXIS_COLOR, [Vector2(0, p_origin.y), Vector2(PIXEL_RECT.size.x, p_origin.y)])

func draw_graph():
	var nxs = range(0, GRAPH_RESOLUTION + 1).map(func(x): return float(x) / GRAPH_RESOLUTION)
	var vxs = nxs.map(func(weight): return lerp(X_MIN, X_MAX, weight))
	var vys = vxs.map(func(x): return expression.execute([x]))
	var pxs = nxs.map(func(value): return lerp(0.0, PIXEL_RECT.size.x, value))
	var nys = vys.map(func(y): return inverse_lerp(Y_MIN, Y_MAX, y))
	var pys = nys.map(func(value): return lerp(PIXEL_RECT.size.y, 0.0, value))
	var points = range(GRAPH_RESOLUTION + 1).map(func(i): return Vector2(pxs[i], pys[i]))
	$Panel/Graph.points = points
	$Panel.move_child($Panel/Graph, -1)





	
func _draw_grid(width: float, color: Color, points: Array) -> void:
	var _l = Line2D.new()
	_l.width = width
	_l.default_color = color
	_l.points = points
	grid_lines.push_back(_l)
	$Panel.add_child(_l)


