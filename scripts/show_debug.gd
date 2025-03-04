extends Sprite2D

@onready var dbg = get_node("../DebugInterface")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dbg.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		# Check if the touch is within the sprite
		if is_touch_within_sprite(event.position):
			dbg.visible = !dbg.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func is_touch_within_sprite(touch_position: Vector2) -> bool:
	var local_pos = to_local(touch_position)
	return get_rect().has_point(local_pos)
