extends SubViewportContainer

@export var GRAPH_RESOLUTION := 1000.0
@export var NAME := "tan"
@export var VALUE_MIN_X := -3.5
@export var VALUE_MAX_X := 3.5
@export var VALUE_MIN_Y := -2.5
@export var VALUE_MAX_Y := 2.5
@export var GRID_WIDTH := 1.0
@export var GRID_COLOR := Color.GRAY * 0.5
@export var AXIS_WIDTH := 2.0
@export var AXIS_COLOR := Color.GRAY * 0.9

func _ready():
	var graph = $SubViewport/Graph
	graph.GRAPH_RESOLUTION = GRAPH_RESOLUTION
	graph.NAME = NAME
	graph.VALUE_MIN_X = VALUE_MIN_X
	graph.VALUE_MAX_X = VALUE_MAX_X
	graph.VALUE_MIN_Y = VALUE_MIN_Y
	graph.VALUE_MAX_Y = VALUE_MAX_Y
	graph.GRID_WIDTH = GRID_WIDTH
	graph.GRID_COLOR = GRID_COLOR
	graph.AXIS_WIDTH = AXIS_WIDTH
	graph.AXIS_COLOR = AXIS_COLOR
	graph.draw_all()
