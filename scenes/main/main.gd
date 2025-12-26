extends Node

@onready var level_handler: Node = $level_handler
@onready var menu_handler: Node = $menu_handler
@onready var audio_handler: Node = $audio_handler


func _ready() -> void:
	var temp = preload("res://scenes/levels/level2/level_2.tscn").instantiate()
	level_handler.add_child(temp)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			menu_handler.pause()


func _on_game_over_restart() -> void:
	level_handler.restart()


func on_game_over() -> void:
	menu_handler.show_game_over()
