extends Node2D



const PIXELS_PER_SECOND: float = 1000



var __initial_position: Vector2
var __target_position: Vector2

var __progress_value: float = 0
@warning_ignore("unused_private_class_variable")
var __progress: float :
	get:
		return __progress_value
	set(value):
		__progress_value = value
		position = lerp(__initial_position, __target_position, __progress_value)



func fire(target: Vector2) -> void:

	__initial_position = position
	__target_position = target

	$NozzleFireYellow.position = global_position
	$AnimationPlayer.play("launch")

	var distance = position.distance_to(target)
	var tween: Tween = create_tween()

	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "__progress", 1, distance / PIXELS_PER_SECOND)

	await tween.finished

	queue_free()
