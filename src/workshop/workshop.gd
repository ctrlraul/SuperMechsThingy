extends Node2D



const MAX_WEIGHT: int = 1000



@onready var mech_gfx: Node2D = %MechGFX

@onready var items_lists: Control = %ItemsLists

@onready var torsos_and_legs_index: TabContainer = %TorsosAndLegsIndex
@onready var side_weapons_index: TabContainer = %SideWeaponsIndex
@onready var top_weapons_index: TabContainer = %TopWeaponsIndex
@onready var drones_index: TabContainer = %DronesIndex
@onready var specials_list_container: PanelContainer = %SpecialsListContainer
@onready var specials_list: PanelContainer = %SMItemsList
@onready var modules_index: TabContainer = %ModulesIndex

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

	var torsos_and_legs: Array[ItemDef] = []
	var side_weapons: Array[ItemDef] = []
	var top_weapons: Array[ItemDef] = []
	var drones: Array[ItemDef] = []
	var specials: Dictionary = {}
	var modules: Array[ItemDef] = []
	var perks: Array[ItemDef] = []

	for item_def in Assets.items_list:
		match item_def.type:

			ItemDef.Type.TORSO:
				torsos_and_legs.append(item_def)

			ItemDef.Type.LEGS:
				torsos_and_legs.append(item_def)

			ItemDef.Type.SIDE_WEAPON:
				side_weapons.append(item_def)

			ItemDef.Type.TOP_WEAPON:
				top_weapons.append(item_def)

			ItemDef.Type.DRONE:
				drones.append(item_def)

			ItemDef.Type.CHARGE_ENGINE,\
			ItemDef.Type.TELEPORTER,\
			ItemDef.Type.GRAPPLING_HOOK,\
			ItemDef.Type.SHIELD:
				if specials.has(item_def.type):
					specials[item_def.type].append(item_def)
				else:
					specials[item_def.type] = [item_def]

			ItemDef.Type.PERK:
				perks.append(item_def)

			ItemDef.Type.MODULE:
				modules.append(item_def)

			_:
				assert(false, "Not implemented")

	torsos_and_legs_index.set_item_defs(torsos_and_legs)
	side_weapons_index.set_item_defs(side_weapons)
	top_weapons_index.set_item_defs(top_weapons)
	drones_index.set_item_defs(drones)
	modules_index.set_item_defs(modules)

	for type in specials:
		var label = ItemDef.Type.find_key(type).capitalize()
		specials_list.add_section(label)

		for item in specials[type]:
			specials_list.add_item(Item.new(item))


func __hide_all() -> void:
	for list in items_lists.get_children():
		list.visible = false


func __clear() -> void:

	mech_build = MechBuild.new()
	mech_gfx.set_build(mech_build)

	var stats: Dictionary = StatsManager.get_stats_for_build(mech_build)
	stats.erase(ItemDef.Stat.WEIGHT)
	stats_display.set_stats(stats)

	__hide_all()
	__set_weight_label(0)

	torsos_and_legs_index.visible = true


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
	torsos_and_legs_index.visible = true


func _on_side_weapons_button_pressed() -> void:
	__hide_all()
	side_weapons_index.visible = true


func _on_top_weapons_button_pressed() -> void:
	__hide_all()
	top_weapons_index.visible = true


func _on_drones_button_pressed() -> void:
	__hide_all()
	drones_index.visible = true


func _on_specials_button_pressed() -> void:
	__hide_all()
	specials_list_container.visible = true


func _on_modules_button_pressed() -> void:
	__hide_all()
	modules_index.visible = true


func _on_perks_button_pressed() -> void:
	__hide_all()


func _on_item_equipped(item: Item, slot: MechBuild.Slot) -> void:

	mech_build.set_item(slot, item)
	mech_gfx.set_build(mech_build)

	var stats: Dictionary = StatsManager.get_stats_for_build(mech_build)
	__set_weight_label(stats[ItemDef.Stat.WEIGHT])
	stats.erase(ItemDef.Stat.WEIGHT)
	stats_display.set_stats(stats)


func _on_general_item_drop_area_item_button_dropped(item: Item) -> void:
	__auto_equip(item)
