extends Node

var is_landing: bool = false


func process_animation(player: CharacterBody2D) -> void:
	var anim: AnimatedSprite2D = player.get_node("AnimatedSprite2D")
	var movement := player.get_node("Movement")
	var combat := player.get_node("Combat")

	#Combat Override, overrides other animation
	if combat.is_attacking:
		return

	var direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if not movement.is_sliding: #Flip only when not sliding
		if direction != 0.0:
			anim.flip_h = direction < 0.0
		elif player.velocity.x != 0.0:
			anim.flip_h = player.velocity.x < 0.0

	#Landing logic
	if movement.was_in_air and player.is_on_floor():
		is_landing = true
		anim.play("land")

	if is_landing:
		if movement.is_sliding and player.is_on_floor():
			is_landing = false
		elif direction != 0.0 and player.is_on_floor():
			is_landing = false
		elif combat.is_attacking:
			is_landing = false
		elif not anim.is_playing() or anim.animation != "land":
			is_landing = false
		else:
			return

	#Sliding logic
	if movement.is_sliding and player.is_on_floor():
		anim.play("slide")
		return

	#Logic when in air
	if not player.is_on_floor():
		if player.velocity.y < 0.0:
			if movement.jump_count == 1:
				anim.play("double_jump")
			else:
				anim.play("jump")
		else:
			anim.play("fall")
		return

	#Combat override
	if combat.is_attacking:
		return

	#Ground states
	if direction == 0.0:
		anim.play("idle")
	else:
		anim.play("run")
