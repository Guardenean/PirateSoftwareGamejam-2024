extends CharacterBody2D

# STATE MACHINE
@onready var state_machine : StateMachine = $StateMachine

# VARIÁVEIS DE MOVIMENTO
@export var normalSpeed = 150.0
@export var chaseSpeed = 300.0
@export var JUMP_VELOCITY = -400.0
@export var distAtaque : float

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
@onready var tempo_ataque = $TempoAtaque

# INSTANTIATE
@export var projetil : PackedScene
const cena_player = preload("res://Cenas/PlayerV2.tscn")

# POSSESSÃO
var pode_possuir : bool = false

# GRAVIDADE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.Init(self)

func _process(delta):
	state_machine.Update(delta)

func _physics_process(delta):
	state_machine.FixedUpdate(delta)
	
	# Aplica gravidade
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Muda a posição da visão do inimigo
	if velocity.x < 0:
		ray_visao.scale.x = -1
	if velocity.x > 0:
		ray_visao.scale.x = 1
		
	move_and_slide()

func Atacar():
	var b = projetil.instantiate()
	add_child(b)
	b.reparent(get_tree().root)
	b.global_position = global_position

func _on_area_possessao_body_entered(body):
	if body.is_in_group('Player'):
		target = body
		pode_possuir = true

func _on_area_possessao_body_exited(body):
	if body.is_in_group('Player'):
		pode_possuir = false
