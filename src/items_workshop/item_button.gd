extends Button
class_name SMItemButton



@onready var texture_rect: TextureRect = %TextureRect



var item: ItemDef



func _get_drag_data(_position: Vector2):
	return DragData.new(self, item)



func set_item(value: ItemDef) -> void:
	item = value
	texture_rect.texture = Assets.get_texture_for_item(item)
