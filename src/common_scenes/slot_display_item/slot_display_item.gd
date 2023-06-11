extends Control



@onready var element_color: TextureRect = $ElementColor
@onready var tier_border: TextureRect = $TierBorder
@onready var display_item: Control = $DisplayItem



func _ready() -> void:
	clear()



func clear() -> void:
	element_color.texture = null
	tier_border.texture = null
	display_item.clear()


func set_item(item: Item) -> void:

	if item == null:
		clear()
		return

	element_color.texture = Assets.get_slot_background_for_element(item.def.element)
	tier_border.texture = Assets.get_slot_border_for_tier(item.def.tier)
	display_item.set_item(item)


func set_item_def(item_def: ItemDef) -> void:
	set_item(Item.new(item_def))
