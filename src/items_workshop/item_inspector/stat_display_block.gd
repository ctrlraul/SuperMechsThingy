extends PanelContainer
class_name StatDisplayBlock


@onready var icon: TextureRect = $MarginContainer/HBoxContainer/Icon
@onready var value_label: Label = $MarginContainer/HBoxContainer/DisplayName


func set_stat(id: String, value) -> void:

	icon.texture = Assets.get_texture_for_stat_id(id)

	if value is Array:
		value_label.text = "%s-%s" % value
	else:
		value_label.text = str(value)
