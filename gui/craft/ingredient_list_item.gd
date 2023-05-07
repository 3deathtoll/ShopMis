extends Control


@onready
var label = $MarginContainer/HBoxContainer/Label
@onready
var label2 = $MarginContainer/HBoxContainer/Label2
@onready
var button = $Button

var ingredient: Recipe.Ingredient
var total:= 0

func refresh():
	label.text = ingredient.name
	label2.text = "{0}/{1}".format([total, ingredient.qty])

func set_button_group(button_group):
	button.button_group = button_group
