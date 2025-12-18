extends Node2D

@export var coin_layer_path: NodePath
@onready var coin_layer: TileMapLayer = get_node(coin_layer_path)
@onready var collected: Label = $UICanvasLayer/CoinUI/CoinContainer/Collected
@onready var total: Label = $UICanvasLayer/CoinUI/CoinContainer/Total
@onready var final_door: TileMapLayer = $FinalDoor

var total_coin_count: int
var collected_coins: int = 0


func _ready() -> void:
	total_coin_count = coin_layer.get_used_cells().size()
	total.text ="/ " + str(total_coin_count)
	collected.text = str(collected_coins)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			unlock_gate()

func _on_player_check_pickup(p_player_global_pos: Vector2) -> void:
	if coin_layer == null:
		return

	var local_pos: Vector2 = coin_layer.to_local(p_player_global_pos)
	var tile_pos: Vector2i = coin_layer.local_to_map(local_pos)
	var source_id: int = coin_layer.get_cell_source_id(tile_pos)

	if source_id != -1:
		coin_layer.erase_cell(tile_pos)
		increase_points()


func increase_points() -> void:
	collected_coins += 1
	collected.text = str(collected_coins)
	
	if total_coin_count == collected_coins:
		unlock_gate()

func unlock_gate() -> void:
	var m_unlock_tween = create_tween()
	m_unlock_tween.tween_property(final_door, "modulate:a", 0, 1)
	m_unlock_tween.play()
	
	await  m_unlock_tween.finished
	final_door.clear()
	push_error("unlocked")
	pass
