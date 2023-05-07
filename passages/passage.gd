extends PassageBase

class_name Passage



var domain:= ""
var on_ready:= LemonScript.new()
var text:= LemonScript.new()
var image:= ""
var is_location: = false

static func parse(obj, default_domain = ""):
	var id = obj.get("id")
	if id == null:
		return
	var passage = Passage.new()
	passage.id = id
	passage.domain = obj.get("domain", default_domain)
	passage.on_ready.parse(str(obj.get("on_ready", "")))
	for error in passage.on_ready.get_errors():
		print("Error parsing Passage '{0}': ".format([id]) + error)
	passage.text.parse(str(obj.get("text", "")))
	for error in passage.text.get_errors():
		print("Error parsing Passage '{0}': ".format([id]) + error)
	passage.image = obj.get("image", "")
	passage.is_location = obj.get("is_location", false)
	if passage.is_location:
		passage.can_save = obj.get("can_save", true)
	var actions = obj.get("actions", [])
	for action_obj in actions:
		var action = Action.parse(action_obj, id)
		if action != null:
			actions.append(action)
	return passage

func load_from(obj: Dictionary):
	if obj.has("domain"):
		domain = obj.domain
	if obj.has("on_ready"):
		on_ready.parse(str(obj.on_ready))
		for error in on_ready.get_errors():
			print("Error parsing Passage '{0}': ".format([id]) + error)
	if obj.has("text"):
		text.parse(str(obj.text))
		for error in text.get_errors():
			print("Error parsing Passage '{0}': ".format([id]) + error)
	if obj.has("image"):
		image = obj.image
	if obj.has("is_location"):
		is_location = obj.is_location
	if is_location:
		can_save = obj.get("can_save", true)
	for action_obj in obj.get("actions", []):
		var action = Action.parse(action_obj, id)
		if action != null:
			actions.append(action)
