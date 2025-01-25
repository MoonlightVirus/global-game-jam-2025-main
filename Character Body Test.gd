extends CharacterBody3D

const SPEED = 8.0  # Movement speed
const ROTATION_SPEED = 3.0  # How fast the player rotates (radians per second)
const ACCELERATION = 2.0  # Acceleration speed
const DECELERATION = 3.0  # Deceleration speed
var target_rotation_y = 0.0
		
#Oxygen Bar
var oxygen = 100
@onready var oxygen_timer = $"../Timer"
@onready var progress = $"../CanvasLayer/ProgressBar"
@onready var timer = $"../oxygen_timer"
		
# Target velocity for smoothing
var target_velocity: Vector3 = Vector3.ZERO

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
		
func add_oxygen(hit_points):
	if ((hit_points + oxygen) < 100):
		oxygen += hit_points
	else:
		oxygen = 100
		$"../CanvasLayer/ProgressBar".value = oxygen
	
func die():
	pass
	
func _ready() -> void:
	oxygen_timer.wait_time = 4.0
	oxygen_timer.one_shot = false
	oxygen_timer.start()
	oxygen_timer.timeout.connect(self.natural_oxygen_drop)
	
func _physics_process(delta: float) -> void:
	# Handle rotation when pressing A/D
	if Input.is_action_pressed("left"):  # A key
		target_rotation_y += ROTATION_SPEED * delta
	if Input.is_action_pressed("right"):  # D key
		target_rotation_y -= ROTATION_SPEED * delta

	# Get forward/backward input
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
	target_velocity = transform.basis * input_dir * SPEED

	# Smoothly interpolate velocity towards the target velocity
	velocity.x = lerp(velocity.x, target_velocity.x, ACCELERATION * delta if target_velocity.x != 0 else DECELERATION * delta)
	velocity.y = lerp(velocity.y, target_velocity.y, ACCELERATION * delta if target_velocity.y != 0 else DECELERATION * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, ACCELERATION * delta if target_velocity.z != 0 else DECELERATION * delta)
	rotation.y = lerp_angle(rotation.y, target_rotation_y, 0.1)
	# Apply movement
	move_and_slide()
