extends RefCounted

class_name Aloysius

var has_met:= false
var start_learn:= false
var learn_progress:= 0

func learn():
	if not start_learn:
		Game.change_passage("AloysiusLearnStart")
	elif learn_progress == 1:
		Game.change_passage("AloysiusQuest1Completed")
	else:
		Game.change_passage("AloysiusLearnWait")
