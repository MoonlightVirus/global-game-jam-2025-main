extends CharacterBody3D

const SPEED = 5.0  # Movement speed
const ROTATION_SPEED = 2.0  # How fast the player rotates (radians per second)
func logaAccele():
	for i in range(0, 10):  # Loop from 0 to 9 (10 iterations)
		var value = i * 0.1  # Convert to a float value
	
func _physics_process(delta: float) -> void:
	# Handle rotation when pressing A/D
	if Input.is_action_pressed("left"):  # A key
		rotation.y += ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):  # D key
		rotation.y -= ROTATION_SPEED * delta

	# Get forward/backward input
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("up"):  # W key
		for i in range(0,10):
			input_dir.z -= i * 0.1
	if Input.is_action_pressed("down"):  # S key
		input_dir.z += 1.0
	if Input.is_action_pressed("z-axis up"):  # W key
		input_dir.y -= 1.0
	if Input.is_action_pressed("z-axis down"):  # S key
		input_dir.y += 1.0

	# Transform the input direction into the character's local space
	input_dir = transform.basis * input_dir.normalized()

	# Set velocity based on input direction
	velocity.x = input_dir.x * SPEED
	velocity.z = input_dir.z * SPEED
	velocity.y = input_dir.y * SPEED

	# Apply movement
	move_and_slide()
