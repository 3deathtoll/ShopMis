extends Passage

class_name PreFightPassage

func _init():
	var action
	action = new_action(0, "Next")
	action.set_goto("Fight")


func ready():
	var enemy = Game.enemy_data[Game.data._enemy_id]
	text = enemy.intro
	image = enemy.image

