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

	# -----------------------------------------------
	# PASTE THIS CODE HERE:
	# If we are hurt, apply movement but STOP the rest of the function
	# so we don't overwrite the 'dash1' animation.
	if is_invincible:
		move_and_slide()
		return
	# -----------------------------------------------

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		# ... rest of your code
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
	# If the player is already invincible (because they just got hit),
	# do nothing. Stop the function right here.
	if is_invincible:
		return
	
	# If we are NOT invincible, then...
	is_invincible = true # 1. Turn on invincibility.
	health -= 1          # 2. Subtract 1 from our health.
	print("Player health is now: ", health) # (Optional) Shows health in the Output window for debugging.
	if not sounds["walking"] or sounds ["jumping"]:
		sounds["dashing"].play()
	# 3. Tell the animation sprite to play the damage animation.
	$AnimatedSprite2D.play("dash1") 
	
	# 4. Check if the game is over.
	if health <= 0:
		print("GAME OVER")
		# For now, just reload the scene to restart.
		get_tree().reload_current_scene()
		
# --- ADD THIS EMPTY FUNCTION FOR NOW ---
# This function will be connected to a signal from the animation player.
# It will run automatically when ANY animation finishes.
func _on_animated_sprite_2d_animation_finished():
	# We only care if the "dash" animation was the one that finished.
	if $AnimatedSprite2D.animation == "dash1":
		# If it was, go back to the idle animation.
		$AnimatedSprite2D.play("idle")
		# And, most importantly, turn invincibility OFF so we can get hurt again.
		is_invincible = false
# -----------------------------------------


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		print("GOAL REACHED! Level Complete.")
		
		# *** This is the win action ***
		# Simply reload the scene, just like the player does on death.
		get_tree().reload_current_scene()# Replace with function body.
