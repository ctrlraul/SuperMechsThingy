const JUMP_HEIGHT: float = 400
const CROUCH_SCALE: float = 0.95

static func play(mech: MechGFX, speed: float) -> void:

	if speed <= 0:
		return

	var leg_1 = mech.leg_1
	var leg_2 = mech.leg_2
	var parts = mech.mech_parts
	var thrust_1 = mech.thrust_1
	var thrust_2 = mech.thrust_2

	var crouch: float = leg_1.size.y * (1 - CROUCH_SCALE)

	var t: Tween = mech.create_tween()

	# Crouch
	t.set_parallel(true)
	t.tween_property(leg_1, "scale:y", 0.95, 0.5 / speed)
	t.tween_property(leg_2, "scale:y", 0.95, 0.5 / speed)
	t.tween_property(leg_1, "position:y", leg_1.position.y - crouch, 0.5 / speed)
	t.tween_property(leg_2, "position:y", leg_2.position.y - crouch, 0.5 / speed)
	t.tween_property(parts, "position:y", crouch * 2, 0.5 / speed)

	await t.finished

	mech.reorganize()

	t = mech.create_tween()

	# Leap
	t.set_parallel(true)
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(thrust_2, "scale", Vector2.ONE, 0.3 / speed)
	t.tween_property(thrust_1, "scale", Vector2.ONE, 0.3 / speed)
	t.tween_property(parts, "position:y", -JUMP_HEIGHT, 0.75 / speed)

	await t.finished

	t = mech.create_tween()

	# Fall
	t.set_parallel(true)
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(parts, "position:y", 0, 0.75 / speed)
	t.tween_property(thrust_2, "scale", Vector2.ZERO, 0.3 / speed)
	t.tween_property(thrust_1, "scale", Vector2.ZERO, 0.3 / speed)

	await t.finished

	mech.reorganize()
