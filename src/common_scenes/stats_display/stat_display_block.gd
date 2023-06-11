extends MarginContainer
class_name StatDisplayBlock



@onready var icon: TextureRect = %Icon
@onready var value_label: Label = %Value



func set_stat(stat: ItemDef.Stat, value) -> void:

	var image = Assets.get_stat_texture_for_id(stat).get_image()

	image.resize(32, 32, Image.INTERPOLATE_LANCZOS)
	var texture = ImageTexture.create_from_image(image)

	icon.texture = texture

	if value is Array:
		value_label.text = "%s-%s" % value
		value_label.modulate.a = 1.0 if value[0] > 0 || value[1] > 0 else 0.5
	else:
		value_label.text = str(value)
		value_label.modulate.a = 1.0 if value > 0 else 0.5
