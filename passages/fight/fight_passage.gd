extends PassageBase

class_name FightPassage

class FightDialogue extends RefCounted:
	var text:= ""
	var align_left:= true

	func _init(align_left, text):
		self.align_left = align_left
		self.text = text

var enemy: Enemy

const PLAYER_ATTACK_DEFAULT = "You attack the enemy."
const PLAYER_ATTACK_FAIL_DEFAULT = "You try to attack the enemy. But the enemy evades."
const DEFENSE_DEFAULT = "You take a defensive stance."
const WAIT_DEFAULT = "You wait."
const ESCAPE_DEFAULT = "You flee from the battle."
const FAIL_ESCAPE_DEFAULT = "You fail to escape."

const ENEMY_DESC = """{name}
{hp}/{maxhp}
"""

func _init():
	type = Passage.FIGHT
	var action
	action = new_action(0, "Fight")
	action = new_action(1, "Defend")
	action = new_action(10, "Item")
	action = new_action(13, "Wait")
	action = new_action(14, "Flee")

static func add_dialogue(align_left, text):
	Game.data._fight_dialogues.push_back(FightDialogue.new(align_left, text))

func ready():
	enemy = Game.enemy_data[Game.data._enemy_id]
	if Game.data._reset_fight_scene:
		enemy.ready()
		Game.data._fight_dialogues = []
#		add_dialogue(false, enemy.intro)

func on_action(key: int) -> void:
	var player = Game.data.player.stats()

	if key == 10:
		Game.push_current_to_stack()
		Game.change_passage("FightItem")

	if key == 14:
		if randf() * (player.agi + 40) > randf() * enemy.agi:
			add_dialogue(true, ESCAPE_DEFAULT)
			Game.change_passage("FightEnd")
			return
		else:
			add_dialogue(true, FAIL_ESCAPE_DEFAULT)
	elif key == 0:
		add_dialogue(true, Combat.player_attack(player, enemy))
	elif key == 1:
		add_dialogue(true, DEFENSE_DEFAULT)
	elif key == 13:
		add_dialogue(true, WAIT_DEFAULT)

	if key == 0 or key == 13 or key == 14:
		add_dialogue(false, Combat.enemy_attack(player, enemy, 2.0/3))
	elif key == 1:
		add_dialogue(false, Combat.enemy_attack(player, enemy, 4.0/3))

	player = Game.data.player.stats()
	if player.hp <= 0:
		Game.data.player.hp = 0
		if enemy.hp > 0:
			Game.lose_money(10)
			Game.passage_stack.push_back(enemy.defeat_passage)
			Game.change_passage("FightEnd")
			return

	if enemy.hp <= 0:
		enemy.hp = 0
		var item = enemy.drop.get_drop()
		Game.gain_item(item)
		Game.passage_stack.push_back(enemy.victory_passage)
		Game.change_passage("FightEnd")
		return

	Game.main_scene.sub_scene.refresh()


