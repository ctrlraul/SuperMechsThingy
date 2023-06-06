extends Node



const ITEM_DEFINITIONS_PATH: String = "res://data/items.json"
const STAT_DEFINITIONS_PATH: String = "res://data/stats.json"
const ITEM_IMAGES_PATH: String = "res://assets/images/items/"
const STAT_IMAGES_PATH: String = "res://assets/images/stats/"
const EXPORTED_ITEM_DEFINITIONS_PATH: String = "user://items.json"



var item_defs: Dictionary
var stats: Dictionary



func _ready() -> void:

	for raw_item in load(ITEM_DEFINITIONS_PATH).data:
		var item: ItemDef = ItemDef.new(raw_item)
		item_defs[item.id] = item

	for raw_stat in load(STAT_DEFINITIONS_PATH).data:
		var stat: Stat = Stat.new(raw_stat)
		stats[stat.id] = stat



func get_item_def(id: int) -> ItemDef:
	return item_defs[id]


func get_items() -> Array[ItemDef]:
	var items_list: Array[ItemDef] = []
	for item in item_defs.values():
		items_list.append(item)
	return items_list


func get_first_torso() -> ItemDef:
	for item in item_defs.values():
		if item.type == ItemDef.Type.TORSO:
			return item
	return null


func get_first_legs() -> ItemDef:
	for item in item_defs.values():
		if item.type == ItemDef.Type.LEGS:
			return item
	return null


func get_texture_for_item(item: ItemDef) -> Texture2D:
	return load(ITEM_IMAGES_PATH.path_join(item.texture))


func get_texture_for_stat_id(id: String) -> Texture2D:
	return load(STAT_IMAGES_PATH.path_join(id + ".svg"))


func export_items() -> void:

	var file = FileAccess.open(EXPORTED_ITEM_DEFINITIONS_PATH, FileAccess.WRITE)
	var item_dicts: Array[Dictionary] = []

	for item in item_defs.values():
		item_dicts.append(item.to_json())

	file.store_string(JSON.stringify(item_dicts))


func export_item(item: ItemDef) -> void:
	var file = FileAccess.open("user://%s.json" % item.display_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(item.to_json(), "\t"))


func save_items() -> void:

	var file = FileAccess.open(ITEM_DEFINITIONS_PATH, FileAccess.WRITE)
	var item_dicts: Array[Dictionary] = []

	for item in item_defs.values():
		item_dicts.append(item.to_json())

	file.store_string(JSON.stringify(item_dicts))
