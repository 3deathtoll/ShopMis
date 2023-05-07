extends Control


@onready
var label = $MarginContainer/HBoxContainer/Label
@onready
var label2 = $MarginContainer/HBoxContainer/Label2
@onready
var button = $Button
@onready
var indicator = $MarginContainer/HBoxContainer/Label3

var ingredient: Recipe.Ingredient
var total:= 0

var is_label:= true

func refresh():
	label.text = ingredient.name
	label2.text = "{0}/{1}".format([total, ingredient.qty])

func set_button_group(button_group):
	button.button_group = button_group

func set_expanded(expanded: bool):
	if expanded:
		indicator.text = "v"
	else:
		indicator.text = ">"
