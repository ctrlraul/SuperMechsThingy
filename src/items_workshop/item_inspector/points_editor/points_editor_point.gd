extends Control
class_name PointsEditorPoint
signal moved(place: Vector2)



func _ready() -> void:
	set_process_input(false)
	$Label.visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position += event.relative / get_global_transform().get_scale()
		moved.emit(position)



func set_image(texture: Texture2D) -> void:
	$TextureRect.texture = texture


func set_label(text: String) -> void:
	$Label.text = text


func set_color(color: Color) -> void:
	$ColorRect.color = color



func _on_button_button_down() -> void:
	set_process_input(true)


func _on_button_button_up() -> void:
	set_process_input(false)


func _on_button_mouse_entered() -> void:
	$Label.visible = true


func _on_button_mouse_exited() -> void:
	$Label.visible = false
