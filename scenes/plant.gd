extends CharacterBody2D

# --- Settings ---
# The target height (positive number, we handle the negative in math)
var target_height = 200.0 

# Get the project's gravity settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# --- Math Magic ---
# This formula calculates exactly how much velocity is needed to reach
# a specific height based on the current gravity.
# Formula: v = sqrt(2 * gravity * height)
# We make it negative because in Godot, Up is Negative.
var jump_force = -sqrt(2 * gravity * target_height)

func _physics_process(delta):
	# 1. Apply Gravity (Fall down)
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# 2. Continuous Jump Logic
	# If we are on the floor, immediately jump again.
	else:
		velocity.y = jump_force
		
		# Optional: Play your animation here if you have one
		# $AnimatedSprite2D.play("jump")

	move_and_slide()
