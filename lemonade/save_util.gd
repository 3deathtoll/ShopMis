extends RefCounted

class_name SaveUtil

static func to_saveable(obj):
	if obj == null:
		return
	if typeof(obj) in [
		TYPE_BOOL,
		TYPE_INT,
		TYPE_FLOAT,
		TYPE_STRING,
	]:
		return obj
	if typeof(obj) == TYPE_ARRAY:
		var ret = []
		ret.resize(len(obj))
		for i in len(obj):
			ret[i] = to_saveable(obj[i])
		return ret
	if typeof(obj) == TYPE_DICTIONARY:
		var ret = {}
		for key in obj:
			if not key.begins_with("_"):
				ret[key] = to_saveable(obj[key])
		return ret
	if typeof(obj) == TYPE_OBJECT:
		if obj.has_method("to_saveable"):
			return to_saveable(obj.to_saveable())
		var ret = {}
		for prop in obj.get_property_list():
			if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
				if not prop.name.begins_with("_"):
					ret[prop.name] = to_saveable(obj.get(prop.name))
		return ret

static func from_saveable(obj, save):
	if typeof(obj) == TYPE_INT:
		if typeof(save) == TYPE_FLOAT:
			return int(save)
	elif typeof(obj) == TYPE_DICTIONARY:
		if typeof(save) == TYPE_DICTIONARY:
			for key in save:
				if key in obj:
					obj[key] = from_saveable(obj[key], save[key])
			return obj
	elif typeof(obj) == TYPE_OBJECT:
		if obj.has_method("from_saveable"):
			obj.from_saveable(save)
			return obj
		if typeof(save) == TYPE_DICTIONARY:
			for key in save:
				if key in obj and not obj.has_method(key):
					obj.set(key,
						from_saveable(obj.get(key), save[key])
					)
			return obj
	return save

