extends Area2D

func _on_body_entered(body):
	if body.is_in_group('Player'):
		print('ENTROU')
		body.darkness(0)

func _on_body_exited(body):
	if body.is_in_group('Player'):
		print('SAIU')
		body.darkness(1)
