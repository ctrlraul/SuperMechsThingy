extends Node2D
class_name MechGFXPart
signal animation_finished()



const __FIRING_INTERVAL: float = 0.1



const RocketScene = preload("res://mech_gfx/projectiles/rocket.tscn")
const BigRocketScene = preload("res://mech_gfx/projectiles/big_rocket.tscn")
const BulletsScene = preload("res://mech_gfx/projectiles/bullets.tscn")



@onready var sprite: Sprite2D = %Sprite2D
@onready var ornaments_container: Node2D = %OrnamentsContainer
@onready var glowing_ornaments: Node2D = %Glowing
@onready var blinking_ornaments: Node2D = %Blinking
@onready var projectiles_container: Node = %Projectiles



const OUTLINE: int = 2
const MARGIN: int = 1



var size: Vector2i
var item: Item
var torso_joint: Vector2 :
	get:
		if ItemDef.Joint.TORSO in item.def.joints:
			return item.def.joints[ItemDef.Joint.TORSO]
		return Vector2.ZERO



func _ready() -> void:
	Assets.item_changed.connect(_on_item_changed)



func set_item(value: Item) -> void:

	clear()

	if value == null:
		return

	item = value

	visible = true

	var texture: Texture2D = Assets.get_item_texture_for_def(item.def)
	var image: Image = texture.get_image()

	size = texture.get_size()

	var padded_image = Image.create(
		size.x + OUTLINE * 2 + MARGIN,
		size.y + OUTLINE * 2 + MARGIN,
		false,
		image.get_format()
	)

	padded_image.blit_rect(
		image,
		Rect2i(Vector2.ZERO, size),
		Vector2.ONE * OUTLINE + Vector2.ONE * MARGIN
	)

	sprite.texture = ImageTexture.create_from_image(padded_image)

	if item.def.type != ItemDef.Type.TORSO:
		sprite.position = size * 0.5 -torso_joint

	__prepare_animations()


func clear() -> void:

	size = Vector2i.ZERO
	item = null
	visible = false

	ornaments_container.visible = false

	NodeUtils.clear(blinking_ornaments)
	NodeUtils.clear(glowing_ornaments)


func play_animation(target_visual_center: Vector2) -> void:

	for projectile in item.def.projectiles:

		match projectile.gfx:

			MechGFX.Projectile.ROCKET:
				await __fire_rocket(projectile, target_visual_center).finished

			MechGFX.Projectile.BIG_ROCKET:
				await __fire_big_rocket(projectile, target_visual_center).finished

			MechGFX.Projectile.BULLETS:
				__fire_bullets(projectile)

			_:
				var key = MechGFX.Projectile.find_key(projectile.gfx)
				push_error("Animation for %s is not implemented" % key)

	var tween: Tween = create_tween()

	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(glowing_ornaments, "modulate:a", 1, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(glowing_ornaments, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN)

	ornaments_container.visible = true
	await __time(1.5)
	ornaments_container.visible = false



func __fire_rocket(config: ItemDef.ProjectileConfig, target: Vector2) -> Tween:

	var recoil: Vector2 = Vector2(10, 0)
	var projectile = RocketScene.instantiate()

	projectiles_container.add_child(projectile)
	projectile.position = global_position + (-torso_joint + config.place) * global_scale
	projectile.scale = global_scale
	projectile.fire(target)

	# Recoil effect

	var tween: Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "position:x", sprite.position.x, __FIRING_INTERVAL)

	sprite.position -= recoil

	return tween


func __fire_big_rocket(config: ItemDef.ProjectileConfig, target: Vector2) -> Tween:

	var recoil: Vector2 = Vector2(10, 0)
	var projectile = BigRocketScene.instantiate()

	projectiles_container.add_child(projectile)
	projectile.position = global_position + (-torso_joint + config.place) * global_scale
	projectile.scale = global_scale
	projectile.fire(target)

	# Recoil effect

	var tween: Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "position:x", sprite.position.x, __FIRING_INTERVAL)

	sprite.position -= recoil

	return tween


func __fire_bullets(config: ItemDef.ProjectileConfig) -> void:
	var projectile = BulletsScene.instantiate()
	projectiles_container.add_child(projectile)
	projectile.position = -torso_joint + config.place
	projectile.scale = global_scale


func __prepare_animations() -> void:

	NodeUtils.clear(blinking_ornaments)

	for ornament in item.def.ornaments:

		var ornament_sprite = Sprite2D.new()

		ornament_sprite.position = ornament.place - torso_joint
		ornament_sprite.texture = ornament.texture

		match ornament.effect:

			ItemDef.OrnamentConfig.Effect.NONE:
				pass

			ItemDef.OrnamentConfig.Effect.BLINK:
				blinking_ornaments.add_child(ornament_sprite)
				ornament_sprite.use_parent_material = true

			ItemDef.OrnamentConfig.Effect.GLOW:
				glowing_ornaments.add_child(ornament_sprite)

			_:
				assert(false, "Not Implemented")


func __time(seconds: float) -> Signal:
	return get_tree().create_timer(seconds).timeout



func _on_item_changed(item_def: ItemDef) -> void:
	if item && item.def == item_def:
		set_item(item)
