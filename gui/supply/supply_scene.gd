extends Control

@onready
var left_list = $GridContainer/VBoxContainer/LeftList
@onready
var right_list = $GridContainer/RightList
@onready
var left_qty_label = $GridContainer/MarginContainer/HBoxContainer/Label2
@onready
var right_qty_label = $GridContainer/MarginContainer2/HBoxContainer/Label2
@onready
var total_label = $GridContainer/VBoxContainer/MarginContainer/Label

var left_total:= 0
var right_total:= 0

var left_max:= 100
#var right_max:= 100

func _ready():
	left_list.set_cost_type(Item.BUY_PRICE)
	left_list.item_moved.connect(on_left_list_move)
	right_list.set_cost_type(Item.BUY_PRICE)
	right_list.item_moved.connect(on_right_list_move)
	left_list.item_chosen.connect(on_left_list_chosen)
	right_list.item_chosen.connect(on_right_list_chosen)
	Game.data._order_list = ItemDict.new()

func start():
	left_list.items = Game.data._order_list.values()
	left_list.index = -1
	left_list.refresh()

	right_list.items = Game.data.supply_list.values()
	right_list.index = -1
	right_list.refresh()
	refresh()

func refresh():
	left_max = 100
	for item in Game.data.items.values():
		left_max -= item.qty
	if left_max <= 0:
		left_max = 0
	left_total = 0
	var total_cost = 0
	var orders = Game.data._order_list.values()
	for item in orders:
		left_total += item.qty
		total_cost += item.qty * item.get_buy_price()
	left_qty_label.text = "{0}/{1}".format([left_total, left_max])
	total_label.text = "Total: {0}c".format([total_cost])
	Game.data._total_cost = total_cost
	Game.main_scene.reload_actions()
	if len(orders) <= 0:
		left_list.items = []
		left_list.index = -1
		left_list.refresh()

	right_total = 0
	for item in Game.data.supply_list.values():
		right_total += item.qty
	right_qty_label.text = String.num_int64(right_total)

func end():
	pass

func on_left_list_move(item, qty):
	if Game.data._order_list.remove(item, qty):
		left_list.items = Game.data._order_list.values()
		left_list.index = -1
		left_list.refresh()
	else:
		left_list.light_refresh()
	if Game.data.supply_list.add(item, qty):
		right_list.items = Game.data.supply_list.values()
		right_list.refresh()
	else:
		right_list.light_refresh()
	refresh()

func on_right_list_move(item, qty):
	if left_total >= left_max: return
	if left_total + qty > left_max:
		qty = left_max - left_total
	if Game.data.supply_list.remove(item, qty):
		right_list.items = Game.data.supply_list.values()
		right_list.index = -1
		right_list.refresh()
	else:
		right_list.light_refresh()
	if Game.data._order_list.add(item, qty):
		left_list.items = Game.data._order_list.values()
		left_list.refresh()
	else:
		left_list.light_refresh()
	refresh()


func on_left_list_chosen(item: Item):
	right_list.hide_expanded()

func on_right_list_chosen(item: Item):
	left_list.hide_expanded()
