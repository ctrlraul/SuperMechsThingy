extends Button
class_name SMItemButton



@onready var slot_display_item: Control = %SlotDisplayItem



var item: Item



func _ready() -> void:
	Assets.item_changed.connect(_on_item_changed)



func _get_drag_data(_position: Vector2):
	return DragData.new(self, item)



func set_item(value: Item) -> void:
	item = value
	slot_display_item.set_item(item)



func _on_item_changed(item_def: ItemDef) -> void:
	if item_def == item.def:
		set_item(item)
