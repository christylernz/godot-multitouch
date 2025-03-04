extends Node2D

var points = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
var touch_distances = {}
var angles = {}
@export var save_file_name: String =  "/storage/emulated/0/Download/letter_patterns.json"

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	for i in points.size():
		var start = points[i]
		var end = points[_wrap_index(i,1)]
		#draw the points of the signature
		#draw_circle(start,50,Color.WHITE,true)
		
		#draw line between each of the points
		draw_line(start,end, Color.WHITE,6.0,true) 
		draw_line(start,end, Color.BLACK,3.0,true)
		#Draw the distance between points as a string
		var mid = start.lerp(end,0.5)
		draw_string(ThemeDB.fallback_font,mid,"%.2f" % touch_distances[i])
		
		#draw angles
		var angle_origin = points[i] + Vector2(10,-10)
		draw_string(ThemeDB.fallback_font,angle_origin,"%.1f°" % rad_to_deg(angles[i]))

func _wrap_index(index: int, offset: int) -> int:
	return (index + offset) % points.size()

func update_point(index: int, new_position: Vector2):
	if index >= 0 and index < points.size():
		points[index] = new_position
		#TODO normalize the distance so that the signature is not affected by screen size. 
		#Is there a normalised distance function? Or create a seperate distance function that takes into account max distance
		#also experiment with normalising based on screen width and height
		#also try using the distance_squared_to tonsee what impact that has
		touch_distances[index] = points[index].distance_to(points[_wrap_index(index,1)])
		angles[index] = _get_angle(points[_wrap_index(index,1)],points[index],points[_wrap_index(index,2)])
		queue_redraw()

func _get_angle(a: Vector2, b: Vector2, c: Vector2) -> float:
	var ab = (a - b).normalized()
	var bc = (c - b).normalized()
	return acos(ab.dot(bc))

func _save_JSON(letter: String):
	var signature = {
		"letter" : letter,
		"touch_distances" : touch_distances,
		"touch_angles" : angles
	}
	var file = FileAccess.open(save_file_name, FileAccess.WRITE)
	if file == null:
		print("Error opening file:", FileAccess.get_open_error())
		return
	if file:
		OS.request_permissions()
		file.store_string(JSON.stringify(signature, "\t"))
		file.close()
		print("Saving to: ", ProjectSettings.globalize_path(save_file_name))
	if FileAccess.file_exists(save_file_name):
		print("File exists:", save_file_name)
		_read_JSON()
	else:
		print("File does not exist yet, creating:", save_file_name)

func _read_JSON():
	if FileAccess.file_exists(save_file_name):
		var file = FileAccess.open(save_file_name, FileAccess.READ)
		var content = file.get_as_text()
		print("File Contents:\n", content)
		file.close()
	else:
		print("File does not exist")
