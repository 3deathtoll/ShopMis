extends RefCounted

class_name Maps

const MapScene = preload("res://gui/map/map.tscn")

var map_nodes = {}
var global_edges = []
var default_map: Map

func _init():
	default_map = MapScene.instantiate()


func move_to(id):
	for map in map_nodes.values():
		if map.nodes.has(id):
			map.move_to(id)
			return map
	return default_map


func new_map(id) -> Map:
	var node = MapScene.instantiate()
	node.id = id
	map_nodes[id] = node
	return node

func load_global_edges(edge_array):
	for edge in edge_array:
		var e = Map.Edge.new(null, null, edge.dir)
		e.loc1 = edge.loc1
		e.loc2 = edge.loc2
		if edge.has("min"):
			e.min = edge.min
		global_edges.append(e)

func add_map_actions():
	for map in map_nodes.values():
		for edge in map.edges:
			add_map_edge(edge)
	for edge in global_edges:
		add_map_edge(edge)

func add_map_edge(edge):
			if not Game.passages.has(edge.loc1): return
			if not Game.passages.has(edge.loc2): return
			var location1 = Game.passages[edge.loc1]
			var location2 = Game.passages[edge.loc2]
			var key1: int
			var dir_str1: String
			var key2: int
			var dir_str2: String
			if edge.dir == Map.NORTH_SOUTH:
				key1 = Game.ACTION_NORTH
				dir_str1 = "North"
				key2 = Game.ACTION_SOUTH
				dir_str2 = "South"
			elif edge.dir == Map.WEST_EAST:
				key1 = Game.ACTION_WEST
				dir_str1 = "West"
				key2 = Game.ACTION_EAST
				dir_str2 = "East"
			elif edge.dir == Map.DOWN_UP:
				key1 = Game.ACTION_DOWN
				dir_str1 = "Down"
				key2 = Game.ACTION_UP
				dir_str2 = "Up"
			else:
				return
			var action
			action = location2.new_action(key1, dir_str1)
			action.set_goto(edge.loc1)
			action.min = edge.min
			action = location1.new_action(key2, dir_str2)
			action.set_goto(edge.loc2)
			action.min = edge.min
