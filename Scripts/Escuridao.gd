extends Area2D

func _on_body_entered(body):
	if body.has_method('darkness'):
		body.darkness(1)

func _on_body_exited(body):
	if body.has_method('darkness'):
		body.darkness(0)
