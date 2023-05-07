extends RefCounted

class_name ItemData

const LEVEL_TO_RARITY = [
	0, #but actually 1
	10,
	25,
	50,
	80,
	120,
	170,
	230,
	300,
]

var name: String
var base_price: int
var base_factor: int
var buy_price: int
var buy_factor: int
var base_level:= 1
var type: String
var demand: int
var desc: String
var on_combat_use = null
var on_use = null
var exhaust_on_use:= false
var equip_slot:= ""

var attributes:= {}

func _init(name: String):
	self.name = name

func add_attribute(key, value):
	attributes[key] = value
