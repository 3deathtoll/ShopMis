extends RefCounted

class_name Recipe

var title: String
var ingredients:= []
var min:= 0

func _init(title: String, min: int):
	self.title = title
	self.min = min

static func dummy() -> Recipe:
	return Recipe.new("DUMMY", 0)

func is_dummy() -> bool:
	return title == "DUMMY"

func add_ingredient(name: String, type: String, qty: int):
	ingredients.push_back(Ingredient.new(name, type, qty))

class Ingredient:
	var name: String
	var type: String
	var qty: int
	var min_lvl: int

	func _init(name: String, type: String, qty: int, min_lvl:=0):
		self.name = name
		self.type = type
		self.qty = qty
		self.min_lvl = min_lvl

	func can_be(item):
		return (item.name == name or Game.item_datas[item.name].type == type) and item.level >= min_lvl

func craft_auto(max_mode:= true):
	var items = Game.data.items
	var chosen_lists = []
	for ingredient in ingredients:
		var list = []
		var total_qty = 0
		for item in items.values():
			if ingredient.can_be(item):
				list.push_back(item)
				total_qty += item.qty
		if total_qty < ingredient.qty:
			return
		chosen_lists.push_back(list)
	for list in chosen_lists:
		if max_mode:
			list.sort_custom(func (a, b): return a.level < b.level)
		else:
			list.sort_custom(func (a, b): return a.level > b.level)

	var lmath = Util.LevelMath.new()
	for i in len(ingredients):
		var q = ingredients[i].qty
		var l: Array= chosen_lists[i]
		while q > 0:
			var item = l.back()
			var key = item.to_string()
			if item.qty > q:
				item.qty -= q
				lmath.add_level(item.level, q)
				break
			else:
				q -= item.qty
				lmath.add_level(item.level, item.qty)
				items.dict.erase(key)
				l.pop_back()
	var item = Item.new(title, lmath.get_result_level(), 1)
	Game.gain_crafted_item(item)
	Game.data.time.add_min(min)

func craft_manual(item_lists: Array):
	var chosen_lists = []
	var qty = INF
	var i = 0
	for list in item_lists:
		var ingredient = ingredients[i]; i+=1
		var total_qty := 0
		for item in list.values():
			total_qty += item.qty
		qty = min(qty, total_qty / ingredient.qty)
	var craft_list = ItemDict.new()
	for j in qty:
		var item = craft_manual_one(item_lists)
		craft_list.add(item, item.qty, true)
	for item in craft_list.values():
		Game.gain_crafted_item(item)
	Game.data.time.add_min(qty * min)


func craft_manual_one(item_lists):
	var items = Game.data.items
	var lmath = Util.LevelMath.new()
	for i in len(ingredients):
		var q = ingredients[i].qty
		var l: Array= item_lists[i].values()
		while q > 0:
			var item = l.back()
			var key = item.to_string()
			var base_item = items.dict[key]
			if item.qty > q:
				item.qty -= q
				base_item.qty -= q
				lmath.add_level(item.level, q)
				break
			else:
				q -= item.qty
				lmath.add_level(item.level, item.qty)
				if base_item.qty == item.qty and q == 0:
					items.dict.erase(key)
				else:
					base_item.qty -= item.qty
					item.qty = 0
				var temp = l.pop_back()
				item_lists[i].dict.erase(temp.to_string())
	return Item.new(title, lmath.get_result_level(), 1)
