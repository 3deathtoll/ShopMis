extends Control


@onready
var label_type = $MarginContainer/VBoxContainer/LabelType
@onready
var label_name = $MarginContainer/VBoxContainer/HBoxContainer/LabelName
@onready
var label_level = $MarginContainer/VBoxContainer/HBoxContainer/LabelLevel

@onready
var button = $Button

var item: Item
var equip_type:= ""

func refresh():
	label_type.text = equip_type
	if not item.is_dummy():
		label_name.text = item.name
		label_level.text = "Lv{0}".format([item.level])
	else:
		label_name.text = "---"
		label_level.text = ""

func set_button_group(button_group):
	$Button.button_group = button_group

