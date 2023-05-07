extends PassageBase

class_name CraftManualPassage


func _init():
	type = Passage.CRAFT_MANUAL
	new_action(0, "Craft")
	var action = new_action(14, "Back")
	action.set_goto("CraftMain")

func on_action(key: int) -> void:
	if key == 0:
		if not Game.data._recipe.is_dummy():
			Game.data._recipe.craft_manual(
				Game.main_scene.sub_scene.left_items
			)
			Game.main_scene.sub_scene.refresh()

