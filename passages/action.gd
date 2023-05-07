extends RefCounted

class_name Action

var key: int
var text:= ""
var tooltip:= ""
var goto:= ""
var min:= 0
var event:= ""
var enable = true
var show = true
var stack_push_back:= false
var do: LemonScript

func _init(key: int, text: String) -> void:
	self.key = key
	self.text = text

# if 2 arguments then goto is location else can be passage or location
func set_goto(goto:String, event:= ""):
	self.goto = goto
	self.event = event

static func parse(obj, passage_id):
	var key = obj.get("key")
	if not typeof(key) == TYPE_FLOAT:
		return
	key = int(key)
	if key < 0 or key >= 15:
		return
	var text = str(obj.get("text"))
	var action = Action.new(key, text)
	action.tooltip = obj.get("tooltip", "")
	action.goto = obj.get("goto", "")
	action.min = obj.get("min", 0)
	action.event = obj.get("event", "")
	if obj.has("enable"):
		if typeof(obj.enable) == TYPE_BOOL:
			action.enable = obj.enable
		else:
			action.enable = LemonScript.new()
			action.enable.parse(obj.enable)
			for error in action.enable.get_errors():
				print("Error parsing Passage '{0}': ".format([passage_id]) + error)
	if obj.has("show"):
		if typeof(obj.show) == TYPE_BOOL:
			action.show = obj.show
		else:
			action.show = LemonScript.new()
			action.show.parse(obj.show)
			for error in action.show.get_errors():
				print("Error parsing Passage '{0}': ".format([passage_id]) + error)
	action.stack_push_back = obj.get("stack_push_back", false)
	if obj.has("do"):
		action.do = LemonScript.new()
		action.do.parse(obj.do)
		for error in action.do.get_errors():
			print("Error parsing Passage '{0}': ".format([passage_id]) + error)
	return action
