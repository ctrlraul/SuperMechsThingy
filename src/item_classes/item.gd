class_name Item

var def: ItemDef
var paint: int = 0
var level: int = 1

func _init(source) -> void:

	if source is ItemDef:
		def = source

	else:
		def = Assets.get_item_def(source.item_id)
		paint = source.paint
		level = source.level
