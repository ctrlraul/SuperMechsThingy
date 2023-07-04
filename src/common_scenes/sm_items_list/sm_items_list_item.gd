class_name SMItemsListItem
extends Control

signal selected()



@onready var slot_display_item: Control = %SlotDisplayItem



var __pressed: bool = false

var item: Item = null



func _ready() -> void:
	clear()


func _get_drag_data(_at_position: Vector2) -> Variant:
	return DragData.new(self, item)


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.source == self


func _drop_data(_at_position: Vector2, _data: Variant) -> void:
	selected.emit()



func set_item(value: Item) -> void:

	if value == null:
		clear()
		return

	item = value

	slot_display_item.set_item(item)


func clear() -> void:
	slot_display_item.clear()



func _on_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed():
				__pressed = true
			else:
				if __pressed:
					selected.emit()

	elif event is InputEventMouseMotion:
		__pressed = false
