extends RefCounted

class_name ItemFactory

static func init():
	var item_data
	item_data = ItemData.new("Troll Blood")
	item_data.type = "Blood"
	item_data.base_price = 50
	item_data.base_factor = 10
	item_data.buy_price = 40
	item_data.buy_factor = 8
	item_data.desc = "Blood of a Troll. Key ingredient of Healing Draughts."
	Game.item_datas[item_data.name] = item_data
	item_data = ItemData.new("Copper Ore")
	item_data.type = "Ore"
	item_data.base_price = 20
	item_data.base_factor = 4
	item_data.buy_price = 12
	item_data.buy_factor = 3
	item_data.desc = "Ore of Copper."
	Game.item_datas[item_data.name] = item_data
	item_data = ItemData.new("Tin Ore")
	item_data.type = "Ore"
	item_data.base_price = 20
	item_data.base_factor = 4
	item_data.buy_price = 12
	item_data.buy_factor = 3
	item_data.desc = "Ore of Tin."
	Game.item_datas[item_data.name] = item_data
	item_data = ItemData.new("Water")
	item_data.type = "Water"
	item_data.base_price = 5
	item_data.base_factor = 5
	item_data.buy_price = 5
	item_data.buy_factor = 4
	item_data.desc = "Ordinary water, enriched with mana."
	Game.item_datas[item_data.name] = item_data
	item_data = ItemData.new("Healing Draught")
	item_data.type = "Potion"
	item_data.base_price = 60
	item_data.base_factor = 20
	item_data.buy_price = 50
	item_data.buy_factor = 16
	item_data.desc = "Tastes terrible."
	item_data.on_combat_use = func (level):
		var hp = 5 * level
		Game.data.player.hp += hp
		if Game.data.player.hp > Game.data.player.maxhp:
			Game.data.player.hp = Game.data.player.maxhp
		return "You drink a Healing Draught." + "(HP +{0})".format([hp])
	item_data.on_use = func (level):
		var hp = 5 * level
		Game.data.player.hp += hp
		if Game.data.player.hp > Game.data.player.maxhp:
			Game.data.player.hp = Game.data.player.maxhp
	item_data.exhaust_on_use = true
	Game.item_datas[item_data.name] = item_data
	item_data = ItemData.new("Bronze Ingot")
	item_data.type = "Metal"
	item_data.base_price = 24
	item_data.base_factor = 4
	item_data.buy_price = 16
	item_data.buy_factor = 4
	item_data.desc = "An alloy of copper and tin."
	Game.item_datas[item_data.name] = item_data
	item_data = ItemData.new("Bronze Knife")
	item_data.type = "Equipment"
	item_data.base_price = 90
	item_data.base_factor = 15
	item_data.buy_price = 80
	item_data.buy_factor = 12
	item_data.desc = "A knife made of bronze"
	item_data.equip_slot = "Weapon"
	item_data.attributes['att'] = 5
	item_data.attributes['agi'] = 5
	Game.item_datas[item_data.name] = item_data


