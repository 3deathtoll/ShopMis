extends RefCounted

class_name ItemDict

var dict = {}

static func from_array(items: Array) -> ItemDict:
	var ret = ItemDict.new()
	for item in items:
		ret.dict[item.to_string()] = item
	return ret

func remove(item: Item, qty: int) -> bool:
	var key = item.to_string()
	if dict.has(key):
		var dict_item = dict[key]
		if dict_item.qty > qty:
			dict_item.qty -= qty
		else:
			dict.erase(key)
			return true
	return false

func add(item: Item, qty: int, assign_pos:=false) -> bool:
	var key = item.to_string()
	var ret = false
	var temp
	if dict.has(key):
		temp = dict[key]
		temp.qty += qty
	else:
		temp = Item.new(item.name, item.level, qty)
		dict[key] = temp
		ret = true
	if assign_pos:
		Item.inc_item_pos(item)
	return ret

func to_saveable():
	return dict.values()

func from_saveable(save):
	for i in save:
		var item = Item.new(i.name, i.level, i.qty)
		dict[item.to_string()] = item


func values() -> Array:
	return dict.values()

func size():
	return len(dict)
