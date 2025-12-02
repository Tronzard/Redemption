extends ParallaxLayer


@export var SPEED: float = -9


func _process(delta: float) -> void:
	self.motion_offset.x += SPEED * delta
