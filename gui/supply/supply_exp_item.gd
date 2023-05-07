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

@onready
var line_edit = $MarginContainer/VBoxContainer/HBoxContainer3/LineEdit

@onready
var button_all = $MarginContainer/VBoxContainer/HBoxContainer3/ButtonAll
@onready
var button_some = $MarginContainer/VBoxContainer/HBoxContainer3/ButtonSome

signal item_moved(item: Item, qty: int)

var item: Item
var move_qty := 1
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


func fix_line_edit():
	if line_edit.text.is_valid_int():
		move_qty = line_edit.text.to_int()
		if move_qty < 1:
			move_qty = 1
	else:
		move_qty = 1
	refresh()


func set_button_group(button_group):
	$Button.button_group = button_group

func _on_line_edit_text_submitted(new_text):
	fix_line_edit()
	if move_qty < item.qty:
		emit_signal("item_moved", item, move_qty)
	else:
		emit_signal("item_moved", item, item.qty)

func _on_line_edit_focus_exited():
	fix_line_edit()

func _on_button_some_button_down():
	fix_line_edit()
	if move_qty < item.qty:
		emit_signal("item_moved", item, move_qty)
	else:
		emit_signal("item_moved", item, item.qty)


func _on_button_all_button_down():
	fix_line_edit()
	emit_signal("item_moved", item, item.qty)
