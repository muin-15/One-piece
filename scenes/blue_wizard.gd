extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DOUBLE_VELOCITY = -800.0
var health = 3
var max_health = 3
var is_invincible = false

@onready var sounds={
	"walking":$AnimatedSprite2D/walk,
	"jumping":$AnimatedSprite2D/jump,
	"dashing":$AnimatedSprite2D/dash
}
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_invincible:
		move_and_slide()
		return

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sounds["jumping"].play()
	if Input.is_action_just_pressed("double_jump") and is_on_floor():
		velocity.y = DOUBLE_VELOCITY
		sounds["jumping"].play()
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
			
		sounds["walking"].stop()
	elif velocity.x!=0:
		$AnimatedSprite2D.play("walk")
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true #left
		else:
			$AnimatedSprite2D.flip_h = false #right
		if not sounds["walking"].playing:
			sounds["walking"].play()
	else:
		$AnimatedSprite2D.play("idle")
		sounds["walking"].stop()
	move_and_slide()
	print(velocity.x)

func take_damage():
	if is_invincible:
		return
	
	is_invincible = true 
	health -= 1          
	if not sounds["walking"] or sounds ["jumping"]:
		sounds["dashing"].play()
	$AnimatedSprite2D.play("dash1") 
	if health <= 0:
		print("GAME OVER")
		get_tree().reload_current_scene()
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "dash1":
		$AnimatedSprite2D.play("idle")
		is_invincible = false
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("GOAL REACHED! Level Complete.")
		get_tree().reload_current_scene()
