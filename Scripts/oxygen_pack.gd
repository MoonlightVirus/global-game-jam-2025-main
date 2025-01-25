extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		$"../Timer".start()
		queue_free()
		
func _on_timer_timeout():
	$"../CanvasLayer/ProgressBar".value+=50
