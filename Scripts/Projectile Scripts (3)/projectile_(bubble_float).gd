extends RigidBody3D


# Called when the node enters the scene tree for the first time.

var speed = 10.0  
var upward_force = 0.2
var lifetime = 15.0
var initial_velocity: Vector3 = Vector3.ZERO
func _ready() -> void:
	
	add_to_group("bubbles")
	linear_velocity = initial_velocity + (transform.basis.z * -speed) + Vector3(0, upward_force, 0)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	linear_velocity.y += upward_force
