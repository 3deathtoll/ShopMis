extends Control


@onready
var label_title = $MarginContainer/LabelTitle
@onready
var button = $Button

var recipe: Recipe

func refresh():
	label_title.text = recipe.title

func set_button_group(button_group):
	$Button.button_group = button_group

