extends CharacterBody3D

<<<<<<< HEAD
@export var bubble_scene: PackedScene = load("res://Scripts/Projectile Scripts (3)/projectile_(bubble_float).tscn")
@export var spawn_offset: Vector3 = Vector3(0, 1, -2)

const SPEED = 8.0
const ROTATION_SPEED = 3.0
const ACCELERATION = 2.0
const DECELERATION = 3.0

var target_rotation_y = 0.0
var target_velocity: Vector3 = Vector3.ZERO

=======
@export var bubble_scene: PackedScene  = load("res://Scripts/Projectile Scripts (3)/projectile_(bubble_float).tscn")  # Reference to the bubble scene# Bubble scene reference to be set in the editor
@export var spawn_offset: Vector3 = Vector3(0.5, 0, -1.5)  # Offset from character position

const SPEED = 8.0  # Movement speed
const ROTATION_SPEED = 3.0  # How fast the player rotates (radians per second)
const ACCELERATION = 2.0  # Acceleration speed
const DECELERATION = 3.0  # Deceleration speed
const SHOOT_DELAY = 0.5
var target_rotation_y = 0.0
		
#Oxygen Bar
var oxygen = 100
@onready var oxygen_timer = $"../Timer"
@onready var progress = $"../CanvasLayer/ProgressBar"
@onready var timer = $"../oxygen_timer"

		
# Target velocity for smoothing
var target_velocity: Vector3 = Vector3.ZERO

var can_shoot = true

func add_oxygen(hit_points):
	if ((hit_points + oxygen) < 100):
		oxygen += hit_points
		$"../CanvasLayer/ProgressBar".value = oxygen
	else:
		oxygen = 100
		$"../CanvasLayer/ProgressBar".value = oxygen

func natural_oxygen_drop():
	if oxygen > 0:
		oxygen -= 5
		$"../CanvasLayer/ProgressBar".value = oxygen
	if oxygen <= 0:
		oxygen = 0
		die()

func oxygen_drop(hit_points):
	if hit_points < oxygen:
		oxygen-=hit_points
	else:
		oxygen = 0
		$"../CanvasLayer/ProgressBar".value = oxygen
	if oxygen == 0:
		die()
		

func die():
	pass
	
func _ready() -> void:
	oxygen_timer.wait_time = 4.0
	oxygen_timer.one_shot = false
	oxygen_timer.start()
	oxygen_timer.timeout.connect(self.natural_oxygen_drop)
	

# Handles input events
>>>>>>> 5c54e1dad8652b8e783a7fd5f192c4b56e81c1e6
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("shoot"):
		shoot_bubble()
<<<<<<< HEAD
=======
		print("Bubble Shot!")
		can_shoot = false
		start_shoot_delay()

# Function to shoot the bubble
>>>>>>> 5c54e1dad8652b8e783a7fd5f192c4b56e81c1e6

func shoot_bubble():
	if bubble_scene:
		var bubble = bubble_scene.instantiate()
<<<<<<< HEAD
=======
		
		# Add the bubble to the scene
		get_tree().get_current_scene().add_child(bubble)

		# Set the bubble's starting position based on the character's position + offset
>>>>>>> 5c54e1dad8652b8e783a7fd5f192c4b56e81c1e6
		bubble.global_transform.origin = global_transform.origin + (transform.basis * spawn_offset)
		bubble.rotation = rotation
		var forward_direction = -transform.basis.z.normalized()
		var bubble_velocity = forward_direction * SPEED

<<<<<<< HEAD
		if bubble.has_method("set_linear_velocity"):
			bubble.set_linear_velocity(bubble_velocity)
		elif bubble.has_property("linear_velocity"):
=======
		# Set the bubble's rotation to match the character's rotation
		bubble.rotation = rotation  # Set projectile rotation to match character's rotation

		# Get the direction the player is facing (forward vector)
		var forward_direction = transform.basis.z.normalized()  # The forward vector of the character

		# Apply the forward direction to the bubble's velocity
		var bubble_velocity = forward_direction * SPEED  # Set the bubble's velocity
		
		oxygen_drop(0.2)
		# Ensure the bubble's script has a `linear_velocity` property
		if bubble is RigidBody3D:
>>>>>>> 5c54e1dad8652b8e783a7fd5f192c4b56e81c1e6
			bubble.linear_velocity = bubble_velocity
			
			

<<<<<<< HEAD
		get_tree().get_current_scene().add_child(bubble)

=======
func start_shoot_delay():
	var shoot_timer = Timer.new()
	shoot_timer.wait_time = SHOOT_DELAY
	shoot_timer.one_shot = true
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timeout"))  # Use Callable for connecting
	add_child(shoot_timer)
	shoot_timer.start()

# Callback for when the shoot delay is over
func _on_shoot_timeout():
	can_shoot = true  # Enable shooting again

# Handles character movement and rotation
>>>>>>> 5c54e1dad8652b8e783a7fd5f192c4b56e81c1e6
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
<<<<<<< HEAD
	if Input.is_action_pressed("z-axis up"):  # Fly up
		input_dir.y += 1.0
	if Input.is_action_pressed("z-axis down"):  # Fly down
		input_dir.y -= 1.0

	# Calculate target velocity based on movement inputs
=======

	# Get forward/backward input (W/S or up/down keys)
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("up"):  # W key
		input_dir.z -= 1.0
	if Input.is_action_pressed("down"):  # S key
		input_dir.z += 1.0
	if Input.is_action_pressed("z-axis up"):  # W key
		input_dir.y += 1.0
	if Input.is_action_pressed("z-axis down"):  # S key
		input_dir.y -= 1.0

	# Transform the input direction into the character's local space
>>>>>>> 5c54e1dad8652b8e783a7fd5f192c4b56e81c1e6
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
