extends Panel
signal joints_copied(joints: Dictionary)



var item_type: ItemDef.Type



func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:

	if data.data is ItemDef && data.data.type == item_type:
		return true

	if data.data is Item:
		return true

	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data.data is ItemDef:
		joints_copied.emit(data.data.joints)
	elif data.data is Item:
		joints_copied.emit(data.data.def.joints)
