extends Control

@onready
var map_parent = $HBox/VBox/MarginContainer/Control
@onready
var label = $HBox/RichTextLabel
@onready
var texture_rect = $HBox/VBox/MarginContainer2/TextureRect

func _ready():
	pass

func start():
	refresh()

func refresh():
	label.text = Game.evaluate_text_from(Game.current_passage)
	var current_loc = Game.passages[Game.data.current_location]
	if Game.current_passage.image:
		texture_rect.texture = Game.load_asset(Game.current_passage.image)
	elif current_loc.image:
		texture_rect.texture = Game.load_asset(current_loc.image)
	else:
		texture_rect.texture = null
	var map = Game.maps.move_to(Game.data.current_location)
	for child in map_parent.get_children():
		map_parent.remove_child(child)
		if child is InstancePlaceholder:
			child.free()
	map_parent.add_child(map)

func end():
	pass

func light_refresh():
	label.text = Game.evaluate_text_from(Game.current_passage)

