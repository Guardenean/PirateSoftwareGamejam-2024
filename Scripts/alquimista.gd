extends CharacterBody2D


@export var normalSpeed = 150.0
@export var chaseSpeed = 300.0
@export var JUMP_VELOCITY = -400.0

@export var target : RigidBody2D

@onready var rayparent = $Raycast
@onready var ray_parede = $Raycast/RayParede
@onready var ray_chao = $Raycast/RayChao
@onready var ray_visao = $Raycast/RayVisao

@onready var tempo_parado = $TempoParado

@export var projetil : PackedScene
@export var cena_player : PackedScene

var direction := 1
var next_dir := 0

var esperando : bool = false

@export var possuido : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if possuido:
		Possuido()
	
	else:
		var c
		if ray_visao.is_colliding():
			c = ray_visao.get_collider()
			if c.is_in_group('Player'):
				Perseguir()
			
		else:
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
			print('to esperando!')
		
		velocity.x = direction * normalSpeed

func Perseguir():
	velocity.x = 0
	print('A LÁ O CORNO!!!!!!!')

func Atacar():
	var b = projetil.instantiate()

func Possuido():
	# Handle jump.
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	direction = Input.get_axis("esquerda", "direita")
	if direction:
		velocity.x = direction * normalSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, normalSpeed)

func liberar():
	var p = cena_player.instantiate()
	p.global_position = global_position

func Morrer():
	# VAI MUDAR
	queue_free()

func _on_tempo_parado_timeout():
	print('TIMEOUT')
	direction = next_dir
	esperando = false
