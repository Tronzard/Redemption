extends Node

var is_attacking: bool = false


func process_combat(player: CharacterBody2D) -> void:
	var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var movement := player.get_node("Movement")
	var anim := player.get_node("AnimatedSprite2D")

	if Input.is_action_just_pressed("ui_attack") and not is_attacking:
		is_attacking = true

		if movement.is_sliding:
			anim.play("attack_slide")
		elif not player.is_on_floor():
			anim.play("attack_jump")
		elif direction != 0.0:
			anim.play("attack_run")
		else:
			anim.play("attack_idle")

	if is_attacking:
		if not anim.is_playing() or not anim.animation.begins_with("attack"):
			is_attacking = false
