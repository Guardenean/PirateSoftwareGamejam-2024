extends State

@export var Persegue : State
@export var Possuido : State
@export var Morto : State

var direction := 1.0
var next_dir := 0.0
var esperando : bool = false

func Enter() -> void:
	parent.sprite.play('Walk')

func Update(_delta : float) -> State:
	# Checagem de possessão
	if Input.is_action_just_pressed("interagir") and parent.pode_possuir:
		if not parent.alquiLuz:
			parent.pode_possuir = false
			return Possuido
	
	return null

func FixedUpdate(_delta : float) -> State:
	if parent.morto:
		return Morto
	
	if parent.ray_visao.is_colliding():
		var c = parent.ray_visao.get_collider()
		if c != null:
			if c.is_in_group('Player'):
				parent.target = c
				return Persegue
			#return null
	
	if parent.is_on_floor() and esperando == false:
		if parent.ray_parede.is_colliding() or !parent.ray_chao.is_colliding():
			esperando = true
			next_dir = -direction
			parent.rayparent.scale.x = -direction
			direction = 0
			parent.sprite.play('Idle')
			parent.tempo_parado.start()
			
		parent.velocity.x = direction * parent.normalSpeed
		
	return null

func _on_tempo_parado_timeout():
	direction = next_dir
	esperando = false
	if parent.state_machine.current_state == self:
		parent.sprite.play('Walk')
