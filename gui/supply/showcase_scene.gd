extends Control

@onready
var left_list = $GridContainer/LeftList
@onready
var right_list = $GridContainer/RightList
@onready
var left_qty_label = $GridContainer/MarginContainer/HBoxContainer/Label2
@onready
var right_qty_label = $GridContainer/MarginContainer2/HBoxContainer/Label2

var left_total:= 0
var right_total:= 0

var left_max:= 100
var right_max:= 100

var sort_by = SortUtil.sort_by_recent

func _ready():
	left_list.item_moved.connect(on_left_list_move)
	right_list.item_moved.connect(on_right_list_move)
	left_list.item_chosen.connect(on_left_list_chosen)
	right_list.item_chosen.connect(on_right_list_chosen)

func start():
	left_list.items = Game.data.showcased_items.values()
	left_list.index = -1
	left_list.refresh()

	var items = Game.data.items.values()
	items.sort_custom(sort_by)
	right_list.items = items
	right_list.index = -1
	right_list.refresh()
	refresh()

func refresh():
	left_total = 0
	for item in Game.data.showcased_items.values():
		left_total += item.qty
	left_qty_label.text = "{0}/{1}".format([left_total, left_max])
	right_total = 0
	for item in Game.data.items.values():
		right_total += item.qty
	right_qty_label.text = "{0}/{1}".format([right_total, right_max])

func end():
	pass

func on_left_list_move(item, qty):
	if right_total >= right_max: return
	if right_total + qty > right_max:
		qty = right_max - right_total
	if Game.data.showcased_items.remove(item, qty):
		left_list.items = Game.data.showcased_items.values()
		left_list.index = -1
		left_list.refresh()
	else:
		left_list.light_refresh()
	if Game.data.items.add(item, qty):
		var items = Game.data.items.values()
		items.sort_custom(sort_by)
		right_list.items = items
		right_list.refresh()
	else:
		right_list.light_refresh()
	refresh()

func on_right_list_move(item, qty):
	if left_total >= left_max: return
	if left_total + qty > left_max:
		qty = left_max - left_total
	if Game.data.items.remove(item, qty):
		var items = Game.data.items.values()
		items.sort_custom(sort_by)
		right_list.items = items
		right_list.index = -1
		right_list.refresh()
	else:
		right_list.light_refresh()
	if Game.data.showcased_items.add(item, qty):
		left_list.items = Game.data.showcased_items.values()
		left_list.refresh()
	else:
		left_list.light_refresh()
	refresh()

func on_left_list_chosen(item: Item):
	right_list.hide_expanded()

func on_right_list_chosen(item: Item):
	left_list.hide_expanded()
