extends Node2D

const gc = preload("res://Scripts/GameController.gd")

var podeInteragir : bool = false
@onready var sfx = $AudioStreamPlayer
@onready var anim = $"."

@onready var area_luz = $AreaLuz
@onready var area_interact = $AreaInteract
@onready var point_light_2d = $PointLight2D

func _physics_process(_delta):
	if Input.is_action_just_pressed("interagir") and podeInteragir:
		sfx.play()
		area_luz.queue_free()
		area_interact.queue_free()
		point_light_2d.queue_free()
		#timer.start()
		gc.tochasApagadas += 1
		anim.play("Apaga")

func _on_area_luz_body_entered(body):
	if body.is_in_group('Player'):
		body.add_dark(1)


func _on_area_luz_body_exited(body):
	if body.is_in_group('Player'):
		body.add_dark(-1)


func _on_area_interact_body_entered(body):
	if body.is_in_group('Player'):
		podeInteragir = true
	
	if body.is_in_group('Inimigo'):
		if body.possuido:
			podeInteragir = true


func _on_area_interact_body_exited(body):
	if body.is_in_group('Player'):
		podeInteragir = false
	
	if body.is_in_group('Inimigo'):
		if body.possuido:
			podeInteragir = false
