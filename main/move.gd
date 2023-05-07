extends RefCounted

class_name Move

const PHYS = 0
const LUST = 1

var category: int
var success_text: String
var fail_text: String
var dmg:= 1
var type:= Combat.NORMAL
var cooldown:= 0
var cooldown_timer:= 0
var afflicts:= []

func _init(category: int):
	self.category = category

