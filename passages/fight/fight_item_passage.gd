extends PassageBase

class_name FightItemPassage

func _init():
	type = Passage.INV
	var action: Action
	action = new_action(0, "Use")
	action = new_action(14, "Back")
	action.set_goto("End")

func on_action(key: int) -> void:
	if key == 0:
		var item = Game.data._chosen_item
		if item.is_dummy(): return

		var data = Game.item_datas[item.name]
		if data.on_combat_use:
			var text = data.on_combat_use.call(item.level)
			if data.exhaust_on_use:
				if Game.lose_item(item, 1):
					Game.main_scene.sub_scene.refresh()
					Game.main_scene.set_label_item(null)
					Game.data._chosen_item = Item.dummy()
				else:
					Game.main_scene.sub_scene.light_refresh()
			var player = Game.data.player.stats()
			var enemy = Game.enemy_data[Game.data._enemy_id]
			FightPassage.add_dialogue(true, text)
			FightPassage.add_dialogue(false, Combat.enemy_attack(player, enemy, 2.0/3))
			Game.change_passage("End")


