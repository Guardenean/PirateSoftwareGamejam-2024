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
	parent.sprite.play('Idle')
	direction = 0
	parent.tempo_alerta.start()
	alerta = true

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
		
	if cansou or parent.target == null:
		return Patrulha
	
	if not alerta:
		var x = parent.global_position.x - parent.target.global_position.x
		var y = parent.global_position.y - parent.target.global_position.y
		if abs(x) <= parent.distAtaqueX and abs(y) <= parent.distAtaqueY:
			direction = 0
			if podeAtacar:
				direction = 0
				podeAtacar = false
				parent.Atacar()
				parent.tempo_ataque.start()
		else:
			var pos = parent.target.global_position.x - parent.global_position.x
			#print(pos)
			if pos < -5:
				direction = -1
			elif pos > 5:
				direction = 1
			#else:
				#direction = 0
		
	parent.velocity.x = direction * parent.chaseSpeed
	parent.move_and_slide()
	return null

func Exit() -> void:
	cansou = false

func _on_tempo_alerta_timeout():
	print('ABUBUBUBUBU')
	alerta = false
	parent.tempo_persegue.start()
	if parent.state_machine.current_state == self:
		parent.sprite.play('Walk')

func _on_tempo_persegue_timeout():
	cansou = true
	print('CANSEI')

func _on_tempo_ataque_timeout():
	podeAtacar = true
