
class_name Combat

const NORMAL = 0
const FIRE = 1
const WATER = 2
const NATURE = 3
const EARTH = 4
const DARK = 5

const ADV = 1.2
const DIS = 0.8
const NEU = 1.0


const TYPE_MODIFIERS = [
	[NEU, NEU, NEU, NEU, NEU, NEU],
	[ADV, NEU, DIS, ADV, DIS, ADV],
	[ADV, ADV, NEU, DIS, ADV, DIS],
	[ADV, DIS, ADV, NEU, ADV, DIS],
	[ADV, ADV, DIS, DIS, NEU, ADV],
	[ADV, DIS, ADV, ADV, DIS, NEU],
]

static func get_type_modifier(attack_type: int, body_type: int):
	return TYPE_MODIFIERS[attack_type][body_type]

static func get_tease_modifier(tease_types: Array, likes: Dictionary):
	var base = 1.0
	for type in tease_types:
		if type in likes:
			base *= likes[type]
	return base

static func enemy_attack(player, enemy, def_ratio):
	var move: Move= enemy.get_move()
	var rngesus = randf()
	var rngesus2 = randf() + randf()
	if rngesus < 0.05 or rngesus > 0.1 and rngesus2 * player.agi < 1.2 * enemy.agi:
		var mod = get_type_modifier(move.type, player.type)
		var a = int(mod * move.dmg * enemy.att - randf() * player.def * def_ratio)
		if a <= 0:
			a = 0
		Game.data.player.hp -= a
		return move.success_text + "(HP -{0})".format([a])
	else:
		return move.fail_text + "(HP -0)"

const PLAYER_ATTACK_DEFAULT = "You attack the enemy."
const PLAYER_ATTACK_FAIL_DEFAULT = "You try to attack the enemy. But the enemy evades."
static func player_attack(player, enemy):
	var rngesus = randf()
	var rngesus2 = randf() + randf()
	if rngesus < 0.05 or rngesus > 0.1 and rngesus2 * enemy.agi < 1.2 * player.agi:
		var mod = get_type_modifier(NORMAL, enemy.type)
		var a = int(player.att - randf() * enemy.def * 2 / 3)
		if a <= 0:
			a = 0
		enemy.hp -= a
		return PLAYER_ATTACK_DEFAULT + "(HP -{0})".format([a])
	else:
		return PLAYER_ATTACK_FAIL_DEFAULT + "(HP -0)"
