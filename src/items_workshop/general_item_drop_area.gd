extends Control

signal item_button_dropped(item: Item)



func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.source is ItemSlot || data.source is SMItemButton


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data.source is ItemSlot:
		data.source.clear()

	elif data.source is SMItemButton:
		item_button_dropped.emit(data.data)
