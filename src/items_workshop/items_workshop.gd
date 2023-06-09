extends Node2D
class_name ItemsWorkshop



@export var item_button_scene: PackedScene


@onready var mech_gfx: MechGFX = %MechGFX
@onready var items_index: TabContainer = %ItemsIndex
@onready var item_inspector: Control = %ItemInspector
@onready var save_button: Button = %SaveButton

# Slots
@onready var torso_slot: ItemSlot = %TorsoSlot
@onready var legs_slot: ItemSlot = %LegsSlot
@onready var side_weapon_1_slot: ItemSlot = %SideWeapon1Slot
@onready var side_weapon_2_slot: ItemSlot = %SideWeapon2Slot
@onready var side_weapon_3_slot: ItemSlot = %SideWeapon3Slot
@onready var side_weapon_4_slot: ItemSlot = %SideWeapon4Slot
@onready var top_weapon_1_slot: ItemSlot = %TopWeapon1Slot
@onready var top_weapon_2_slot: ItemSlot = %TopWeapon2Slot
@onready var drone_slot: ItemSlot = %DroneSlot



var mech_build: MechBuild = MechBuild.new()



func _ready() -> void:

	save_button.visible = OS.has_feature("editor")

	for slot in %SlotsContainer.get_children():
		slot.item_equipped.connect(_on_item_equipped)
		slot.selected.connect(_on_item_slot_selected)

	items_index.set_items(Assets.items_list)



func __auto_equip(item: Item) -> void:
	match item.def.type:

		ItemDef.Type.TORSO: torso_slot.set_item(item)
		ItemDef.Type.LEGS: legs_slot.set_item(item)
		ItemDef.Type.DRONE: drone_slot.set_item(item)

		ItemDef.Type.SIDE_WEAPON:

			var equipped: bool = false
			var side_weapon_slots: Array[ItemSlot] = [
				side_weapon_1_slot, side_weapon_2_slot,
				side_weapon_3_slot, side_weapon_4_slot,
			]

			for slot in side_weapon_slots:
				if slot.item == null:
					slot.set_item(item)
					equipped = true
					break

			if !equipped:
				side_weapon_1_slot.set_item(item)

		ItemDef.Type.TOP_WEAPON:

			var equipped: bool = false
			var top_weapon_slots: Array[ItemSlot] = [
				top_weapon_1_slot, top_weapon_2_slot
			]

			for slot in top_weapon_slots:
				if slot.item == null:
					slot.set_item(item)
					equipped = true
					break

			if !equipped:
				top_weapon_1_slot.set_item(item)



func _on_item_equipped(item: Item, slot_id: MechBuild.Slot) -> void:

	mech_build.set_item(slot_id, item)
	mech_gfx.set_build(mech_build)

	if item_inspector.item == null:
		item_inspector.set_item(item.def)


func _on_item_slot_selected(slot: ItemSlot) -> void:
	if slot.item != null:
		item_inspector.set_item(slot.item.def)


func _on_jump_button_pressed() -> void:
	mech_gfx.play_jump()


func _on_sword_button_pressed() -> void:
	if mech_build.side_weapon_1 && mech_build.side_weapon_1.def == item_inspector.item:
		mech_gfx.play_melee(MechBuild.Slot.SIDE_WEAPON_1)
	if mech_build.side_weapon_2 && mech_build.side_weapon_2.def == item_inspector.item:
		mech_gfx.play_melee(MechBuild.Slot.SIDE_WEAPON_2)
	if mech_build.side_weapon_3 && mech_build.side_weapon_3.def == item_inspector.item:
		mech_gfx.play_melee(MechBuild.Slot.SIDE_WEAPON_3)
	if mech_build.side_weapon_4 && mech_build.side_weapon_4.def == item_inspector.item:
		mech_gfx.play_melee(MechBuild.Slot.SIDE_WEAPON_4)


func _on_backflip_button_pressed() -> void:
	mech_gfx.play_backflip()


func _on_item_joint_changed(item: ItemDef) -> void:
	if mech_build.has(item):
		mech_gfx.set_build(mech_build)


func _on_item_inspector_ornament_changed(item) -> void:
	if mech_build.has(item):
		mech_gfx.set_build(mech_build)


func _on_item_inspector_animation_preview_requested(item) -> void:

	if !mech_build.torso:
		torso_slot.set_item(Item.new(Assets.get_first_torso()))

	if !mech_build.legs:
		legs_slot.set_item(Item.new(Assets.get_first_legs()))

	if !mech_build.has(item):
		__auto_equip(Item.new(item))

	for id in MechBuild.Slot.values():
		var build_item = mech_build.get_item(id)
		if build_item && build_item.def == item:
			mech_gfx.play_for_slot(id)
			break


func _on_export_button_pressed() -> void:
	Assets.export_items()


func _on_save_button_pressed() -> void:
	Assets.save_items()


func _on_general_item_drop_area_item_button_dropped(item: Item) -> void:
	__auto_equip(item)


func _on_items_index_item_selected(item: ItemDef) -> void:
	item_inspector.set_item(item)
