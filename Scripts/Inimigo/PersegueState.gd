extends State

@export var Patrulha : State
@export var Possuido : State
@export var Morto : State

var alerta : bool = false
var cansou : bool = false
var direction := 1.0

var podeAtacar : bool = true

func Enter() -> void:
	print('OLHA LÁ ELE!')
	direction = 0
	parent.tempo_alerta.start()
	alerta = true
	
func Exit() -> void:
	pass

func Update(_delta : float) -> State:
	# Checagem de possessão
	if Input.is_action_just_pressed("interagir") and parent.pode_possuir:
		parent.pode_possuir = false
		return Possuido
	return null

func FixedUpdate(_delta : float) -> State:
	if cansou:
		return Patrulha
	
	if not alerta:
		var p = parent.global_position.x - parent.target.global_position.x
		print(p)
		if abs(p) <= parent.distAtaque:
			direction = 0
			if podeAtacar:
				podeAtacar = false
				parent.Atacar()
				parent.tempo_ataque.start()
		else:
			var pos = parent.target.global_position.x - parent.global_position.x
			if pos < 0:
				direction = -1
			else:
				direction = 1
		
	parent.velocity.x = direction * parent.chaseSpeed
	parent.move_and_slide()
	return null

func _on_tempo_alerta_timeout():
	alerta = false

func _on_tempo_persegue_timeout():
	cansou = true

func _on_tempo_ataque_timeout():
	podeAtacar = true
