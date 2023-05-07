extends RefCounted

class_name PassageBase


enum {
	PASSAGE,
	INV,
	CRAFT,
	CRAFT_MANUAL,
	SUPPLY,
	SHOWCASE,
	SAVE,
	FIGHT,
}

var id:= ""
var actions:= []
var type:= PASSAGE
var can_save:= false

func ready() -> void:
	pass

func update() -> void:
	pass

func exit() -> void:
	pass

func on_action(key: int) -> void:
	pass

func new_action(key: int, text: String) -> Action:
	var action = Action.new(key, text)
	actions.push_back(action)
	return action
