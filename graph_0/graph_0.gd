@tool
extends Node2D

@export var X_MIN: float = -5
@export var X_MAX: float = 5
@export var Y_MIN: float = 0
@export var Y_MAX: float = 1
@export var OFFSET: bool = false
@export var GRAPH_RESOLUTION: int = 40
@export var GRID_WIDTH_1: int = 1
@export var GRID_COLOR_1 := Color(1,1,1) * 0.3
@export var GRID_WIDTH_2: int = 1
@export var GRID_COLOR_2 := Color(1,1,1) * 0.6
@export var GRAPH_SIZE: Rect2 = Rect2(0, 0, 240, 480)

@export var gradient: Gradient

var f := func(x): return sin(x)

func _on_tree_entered():
	draw_grid()
	draw_graph()

func get_raw_points():
	var res = []
	$Line.gradient = gradient
	for i in GRAPH_RESOLUTION + 1.0:
		var norm_x = i / GRAPH_RESOLUTION
		var x = lerp(X_MIN, X_MAX, norm_x)
		var y = f.call(x)
		var norm_y = inverse_lerp(Y_MAX, Y_MIN, y)
		var pixel_x = lerp(-700, 700, norm_x)
		var pixel_y = lerp(-300, 300, norm_y)
		res.push_back(Vector2(pixel_x, pixel_y))
	return res

func draw_graph():

	var raw_points = get_raw_points()	

	var i = 0
	while i < raw_points.size() - 2:
		if !is_in_rect(raw_points[i]) && !is_in_rect(raw_points[i + 1]) && !is_in_rect(raw_points[i + 2]):
			raw_points.remove_at(i + 1)
		else:
			i += 1
	
	if !is_in_rect(raw_points[0]) && !is_in_rect(raw_points[1]):
		raw_points.remove_at(0)
	if !is_in_rect(raw_points[-1]) && !is_in_rect(raw_points[-2]):
		raw_points.remove_at(-1)

	var slice_points = [0]
	for j in raw_points.size() - 1:
		if !GRAPH_SIZE.has_point(raw_points[j]) && !GRAPH_SIZE.has_point(raw_points[j + 1]):
			slice_points.push_back(j + 1)
	slice_points.push_back(raw_points.size())

	var point_datas = []
	for k in slice_points.size() - 1:
		point_datas.push_back(raw_points.slice(slice_points[k], slice_points[k + 1]))

	
	for ps in point_datas:
		var _l = $Line.duplicate() 
		var _gradient = gradient.duplicate()
		_gradient.set_color(0, gradient.sample((ps[0].x + 700.0) / 1400.0))
		_gradient.set_color(1, gradient.sample((ps[-1].x + 700.0) / 1400.0))
		_l.gradient = _gradient
		_l.points = ps
		add_child(_l)

	$Line.visible = false


func draw_grid():
	for x in  15:
		var pixel_x = lerp(GRAPH_SIZE.position.x, GRAPH_SIZE.end.x, x / 14.0)
		var points = [Vector2(pixel_x, -300), Vector2(pixel_x, 300)]
		_generate_grid_line(float(x % 2), points)

	for y in 7:
		var pixel_y = lerp(GRAPH_SIZE.position.y, GRAPH_SIZE.end.y, y / 6.0)
		var points = [Vector2(-700, pixel_y), Vector2(700, pixel_y)]
		_generate_grid_line(float(y % 2), points)

func _generate_grid_line(weight: float, points: Array) -> void:
	var _l = Line2D.new()
	_l.width = lerp(GRID_WIDTH_1, GRID_WIDTH_2, weight)
	_l.default_color = lerp(GRID_COLOR_1, GRID_COLOR_2, weight)
	_l.points = points
	add_child(_l)
	move_child(_l, 0)
	

func is_in_rect(pos: Vector2) -> bool:
	return GRAPH_SIZE.has_point(pos)
