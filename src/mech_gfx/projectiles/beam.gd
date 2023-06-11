extends Node2D



@onready var beam_source: Sprite2D = %BeamSource
@onready var beam: Sprite2D = %Beam



func _ready() -> void:

	beam_source.scale = Vector2.ZERO
	beam.scale = Vector2(0, 1)

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(beam_source, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
	tween.tween_property(beam, "scale:x", 100, 0.4)
	tween.tween_property(beam, "scale:y", 0, 0.2)
	tween.tween_property(beam, "modulate:a", 0, 0.001)
	tween.tween_property(beam_source, "scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN)

	await tween.finished

	queue_free()
