extends RefCounted

class_name ItemDrop

var components:= []

class Component:
	var item_data: ItemData
	var qty: int
	var weight: float
	var min_qlty: float
	var max_qlty: float

	func _init(name: String, weight: float, min_qlty: float, max_qlty: float):
		self.item_data = Game.item_datas[name]
		self.weight = weight
		self.min_qlty = max(min_qlty, 1)
		self.max_qlty = max_qlty

	func get_drop():
		var qlty = exp(randf_range(log(min_qlty), log(max_qlty)))
		var level = ItemData.LEVEL_TO_RARITY.bsearch(qlty)
		return Item.new(item_data.name, level, 1)

func add_component(name: String, weight:float, min_qlty: int, max_qlty: int):
	components.push_back(Component.new(name, weight, min_qlty, max_qlty))

func get_drop():
	var total_weight = 0
	for component in components:
		total_weight += component.weight
	var rngesus = total_weight * randf()
	for component in components:
		rngesus -= component.weight
		if rngesus < 0:
			return component.get_drop()
	return components.back().get_drop()

