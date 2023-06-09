extends Control



const MARGIN: int = 2



@export var image_scale: float = 1
@export var outline_thickness: int = 2
@export var interpolation = Image.INTERPOLATE_LANCZOS



@onready var sprite: TextureRect = %Sprite
@onready var paint_mask: TextureRect = %PaintMask



var item: Item



func set_item(value: Item) -> void:

	if value == null:
		clear()
		return

	item = value

	var texture: Texture2D = Assets.get_item_texture_for_def(item.def)
	var texture_size: Vector2 = texture.get_size()
	var image: Image = texture.get_image()
	var node_size: Vector2 = size * 1.5
	var scaled_size: Vector2 = node_size

	if texture_size.x > texture_size.y:
		scaled_size.y = node_size.x * texture_size.y / texture_size.x
	else:
		scaled_size.x = node_size.y * texture_size.x / texture_size.y

	image.resize(
		int(scaled_size.x),
		int(scaled_size.y),
		interpolation
	)

	var padded_image = Image.create(
		int(scaled_size.x + outline_thickness * 2 + MARGIN),
		int(scaled_size.y + outline_thickness * 2 + MARGIN),
		false,
		image.get_format()
	)

	padded_image.blit_rect(
		image,
		Rect2i(Vector2.ZERO, scaled_size),
		Vector2.ONE * outline_thickness + Vector2.ONE * MARGIN
	)

	sprite.texture = ImageTexture.create_from_image(padded_image)
	sprite.material.set_shader_parameter("line_thickness", outline_thickness)


func set_item_def(value: ItemDef) -> void:
	if value == null:
		clear()
	else:
		set_item(Item.new(value))



func clear() -> void:
	item = null
	sprite.texture = null
