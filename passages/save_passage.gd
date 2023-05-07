extends PassageBase

class_name SavePassage


func _init():
	type = Passage.SAVE
	var action
	action = new_action(0, "Save")
	action.enable = func (): return Game.data._save_enabled
	new_action(1, "Load")
	new_action(2, "Delete")
	action = new_action(14, "Back")
	action.set_goto("End")

func on_action(key: int) -> void:
	if key == 0:
		Game.main_scene.sub_scene.set_mode(SaveScene.SAVE_MODE)
	if key == 1:
		Game.main_scene.sub_scene.set_mode(SaveScene.LOAD_MODE)
	if key == 2:
		Game.main_scene.sub_scene.set_mode(SaveScene.DELETE_MODE)
