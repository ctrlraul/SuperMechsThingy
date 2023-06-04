extends Button



var item: ItemDef



func _get_drag_data(_position: Vector2):
	return item


func set_item(value: ItemDef) -> void:
	item = value
	icon = Assets.get_texture_for_item(item)
