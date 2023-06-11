extends Node2D



const MAX_WEIGHT: int = 1000



@onready var mech_gfx: Node2D = %MechGFX

@onready var body_items_index: TabContainer = %BodyItemsIndex
@onready var special_items_index: TabContainer = %SpecialItemsIndex
@onready var module_items_index: TabContainer = %ModuleItemsIndex

@onready var weight_label: Label = %Weight
@onready var stats_display: GridContainer = %StatsDisplay

@onready var slots: Array = get_tree().get_nodes_in_group(ItemSlot.GROUP)



var mech_build: MechBuild



func _ready() -> void:
	__setup_slots()
	__fill_item_lists()
	__clear()



func __setup_slots() -> void:
	for slot in slots:
		slot.item_equipped.connect(_on_item_equipped)


func __fill_item_lists() -> void:
	var body_items: Array[ItemDef] = []
	var special_items: Array[ItemDef] = []
	var module_items: Array[ItemDef] = []

	for item_def in Assets.items_list:
		match item_def.type:

			ItemDef.Type.TORSO,\
			ItemDef.Type.LEGS,\
			ItemDef.Type.SIDE_WEAPON,\
			ItemDef.Type.TOP_WEAPON:
				body_items.append(item_def)

			ItemDef.Type.DRONE,\
			ItemDef.Type.CHARGE_ENGINE,\
			ItemDef.Type.TELEPORTER,\
			ItemDef.Type.GRAPPLING_HOOK,\
			ItemDef.Type.SHIELD,\
			ItemDef.Type.PERK:
				special_items.append(item_def)

			ItemDef.Type.MODULE:
				module_items.append(item_def)

			_:
				assert(false, "Not implemented")

	body_items_index.set_items(body_items)
	special_items_index.set_items(special_items)
	module_items_index.set_items(module_items)


func __hide_all() -> void:
	body_items_index.visible = false
	special_items_index.visible = false
	module_items_index.visible = false


func __clear() -> void:

	mech_build = MechBuild.new()
	mech_gfx.set_build(mech_build)

	var stats: Dictionary = StatsManager.get_stats_for_build(mech_build)
	stats.erase(ItemDef.Stat.WEIGHT)
	stats_display.set_stats(stats)

	__hide_all()
	__set_weight_label(0)
	_on_body_button_pressed()


func __set_weight_label(weight: int) -> void:
	weight_label.text = "%s/%s" % [weight, MAX_WEIGHT]


func __auto_equip(item: Item) -> void:

	for slot in slots:
		if slot.item_type == item.def.type && slot.item == null:
			slot.set_item(item)
			return

	for slot in slots:
		if slot.item_type == item.def.type:
			slot.set_item(item)
			return




func _on_return_button_pressed() -> void:
	pass # Replace with function body.


func _on_body_button_pressed() -> void:
	__hide_all()
	body_items_index.visible = true


func _on_specials_button_pressed() -> void:
	__hide_all()
	special_items_index.visible = true


func _on_modules_button_pressed() -> void:
	__hide_all()
	module_items_index.visible = true


func _on_item_equipped(item: Item, slot: MechBuild.Slot) -> void:

	mech_build.set_item(slot, item)
	mech_gfx.set_build(mech_build)

	var stats: Dictionary = StatsManager.get_stats_for_build(mech_build)
	__set_weight_label(stats[ItemDef.Stat.WEIGHT])
	stats.erase(ItemDef.Stat.WEIGHT)
	stats_display.set_stats(stats)


func _on_general_item_drop_area_item_button_dropped(item: Item) -> void:
	__auto_equip(item)
