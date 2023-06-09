extends Control
signal joint_changed(item: ItemDef)
signal animation_preview_requested(item: ItemDef)
signal ornament_changed(item: ItemDef)



const ANIMATABLE_ITEM_TYPES: Array[ItemDef.Type] = [
	ItemDef.Type.LEGS,
	ItemDef.Type.SIDE_WEAPON,
	ItemDef.Type.TOP_WEAPON,
	ItemDef.Type.DRONE,
]



@export var point_scene: PackedScene



@onready var empty_text: Panel = $EmptyText
@onready var tab_container: TabContainer = %TabContainer

@onready var overview_tab = %Overview
@onready var joints_tab = %Joints
@onready var animations_tab = %Animations



var item: ItemDef



func _ready() -> void:
	__clear()


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.data is Item || data.data is ItemDef


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data.data is Item:
		set_item(data.data.def)
	elif data.data is ItemDef:
		set_item(data.data)



func set_item(value: ItemDef) -> void:

	if value == null:
		__clear()
		return

	var animations_tab_index: int = tab_container.get_children().find(animations_tab)

	item = value
	empty_text.visible = false
	tab_container.visible = true

	overview_tab.set_item(item)
	joints_tab.set_item(item)

	if item.type in ANIMATABLE_ITEM_TYPES:
		tab_container.set_tab_disabled(animations_tab_index, false)
		animations_tab.set_item(item)

	else:
		tab_container.set_tab_disabled(animations_tab_index, true)
		if tab_container.current_tab == animations_tab_index:
			tab_container.current_tab = 0



func __clear() -> void:

	item = null

	empty_text.visible = true
	tab_container.visible = false

	overview_tab.clear()
	joints_tab.clear()
	animations_tab.clear()



func _on_joints_tab_joint_changed(updated_item: ItemDef) -> void:
	joint_changed.emit(updated_item)



func _on_animations_animation_preview_requested(updated_item: ItemDef) -> void:
	animation_preview_requested.emit(updated_item)


func _on_animations_ornament_changed(updated_item: ItemDef) -> void:
	ornament_changed.emit(updated_item)
