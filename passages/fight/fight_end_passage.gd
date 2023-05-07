extends PassageBase

class_name FightEndPassage

func _init():
	type = Passage.FIGHT
	var action = new_action(0, "Next")
	action.set_goto("End")
	action.min = 15

func on_action(key: int) -> void:
	var player = Game.data.player.stats()
	if player.hp < 1:
		Game.data.player.hp = 1
	Game.data._reset_fight_scene = true





