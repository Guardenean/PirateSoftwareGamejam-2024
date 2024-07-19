extends Node2D

@onready var entrada = $Entrada
@onready var saida = $Saida

var ativado : bool = false
var pos : int = 1 # 1 == Entrada para Saída/ 2 == Saida para Entrada

var target

func _process(_delta):
	if Input.is_action_just_pressed("interagir") and ativado:
		match(pos):
			1:
				target.global_position = saida.global_position
			2:
				target.global_position = entrada.global_position

func _on_entrada_body_entered(body):
	if body.is_in_group('Player'):
		target = body
		ativado = true
		pos = 1


func _on_entrada_body_exited(body):
	if body.is_in_group('Player'):
		ativado = false


func _on_saida_body_entered(body):
	if body.is_in_group('Player'):
		target = body
		ativado = true
		pos = 2


func _on_saida_body_exited(body):
	if body.is_in_group('Player'):
		ativado = false
