extends BaseEnemy


@onready var sprite: AnimatedSprite2D = $Path2D/PathFollow2D/AnimatedSprite2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D


var direction := 1  
@export var speed := 0.5 


func _ready() -> void:
	sprite.play("walk")


func _process(delta: float) -> void:
	path_follow.progress_ratio += delta * 0.1


func _physics_process(_delta: float) -> void:
	if path_follow.progress_ratio >= 0.5:
		sprite.flip_h = false
		
	else:
		sprite.flip_h = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	_on_body_entered(body)
