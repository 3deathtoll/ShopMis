extends Control

const SupplyListItem = preload("res://gui/supply/supply_list_item.tscn")
const SupplyExpItem = preload("res://gui/supply/supply_exp_item.tscn")

@onready
var vbox = $ScrollContainer/VBoxContainer
@onready
var vbox_parent = $ScrollContainer

@onready
var button_group = ButtonGroup.new()

var items = []
var index = -1
var expanded_item
var disabled := false
var cost_type:= Item.SELL_PRICE

signal item_moved(item: Item, qty: int)
signal item_chosen(item: Item)

func _ready():
	button_group.pressed.connect(on_button_group_pressed)
	expanded_item = SupplyExpItem.instantiate()
	expanded_item.set_button_group(button_group)
	expanded_item.item_moved.connect(on_item_moved)
	refresh()

func set_cost_type(type):
	expanded_item.cost_type = type
	self.cost_type = type

func refresh():
	if expanded_item.get_parent():
		vbox.remove_child(expanded_item)

	vbox.free()
	vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox_parent.add_child(vbox)

	if len(items) == 0:
		return
	for item in items:
		var list_item = SupplyListItem.instantiate()
		list_item.item = item
		list_item.cost_type = cost_type
		vbox.add_child(list_item)
		list_item.set_button_group(button_group)
		list_item.refresh()
	if index < 0:
		return
	var list_item = vbox.get_child(index)
	list_item.hide()
	expanded_item.item = list_item.item
	vbox.add_child(expanded_item)
	vbox.move_child(expanded_item, index)
	expanded_item.refresh()

func light_refresh():
	if len(items) == 0:
		return
	for child in vbox.get_children():
		child.refresh()

func on_button_group_pressed(button):
	var list_item = button.get_parent()
	item_chosen.emit(list_item.item)
	Game.main_scene.set_label_item(list_item.item)
	if disabled: return
	if list_item == expanded_item:
		return
	hide_expanded()
	index = list_item.get_index()

	list_item.hide()
	expanded_item.item = list_item.item
	vbox.add_child(expanded_item)
	vbox.move_child(expanded_item, index)
	expanded_item.refresh()

	expanded_item.button.grab_focus()
	expanded_item.button.set_pressed_no_signal(true)

func hide_expanded():
	if expanded_item.get_parent():
		vbox.remove_child(expanded_item)
	if index >= 0:
		var list_item = vbox.get_child(index)
		list_item.show()
		list_item.button.set_pressed_no_signal(false)
	index = -1

func on_item_moved(item: Item, qty: int):
	emit_signal("item_moved", item, qty)
