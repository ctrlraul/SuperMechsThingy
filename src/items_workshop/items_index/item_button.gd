extends Button
class_name SMItemButton



@onready var element_color: TextureRect = %ElementColor
@onready var tier_border: TextureRect = %TierBorder
@onready var display_item: Control = %DisplayItem



var item: Item

func _ready() -> void:
	Assets.item_changed.connect(_on_item_changed)



func _get_drag_data(_position: Vector2):
	return DragData.new(self, item)



func set_item(value: Item) -> void:
	item = value
	element_color.texture = Assets.get_slot_background_for_element(item.def.element)
	tier_border.texture = Assets.get_slot_border_for_tier(item.def.tier)
	display_item.set_item(item)



func _on_item_changed(item_def: ItemDef) -> void:
	if item_def == item.def:
		set_item(item)
