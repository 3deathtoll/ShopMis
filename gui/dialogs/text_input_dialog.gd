extends Control

@onready
var line_edit = $MarginContainer/MarginContainer/VBox/LineEdit
@onready
var label = $MarginContainer/MarginContainer/VBox/Label

var on_submit

func launch(query, text, on_submit=null):
	label.text = query
	line_edit.text = text
	self.on_submit = on_submit
	show()
	line_edit.grab_focus.call_deferred()

func _on_line_edit_text_submitted(new_text):
	if on_submit:
		on_submit.call(line_edit.text)
	hide()
	Game.main_scene.load_passage()

func _on_ok_button_down():
	if on_submit:
		on_submit.call(line_edit.text)
	hide()
	Game.main_scene.load_passage()

func _on_cancel_button_down():
	hide()

