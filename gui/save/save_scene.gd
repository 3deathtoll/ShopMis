extends Control
class_name SaveScene
const SaveListItem = preload("res://gui/save/save_list_item.tscn")

const SAVE_PATH = "user://saves/save{0}.json"
const SAVE_DIR_PATH = "user://saves"
const NUM_SAVES = 14
const SAVE_MODE = 0
const LOAD_MODE = 1
const DELETE_MODE = 2
@onready
var title_label = $VBoxContainer/Label
@onready
var grid = $VBoxContainer/ScrollContainer/GridContainer
@onready
var grid_parent = $VBoxContainer/ScrollContainer

@onready
var button_group:= ButtonGroup.new()
var mode:= SAVE_MODE

func _ready():
	button_group.pressed.connect(on_button_group_pressed)

func set_mode(mode):
	self.mode = mode
	if mode == SAVE_MODE:
		title_label.text = "Save"
	elif mode == LOAD_MODE:
		title_label.text = "Load"
	elif mode == DELETE_MODE:
		title_label.text = "Delete"

func start():
	if Game.data._save_enabled:
		set_mode(SAVE_MODE)
	else:
		set_mode(LOAD_MODE)

	grid.free()
	grid = GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid_parent.add_child(grid)

	for i in NUM_SAVES:
		var save_desc = null
		var file_name = SAVE_PATH.format([i+1])
		DirAccess.make_dir_recursive_absolute(SAVE_DIR_PATH)
		if FileAccess.file_exists(file_name):
			FileAccess.open(file_name, FileAccess.READ)
			var file = FileAccess.open(file_name, FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			save_desc = {
				"name": data.player.name,
				"time": SaveUtil.from_saveable(Clock.new(0, 0, 0), data.time),
				"timestamp": data.timestamp,
			}
		var list_item = SaveListItem.instantiate()
		list_item.id = i+1
		list_item.save_desc = save_desc
		grid.add_child(list_item)
		list_item.set_button_group(button_group)
		list_item.refresh()

func refresh():
	pass
#	for child in grid.get_children():
#		child.refresh()

func end():
	pass

func on_button_group_pressed(button):
	var list_item = button.get_parent()
	var id = list_item.id
	var file_path = SAVE_PATH.format([id])
	if mode == SAVE_MODE:
		if Game.data._save_enabled:
			list_item.save_desc = Game.save(file_path)
			list_item.refresh()
	elif mode == LOAD_MODE:
		if list_item.save_desc:
			Game.load_save(file_path)
	elif mode == DELETE_MODE:
		DirAccess.remove_absolute(file_path)
		list_item.save_desc = null
		list_item.refresh()


