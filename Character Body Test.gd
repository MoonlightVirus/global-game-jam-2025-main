extends CharacterBody3D

@export var bubble_scene: PackedScene  = load("res://Scripts/Projectile Scripts (3)/projectile_(bubble_float).tscn")  # Reference to the bubble scene# Bubble scene reference to be set in the editor
@export var spawn_offset: Vector3 = Vector3(0, 1, -2)  # Offset from character position

const SPEED = 8.0  # Movement speed
const ROTATION_SPEED = 3.0  # How fast the player rotates (radians per second)
const ACCELERATION = 2.0  # Acceleration speed
const DECELERATION = 3.0  # Deceleration speed
var target_rotation_y = 0.0


# Target velocity for smoothing
var target_velocity: Vector3 = Vector3.ZERO

# Handles input events
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("shoot"):  # Check for the "shoot" action (Space or another key)
		shoot_bubble()
		print("Bubble Shot!")

# Function to shoot the bubble

func shoot_bubble():
	if bubble_scene:
		# Create an instance of the bubble
		var bubble = bubble_scene.instantiate()

		# Set the bubble's starting position based on the character's position + offset
		bubble.global_transform.origin = global_transform.origin + (transform.basis * spawn_offset)

		# Set the bubble's rotation to match the character's rotation
		bubble.rotation = rotation  # Set projectile rotation to match character's rotation

		# Get the direction the player is facing (forward vector)
		var forward_direction = transform.basis.z.normalized()  # The forward vector of the character

		# Apply the forward direction to the bubble's velocity
		var bubble_velocity = forward_direction * SPEED  # Set the bubble's velocity

		# Ensure the bubble's script has a `linear_velocity` property
		if bubble is RigidBody3D:
			bubble.linear_velocity = bubble_velocity

		# Add the bubble to the scene
		get_tree().get_current_scene().add_child(bubble)


# Handles character movement and rotation
func _physics_process(delta: float) -> void:
	# Handle rotation when pressing A/D
	if Input.is_action_pressed("left"):  # A key
		target_rotation_y += ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):  # D key
		target_rotation_y -= ROTATION_SPEED * delta

	# Get forward/backward input (W/S or up/down keys)
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("up"):  # W key
		input_dir.z -= 1.0
	if Input.is_action_pressed("down"):  # S key
		input_dir.z += 1.0
	if Input.is_action_pressed("z-axis up"):  # W key
		input_dir.y -= 1.0
	if Input.is_action_pressed("z-axis down"):  # S key
		input_dir.y += 1.0
	
	# Transform the input direction into the character's local space
	target_velocity = transform.basis * input_dir * SPEED

	# Smoothly interpolate velocity towards the target velocity
	velocity.x = lerp(velocity.x, target_velocity.x, ACCELERATION * delta if target_velocity.x != 0 else DECELERATION * delta)
	velocity.y = lerp(velocity.y, target_velocity.y, ACCELERATION * delta if target_velocity.y != 0 else DECELERATION * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, ACCELERATION * delta if target_velocity.z != 0 else DECELERATION * delta)

	# Smoothly interpolate rotation
	rotation.y = lerp_angle(rotation.y, target_rotation_y, 0.1)

	# Apply movement
	move_and_slide()
