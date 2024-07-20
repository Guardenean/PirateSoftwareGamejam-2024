extends State

@export var Morto : State

func Enter() -> void:
	print('TO POSSUIDO AAAAAAAAAA')
	parent.target.queue_free()

func Update(_delta : float) -> State:
	print()
	# Checagem de libertação
	if Input.is_action_just_pressed("baixo"):
		liberar()
		return Morto
		
	return null
	
func FixedUpdate(_delta : float) -> State:
	# Pulo
	if Input.is_action_just_pressed("pulo") and parent.is_on_floor():
		parent.velocity.y = parent.JUMP_VELOCITY
	
	if Input.is_action_just_pressed("atirar"):
		parent.Atacar()
	
	# Movimento
	var direction = Input.get_axis("esquerda", "direita")
	if direction:
		parent.velocity.x = direction * parent.chaseSpeed
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.chaseSpeed)
	return null

func UnhandledEvent(_event : InputEvent) -> State:
	return null

func liberar():
	var p = parent.cena_player.instantiate()
	parent.add_child(p)
	p.reparent(get_tree().root)
	p.global_position = parent.global_position
