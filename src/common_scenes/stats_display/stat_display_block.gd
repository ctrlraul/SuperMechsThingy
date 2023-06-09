extends PanelContainer
class_name StatDisplayBlock


@onready var icon: TextureRect = %Icon
@onready var value_label: Label = %Value


func set_stat(id: String, value) -> void:

	var image = Assets.get_stat_texture_for_id(id).get_image()

	image.resize(32, 32, Image.INTERPOLATE_LANCZOS)
	var texture = ImageTexture.create_from_image(image)

	icon.texture = texture

	if value is Array:
		value_label.text = "%s-%s" % value
	else:
		value_label.text = str(value)
