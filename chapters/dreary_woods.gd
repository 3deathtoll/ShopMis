extends RefCounted

class_name DrearyWoods

func check_encounter():
	if randf() < 0.3:
		Game.start_fight("Troll")
