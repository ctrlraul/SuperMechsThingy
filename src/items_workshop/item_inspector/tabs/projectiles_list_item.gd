extends HBoxContainer
signal delete()



@onready var color_rect: ColorRect = %ColorRect
@onready var gfx_options: OptionButton = %GfxOptions



var __item: ItemDef
var __projectile: ItemDef.ProjectileConfig



func _ready() -> void:
	gfx_options.clear()
	for key in MechGFX.Projectile.keys():
		gfx_options.add_item(key.capitalize())


func init(item: ItemDef, projectile: ItemDef.ProjectileConfig) -> void:

	__item = item
	__projectile = projectile

	var hue: float = int(projectile.id) % 2048 / 2048.0

	color_rect.color = ColorUtils.from_hsl(hue, 1, 1, 1)

	gfx_options.select(projectile.gfx)



func _on_gfx_options_item_selected(index: int) -> void:
	__projectile.gfx = index as MechGFX.Projectile
	Assets.notify_item_changed(__item)


func _on_delete_button_pressed() -> void:
	__item.projectiles.erase(__projectile)
	queue_free()
	Assets.notify_item_changed(__item)
