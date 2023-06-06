extends TabBar
signal joint_changed(item: ItemDef)



@onready var points_editor: Control = %PointsEditor



var item: ItemDef



func set_item(value: ItemDef) -> void:

	if value == null:
		clear()
		return

	item = value

	points_editor.clear()
	points_editor.set_reference_texture(Assets.get_texture_for_item(item))

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


func clear() -> void:
	item = null
	points_editor.clear()


func __emit_joint_changed(joint_value: ItemDef.Joint, place: Vector2) -> void:
	item.joints[joint_value] = place
	joint_changed.emit(item)
