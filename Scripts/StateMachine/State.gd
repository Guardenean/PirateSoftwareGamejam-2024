class_name State
extends Node

var parent : Node

func Enter() -> void:
	pass
	
func Exit() -> void:
	pass

func Update(_delta : float) -> State:
	return null
	
func FixedUpdate(_delta : float) -> State:
	return null

func UnhandledEvent(_event : InputEvent) -> State:
	return null
