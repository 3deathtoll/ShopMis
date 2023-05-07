extends RefCounted

class_name Item

const BUY_PRICE = 0
const SELL_PRICE = 1
const NO_PRICE = 2

var name: String
var level: int
var qty:= 0

func _init(name: String, level: int, qty:= 0):
	self.name = name
	self.level = level
	self.qty = qty

func copy():
	return Item.new(name, level, qty)

static func dummy() -> Item:
	return Item.new("DUMMY", 1, 0)

func is_dummy() -> bool:
	return name == "DUMMY"

func get_buy_price():
	var data = Game.item_datas[name]
	return data.buy_price + data.buy_factor * (level - data.base_level)

func get_sell_price():
	var data = Game.item_datas[name]
	return data.base_price + data.base_factor * (level - data.base_level)



func _to_string():
	return "{0} Lv{1}".format([name, level])


static func inc_item_pos(item: Item):
	var dict = Game.data.recent_item_pos
	var key = item.to_string()
	dict[key] = Game.data.next_item_pos
	Game.data.next_item_pos+=1

static func get_item_pos(item: Item):
	var dict = Game.data.recent_item_pos
	var key = item.to_string()
	if dict.has(key):
		return dict[key]
	else:
		return -1

static func choose_n_from(items: Array, n: int):
	var m = 0
	for item in items:
		m += item.qty
	var ret = []

	var j = n
	var p = m

	for item in items:
		var qty = 0
		for k in item.qty:
			if p * randf() <= j + Util.TOLERANCE:
				j -= 1
				qty += 1
				if j <= 0:
					break
			p -= 1
#			if j >= p: #TODO maybe implement this later
#				break
		if qty > 0:
			var temp = item.copy()
			temp.qty = qty
			ret.push_back(temp)
	return ret
