extends Control

const EquipListItem = preload("res://gui/inv/equip_list_item.tscn")

@onready
var vbox = $ScrollContainer/VBoxContainer
@onready
var vbox_parent = $ScrollContainer

@onready
var button_group = ButtonGroup.new()

signal item_chosen(item: Item)

func _ready():
	button_group.pressed.connect(on_button_group_pressed)
	refresh()

func refresh():

	vbox.free()
	vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox_parent.add_child(vbox)

	for key in Game.data.equipments:
		var list_item = EquipListItem.instantiate()
		list_item.set_button_group(button_group)
		list_item.equip_type = key
		list_item.item = Game.data.equipments[key]
		vbox.add_child(list_item)
		list_item.refresh()

func light_refresh():
	for child in vbox.get_children():
		child.refresh()

func on_button_group_pressed(button):
	var list_item = button.get_parent()
	item_chosen.emit(list_item.item)
	Game.main_scene.set_label_item(list_item.item)

