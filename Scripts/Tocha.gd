extends Node2D

const gc = preload("res://Scripts/GameController.gd")

var podeInteragir : bool = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("interagir") and podeInteragir:
		gc.tochasApagadas += 1
		queue_free()

func _on_area_luz_body_entered(body):
	if body.is_in_group('Player'):
		body.add_dark(1)


func _on_area_luz_body_exited(body):
	if body.is_in_group('Player'):
		body.add_dark(-1)


func _on_area_interact_body_entered(body):
	if body.is_in_group('Player'):
		podeInteragir = true


func _on_area_interact_body_exited(body):
	if body.is_in_group('Player'):
		podeInteragir = false
