extends Control

const gc = preload("res://Scripts/GameController.gd")

func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://Cenas/Fases/fase_1.tscn")
	#gc.fasesCompletadas = 0

func _on_sair_pressed():
	get_tree().quit()

