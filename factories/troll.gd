
class_name TrollFactory


static func init():
	var enemy = Enemy.new("Troll", 30, 10, 20, 15)
	Game.enemy_data[enemy.name] = enemy
	enemy.image = "troll.jpg"
	enemy.intro.parse("The giant rock in front of you starts moving. Only after a moment do you realize that the 'rock' isn't actually a rock but a Troll. He is less than five feet tall. His skin has a grey texture with some rocky bumps here and there. His spiky hair looks like grass. The thick member hanging between his legs appears dispropotionate with respect to his height. \"Booty! mine!\", he says in a groaning voice. You get ready to fight him.")
	enemy.type = Combat.EARTH
	enemy.likes = {
		"ass": 1.2,
		"vagina": 1.2,
	}
	var move

	move = Move.new(Move.PHYS)
	move.success_text = "The Troll rolls into a ball-like shape and charges towards you. He smashes into you using his rock-like body."
	move.fail_text = "The Troll rolls into a ball-like shape and charges towards you. You manage to jump out of his path."
	enemy.add_move(move)

	move = Move.new(Move.PHYS)
	move.success_text = "The Troll flails his rocky fists at you. Some of his hits land on you."
	move.fail_text = "The Troll flails his rocky fists at you. You manage to dodge his slow and clumsy attack."
	enemy.add_move(move)

	move = Move.new(Move.PHYS)
	move.success_text = "The Troll picked up a sharp stone and threw it at you. The stone hits you straight on the face. You are stunned." # TODO: implement stun
	move.fail_text = "The Troll picked up a sharp stone and threw it at you. You swerve to the side narrowly avoiding the stone."
	enemy.add_move(move)

	move = Move.new(Move.LUST)
	move.success_text = "The Troll is sensually stroking his member in an attempt to entice you. His hands are making wet noises due to the precum."
	enemy.add_move(move)

	move = Move.new(Move.LUST)
	move.success_text = "The Troll makes an inviting gesture. He is trying to convince you to surrender yourself to his loving embrace."
	enemy.add_move(move)

	enemy.drop = ItemDrop.new()
	enemy.drop.add_component("Troll Blood", 1, 1, 45)
	enemy.drop.add_component("Copper Ore", 1, 1, 50)
	enemy.drop.add_component("Tin Ore", 1, 1, 50)

	enemy.victory_passage = "TrollVictory"
	enemy.defeat_passage = "TrollDefeatAss"
