extends PassageBase

class_name CraftPassage


func _init():
	type = Passage.CRAFT
	var action
	var enable = func (): return len(Game.data.known_recipes) > 0
	action = new_action(0, "Auto Max")
	action.enable = enable
	action = new_action(1, "Auto Min")
	action.enable = enable
	action = new_action(5, "Craft Manually")
	action.enable = enable
	action.set_goto("CraftManual")
	action = new_action(14, "Back")
	action.set_goto("End")

func on_action(key: int) -> void:
		if key == 0:
			if not Game.data._recipe.is_dummy():
				Game.data._recipe.craft_auto(true)
				Game.main_scene.sub_scene.refresh()
		if key == 1:
			if not Game.data._recipe.is_dummy():
				Game.data._recipe.craft_auto(false)
				Game.main_scene.sub_scene.refresh()
