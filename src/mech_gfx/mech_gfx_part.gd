extends Node2D
class_name MechGFXPart



@onready var sprite: Sprite2D = %Sprite2D
@onready var blinking_props: Node2D = %BlinkingProps



const OUTLINE: int = 2
const MARGIN: int = 1



var size: Vector2i
var item: Item



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
		sprite.position = size * 0.5 -item.def.joints[ItemDef.Joint.TORSO]

	__prepare_animations()


func clear() -> void:

	size = Vector2i.ZERO
	item = null
	visible = false
	blinking_props.visible = false

	set_process(false)

	for prop in blinking_props.get_children():
		prop.queue_free()


func play_animation() -> void:
	set_process(true)
	await get_tree().create_timer(1.5).timeout
	set_process(false)
	blinking_props.visible = false



func __prepare_animations() -> void:

	for prop in blinking_props.get_children():
		prop.queue_free()

	for ornament in item.def.ornaments:

		var ornament_sprite = Sprite2D.new()

		ornament_sprite.position = ornament.place - item.def.joints[ItemDef.Joint.TORSO]
		ornament_sprite.texture = ornament.texture

		match ornament.effect:
			ItemDef.OrnamentConfig.Effect.BLINK:
				blinking_props.add_child(ornament_sprite)
