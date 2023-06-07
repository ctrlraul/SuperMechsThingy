extends Control



const OUTLINE: int = 2
const MARGIN: int = 1



@onready var sprite: TextureRect = %Sprite
@onready var paint_mask: TextureRect = %PaintMask



var item: Item



func set_item(value: Item) -> void:

	if value == null:
		clear()
		return

	item = value

	var texture: Texture2D = Assets.get_texture_for_item(item.def)
	var texture_size: Vector2i = texture.get_size() * 0.4
	var image: Image = texture.get_image()

	image.resize(texture_size.x, texture_size.y, Image.INTERPOLATE_TRILINEAR)

	var padded_image = Image.create(
		texture_size.x + OUTLINE * 2 + MARGIN,
		texture_size.y + OUTLINE * 2 + MARGIN,
		false,
		image.get_format()
	)

	padded_image.blit_rect(
		image,
		Rect2i(Vector2.ZERO, texture_size),
		Vector2.ONE * OUTLINE + Vector2.ONE * MARGIN
	)

	sprite.texture = ImageTexture.create_from_image(padded_image)


func clear() -> void:
	item = null
	sprite.texture = null
