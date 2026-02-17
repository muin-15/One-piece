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

func _on_area_2d_body_entered(body):
	# 1. Check if the body that entered is the player.
	# We do this by checking if it belongs to a group named "player".
	# This is better than checking body.name == "Player" because it's more flexible.
	if body.is_in_group("player"):
		# 2. Check if the player object actually has a function called "take_damage".
		# This is a safety check to prevent sthe game from crashing if we hit something else.
		if body.has_method("take_damage"):
			
			# 3. If it's the player and they have the function, call it.
			# This is like sending a message: "Hey player, you've been hit!"
			body.take_damage()
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


# This function runs automatically whenever a solid body (like the player)
# enters the Area2D we just made. The 'body' variable is a reference to that object.
