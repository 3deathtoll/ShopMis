extends Control

class_name MainScene

@onready
var grid_buttons := $HBox/CenterPanel/Margin2/GridButtons.get_children()
@onready
var label_player := $HBox/LeftPanel/MarginContainer/VBox/LabelPlayer
@onready
var label_item := $HBox/LeftPanel/MarginContainer/VBox/LabelItem
@onready
var label_clock := $HBox/LeftPanel/MarginContainer/VBox/LabelClock


@onready
var hbox:= $HBox/CenterPanel/Margin/HBox

@onready
var map_text_scene:= $HBox/CenterPanel/Margin/HBox/MapText
@onready
var inv_scene:= $HBox/CenterPanel/Margin/HBox/Inv
@onready
var craft_scene:= $HBox/CenterPanel/Margin/HBox/Craft
@onready
var craft_manual_scene:= $HBox/CenterPanel/Margin/HBox/CraftManual
@onready
var supply_scene:= $HBox/CenterPanel/Margin/HBox/Supply
@onready
var showcase_scene:= $HBox/CenterPanel/Margin/HBox/Showcase
@onready
var save_scene:= $HBox/CenterPanel/Margin/HBox/Save
@onready
var fight_scene:= $HBox/CenterPanel/Margin/HBox/Fight

@onready
var text_input_dialog:= $TextInputDialog

var sub_scene = null
var same_sub_scene := false

const PLAYER_DESC = """{name}
{hp}/{maxhp}
"""
const CLOCK_DESC = """{money}c
{time}
"""
const ITEM_DESC = """{name}
{desc}
"""

func _ready():
	print("TODO: fix nesting")
	print("Read all TODOs")
#	OS.low_processor_usage_mode = true
	text_input_dialog.hide()
	Game.main_scene = self
	Game.log_list = $HBox/LeftPanel/MarginContainer2/LogList
	var i = 0
	for button in grid_buttons:
		button.button_up.connect(_on_action_button_up.bind(i))
		i+=1
	Game.change_passage("HomeShop")
	Game.change_passage("IntroName")
	Game.data.do_call("recover", [], "")
	var test = LemonScript.new()
	test.parse("{open_shop(1)}")
#	print(JSON.stringify(SaveUtil.to_saveable(Game.data), "\t"))
#	print(SaveUtil.to_saveable(Item.new("name", 1, 1)))
	var save = SaveUtil.to_saveable(Game.data)
#	print(save)
	SaveUtil.from_saveable(Game.data, save)
	save = SaveUtil.to_saveable({
		"Weapon": Item.new("Bronze Knife", 1, 1),
	})
	print(0 if "" else 2)
#	print(test.parsed_nodes[0].type)

#	print(test.evaluate("maplewick", Game.data))


func load_passage(start:= false):
	var passage = Game.current_passage
	passage.update()
	for child in hbox.get_children():
		child.hide()
	if start and sub_scene:
		sub_scene.end()
	if passage.type == Passage.INV:
		sub_scene = inv_scene
	elif passage.type == Passage.CRAFT:
		sub_scene = craft_scene
	elif passage.type == Passage.CRAFT_MANUAL:
		sub_scene = craft_manual_scene
	elif passage.type == Passage.SUPPLY:
		sub_scene = supply_scene
	elif passage.type == Passage.SHOWCASE:
		sub_scene = showcase_scene
	elif passage.type == Passage.SAVE:
		sub_scene = save_scene
	elif passage.type == Passage.FIGHT:
		sub_scene = fight_scene
	else:
		sub_scene = map_text_scene
	if start:
		sub_scene.start()
	elif sub_scene == map_text_scene:
		sub_scene.light_refresh()
	sub_scene.show()

	refresh_left_panel(start)

func refresh_left_panel(start:=true):
	var player = Game.data.player
	label_player.text = PLAYER_DESC.format({
		"name": player.name,
		"hp": player.hp,
		"maxhp": player.stats().maxhp,
	})
	if start:
		set_label_item(null)
	label_clock.text = CLOCK_DESC.format({
		"time": Game.data.time,
		"money": Game.data.money,
	})
	reload_actions()

func set_label_item(item):
	if item == null or item.is_dummy():
		label_item.text = ""
		return
	var data = Game.item_datas[item.name]
	label_item.text = ITEM_DESC.format({
		"name": item.name,
		"desc": data.desc,
	})

func reload_actions():
	var i = 0
	for button in grid_buttons:
		i+=1
		button.text = ""
		button.disabled = true
	var passage = Game.current_passage
	for action in passage.actions:
		var text = action.text
		i = action.key
		var show = action.show
		if show is Callable:
			show = show.call()
		elif show is LemonScript:
			show = show.evaluate_value(passage.domain, Game.data)
		if show:
			grid_buttons[i].text = text
			var enable = action.enable
			if enable is Callable:
				enable = enable.call()
			elif enable is LemonScript:
				enable = enable.evaluate_value(passage.domain, Game.data)
			if enable:
				grid_buttons[i].disabled = false

func _unhandled_key_input(event):
	if event is InputEventKey and not event.is_pressed():
		var key = Util.rev_key(event.keycode)
		if key >= 0: _on_action_button_up(key)

func _on_action_button_up(key: int):
	var passage = Game.current_passage
	for action in passage.actions:
		if key == action.key and not grid_buttons[key].disabled:
			passage.on_action(key)
			if action.min:
				Game.data.time.add_min(action.min)
			if action.do:
				action.do.evaluate(passage.domain, Game.data)
			if action.goto:
				if action.stack_push_back:
					Game.push_current_to_stack()
				Game.change_passage(action.goto)
			else:
				load_passage()

func _on_inv_button_up():
	if Game.current_passage.can_save: # TODO change to can_open_menu
		Game.change_passage("Inv")
	elif Game.current_passage.type == Passage.INV:
		Game.change_passage("End")

func _on_craft_button_up():
	if Game.current_passage.can_save:
		Game.change_passage("CraftMain")
	elif Game.current_passage.type == Passage.CRAFT or Game.current_passage.type == Passage.CRAFT_MANUAL:
		Game.change_passage("End")

func _on_data_button_up():
	if Game.current_passage.type == Passage.SAVE:
		Game.change_passage("End")
	else:
		Game.data._save_enabled = Game.current_passage.can_save
		Game.passage_stack.push_back(Game.current_passage.id)
		Game.change_passage("Data")
