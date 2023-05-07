extends Control


@onready
var label_name = $MarginContainer/VBoxContainer/HBoxContainer/LabelName
@onready
var label_level = $MarginContainer/VBoxContainer/HBoxContainer/LabelLevel
@onready
var label_cost = $MarginContainer/VBoxContainer/HBoxContainer2/LabelCost
@onready
var label_qty = $MarginContainer/VBoxContainer/HBoxContainer2/LabelQty


@onready
var button = $Button

var item: Item
var cost_type := Item.SELL_PRICE

func refresh():
	label_name.text = item.name
	label_level.text = "Lv{0}".format([item.level])
	if cost_type == Item.BUY_PRICE:
		label_cost.text = "{0}c".format([item.get_buy_price()])
	elif cost_type == Item.SELL_PRICE:
		label_cost.text = "{0}c".format([item.get_sell_price()])
	else:
		label_cost.text = ""
	label_qty.text = "x{0}".format([item.qty])


func set_button_group(button_group):
	$Button.button_group = button_group

