extends CanvasLayer

signal pause()
signal restart()

var _is_paused: bool = false


func _on_resume_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	_is_paused = false


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			emit_signal("pause")
			_is_paused = true


func _on_restart_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	emit_signal("restart")
