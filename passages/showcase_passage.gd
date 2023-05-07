extends PassageBase

class_name ShowcasePassage

func _init():
	type = Passage.SHOWCASE
	var action: Action
	action = new_action(14, "Back")
	action.set_goto("End")
