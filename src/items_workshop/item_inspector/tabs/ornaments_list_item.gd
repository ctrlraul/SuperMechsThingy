extends VBoxContainer
signal delete()



@onready var color_rect: ColorRect = %ColorRect
@onready var effect_options: OptionButton = %EffectOptions
@onready var thumbnail: TextureRect = %Thumbnail
@onready var texture_path: LineEdit = %TexturePath



var __item: ItemDef
var __ornament: ItemDef.OrnamentConfig



func _ready() -> void:
	effect_options.clear()
	for key in ItemDef.OrnamentConfig.Effect.keys():
		effect_options.add_item(key.capitalize())


func init(item: ItemDef, ornament: ItemDef.OrnamentConfig) -> void:

	__item = item
	__ornament = ornament

	var hue: float = int(ornament.id) % 2048 / 2048.0

	color_rect.color = ColorUtils.from_hsl(hue, 1, 1, 1)

	if ornament.texture:
		thumbnail.texture = ornament.texture
		texture_path.text = ornament.texture.resource_path.get_file()
	else:
		thumbnail.texture = load(Config.Paths.MISSING_TEXTURE)

	effect_options.select(ornament.effect)



func _on_effect_options_item_selected(index: int) -> void:
	__ornament.effect = index as ItemDef.OrnamentConfig.Effect
	Assets.notify_item_changed(__item)


func _on_delete_button_pressed() -> void:
	__item.ornaments.erase(__ornament)
	queue_free()
	Assets.notify_item_changed(__item)


func _on_texture_path_text_submitted(new_text: String) -> void:

	var new_texture = load("res://assets/images/items/".path_join(new_text))

	if new_texture != null:
		__ornament.texture = new_texture
	else:
		new_texture = load(Config.Paths.MISSING_TEXTURE)
		__ornament.texture = null

	thumbnail.texture = new_texture

	Assets.notify_item_changed(__item)
