extends Control

const FightDialogueLeft = preload("res://gui/fight/fight_dialogue_left.tscn")
const FightDialogueRight = preload("res://gui/fight/fight_dialogue_right.tscn")

const ENEMY_DESC = """{name}
{hp}/{maxhp}
"""

@onready
var vbox = $HBox/ScrollContainer/VBox
@onready
var vbox_parent = $HBox/ScrollContainer
@onready
var label = $HBox/Label


func _ready():
	pass

func start():
	if Game.data._reset_fight_scene:
		vbox.free()
		vbox = VBoxContainer.new()
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox_parent.add_child(vbox)
		Game.data._reset_fight_scene = false
	refresh()

func refresh():
	var enemy = Game.enemy_data[Game.data._enemy_id]
	label.text = ENEMY_DESC.format({
		"name": enemy.name,
		"hp": enemy.hp,
		"maxhp": enemy.maxhp
	})
	var flag = false
	for dialogue in Game.data._fight_dialogues:
		flag = true
		var node
		if dialogue.align_left:
			node = FightDialogueLeft.instantiate()
		else:
			node = FightDialogueRight.instantiate()
		node.set_text(dialogue.text)
		vbox.add_child(node)
	Game.data._fight_dialogues = []
	if flag:
		await get_tree().process_frame
		var scroll_bar = vbox_parent.get_v_scroll_bar()
		scroll_bar.value = scroll_bar.max_value

func end():
	if Game.data._reset_fight_scene:
		vbox.free()
		vbox = VBoxContainer.new()
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		vbox_parent.add_child(vbox)
		Game.data._reset_fight_scene = false


