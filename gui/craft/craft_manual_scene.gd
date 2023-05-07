extends Control

const IngredientLabelItem = preload("res://gui/craft/ingredient_label_item.tscn")
const IngredientAccordion = preload("res://gui/craft/ingredient_accordion.tscn")

@onready
var left_list = $GridContainer/ScrollContainer/VBoxContainer
@onready
var right_list = $GridContainer/RightList
@onready
var left_qty_label = $GridContainer/MarginContainer/HBoxContainer/Label2
@onready
var right_qty_label = $GridContainer/MarginContainer2/HBoxContainer/Label2

@onready
var button_group = ButtonGroup.new()
var current_ingredient := 0
var right_items = []
var left_items = []
var left_drawer

func _ready():
	right_list.item_moved.connect(on_right_list_move)
	right_list.item_chosen.connect(on_right_list_chosen)
	button_group.pressed.connect(on_button_group_pressed)

func start():
	for child in left_list.get_children():
		child.free()
	var items = Game.data.items.values()
	var i = 0
	right_items = []
	left_items = []
	for ingredient in Game.data._recipe.ingredients:
		var item_dict = ItemDict.new()
		for item in items:
			if ingredient.can_be(item):
				item_dict.dict[item.to_string()] = item.copy()
		right_items.push_back(item_dict)
		left_items.push_back(ItemDict.new())

		var list_item = IngredientLabelItem.instantiate()
		list_item.ingredient = ingredient
		left_list.add_child(list_item)
		list_item.set_button_group(button_group)
	left_list.get_child(current_ingredient).button.set_pressed_no_signal(true)
	left_drawer = IngredientAccordion.instantiate()
	left_drawer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_drawer.item_chosen.connect(on_left_drawer_chosen)
#	left_drawer.items = left_items[current_ingredient].values()
	left_list.add_child(left_drawer)
	left_list.move_child(left_drawer, current_ingredient + 1)
	left_list.get_child(current_ingredient).set_expanded(true)
	left_drawer.item_moved.connect(on_left_list_move)
	right_list.items = right_items[current_ingredient].values()
	right_list.index = -1
	right_list.refresh()
	refresh()

func refresh():
	left_drawer.items = left_items[current_ingredient].values()
	left_drawer.index = -1
	left_drawer.refresh()
	light_refresh()

func light_refresh():
	var i = 0
	for list_item in left_list.get_children():
		if list_item.is_label:
			var sum = 0
			for item in left_items[i].values():
				sum += item.qty
			list_item.total = sum
			list_item.refresh()
			i+=1
	var total = 0
	left_qty_label.text = ""
	total = 0
	for item in right_items[current_ingredient].values():
		total += item.qty
	right_qty_label.text = String.num_int64(total)


func end():
	pass

func on_left_list_move(item, qty):
	if left_items[current_ingredient].remove(item, qty):
		left_drawer.items = left_items[current_ingredient].values()
		left_drawer.index = -1
		left_drawer.refresh()
		refresh()
	else:
		left_drawer.light_refresh()
		light_refresh()

	if right_items[current_ingredient].add(item, qty):
		var key = item.to_string()
		right_list.items = right_items[current_ingredient].values()
		right_list.refresh()
	else:
		right_list.light_refresh()

func on_right_list_move(item, qty):
	if right_items[current_ingredient].remove(item, qty):
		right_list.items = right_items[current_ingredient].values()
		right_list.index = -1
		right_list.refresh()
	else:
		right_list.light_refresh()


	if left_items[current_ingredient].add(item , qty):
		left_drawer.items = left_items[current_ingredient].values()
		left_drawer.refresh()
		refresh()
	else:
		left_drawer.light_refresh()
		light_refresh()

func on_button_group_pressed(button):
	var list_item = button.get_parent()
	var new_index = list_item.get_index()
	if new_index > left_drawer.get_index():
		new_index -= 1

	if new_index == current_ingredient: return
	list_item.set_expanded(true)
	left_list.get_child(current_ingredient).set_expanded(false)
	current_ingredient = new_index

	left_list.move_child(left_drawer, current_ingredient + 1)
	left_drawer.items = left_items[current_ingredient].values()
	left_drawer.index = -1
	left_drawer.refresh()

	right_list.items = right_items[current_ingredient].values()
	right_list.index = -1
	right_list.refresh()

	light_refresh()

func on_left_drawer_chosen(item: Item):
	right_list.hide_expanded()

func on_right_list_chosen(item: Item):
	left_drawer.hide_expanded()
