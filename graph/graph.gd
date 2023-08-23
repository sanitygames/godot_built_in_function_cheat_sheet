extends Node2D

const GRID_SIZE := 30.0
const PIXEL_RECT := Rect2(10, 10, 420, 300)

var GRAPH_RESOLUTION := 1000.0
var NAME := "tan"
var VALUE_MIN_X := 0.0
var VALUE_MAX_X := 0.0
var VALUE_MIN_Y := 0.0
var VALUE_MAX_Y := 0.0
var GRID_WIDTH := 1.0
var GRID_COLOR := Color.GRAY * 0.5
var AXIS_WIDTH := 2.0
var AXIS_COLOR := Color.GRAY * 0.9

func draw_all():
	assert($Dict.functions.has(NAME), "無い%s" % NAME)
	assert($Dict.functions[NAME].has("func"), "無いfunc")
	assert(VALUE_MIN_X != VALUE_MAX_X, "変な範囲x")
	assert(VALUE_MIN_Y != VALUE_MAX_Y, "変な範囲y")

	draw_grid()

	var points = calc_graph_points($Dict.functions[NAME].func)
	draw_graph(points)

	draw_scale()

	$Title/Label.text = $Dict.functions[NAME].label
	move_child($Title, -1)

func draw_grid() -> void:
	var _pos = _v2p(Vector2.ZERO)
	var draw_point = Vector2i(_pos) % int(GRID_SIZE)

	while draw_point.x <= PIXEL_RECT.end.x:
		var _points = _get_grid_points(Vector2(draw_point.x, 0)).vertical
		add_child(_generate_line_2d(GRID_WIDTH, GRID_COLOR, _points))
		draw_point.x += GRID_SIZE
	while draw_point.y <= PIXEL_RECT.end.y:
		var _points = _get_grid_points(Vector2(0, draw_point.y)).horizontal
		add_child(_generate_line_2d(GRID_WIDTH, GRID_COLOR, _points))
		draw_point.y += GRID_SIZE

	var axis_point = _get_grid_points(_pos)
	add_child(_generate_line_2d(AXIS_WIDTH, AXIS_COLOR, axis_point.vertical))
	add_child(_generate_line_2d(AXIS_WIDTH, AXIS_COLOR, axis_point.horizontal))

func draw_scale():
	if $Dict.functions[NAME].has("scale_x"):
		for scale_value_x in $Dict.functions[NAME].scale_x:
			var _s = $Scale.duplicate()
			_s.position = _v2p(Vector2(scale_value_x, 0))
			_s.get_node("X/Label").text = _format_label(scale_value_x)
			_s.get_node("Y").visible = false
			add_child(_s)
	if $Dict.functions[NAME].has("scale_y"):
		for scale_value_y in $Dict.functions[NAME].scale_y:
			var _s = $Scale.duplicate()
			_s.position = _v2p(Vector2(0, scale_value_y))
			_s.get_node("Y/Label").text = _format_label(scale_value_y)
			_s.get_node("X").visible = false
			add_child(_s)

	$Zero.position = _v2p(Vector2.ZERO)

	$Scale.visible = false

func calc_graph_points(f: Callable) -> Array:
	var res = []
	for i in GRAPH_RESOLUTION + 1.0:
		var px = _n2p(Vector2(i / GRAPH_RESOLUTION, 0)).x
		var vx = _n2v(Vector2(i / GRAPH_RESOLUTION, 0)).x
		var py = _v2p(Vector2(0, f.call(vx))).y
		res.push_back(Vector2(px, py))
	return res

func draw_graph(p: Array) -> void:
	var i = 0
	while i < p.size() - 2:
		if !_rhp(p[i]) && !_rhp(p[i + 1]) && !_rhp(p[i + 2]):
			p.remove_at(i + 1)
		else:
			i += 1
	
	if !_rhp(p[0]) && !_rhp(p[1]):
		p.remove_at(0)
	if !_rhp(p[-1]) && !_rhp(p[-2]):
		p.pop_back()

	var sp = [0]
	for j in p.size() - 1:
		if !_rhp(p[j]) && !_rhp(p[j + 1]):
			sp.push_back(j + 1)
	sp.push_back(p.size())

	var pds = []
	for k in sp.size() - 1:
		pds.push_back(p.slice(sp[k], sp[k + 1]))

	for pd in pds:
		var _l = $Line.duplicate()
		var _g = $Line.gradient.duplicate()
		_g.set_color(0, _g.sample(inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pd[0].x)))
		_g.set_color(1, _g.sample(inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pd[-1].x)))
		_l.gradient = _g
		_l.points = pd
		add_child(_l)

	$Line.visible = false
		
func _generate_line_2d(width: float, color: Color, points: Array) -> Line2D:
	var _l2d = Line2D.new()
	_l2d.width = width
	_l2d.default_color = color
	_l2d.points = points
	return _l2d
	
func _get_grid_points(pos: Vector2) -> Dictionary:
	return {
		"vertical":
			[Vector2(pos.x, PIXEL_RECT.position.y), Vector2(pos.x, PIXEL_RECT.end.y)],
		"horizontal":
			[Vector2(PIXEL_RECT.position.x, pos.y), Vector2(PIXEL_RECT.end.x, pos.y)],
	}

func _rhp(pos: Vector2) -> bool:
	return PIXEL_RECT.has_point(pos)

func _n2p(norm: Vector2) -> Vector2:
	var x = lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, norm.x)
	var y = lerp(PIXEL_RECT.position.y, PIXEL_RECT.end.y, norm.y)
	return Vector2(x, y)

func _n2v(norm: Vector2) -> Vector2:
	var x = lerp(VALUE_MIN_X, VALUE_MAX_X, norm.x)
	var y = lerp(VALUE_MAX_Y, VALUE_MIN_Y, norm.y)
	return Vector2(x, y)
	
func _p2n(pos: Vector2) -> Vector2:
	var x = inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pos.x)
	var y = inverse_lerp(PIXEL_RECT.position.y, PIXEL_RECT.end.y, pos.y)
	return Vector2(x, y)

func _v2n(value: Vector2) -> Vector2:
	var x = inverse_lerp(VALUE_MIN_X, VALUE_MAX_X, value.x)
	var y = inverse_lerp(VALUE_MAX_Y, VALUE_MIN_Y, value.y)
	return Vector2(x, y)

func _p2v(pos: Vector2) -> Vector2:
	return _n2v(_p2n(pos))

func _v2p(value: Vector2) -> Vector2:
	return _n2p(_v2n(value))

func _format_label(f: float) -> String:
	var _str = "%.2f" % f
	var dict = {
		"-6.28": "-2π",
		"-4.71": "-3π/2",
		"-3.14": "-π",
		"-1.57": "-π/2",
		"3.14": "π",
		"6.28": "2π",
		"4.71": "3π/2",
		"1.57": "π/2",
	}
	return dict[_str] if dict.has(_str) else "%.1f" % f
