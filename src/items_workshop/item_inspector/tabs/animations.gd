extends TabBar
signal animation_preview_requested(item: ItemDef)
signal ornament_changed(item: ItemDef)



@onready var points_editor: Control = %PointsEditor
@onready var mech_movement_options: OptionButton = %MechMovementOptions
@onready var add_projectile_options: OptionButton = %AddProjectileOptions



var item: ItemDef



func _ready() -> void:

	clear()

	mech_movement_options.clear()

	for movement in MechGFX.Movement:
		mech_movement_options.add_item(movement.capitalize())

	for projectile in MechGFX.Projectile:
		add_projectile_options.add_item(projectile.capitalize())



func set_item(value: ItemDef) -> void:

	if value == null:
		clear()
		return

	item = value

	points_editor.clear()
	points_editor.set_reference_texture(Assets.get_texture_for_item(item))

	mech_movement_options.selected = item.mech_movement

	__add_animation_ornament_points()
	__add_animation_projectile_points()



func clear() -> void:
	points_editor.clear()
	mech_movement_options.select(-1)



func __add_animation_ornament_points() -> void:
	for ornament in item.ornaments:

		var point = points_editor.add_point(
			ornament.place,
			Color(0, 0.5, 1),
			"",
			ornament.texture
		)

		point.moved.connect(
			func(place: Vector2) -> void:
				ornament.place = place
				ornament_changed.emit(item)
		)


func __add_animation_projectile_points() -> void:
	for projectile in item.projectiles:

		var point = points_editor.add_point(
			projectile.place,
			Color(1, 0.5, 0),
			MechGFX.Projectile.find_key(projectile.gfx).capitalize()
		)

		point.moved.connect(
			func(place: Vector2) -> void:
				projectile.place = place
		)


func _on_preview_button_pressed() -> void:
	animation_preview_requested.emit(item)


func _on_mech_movement_selected(index: int) -> void:
	item.mech_movement = index as MechGFX.Movement


func _on_add_projectile_button_pressed() -> void:

	var projectile: ItemDef.ProjectileConfig = ItemDef.ProjectileConfig.new()

	projectile.id = str(randi())
	projectile.gfx = add_projectile_options.selected as MechGFX.Projectile

	item.projectiles.append(projectile)
	set_item(item)


