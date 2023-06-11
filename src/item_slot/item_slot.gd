@tool

class_name ItemSlot
extends Control

signal item_equipped(item: ItemDef, slot_id: MechBuild.Slot)
signal selected(slot: ItemSlot)



const GROUP: String = "ITEM_SLOTS"



@onready var slot_display_item: Control = %SlotDisplayItem
@onready var slot_symbol: TextureRect = %SlotSymbol



@export var slot_id: MechBuild.Slot
@export var item_type: ItemDef.Type :
	set(value):
		item_type = value
		__update_slot_symbol()



var item: Item
var pressing: bool = false



func _ready() -> void:
	add_to_group(GROUP)
	slot_display_item.visible = !Engine.is_editor_hint()



func _get_drag_data(_position: Vector2):
	return DragData.new(self, item)


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:

	if data.source is ItemSlot && (!data.data || data.data.def.type == item_type):
		return true

	if data.data is Item && data.data.def.type == item_type:
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



func set_item(value: Item) -> void:

	if value == null:
		clear()
		return

	item = value
	slot_display_item.set_item(item)
	item_equipped.emit(item, slot_id)


func clear() -> void:
	item = null
	slot_display_item.clear()
	item_equipped.emit(null, slot_id)



func __update_slot_symbol() -> void:

	$SlotSymbol.texture = Assets.get_slot_symbol_for_type(item_type)

	if item_type == ItemDef.Type.SIDE_WEAPON || item_type == ItemDef.Type.TOP_WEAPON:
		$SlotSymbol.flip_h = !MechGFX.is_frontal_slot(slot_id)



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
