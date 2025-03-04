extends Sprite2D

@onready var signature = get_node("../../Signature")
# Called when the node enters the scene tree for the first time.

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		if is_touch_within_sprite(event.position):
			if signature:
				signature._save_JSON("A")
			else:
				print("Error saving signature")
		
func is_touch_within_sprite(touch_position: Vector2) -> bool:
	var local_pos = to_local(touch_position)
	return get_rect().has_point(local_pos)
