class_name StateMachine
extends Node

@export var start_state : State
var current_state : State

func Init(parent) -> void:
	for child in get_children():
		child.parent = parent
		
	ChangeState(start_state)

func ChangeState(new_state : State) -> void:
	if current_state:
		current_state.Exit()
	
	current_state = new_state
	current_state.Enter()

func Update(delta : float) -> void:
	var new_state = current_state.Update(delta)
	if new_state:
		ChangeState(new_state)
	
func FixedUpdate(delta : float) -> void:
	var new_state = current_state.FixedUpdate(delta)
	if new_state:
		ChangeState(new_state)

func UnhandledEvent(event : InputEvent) -> void:
	var new_state = current_state.UnhandledEvent(event)
	if new_state:
		ChangeState(new_state)

