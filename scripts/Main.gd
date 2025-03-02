extends Node2D

@onready var circle_container = $Circle_Container
@onready var touch_count = $DebugInterface/GridContainer/TouchCountText
@onready var touch_overflow = $DebugInterface/GridContainer/TouchOverflowText
@onready var signature = $Signature

@onready var position_labels = [
	$DebugInterface/GridContainer/P1PositionText,
	$DebugInterface/GridContainer/P2PositionText,
	$DebugInterface/GridContainer/P3PositionText
]
var circles = []
var active_touches = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	for circle in circle_container.get_children():
		circles.append(circle)

func _input(event):
	# update position when dragging occurs
	if event is InputEventScreenDrag:
		var i = event.index
		#print("dragging started")
		active_touches[i] = event.position
	if event is InputEventScreenTouch:
		var i = event.index
		#Update/add position when touch point is touched
		if event.pressed:
			#print("touch added")
			active_touches[i] = event.position
		#removes position when touch point is removed
		if not event.pressed:
			#print("touch removed")
			if active_touches.has(i):
				active_touches.erase(i)
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_display()
	
func _update_display():
	touch_count.text = str(active_touches.size())
	if active_touches.size() > circles.size():
		touch_overflow.text = str(active_touches.size() - circles.size())
		touch_overflow.modulate = Color.RED
	elif active_touches.size() > 0:
		touch_overflow.text = "0"
		touch_overflow.modulate = Color.WHITE
	#only identify positions when there are 3 touch points
	if active_touches.size() == 3:
		touch_count.modulate = Color.GREEN
		_update_signature()
	else:
		touch_count.modulate = Color.WHITE	
	_update_touch_points()
	

func _update_touch_points():
	for i in range(circles.size()):
		if active_touches.has(i):
			circles[i].global_position = active_touches[i]
			circles[i].show()
			position_labels[i].text = str(int(active_touches[i].x), ",", int(active_touches[i].y))
		else:
			circles[i].hide()
			position_labels[i].text = "-"
			
func _update_signature():
	signature.show()
	for i in range(active_touches.size()):
		signature.update_point(i,active_touches[i])
