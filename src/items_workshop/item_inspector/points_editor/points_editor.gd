extends Control
class_name PointsEditor



@export var point_scene: PackedScene


@onready var canvas: Control = %Canvas
@onready var reference: TextureRect = %Reference
@onready var points: Control = %Points



const __ZOOM_STEP: float = 0.1
const __ZOOM_MIN: float = 0.25
const __ZOOM_MAX: float = 5



var __panning: bool = false



func set_reference_texture(texture: Texture2D) -> void:
	reference.texture = texture
	canvas.position = size * 0.5
	points.position = -texture.get_size() * 0.5


func clear() -> void:

	reference.texture = null

	for point in points.get_children():
		point.queue_free()


func add_point(place: Vector2, color: Color, label: String, image: Texture2D = null) -> PointsEditorPoint:

	var point: PointsEditorPoint = point_scene.instantiate()

	points.add_child(point)

	point.position = place

	point.set_color(color)
	point.set_label(label)
	point.set_image(image)

	return point



func _on_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				__panning = event.pressed

			MOUSE_BUTTON_WHEEL_UP:
				__zoom(1)

			MOUSE_BUTTON_WHEEL_DOWN:
				__zoom(-1)

	elif event is InputEventMouseMotion:
		if __panning:
			canvas.position += event.relative


func __zoom(delta: int) -> void:

	var old_zoom: Vector2 = canvas.scale

	canvas.scale = Vector2.ONE * clamp(
		canvas.scale.x + __ZOOM_STEP * delta * canvas.scale.x,
		__ZOOM_MIN,
		__ZOOM_MAX,
	)

	var change: Vector2 = old_zoom - canvas.scale

	canvas.position += canvas.get_local_mouse_position() * change


func _on_reset_transforms_button_pressed() -> void:
	canvas.position = size * 0.5
	points.position = -reference.texture.get_size() * 0.5
	canvas.scale = Vector2.ONE
