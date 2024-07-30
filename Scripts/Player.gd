extends CharacterBody2D


@export var speed : float = 300.0
@export var jumpVel : float = -400.0
@export var jumpGravity : float
@export var fallGravity : float
var gravity

var pulando : bool = false

@onready var sprite = $Sprite
@onready var dark = $Dark

var darkCount := 0
var inDark : bool = true

var morto : bool = false
@onready var morte_sfx = $MorteSFX
@onready var timer_morte = $TimerMorte

func  _ready():
	sprite.visible = true
	dark.visible = false

func _physics_process(delta):
	if morto:
		return
	#sprite.play("Idle")
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("esquerda", "direita")
	direction.y = Input.get_axis("cima", "baixo")
	
	if darkCount <= 0:
		#sprite.play("Dark")
		sprite.visible = false
		dark.visible = true
		
		if direction:
			velocity = direction.normalized() * speed
			if direction.x < 0:
				sprite.flip_h = true
				dark.flip_h = true
			elif direction.x > 0:
				sprite.flip_h = false
				dark.flip_h = false
					
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)
	
	else:
		sprite.visible = true
		dark.visible = false
		# Add the gravity.
		if not is_on_floor():
			if velocity.y < 0:
				gravity = jumpGravity
				
				if Input.is_action_just_released("pulo") and !pulando:
					velocity.y = 0
			else:
				gravity = fallGravity
				
			velocity.y += gravity * delta
		
		# Handle jump.
		if Input.is_action_just_pressed("pulo") and is_on_floor():
			pulando = true
			velocity.y = -jumpVel
		
		if is_on_floor():
			sprite.play("Idle")
		else:
			sprite.play("Pulo")
		
		if direction:
			velocity.x = direction.x * speed
			if direction.x < 0:
				sprite.flip_h = true
			elif direction.x > 0:
				sprite.flip_h = false
					
		else:
			velocity.x = move_toward(velocity.x, 0, speed)


	move_and_slide()

func add_dark(val):
	if darkCount + val < 0:
		darkCount = 0
	else:
		darkCount += val

func morte():
	if !morto:
		morto = true
		print('AI AI AI EU MORRI NÃAO')
		morte_sfx.play()
		timer_morte.start()
		sprite.play("Morte")

func _on_timer_morte_timeout():
	get_tree().reload_current_scene()
