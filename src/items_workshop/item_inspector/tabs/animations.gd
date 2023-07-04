extends MarginContainer
signal animation_preview_requested(item: ItemDef)
signal ornament_changed(item: ItemDef)



@export var projectiles_list_item_scene: PackedScene
@export var ornaments_list_item_scene: PackedScene



@onready var points_editor: Control = %PointsEditor
@onready var mech_movement_options: OptionButton = %MechMovementOptions
@onready var ornaments_list: VBoxContainer = %OrnamentsList
@onready var projectiles_list: VBoxContainer = %ProjectilesList



var item: ItemDef



func _ready() -> void:

	Assets.item_changed.connect(_on_item_changed)

	clear()

	mech_movement_options.clear()

	for movement in MechGFX.Movement:
		mech_movement_options.add_item(movement.capitalize())



func set_item(value: ItemDef) -> void:

	if value == null:
		clear()
		return

	item = value

	points_editor.clear_points()
	points_editor.set_reference_texture(Assets.get_item_texture_for_def(item))

	mech_movement_options.selected = item.mech_movement

	__add_animation_ornament_points()
	__add_animation_projectile_points()



func clear() -> void:

	points_editor.clear()
	mech_movement_options.select(-1)

	ornaments_list.visible = false
	projectiles_list.visible = false

	NodeUtils.clear(ornaments_list)
	NodeUtils.clear(projectiles_list)



func __add_animation_ornament_points() -> void:

	NodeUtils.clear(ornaments_list)

	for ornament in item.ornaments:

		var list_item = ornaments_list_item_scene.instantiate()
		ornaments_list.add_child(list_item)
		list_item.init(item, ornament)

		var point = points_editor.add_point(
			ornament.place,
			list_item.color_rect.color,
			"",
			ornament.texture
		)

		point.moved.connect(
			func(place: Vector2) -> void:
				ornament.place = place
				ornament_changed.emit(item)
		)

	ornaments_list.visible = ornaments_list.get_child_count() > 0


func __add_animation_projectile_points() -> void:

	NodeUtils.clear(projectiles_list)

	for projectile in item.projectiles:

		var list_item = projectiles_list_item_scene.instantiate()
		projectiles_list.add_child(list_item)
		list_item.init(item, projectile)

		var point = points_editor.add_point(
			projectile.place,
			list_item.color_rect.color,
			MechGFX.Projectile.find_key(projectile.gfx).capitalize()
		)

		point.moved.connect(
			func(place: Vector2) -> void:
				projectile.place = place
		)

	projectiles_list.visible = projectiles_list.get_child_count() > 0



func _on_item_changed(item_def: ItemDef) -> void:
	if item_def == item:
		set_item(item)


func _on_preview_button_pressed() -> void:
	animation_preview_requested.emit(item)


func _on_mech_movement_selected(index: int) -> void:
	item.mech_movement = index as MechGFX.Movement


func _on_add_ornament_button_pressed() -> void:
	var ornament: ItemDef.OrnamentConfig = ItemDef.OrnamentConfig.new()
	item.ornaments.append(ornament)
	set_item(item)


func _on_add_projectile_button_pressed() -> void:

	var projectile: ItemDef.ProjectileConfig = ItemDef.ProjectileConfig.new()

	projectile.id = str(randi())

	item.projectiles.append(projectile)
	set_item(item)
