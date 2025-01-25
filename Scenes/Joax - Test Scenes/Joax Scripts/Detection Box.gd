extends Area3D

@export var bubble_count: int = 0  # Tracks the number of bubbles inside the area
var trapped_bubbles = []  # Stores references to trapped bubbles
var center_position: Vector3  # The center of the area

# Called when the node enters the scene tree
func _ready() -> void:
	# Set the center position of the Area3D
	center_position = global_transform.origin
	
	# Connect the body_entered and body_exited signals to their respective functions
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))
	print("Force field is ready to trap bubbles.")

# Called when a body enters the area
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("bubbles"):
		if body not in trapped_bubbles:  # Avoid duplicates
			trapped_bubbles.append(body)  # Add bubble to the list
			bubble_count += 1
			print("Bubble entered. Total Bubbles: ", bubble_count)

			# Stop the bubble's motion
			if body is RigidBody3D:
				body.linear_velocity = Vector3.ZERO  # Stops the bubble entirely
				body.angular_velocity = Vector3.ZERO  # Prevents spinning

# Called when a body exits the area
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("bubbles"):
		if body in trapped_bubbles:  # Check if the body was in the trapped list
			trapped_bubbles.erase(body)  # Remove bubble from the trapped list
			bubble_count -= 1
			print("Bubble exited. Total Bubbles: ", bubble_count)

# Called every frame (for physics)
func _process(_delta: float) -> void:
	for bubble in trapped_bubbles:
		if is_instance_valid(bubble): 
			if bubble is RigidBody3D:
				# Apply force towards the center to trap the bubble in place
				var direction_to_center = (center_position - bubble.global_transform.origin).normalized()
				var force = direction_to_center * 50.0  # Adjust strength of the force
				bubble.apply_force(force, Vector3.ZERO)  # Apply the force to push the bubble to the center

				# Keep the bubble at rest (disable its movement)
				bubble.linear_velocity = Vector3.ZERO  # Ensure it does not move away
				bubble.angular_velocity = Vector3.ZERO  # Disable any spinning motion
		else:
			# If bubble instance is invalid (freed), remove it from the list
			trapped_bubbles.erase(bubble)
			print("Bubble removed from trapped list, instance is no longer valid.")
