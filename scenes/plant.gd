extends CharacterBody2D

var target_height = 200.0 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_force = -sqrt(2 * gravity * target_height)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage()
		call_deferred("queue_free")
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = jump_force
	move_and_slide()
