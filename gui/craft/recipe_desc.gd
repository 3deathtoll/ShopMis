extends Control

const IngredientListItem = preload("res://gui/craft/ingredient_list_item.tscn")

@onready
var vbox = $VBoxContainer/ScrollContainer/VBoxContainer
@onready
var vbox_parent = $VBoxContainer/ScrollContainer
@onready
var label = $VBoxContainer/Label

@onready
var button_group = ButtonGroup.new()

var recipe: Recipe

func _ready():
	button_group.pressed.connect(on_button_group_pressed)
	refresh()

func refresh():

	vbox.free()
	vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox_parent.add_child(vbox)

	if not recipe or recipe.is_dummy():
		label.text = "---"
		return

	label.text = "{0}\n{1}min".format([recipe.title, recipe.min])
	for ingredient in recipe.ingredients:
		var total = 0
		for item in Game.data.items.values():
			if ingredient.can_be(item):
				total += item.qty

		var list_item = IngredientListItem.instantiate()
		list_item.ingredient = ingredient
		list_item.total = total
		vbox.add_child(list_item)
		list_item.refresh()
#		list_item.set_button_group(button_group)

func light_refresh():
	for list_item in vbox.get_children():
		var ingredient = list_item.ingredient
		var total = 0
		for item in Game.data.items.values():
			if ingredient.can_be(item):
				total += item.qty
		list_item.total = total

	for child in vbox.get_children():
		child.refresh()


func on_button_group_pressed(button):
	var list_item = button.get_parent()


