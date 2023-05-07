extends ScrollContainer

class_name LogList

const MAX_LOGS = 20

@onready
var vbox = $VBox

var last_log:= ""
var count:= 0

func add_log(text, num:= 1):
	if num < 1: return
	if count > 0 and text == last_log:
		count += num
		var node = vbox.get_children()[-1]
		node.text = "{0} (x{1})".format([
			text,
			count,
		])

	else:
		count = num
		last_log = text
		var node = Label.new()
		node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		if count == 1:
			node.text = text
		else:
			node.text = "{0} (x{1})".format([
			text,
			count,
		])
		vbox.add_child(node)
		if vbox.get_child_count() > MAX_LOGS:
			vbox.get_child(0).free()

	await get_tree().process_frame
	var scroll_bar = get_v_scroll_bar()
	scroll_bar.value = scroll_bar.max_value


