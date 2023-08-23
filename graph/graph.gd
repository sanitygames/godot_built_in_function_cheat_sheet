extends Node2D

@export var GRAPH_RESOLUTION := 1000.0
static var GRID_SIZE := 30.0
static var PIXEL_RECT := Rect2(10, 10, 420, 300)

@export var NAME := "tan"
@export var VALUE_MIN_X := 0.0
@export var VALUE_MAX_X := 0.0
@export var VALUE_MIN_Y := 0.0
@export var VALUE_MAX_Y := 0.0


func _ready():
	draw_grid()
	var graph_points = calc_graph_points($Dict.functions[NAME].func)
	draw_graph(graph_points)
	# draw_comment(graph_points)
	$Line.visible = false
	$Title/Label.text = $Dict.functions[NAME].label
	move_child($Title, -1)
	draw_scale()

func draw_scale():
	if $Dict.functions[NAME].has("scale_x"):
		for xsc in $Dict.functions[NAME].scale_x:
			var _s = $Scale.duplicate()
			var nx = inverse_lerp(VALUE_MIN_X, VALUE_MAX_X, xsc)
			var px = lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, nx)
			var ny = inverse_lerp(VALUE_MAX_Y, VALUE_MIN_Y, 0.0)
			var py = lerp(PIXEL_RECT.position.y, PIXEL_RECT.end.y, ny)
			_s.position = Vector2(px, py)
			_s.get_node("X/Label").text = format_label(xsc)
			_s.get_node("Y").visible = false
			add_child(_s)
	if $Dict.functions[NAME].has("scale_y"):
		for ysc in $Dict.functions[NAME].scale_y:
			var _s = $Scale.duplicate()
			var ny = inverse_lerp(VALUE_MAX_Y, VALUE_MIN_Y, ysc)
			var py = lerp(PIXEL_RECT.position.y, PIXEL_RECT.end.y, ny)
			var nx = inverse_lerp(VALUE_MIN_X, VALUE_MAX_X, 0.0)
			var px = lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, nx)
			_s.position = Vector2(px, py)
			_s.get_node("Y/Label").text = format_label(ysc)
			_s.get_node("X").visible = false
			add_child(_s)
	$Scale.visible = false

func format_label(f: float) -> String:
	var str = "%.2f" % f
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
	if dict.has(str):
		return dict[str]
	else:
		return "%.1f" % f

		

# func draw_comment(points: Array) -> void:
# 	print("COMMENT")
# 	for p in points:
# 		print(fmod(p.x, PI))
# 		if _cx.call(p):
# 			print(p.x)
# 		if _cy.call(p):
# 			print(p.y)


func calc_graph_points(f: Callable) -> Array:
	var res = []
	for i in GRAPH_RESOLUTION + 1.0:
		var nx = i / GRAPH_RESOLUTION
		var vx = lerp(VALUE_MIN_X, VALUE_MAX_X, nx)
		var vy = f.call(vx)
		var ny = inverse_lerp(VALUE_MAX_Y, VALUE_MIN_Y, vy)
		var px = lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, nx)
		var py = lerp(PIXEL_RECT.position.y, PIXEL_RECT.end.y, ny)
		res.push_back(Vector2(px, py))
	return res

func draw_graph(p: Array) -> void:
	var i = 0
	while i < p.size() - 2:
		if !prhp(p[i]) && !prhp(p[i + 1]) && !prhp(p[i + 2]):
			p.remove_at(i + 1)
		else:
			i += 1
	
	if !prhp(p[0]) && !prhp(p[1]):
		p.remove_at(0)
	if !prhp(p[-1]) && !prhp(p[-2]):
		p.remove_at(p.size() - 1 )

	var sp = [0]
	for j in p.size() - 1:
		if !prhp(p[j]) && !prhp(p[j + 1]):
			sp.push_back(j + 1)
	sp.push_back(p.size())

	var pds = []
	for k in sp.size() - 1:
		pds.push_back(p.slice(sp[k], sp[k + 1]))

	for pd in pds:
		var _l = $Line.duplicate()
		var _g = $Line.gradient.duplicate()
		# _g.set_color(0, _g.sample((pd[0].x - PIXEL_RECT.position.x) / PIXEL_RECT.end.x))
		# _g.set_color(1, _g.sample((pd[-1].x - PIXEL_RECT.position.x) / PIXEL_RECT.end.x))
		_g.set_color(0, _g.sample(inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pd[0].x)))
		_g.set_color(1, _g.sample(inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pd[-1].x)))
		print(inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pd[0].x))
		print(inverse_lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, pd[-1].x))
		_l.gradient = _g
		_l.points = pd
		add_child(_l)
		move_child(_l, -1)
		

func prhp(pos: Vector2) -> bool:
	return PIXEL_RECT.has_point(pos)
	
func draw_grid():
	var nx = inverse_lerp(VALUE_MIN_X, VALUE_MAX_X, 0.0)
	var ny = inverse_lerp(VALUE_MIN_Y, VALUE_MAX_Y, 0.0)
	var px = lerp(PIXEL_RECT.position.x, PIXEL_RECT.end.x, nx)
	var py = lerp(PIXEL_RECT.end.y, PIXEL_RECT.position.y, ny)

	var draw_point_x = int(px) % int(GRID_SIZE)
	var draw_point_y = int(py) % int(GRID_SIZE)
	draw_point_x += GRID_SIZE if draw_point_x < PIXEL_RECT.position.x else 0.0
	draw_point_y += GRID_SIZE if draw_point_y < PIXEL_RECT.position.y else 0.0

	while draw_point_x <= PIXEL_RECT.end.x:
		var p0 = Vector2(draw_point_x, PIXEL_RECT.position.y)
		var p1 = Vector2(draw_point_x, PIXEL_RECT.end.y)
		add_child(generate_line2d(1.0, Color.GRAY * 0.5, [p0, p1]))
		draw_point_x += GRID_SIZE

	while draw_point_y <= PIXEL_RECT.end.y:
		var p0 = Vector2(PIXEL_RECT.position.x, draw_point_y)
		var p1 = Vector2(PIXEL_RECT.end.x, draw_point_y)
		add_child(generate_line2d(1.0, Color.GRAY * 0.5, [p0, p1]))
		draw_point_y += GRID_SIZE

	var opx0 = Vector2(PIXEL_RECT.position.x, py)
	var opx1 = Vector2(PIXEL_RECT.end.x, py)
	add_child(generate_line2d(2.0, Color.GRAY, [opx0, opx1]))
	print(py)
	
	var opy0 = Vector2(px, PIXEL_RECT.position.y)
	var opy1 = Vector2(px, PIXEL_RECT.end.y)
	add_child(generate_line2d(2.0, Color.GRAY, [opy0, opy1]))

func generate_line2d(width: float, color: Color, points: Array) -> Line2D:
	var _l2d = Line2D.new()
	_l2d.width = width
	_l2d.default_color = color
	_l2d.points = points
	return _l2d
	
