extends Control
signal joint_changed(item: ItemDef)
signal animation_preview_requested(item: ItemDef)
signal ornament_changed(item: ItemDef)



@export var point_scene: PackedScene



@onready var empty_text: Panel = $EmptyText
@onready var tab_container: TabContainer = $TabContainer

@onready var overview_tab = %Overview
@onready var joints_tab = %Joints
@onready var animations_tab = %Animations



var item: ItemDef



func _ready() -> void:
	__clear()


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is ItemDef


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	set_item(data)



func set_item(value: ItemDef) -> void:

	if value == null:
		__clear()
		return

	item = value
	empty_text.visible = false
	tab_container.visible = true

	overview_tab.set_item(item)
	joints_tab.set_item(item)
	animations_tab.set_item(item)



func __clear() -> void:

	item = null

	empty_text.visible = true
	tab_container.visible = false

	overview_tab.clear()
	joints_tab.clear()
	animations_tab.clear()



func _on_joints_tab_joint_changed(updated_item: ItemDef) -> void:
	joint_changed.emit(updated_item)


func _on_item_ornament_changed(updated_item: ItemDef) -> void:
	ornament_changed.emit(updated_item)


func _on_animation_preview_requested(item_def: ItemDef) -> void:
	animation_preview_requested.emit(item_def)
