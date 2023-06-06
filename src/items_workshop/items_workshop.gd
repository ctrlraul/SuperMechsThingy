extends Node2D



@export var item_button_scene: PackedScene


@onready var item_buttons_container: GridContainer = %ItemButtonsContainer
@onready var mech_gfx: MechGFX = %MechGFX
@onready var item_inspector: Control = %ItemInspector
@onready var save_button: Button = %SaveButton



var mech_build: MechBuild = MechBuild.new()



func _ready() -> void:

	save_button.visible = OS.has_feature("editor")

	mech_build.set_item(
		MechBuild.Slot.TORSO,
		Item.new({
			"uuid": "uuid",
			"item_id": 1,
			"level": 1,
			"paint": 0
		})
	)

	mech_build.set_item(
		MechBuild.Slot.LEGS,
		Item.new({
			"uuid": "uuid",
			"item_id": 7,
			"level": 1,
			"paint": 0
		})
	)

	mech_build.set_item(
		MechBuild.Slot.SIDE_WEAPON_1,
		Item.new({
			"uuid": "uuid",
			"item_id": 65,
			"level": 1,
			"paint": 0
		})
	)

	mech_gfx.set_build(mech_build)


	for item_slot in %SlotsContainer.get_children():
		item_slot.item_equipped.connect(_on_item_equipped)

	for item_button in item_buttons_container.get_children():
		item_button.queue_free()

	for item in Assets.get_items():
		var item_button = item_button_scene.instantiate()
		item_buttons_container.add_child(item_button)
		item_button.set_item(item)

	await get_tree().create_timer(0.5).timeout

	mech_gfx.play_for_slot(MechBuild.Slot.SIDE_WEAPON_1)



func _on_item_equipped(item: ItemDef, slot_id: MechBuild.Slot) -> void:

	if item != null:
		mech_build.set_item(slot_id, Item.new(item))
	else:
		mech_build.set_item(slot_id, null)

	mech_gfx.set_build(mech_build)


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
	for id in MechBuild.Slot.values():
		var build_item = mech_build.get_item(id)
		if build_item && build_item.def == item:
			mech_gfx.play_for_slot(id)
			return
	print("Item not equipped")


func _on_export_button_pressed() -> void:
	Assets.export_items()


func _on_save_button_pressed() -> void:
	Assets.save_items()
