extends Node

const gc = preload("res://Scripts/GameController.gd")

@export var numTochas : int

@export var proximaCena : PackedScene

func _ready():
	gc.tochasApagadas = 0

func _process(_delta):
	if gc.tochasApagadas == numTochas:
		get_tree().change_scene_to_packed(proximaCena)
