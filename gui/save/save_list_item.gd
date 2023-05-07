extends Control


@onready
var label_name = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/LabelName
@onready
var label_time = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/LabelTime
@onready
var label_timestamp = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/LabelTimestamp


@onready
var button = $Button

var id
var save_desc

func refresh():
	if save_desc:
		label_name.text = save_desc.name
		label_time.text = save_desc.time.to_string()
		label_timestamp.text = save_desc.timestamp
	else:
		label_name.text = "Empty"
		label_time.text = ""
		label_timestamp.text = ""

func set_button_group(button_group):
	$Button.button_group = button_group

