extends CanvasLayer


signal restart()


func show_game_over() -> void:
	get_tree().paused = true
	self.visible = true


func _on_restart_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	emit_signal("restart")
