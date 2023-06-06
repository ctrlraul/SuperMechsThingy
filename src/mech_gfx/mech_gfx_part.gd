extends Node2D
class_name MechGFXPart
signal animation_finished()



const __FIRING_INTERVAL: float = 0.1



const RocketScene = preload("res://mech_gfx/projectiles/rocket.tscn")
const BigRocketScene = preload("res://mech_gfx/projectiles/big_rocket.tscn")



@onready var sprite: Sprite2D = %Sprite2D
@onready var blinking_props: Node2D = %BlinkingProps
@onready var projectiles_container: Node = %Projectiles



const OUTLINE: int = 2
const MARGIN: int = 1



var size: Vector2i
var item: Item
var torso_joint: Vector2 :
	get:
		return item.def.joints[ItemDef.Joint.TORSO]



func _ready() -> void:
	#sprite.material.set_shader_parameter("line_thickness", OUTLINE)
	set_process(false)


func _process(_delta: float) -> void:
	blinking_props.visible = Engine.get_frames_drawn() % 2 == 0


func set_item(value: Item) -> void:

	if value == null:
		clear()
		return

	item = value

	visible = true

	var texture: Texture2D = Assets.get_texture_for_item(item.def)
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
	blinking_props.visible = false

	set_process(false)

	for prop in blinking_props.get_children():
		prop.queue_free()


func play_animation(target_visual_center: Vector2) -> void:

	for projectile in item.def.projectiles:

		match projectile.gfx:

			MechGFX.Projectile.ROCKET:
				await __fire_rocket(projectile, target_visual_center).finished

			MechGFX.Projectile.BIG_ROCKET:
				await __fire_big_rocket(projectile, target_visual_center).finished

			_:
				var key = MechGFX.Projectile.find_key(projectile.gfx)
				push_error("Animation for %s is not implemented" % key)


func __fire_rocket(config: ItemDef.ProjectileConfig, target: Vector2) -> Tween:

	var recoil: Vector2 = Vector2(10, 0)
	var projectile = RocketScene.instantiate()

	projectiles_container.add_child(projectile)
	projectile.position = global_position + (-torso_joint + config.place) * global_scale - recoil
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
	projectile.position = global_position + (-torso_joint + config.place) * global_scale - recoil
	projectile.scale = global_scale
	projectile.fire(target)

	# Recoil effect

	var tween: Tween = create_tween()

	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(sprite, "position:x", sprite.position.x, __FIRING_INTERVAL)

	sprite.position -= recoil

	return tween


func __prepare_animations() -> void:

	for prop in blinking_props.get_children():
		prop.queue_free()

	for ornament in item.def.ornaments:

		var ornament_sprite = Sprite2D.new()

		ornament_sprite.position = ornament.place - torso_joint
		ornament_sprite.texture = ornament.texture

		match ornament.effect:
			ItemDef.OrnamentConfig.Effect.BLINK:
				blinking_props.add_child(ornament_sprite)


func __wait(seconds: float, callback: Callable) -> void:
	get_tree().create_timer(seconds).timeout.connect(callback)
