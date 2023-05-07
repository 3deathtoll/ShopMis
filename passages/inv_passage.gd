extends PassageBase

class_name InvPassage

func _init():
	type = Passage.INV
	var action: Action
	action = new_action(0, "Use")
	action = new_action(1, "Equip/Unequip")
	action = new_action(14, "Back")
	action.set_goto("End")

func on_action(key: int) -> void:
	if key == 0:
		var item = Game.data._chosen_item
		if item.is_dummy(): return
		var data = Game.item_datas[item.name]
		if data.on_use:
			data.on_use.call(item.level)
			if data.exhaust_on_use:
				if Game.lose_item(item, 1):
					Game.main_scene.sub_scene.refresh()
					Game.main_scene.set_label_item(null)
					Game.data._chosen_item = Item.dummy()
				else:
					Game.main_scene.sub_scene.light_refresh()

	if key == 1:
		var item = Game.data._chosen_item
		if item.is_dummy(): return
		var equips = Game.data.equipments
		var temp = null
		for k in equips:
			if item == equips[k]:
				temp = equips[k]
				equips[k] = Item.dummy()
				Game.main_scene.set_label_item(null)
			Game.data._chosen_item = Item.dummy()
		if temp:
			if Game.data.items.add(temp, 1, true):
				Game.main_scene.sub_scene.refresh()
			else:
				Game.main_scene.sub_scene.light_refresh()
			return
		var data = Game.item_datas[item.name]
		if data.equip_slot:
			temp = item.copy()
			temp.qty = 1
			equips[data.equip_slot] = temp
			if Game.data.items.remove(item, 1):
				Game.main_scene.sub_scene.refresh()
				Game.main_scene.set_label_item(null)
				Game.data._chosen_item = Item.dummy()
			else:
				Game.main_scene.sub_scene.light_refresh()

