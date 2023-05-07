extends Node

const ACTION_UP = 5
const ACTION_DOWN = 7
const ACTION_NORTH = 6
const ACTION_WEST = 10
const ACTION_SOUTH = 11
const ACTION_EAST = 12

const ASSET_PATH = "res://assets/"

var data := GameData.new()

var main_scene: MainScene
var log_list: LogList
var current_passage: PassageBase
var passage_stack:= []

var maps:= Maps.new()

var enemy_data:= {}
var passages:= {}
var item_datas:= {}
var recipes:= {}

var factory_classes = [
	TrollFactory,
]

func _ready():
	var item
#	item = Item.new("Copper Ore", 1, 10)
#	data.items.add(item, item.qty, true)
#	item = Item.new("Tin Ore", 1, 10)
#	data.items.add(item, item.qty, true)
#	item = Item.new("Troll Blood", 1, 10)
#	data.items.add(item, item.qty, true)
#	item = Item.new("Troll Blood", 2, 10)
#	data.items.add(item, item.qty, true)
#	item = Item.new("Troll Blood", 3, 10)
#	data.items.add(item, item.qty, true)
	item = Item.new("Water", 1, 3)
	data.items.add(item, item.qty, true)
#	item = Item.new("Water", 2, 10)
#	data.items.add(item, item.qty, true)
	ItemFactory.init()
	RecipeFactory.init()
	TrollFactory.init()

	Game.add_passage("Inv", InvPassage.new())
	Game.add_passage("Supply", SupplyPassage.new())
	Game.add_passage("Showcase", ShowcasePassage.new())
	Game.add_passage("CraftMain", CraftPassage.new())
	Game.add_passage("CraftManual", CraftManualPassage.new())
	Game.add_passage("Data", SavePassage.new())
	Game.add_passage("PreFight", PreFightPassage.new())
	Game.add_passage("Fight", FightPassage.new())
	Game.add_passage("FightItem", FightItemPassage.new())
	Game.add_passage("FightEnd", FightEndPassage.new())

	load_lmn_files("res://scripts/")
	load_lmp_files("res://scripts/")
	maps.add_map_actions()

func load_lmn_files(dir: String):
	for dir_name in DirAccess.get_directories_at(dir):
		load_lmn_files(dir.path_join(dir_name))
	for filename in DirAccess.get_files_at(dir):
		if filename.ends_with(".lmn"):
			var file = FileAccess.open(dir.path_join(filename), FileAccess.READ)
			var obj = JSON.parse_string(file.get_as_text())
			var domain = obj.get("domain", "")
			var passage_array = obj.get("passages", [])
			for p_obj in passage_array:
				var id = p_obj.get("id")
				if not passages.has(id):
					var passage = Passage.new()
					passage.id = id
					passages[id] = passage
				if not p_obj.has("domain"):
					p_obj["domain"] = domain
				passages[id].load_from(p_obj)

func load_lmp_files(dir: String):
	for dir_name in DirAccess.get_directories_at(dir):
		load_lmp_files(dir.path_join(dir_name))
	for filename in DirAccess.get_files_at(dir):
		if filename.ends_with(".lmp"):
			var file = FileAccess.open(dir.path_join(filename), FileAccess.READ)
			var obj = JSON.parse_string(file.get_as_text())
			var map_id = obj.get("id")
			if map_id == null:
				return
			var map = maps.new_map(map_id)
			map.load_from(
				obj.get("nodes", []),
				obj.get("edges", []),
			)
			maps.load_global_edges(
				obj.get("global_edges", [])
			)

func load_asset(path: String):
	if path.is_empty(): return
	return load(ASSET_PATH.path_join(path))

func evaluate_text_from(passage: Passage):
	return passage.text.evaluate(passage.domain, data)

func add_passage(id: String, passage: PassageBase):
	passage.id = id
	passages[id] = passage

func new_passage(id: String) -> Passage:
	var passage = Passage.new()
	passage.id = id
	passages[id] = passage
	return passage

func add_location(id: String, location: Passage, map_id: String, pos: Vector2i) -> Passage:
	location.id = id
	location.is_location = true
	location.map_id = map_id
	location.x = pos.x
	location.y = pos.y
	passages[id] = location
	return location

func push_current_to_stack():
	passage_stack.push_back(current_passage.id)

var num_nesting:= 0
var max_nesting:= 0
func change_passage(id: String, do_ready:= true):
	if id == "End":
		do_ready = false
		if len(passage_stack) > 0:
			id = passage_stack.pop_back()
		else:
			id = data.current_location
	elif id == "ThisLocation":
		id = data.current_location
	current_passage = passages[id]
	if current_passage.type == PassageBase.PASSAGE and current_passage.is_location:
		data.current_location = id
	if do_ready:
		# code to allow calling change_passage() within ready
		if num_nesting <= 0:
			max_nesting = 0
		elif num_nesting > max_nesting:
			max_nesting = num_nesting
		num_nesting += 1
		current_passage.ready()
		num_nesting -= 1
		if num_nesting < max_nesting:
			return
		num_nesting += 1
		if current_passage is Passage:
			current_passage.on_ready.evaluate(current_passage.domain, data)
		num_nesting -= 1
		if num_nesting < max_nesting:
			return
	main_scene.load_passage(true)


func start_fight(enemy_id):
	data._reset_fight_scene = true
	data._enemy_id = enemy_id
	change_passage("PreFight")

func gain_crafted_item(item: Item):
	if item.name == "Healing Draught":
		data.aloysius.learn_progress = 1
	gain_item(item)

func gain_item(item: Item, qty:= -1):
	if qty <= 0:
		qty = item.qty
	var ret = data.items.add(item, qty, true)
	log_list.add_log("You gain {0}.".format([item.to_string()]), item.qty)
	return ret

func lose_item(item: Item, qty:= -1):
	if qty <= 0:
		qty = item.qty
	var ret = data.items.remove(item, qty)
	log_list.add_log("You lose {0}.".format([item.to_string()]), item.qty)
	return ret

func gain_money(money):
	log_list.add_log("You gain {0} coins.".format([money]))
	data.money += money

func lose_money(money):
	log_list.add_log("You lose {0} coins.".format([money]))
	data.money -= money

func save(path):
	data.timestamp = Time.get_datetime_string_from_system(false, true)
	var save = SaveUtil.to_saveable(data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save))
	file = null
	return {
		"name": data.player.name,
		"time": data.time,
		"timestamp": data.timestamp,
	}

func load_save(path):
	var file = FileAccess.open(path, FileAccess.READ)
	data = SaveUtil.from_saveable(GameData.new(), JSON.parse_string(file.get_as_text()))
	passage_stack = []
	current_passage = passages[data.current_location]
	main_scene.load_passage(true)
