extends Control

const gc = preload("res://Scripts/GameController.gd")

@onready var timer = $Timer
@onready var sfx = $SFX
@onready var fade = $AnimationPlayer

func _ready():
	fade.play("fade_in")

func _on_jogar_pressed():
	sfx.play()
	fade.play("fade_out")
	timer.start()
	await timer.timeout
	get_tree().change_scene_to_file("res://Cenas/Fases/fase_1.tscn")
	
func _on_sair_pressed():
	sfx.play()
	fade.play("fade_out")
	timer.start()
	await timer.timeout
	get_tree().quit()
