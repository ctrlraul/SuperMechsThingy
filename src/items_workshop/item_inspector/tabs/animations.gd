extends TabBar
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

	clear()

	mech_movement_options.clear()

	for movement in MechGFX.Movement:
		mech_movement_options.add_item(movement.capitalize())




func set_item(value: ItemDef) -> void:

	if value == null:
		clear()
		return

	item = value

	points_editor.clear()
	points_editor.set_reference_texture(Assets.get_item_texture_for_def(item))

	mech_movement_options.selected = item.mech_movement

	__add_animation_ornament_points()
	__add_animation_projectile_points()



func clear() -> void:
	points_editor.clear()
	mech_movement_options.select(-1)

	for child in ornaments_list.get_children():
		child.queue_free()

	for child in projectiles_list.get_children():
		child.queue_free()



func __add_animation_ornament_points() -> void:

	for child in ornaments_list.get_children():
		child.queue_free()

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


func __add_animation_projectile_points() -> void:

	for child in projectiles_list.get_children():
		child.queue_free()

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
