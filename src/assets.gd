extends Node



var item_defs: Dictionary
var stats: Dictionary



func _ready() -> void:

	for raw_item in load(Config.Paths.ITEM_DEFINITIONS).data:
		var item: ItemDef = ItemDef.new(raw_item)
		item_defs[item.id] = item

	for raw_stat in load(Config.Paths.STAT_DEFINITIONS).data:
		var stat: Stat = Stat.new(raw_stat)
		stats[stat.id] = stat



# Query

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



# Exporting

func export_items() -> void:

	var file = FileAccess.open(Config.Paths.EXPORTED_ITEMS, FileAccess.WRITE)
	var item_dicts: Array[Dictionary] = []

	for item in item_defs.values():
		item_dicts.append(item.to_json())

	file.store_string(JSON.stringify(item_dicts))


func export_item(item: ItemDef) -> void:
	var file = FileAccess.open("user://%s.json" % item.display_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(item.to_json(), "\t"))


func save_items() -> void:

	var file = FileAccess.open(Config.Paths.ITEM_DEFINITIONS, FileAccess.WRITE)
	var item_dicts: Array[Dictionary] = []

	for item in item_defs.values():
		item_dicts.append(item.to_json())

	file.store_string(JSON.stringify(item_dicts))



# Textures

func get_item_texture_for_def(item: ItemDef) -> Texture2D:
	return load(Config.Paths.ITEM_IMAGES.path_join(item.texture))


func get_stat_texture_for_id(id: String) -> Texture2D:
	return load(Config.Paths.STAT_IMAGES.path_join(id + ".svg"))


func get_slot_background_for_element(element: ItemDef.Element) -> Texture2D:
	var path: String = Config.Paths.SLOT_ELEMENT_BACKGROUNDS
	var file_name: String = ItemDef.Element.find_key(element) + ".png"
	return load(path.path_join(file_name))


func get_slot_border_for_tier(tier: ItemDef.Tier) -> Texture2D:
	var path: String = Config.Paths.SLOT_TIER_BORDERS
	var file_name: String = ItemDef.Tier.find_key(tier) + ".png"
	return load(path.path_join(file_name))


func get_slot_symbol_for_type(type: ItemDef.Type) -> Texture2D:
	var path: String = Config.Paths.SLOT_SYMBOLS
	var file_name: String = ItemDef.Type.find_key(type) + ".png"
	return load(path.path_join(file_name))
