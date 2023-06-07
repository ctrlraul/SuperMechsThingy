extends Control
class_name ItemSlot
signal item_equipped(item: ItemDef, slot_id: MechBuild.Slot)
signal selected(slot: ItemSlot)



const __BACKGROUNDS = {
	ItemDef.Element.PHYSICAL: preload("backgrounds/PHYSICAL.png"),
	ItemDef.Element.EXPLOSIVE: preload("backgrounds/EXPLOSIVE.png"),
	ItemDef.Element.ELECTRIC: preload("backgrounds/ELECTRIC.png"),
	ItemDef.Element.OTHER: preload("backgrounds/OTHER.png"),
}

const __BORDERS = {
	ItemDef.Tier.COMMON: preload("borders/COMMON.png"),
	ItemDef.Tier.RARE: preload("borders/RARE.png"),
	ItemDef.Tier.EPIC: preload("borders/EPIC.png"),
	ItemDef.Tier.LEGENDARY: preload("borders/LEGENDARY.png"),
	ItemDef.Tier.MYTHICAL: preload("borders/MYTHICAL.png"),
	ItemDef.Tier.DIVINE: preload("borders/DIVINE.png"),
}



@export var item_type: ItemDef.Type
@export var slot_id: MechBuild.Slot



@onready var element_color: TextureRect = $ElementColor
@onready var tier_border: TextureRect = $TierBorder
@onready var display_item: Control = $DisplayItem



var item: Item
var pressing: bool = false



func _ready() -> void:
	__set_slot_symbol()
	clear()


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

	element_color.texture = __BACKGROUNDS[item.def.element]
	tier_border.texture = __BORDERS[item.def.tier]

	display_item.set_item(item)

	item_equipped.emit(item, slot_id)


func clear() -> void:

	item = null

	element_color.texture = null
	tier_border.texture = null

	display_item.clear()

	item_equipped.emit(null, slot_id)



func __set_slot_symbol() -> void:

	$SlotSymbol.texture = load(
		"res://item_slot/symbols/%s.png" %
		ItemDef.Type.find_key(item_type)
	)

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
