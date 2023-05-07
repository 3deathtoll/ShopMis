extends Node2D


var edges:= []

func _draw():
	for edge in edges:
		draw_line(edge.node1.position, edge.node2.position, Color.WHITE, 6)
