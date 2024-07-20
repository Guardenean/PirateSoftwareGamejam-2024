extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().quit()
		
	global_position = get_global_mouse_position()
