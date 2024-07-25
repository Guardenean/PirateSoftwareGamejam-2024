extends CharacterBody2D


@export var speed : float = 300.0
@export var jumpVel : float = -400.0
@export var jumpGravity : float
@export var fallGravity : float
var gravity

var pulando : bool = false

@onready var sprite = $Sprite

var inDark : bool = true

func _process(_delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _physics_process(delta):
	sprite.play("Idle")
	
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("esquerda", "direita")
	direction.y = Input.get_axis("cima", "baixo")
	
	if !inDark:
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
	else:
		sprite.play("Dark")
		if direction:
			velocity = direction.normalized() * speed
			if direction.x < 0:
				sprite.flip_h = true
			elif direction.x > 0:
				sprite.flip_h = false
					
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	
func darkness(val : int):
	match(val):
		0:
			inDark = false
			gravity = fallGravity
		1:
			inDark = true
			gravity = 0
