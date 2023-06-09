extends Node2D



@onready var muzzle_fire_yellow: Sprite2D = %MuzzleFireYellow
@onready var muzzle_fire_yellow_2: Sprite2D = %MuzzleFireYellow2



func _process(_delta: float) -> void:
	muzzle_fire_yellow.scale = Vector2(randf(), randf())
	muzzle_fire_yellow_2.scale = Vector2(randf(), randf())


func _on_timer_timeout() -> void:
	queue_free()
