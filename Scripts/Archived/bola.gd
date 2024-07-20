extends RigidBody2D

# VARIÁVEIS
@export var speed : float
@export var jumpVel : float

@onready var sprite = $Sprite
@onready var ground_cast = $Node2D/RayCast2D

var inDark : bool = false

# FUNÇÕES
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
func _physics_process(_delta):
	# INPUT PLAYER
	var inputMove := Vector2(0, 0)
	inputMove.x = Input.get_axis("esquerda", "direita")
	inputMove.y = Input.get_axis("cima", "baixo")

	# MOVIMENTAÇÃO
	# 8 DIREÇÕES
	if inDark:
		var vel = Vector2(inputMove.x, inputMove.y)
		apply_central_force(vel.normalized() * speed)
	
	# SIDESCROLLER
	else:
		apply_central_force(Vector2(inputMove.x * speed, 0))
		# PULO
		if ground_cast.is_colliding() and Input.is_action_just_pressed("pulo"):
			linear_velocity = Vector2(linear_velocity.x, 0)
			apply_impulse(Vector2(0, -jumpVel), Vector2(0,0))
	
	ground_cast.rotation = -rotation

# CHECA SE ESTÁ EM LUGAR ESCURO
func darkness(val : int):
	match(val):
		0:
			inDark = false
			gravity_scale = 1
		1:
			inDark = true
			gravity_scale = 0
