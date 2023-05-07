extends PassageBase

class_name SupplyPassage

func _init():
	type = Passage.SUPPLY
	var action
	action = new_action(0, "Order")
	action.enable = func (): return Game.data._total_cost <= Game.data.money
	action = new_action(14, "Back")
	action.set_goto("End")

func on_action(key: int) -> void:
	if key == 0:
		var total_cost = 0
		var items = Game.data._order_list.values()
		for item in items:
			total_cost += item.qty * item.get_buy_price()
		if total_cost <= Game.data.money:
			Game.data.money -= total_cost
			for item in items:
				Game.data.items.add(item, item.qty, true)
			Game.data._order_list = ItemDict.new()
			Game.main_scene.sub_scene.refresh()

func ready():
	if Game.data.time.day > Game.data.last_supply:
		Game.data.supply_list = ItemDict.from_array([
			Item.new("Healing Draught", 1, 10),
			Item.new("Healing Draught", 2, 15),
			Item.new("Healing Draught", 3, 15),
		])
		Game.data.last_supply = Game.data.time.day
		Game.data._order_list = ItemDict.new()
