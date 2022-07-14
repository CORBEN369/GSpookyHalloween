extends Sprite

var new_delta_x
var new_delta_y
var delta_x
var delta_y
var touch_position = Vector2()
var area_ent = false

func _on_TouchScreenButton_pressed():
	area_ent = true	
	
func _on_TouchScreenButton_released():
	area_ent = false
	
func _input(event):
	if area_ent == true:
		if event is InputEventScreenTouch and event.is_pressed():
			touch_position = event.get_position()
			delta_x = touch_position.x - position.x
			delta_y = touch_position.y - position.y
		elif event is InputEventScreenDrag:
			touch_position = event.get_position()
			new_delta_x = touch_position.x - delta_x
			new_delta_y = touch_position.y - delta_y
			set_position(Vector2(new_delta_x, new_delta_y))
			
