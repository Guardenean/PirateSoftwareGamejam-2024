extends State

func Enter() -> void:
	print('MORRI')
	# TOCA ANIMAÇÃO
	parent.velocity.x = 0
	parent.tempo_morte.start()
	
func _on_tempo_morte_timeout():
	parent.queue_free()
