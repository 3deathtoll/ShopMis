extends Control

const RecipeListItem = preload("res://gui/craft/recipe_list_item.tscn")

@onready
var vbox = $GridContainer/ScrollContainer/VBoxContainer
@onready
var vbox_parent = $GridContainer/ScrollContainer
@onready
var right_list = $GridContainer/RightList

@onready
var label = $GridContainer/ScrollContainer/Label

@onready
var button_group = ButtonGroup.new()

func _ready():
	button_group.pressed.connect(on_button_group_pressed)


func start():
	if Game.data._recipe.is_dummy() and len(Game.data.known_recipes) > 0:
		Game.data._recipe = Game.recipes[Game.data.known_recipes[0]] #TODO consider sort
	right_list.recipe = Game.data._recipe
	right_list.refresh()
	vbox.free()
	vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox_parent.add_child(vbox)
	if len(Game.data.known_recipes) == 0:
		vbox.hide()
		label.show()
	else:
		vbox.show()
		label.hide()
		for title in Game.data.known_recipes:
			var list_item = RecipeListItem.instantiate()
			list_item.set_button_group(button_group)
			list_item.recipe = Game.recipes[title]
			vbox.add_child(list_item)
			list_item.refresh()

func refresh():
	right_list.light_refresh()

func end():
	pass

func on_button_group_pressed(button):
	var list_item = button.get_parent()
	right_list.recipe = list_item.recipe
	Game.data._recipe = list_item.recipe
	right_list.refresh()


