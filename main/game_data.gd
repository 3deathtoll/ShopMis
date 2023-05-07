extends LemonadeEngine

class_name GameData

var timestamp:= ""
var version:= {
	"major": 0,
	"minor": 1,
	"revision": 0
}
var time:= Clock.new(0, 18, 0)
var player:= Player.new("Zoe", 50, 10, 10, 10)
var equipments:= {
	"Weapon": Item.new("Bronze Knife", 1, 1),
}

var body:= {
	"boob_size": 0,
	"body_shape": "Average",
	"body_type": "Human",
	"hair_color": "Black",
	"mutablity": 30,
}
var money:= 100
var items:= ItemDict.new()
var showcased_items:= ItemDict.new()
var known_recipes:= [
#	"Healing Draught",
#	"Bronze Ingot"
]
var last_supply:= -1
var supply_list:= ItemDict.new()
var next_item_pos:= 0
var recent_item_pos:= {}
var current_location:= ""

var _save_enabled:= false
var _order_list:= ItemDict.new()
var _recipe:= Recipe.dummy()
var _total_cost:= 0
var _gain:= 0
var _chosen_item:= Item.dummy()
var _enemy_id:= ""
var _reset_fight_scene:= false
var _fight_dialogues:= []

# chapters
var maplewick:= Maplewick.new()
var aloysius:= Aloysius.new()
var dreary_woods:= DrearyWoods.new()

func recover():
	Game.data.player.hp = Game.data.player.maxhp

func text_input(query, name):
	if name == null: return
	Game.main_scene.text_input_dialog.launch(
		query,
		get_value(name.key, name.domain),
		func (text): set_value(name.key, text, name.domain)
	)

func goto(id):
	Game.change_passage(id)

func learn_recipe(title):
	if not title in known_recipes:
		known_recipes.append(title)
