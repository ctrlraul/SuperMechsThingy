extends MarginContainer
signal joint_changed(item: ItemDef)



@onready var points_editor: Control = %PointsEditor
@onready var re_use_joints_drop_area: Panel = %ReUseJointsDropArea



var item: ItemDef



func set_item(value: ItemDef) -> void:

	if value == null:
		clear()
		return

	item = value
	re_use_joints_drop_area.item_type = item.type

	__refresh_joints()


func clear() -> void:
	item = null
	points_editor.clear()



func __refresh_joints() -> void:

	points_editor.clear()
	points_editor.set_reference_texture(Assets.get_item_texture_for_def(item))

	if item is ItemDef:

		for joint_value in ItemDef.get_joints_for_type(item.type):

			var joint: Vector2

			if joint_value in item.joints:
				joint = item.joints[joint_value]

			var joint_key: String = ItemDef.Joint.find_key(joint_value)
			var point = points_editor.add_point(joint, Color(1, 0, 1), joint_key.capitalize())

			point.moved.connect(
				func(place: Vector2) -> void:
					__emit_joint_changed(joint_value, place)
			)


func __emit_joint_changed(joint_value: ItemDef.Joint, place: Vector2) -> void:
	item.joints[joint_value] = place
	joint_changed.emit(item)



func _on_re_use_joints_drop_area_joints_copied(joints: Dictionary) -> void:
	item.joints = joints.duplicate()
	__refresh_joints()
	joint_changed.emit(item)
