extends Panel
signal joints_copied(joints: Dictionary)



var item_type: ItemDef.Type



func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.data is ItemDef && data.data.type == item_type


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	joints_copied.emit(data.data.joints)
