extends Node2D

func _on_b_play_pressed():
	get_tree().change_scene_to_file("res://Cenas/Teste Bola.tscn")

func _on_b_quit_pressed():
	get_tree().quit()
