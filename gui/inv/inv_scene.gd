extends Control

@onready
var left_list = $GridContainer/LeftList
@onready
var right_list = $GridContainer/RightList
@onready
var left_qty_label = $GridContainer/MarginContainer/HBoxContainer/Label2
@onready
var right_qty_label = $GridContainer/MarginContainer2/HBoxContainer/Label2

var sort_by = SortUtil.sort_by_recent

func _ready():
	right_list.disabled = true
	left_list.item_chosen.connect(on_item_chosen)
	right_list.item_chosen.connect(on_item_chosen)

func start():
	refresh()

func refresh():
	left_list.refresh()
	var items = Game.data.items.values()
	items.sort_custom(sort_by)
	right_list.items = items
	right_list.index = -1
	right_list.refresh()
	var total = 0
	for item in Game.data.items.values():
		total += item.qty
	right_qty_label.text = "{0}/100".format([total])

func light_refresh():
	left_list.refresh()
	right_list.light_refresh()
	var total = 0
	for item in Game.data.items.values():
		total += item.qty
	right_qty_label.text = "{0}/100".format([total])

func end():
	pass

func on_item_chosen(item: Item):
	Game.data._chosen_item = item




