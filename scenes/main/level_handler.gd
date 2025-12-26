extends Node

var levels: Dictionary = {
	2: "res://scenes/levels/level2/level_2.tscn"
}

func restart() -> void:
	var level = get_children()[0].get_level()
	get_children()[0].queue_free()
	#remove_child(level)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	add_child(load(levels[level]).instantiate())


func game_over() -> void:
	get_parent().on_game_over()
