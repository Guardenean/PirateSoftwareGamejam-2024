extends Node

const gc = preload("res://Scripts/GameController.gd")

@export var numTochas : int

@export var proximaCena : PackedScene

@onready var fade = $AnimationPlayer

func _ready():
	gc.tochasApagadas = 0
	fade.connect("animation_finished", on_fade_finished)
	fade.play("fade_in")

func _process(_delta):
	if gc.tochasApagadas == numTochas:# and !transicao:
		fade.play("fade_out")

func on_fade_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_packed(proximaCena)
