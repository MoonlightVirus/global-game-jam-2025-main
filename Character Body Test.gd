extends CharacterBody3D

@export var bubble_scene: PackedScene = load("res://Scripts/Projectile Scripts (3)/projectile_(bubble_float).tscn")
@export var spawn_offset: Vector3 = Vector3(0, 1, -2)

const SPEED = 8.0
const ROTATION_SPEED = 3.0
const ACCELERATION = 2.0
const DECELERATION = 3.0

var target_rotation_y = 0.0
var target_velocity: Vector3 = Vector3.ZERO

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("shoot"):
		shoot_bubble()

func shoot_bubble():
	if bubble_scene:
		var bubble = bubble_scene.instantiate()
		bubble.global_transform.origin = global_transform.origin + (transform.basis * spawn_offset)
		bubble.rotation = rotation
		var forward_direction = -transform.basis.z.normalized()
		var bubble_velocity = forward_direction * SPEED

		if bubble.has_method("set_linear_velocity"):
			bubble.set_linear_velocity(bubble_velocity)
		elif bubble.has_property("linear_velocity"):
			bubble.linear_velocity = bubble_velocity

		get_tree().get_current_scene().add_child(bubble)

func _physics_process(delta: float) -> void:
	var input_dir = Vector3.ZERO

	# Movement inputs
	if Input.is_action_pressed("up"):  # W or up arrow
		input_dir.z -= 1.0
	if Input.is_action_pressed("down"):  # S or down arrow
		input_dir.z += 1.0
	if Input.is_action_pressed("left"):  # A key
		target_rotation_y += ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):  # D key
		target_rotation_y -= ROTATION_SPEED * delta
	if Input.is_action_pressed("z-axis up"):  # Fly up
		input_dir.y += 1.0
	if Input.is_action_pressed("z-axis down"):  # Fly down
		input_dir.y -= 1.0

	# Calculate target velocity based on movement inputs
	target_velocity = transform.basis * input_dir * SPEED

	# Smooth velocity interpolation
	velocity.x = lerp(velocity.x, target_velocity.x, ACCELERATION * delta if target_velocity.x != 0 else DECELERATION * delta)
	velocity.y = lerp(velocity.y, target_velocity.y, ACCELERATION * delta if target_velocity.y != 0 else DECELERATION * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, ACCELERATION * delta if target_velocity.z != 0 else DECELERATION * delta)

	# Smoothly rotate the character
	rotation.y = lerp_angle(rotation.y, target_rotation_y, ROTATION_SPEED * delta)

	# Prevent vertical sticking to the floor (no gravity applied)
	if is_on_floor():
		velocity.y = 20  # Prevent the character being pulled into the floor

	# Move the character using the velocity (Godot 4.x no longer requires arguments)
	move_and_slide()
