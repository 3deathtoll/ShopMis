extends RefCounted

class_name Enemy

var name: String
var hp: int
var maxhp: int
var att: int
var def: int
var agi: int

var intro:= LemonScript.new()
var image:= ""
var statuses:= []
var type:= Combat.NORMAL
var attack_moves:Array[Move]= []
var lust_moves:= []
var likes:= {}

var victory_passage:= ""
var defeat_passage:= ""
var drop: ItemDrop

func _init(name: String, maxhp: int, att: int, def: int, agi: int):
	self.name = name
	self.maxhp = maxhp
	self.hp = maxhp
	self.att = att
	self.def = def
	self.agi = agi

func ready():
	hp = maxhp
	for move in attack_moves:
		move.cooldown_timer = 0
	for move in lust_moves:
		move.cooldown_timer = 0

func add_move(move: Move):
	if move.category == Move.LUST:
		lust_moves.push_back(move)
	else:
		attack_moves.push_back(move)

func get_move():
	var moves = []
	for move in attack_moves:
		if move.cooldown_timer <= 0:
			moves.push_back(move)
#	for move in lust_moves: # TODO: handle this
#		if move.cooldown_timer <= 0:
#			moves.push_back(move)
	var i = randi_range(0, moves.size() - 1)
	return moves[i]



