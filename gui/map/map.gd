extends Control

class_name Map

const MapNode = preload("res://gui/map/map_node.tscn")

enum {
	NORTH_SOUTH,
	WEST_EAST,
	DOWN_UP,
}

const NODE_DEFAULT = Color8(128, 128, 128)
const NODE_HIGHLIGHT = Color8(72, 72, 72)

@onready
var origin = $Origin

var id
var edges = []
var nodes = {}

func _ready():
	$Current/ColorRect/ColorRect.color = NODE_HIGHLIGHT

func move_to(loc_id):
	if not nodes.has(loc_id): return
	origin.position = -nodes[loc_id].position

func load_from(node_array, edge_array):
	origin = $Origin
	for node in node_array:
		var map_node = MapNode.instantiate()
		map_node.position.x = node.x
		map_node.position.y = node.y
		nodes[node.id] = map_node
		origin.add_child(map_node)
	for edge in edge_array:
		var node1 = nodes[edge.loc1]
		var node2 = nodes[edge.loc2]
		var e = Edge.new(node1, node2, edge.dir)
		e.loc1 = edge.loc1
		e.loc2 = edge.loc2
		if edge.has("min"):
			e.min = edge.min
		edges.append(e)
	origin.edges = edges
	origin.queue_redraw()


class Edge:
	var node1
	var node2
	var loc1
	var loc2
	var dir:= NORTH_SOUTH
	var min:= 5

	func _init(n1, n2, d):
		node1 = n1
		node2 = n2
		dir = d
