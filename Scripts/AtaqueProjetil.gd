extends Area2D

@export var speed : float
var direction : int

func _ready():
	$Timer.start()

func _physics_process(_delta):
	global_position.x += speed * direction

func _on_body_entered(body):
	if body.is_in_group('Player'):
		print('PLAYER')
		body.morte()
	if body.is_in_group('Inimigo'):
		print('INIMIGO')
		body.morto = true
		
	queue_free()

func _on_timer_timeout():
	queue_free()
