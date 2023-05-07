extends RefCounted

class_name LemonadeEngine

func get_parent_of(root, names):
	if len(names) == 0:
		return
	var node = root
	var i := 0
	while i < len(names) - 1:
		node = node.get(names[i])
		if node == null:
			return
		if typeof(node) not in [
			TYPE_DICTIONARY,
			TYPE_OBJECT
		]:
			return
		i+=1
	return node

func get_value(key: String, domain: String):
	var names = key.split(".", false)
	var d_names = domain.split(".", false)

	if len(d_names) != 0:
		var parent = get_parent_of(self, d_names+names)
		if parent != null and names[-1] in parent:
			return parent.get(names[-1])

	var parent = get_parent_of(self, names)
	if parent != null:
		return parent.get(names[-1])

func set_value(key: String, value, domain: String):
	var names = key.split(".", false)
	var d_names = domain.split(".", false)

	if len(d_names) != 0:
		var parent = get_parent_of(self, d_names+names)
		if parent != null and names[-1] in parent:
			parent.set(names[-1], value)
			return

	var parent = get_parent_of(self, names)
	if parent != null:
		if typeof(parent) == TYPE_DICTIONARY:
			parent[names[-1]] = value
		else:
			parent.set(names[-1], value)

func do_call(key: String, args: Array, domain: String):
	if key == "len":
		if len(args) < 1:
			print("Error: len() call with no arguments")
			return 0
		return len(args[0])
	var names = key.split(".", false)
	var d_names = domain.split(".", false)

	if len(d_names) != 0:
		var parent = get_parent_of(self, d_names+names)
		if parent != null and names[-1] in parent:
			var node = parent.get(names[-1])
			if typeof(node) == TYPE_CALLABLE:
				return node.callv(args)

	var parent = get_parent_of(self, names)
	if parent != null:
		var node = parent.get(names[-1])
		if typeof(node) == TYPE_CALLABLE:
			return node.callv(args)
