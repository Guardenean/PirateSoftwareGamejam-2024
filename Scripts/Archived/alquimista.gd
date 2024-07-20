extends CharacterBody2D

# VARIÁVEIS DE MOVIMENTO
@export var normalSpeed = 150.0
@export var chaseSpeed = 300.0
@export var JUMP_VELOCITY = -400.0
@export var distAtaque : float

var direction := 1.0
var next_dir := 0.0

var esperando : bool = false

# NODE PLAYER
var target# : CharacterBody2D

# RAYCASTS
@onready var rayparent = $Raycast
@onready var ray_parede = $Raycast/RayParede
@onready var ray_chao = $Raycast/RayChao
@onready var ray_visao = $RayVisao

# TIMERS
@onready var tempo_parado = $TempoParado
@onready var tempo_morte = $TempoMorte
@onready var tempo_alerta = $TempoAlerta
@onready var tempo_persegue = $TempoPersegue

# INSTANTIATE
@export var projetil : PackedScene
const cena_player = preload("res://Cenas/PlayerV2.tscn")

# POSSESSÃO
var possuido : bool = false
var pode_possuir : bool = false

# PERSEGUIÇÃO
var persegue : bool = false

# GRAVIDADE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#MÉTODOS

func _ready():
	possuido = false
	pode_possuir = false

func _physics_process(delta):
	# Aplica gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Muda a posição da visão do inimigo
	if velocity.x < 0:
		ray_visao.scale.x = -1
	if velocity.x > 0:
		ray_visao.scale.x = 1
	
	# Checagem de possessão
	if Input.is_action_just_pressed("interagir") and pode_possuir:
		possuido = true
		pode_possuir = false
		target.queue_free()
	
	# Checagem de libertação
	if Input.is_action_just_pressed("baixo") and possuido:
		possuido = false
		liberar()
	
	# Inteligência do inimigo
	# Lógica quando possuído
	if possuido:
		Possuido()
	
	# Lógica quando normal
	else:
		# PERSEGUIÇÃO
		var c
		if ray_visao.is_colliding():
			c = ray_visao.get_collider()
			if c.is_in_group('Player'):
				target = c
				Perseguir()
		# PATRULHA
		if not persegue:
			Patrulhar()
		
	move_and_slide()
	
func Patrulhar():
	if is_on_floor() and esperando == false:
		if ray_parede.is_colliding() or !ray_chao.is_colliding():
			esperando = true
			next_dir = -direction
			rayparent.scale.x = -direction
			direction = 0
			tempo_parado.start()
			
	velocity.x = direction * normalSpeed

func Perseguir():
	if not persegue:
		if esperando: return
		
		velocity.x = 0
		print('A LÁ O CORNO!!!!!!!')
		tempo_alerta.start()
		esperando = true
	
	else:
		print('VEM AQUI SEU OTARIO')
		if target.global_position.x < global_position.x:
			direction = -1
		else:
			direction = 1
		
		velocity.x = direction * chaseSpeed

func Atacar():
	var b = projetil.instantiate()
	add_child(b)
	b.reparent(get_tree().root)
	b.global_position = global_position

func Possuido():
	# Pulo
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("atirar"):
		Atacar()
	
	# Movimento
	direction = Input.get_axis("esquerda", "direita")
	if direction:
		velocity.x = direction * normalSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, normalSpeed)

func liberar():
	var p = cena_player.instantiate()
	add_child(p)
	p.reparent(get_tree().root)
	p.global_position = global_position
	possuido = false
	Morrer()

func Morrer():
	tempo_morte.start()

func _on_tempo_parado_timeout():
	direction = next_dir
	esperando = false

func _on_area_possessao_body_entered(body):
	if body.is_in_group('Player'):
		target = body
		pode_possuir = true

func _on_area_possessao_body_exited(body):
	if body.is_in_group('Player'):
		pode_possuir = false

func _on_tempo_morte_timeout():
	queue_free()

func _on_tempo_alerta_timeout():
	persegue = true
	esperando = false

func _on_tempo_persegue_timeout():
	persegue = false
