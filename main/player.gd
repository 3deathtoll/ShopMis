extends RefCounted

class_name Player

var name: String
var hp: int
var maxhp: int
var att: int
var def: int
var agi: int
var tdmg: int
var sens: int
var tres: int


var type:= Combat.NORMAL
var statuses:= []

func _init(name: String, maxhp: int, att: int, def: int, agi: int):
	self.name = name # TODO: remove these from arguments
	self.maxhp = maxhp
	self.hp = maxhp
	self.att = att
	self.def = def
	self.agi = agi
	tdmg = 15
	sens = 15
	tres = 15

func stats():
	var ret = {
		"name": name,
		"hp": hp,
		"maxhp": maxhp,
		"att": att,
		"def": def,
		"agi": agi,
		"tdmg": tdmg,
		"sens": sens,
		"tres": tres,
		"type": type,
	}
	for item in Game.data.equipments.values():
		if item and not item.is_dummy():
			var item_data = Game.item_datas[item.name]
			for key in item_data.attributes:
				if ret.has(key):
					ret[key] += item_data.attributes[key]
	return ret

func get_type():
	return Combat.NORMAL
