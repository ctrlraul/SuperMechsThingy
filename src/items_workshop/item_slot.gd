extends Control
class_name ItemSlot
signal item_equipped(item: ItemDef, slot_id: MechBuild.Slot)
signal selected(slot: ItemSlot)



@export var item_type: ItemDef.Type
@export var slot_id: MechBuild.Slot



const OTHER_ELEMENT_COLOR: Color = Color(0.23, 0.23, 0.23)
const ELEMENT_COLORS: Array[Color] = [
	Color(0.3, 0.3, 0.1),
	Color(0.5, 0.1, 0.1),
	Color(0.1, 0.1, 0.5),
]



var item: ItemDef
var pressing: bool = false



func _ready() -> void:
	set_item(null)


func _get_drag_data(_position: Vector2):
	return DragData.new(self, item)


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:

	if data.source is ItemSlot && (!data.data || data.data.type == item_type):
		return true

	if data.data is ItemDef && data.data.type == item_type:
		return true

	if data.source == self:
		return true

	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:

	if data.source is ItemSlot:

		if data.source == self && item != null:
			selected.emit(self)
			return

		data.source.set_item(item)

	set_item(data.data)



func set_item(value: ItemDef) -> void:

	if value == null:
		clear()
		return


	item = value

	if item.element < ELEMENT_COLORS.size():
		$Background.color = ELEMENT_COLORS[item.element]
	else:
		$Background.color = OTHER_ELEMENT_COLOR

	$Sprite.texture = Assets.get_texture_for_item(item)

	item_equipped.emit(item, slot_id)


func clear() -> void:
	item = null
	$Background.color = OTHER_ELEMENT_COLOR
	$Sprite.texture = null
	item_equipped.emit(null, slot_id)



func _on_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton:

		match event.button_index:

			MOUSE_BUTTON_LEFT:
				if event.pressed:
					pressing = true
				elif pressing:
					selected.emit(self)

			MOUSE_BUTTON_RIGHT:
				clear()

	elif event is InputEventMouseMotion:
		pressing = false
