extends Node

@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var game_over: CanvasLayer = $GameOver


func pause() -> void:
	get_tree().paused = !get_tree().paused
	pause_menu.visible = !pause_menu.visible


func show_game_over() -> void:
	get_tree().paused = !get_tree().paused
	game_over.visible = true
