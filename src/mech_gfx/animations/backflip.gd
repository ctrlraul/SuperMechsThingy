const JUMP_HEIGHT: float = 300
const CROUCH_SCALE: float = 0.95
const CENTER: float = 200

static func play(mech: MechGFX, speed: float) -> void:

	if speed <= 0:
		return

	var leg_1 = mech.leg_1
	var leg_2 = mech.leg_2
	var side_weapon_1 = mech.side_weapon_1
	var side_weapon_2 = mech.side_weapon_2
	var side_weapon_3 = mech.side_weapon_3
	var side_weapon_4 = mech.side_weapon_4
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

	var t2: Tween = mech.create_tween()

	# Crouch
	t2.set_parallel(true)
	t2.set_trans(Tween.TRANS_QUAD)
	t2.set_ease(Tween.EASE_OUT)
	t2.tween_property(side_weapon_1, "rotation_degrees", 50, 0.4 / speed)
	t2.tween_property(side_weapon_2, "rotation_degrees", 50, 0.4 / speed)
	t2.tween_property(side_weapon_3, "rotation_degrees", 50, 0.4 / speed)
	t2.tween_property(side_weapon_4, "rotation_degrees", 50, 0.4 / speed)

	t2.set_ease(Tween.EASE_IN)
	t2.set_parallel(false)
	t2.tween_property(side_weapon_1, "rotation_degrees", 0, 0.1 / speed)
	t2.set_parallel(true)
	t2.tween_property(side_weapon_2, "rotation_degrees", -30, 0.2 / speed)
	t2.tween_property(side_weapon_3, "rotation_degrees", -30, 0.2 / speed)
	t2.tween_property(side_weapon_4, "rotation_degrees", -30, 0.2 / speed)


	await t.finished


	mech.reorganize()


	parts.position.y -= CENTER
	for part in parts.get_children():
		part.position.y += CENTER

	t = mech.create_tween()

	# Leap
	t.set_parallel(true)
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(thrust_2, "scale", Vector2.ONE, 0.3 / speed)
	t.tween_property(thrust_1, "scale", Vector2.ONE, 0.3 / speed)
	t.tween_property(mech.rotator, "position:y", -JUMP_HEIGHT, 0.75 / speed)

	t.set_trans(Tween.TRANS_LINEAR)
	t.tween_property(parts, "rotation_degrees", -180, 0.75 / speed)

	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(leg_1, "rotation_degrees", 80, 0.75 / speed)
	t.tween_property(leg_2, "rotation_degrees", 80, 0.75 / speed)
	t.tween_property(side_weapon_1, "rotation_degrees", -50, 0.75 / speed)
	t.tween_property(side_weapon_2, "rotation_degrees", -50, 0.75 / speed)
	t.tween_property(side_weapon_3, "rotation_degrees", -50, 0.75 / speed)
	t.tween_property(side_weapon_4, "rotation_degrees", -50, 0.75 / speed)

	await t.finished

	t = mech.create_tween()

	# Fall
	t.set_parallel(true)
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(mech.rotator, "position:y", 0, 0.75 / speed)
	t.tween_property(thrust_2, "scale", Vector2.ZERO, 0.3 / speed)
	t.tween_property(thrust_1, "scale", Vector2.ZERO, 0.3 / speed)

	t.tween_property(leg_1, "rotation_degrees", 0, 0.75 / speed)
	t.tween_property(leg_2, "rotation_degrees", 0, 0.75 / speed)
	t.tween_property(side_weapon_1, "rotation_degrees", 0, 0.75 / speed)
	t.tween_property(side_weapon_2, "rotation_degrees", 0, 0.75 / speed)
	t.tween_property(side_weapon_3, "rotation_degrees", 0, 0.75 / speed)
	t.tween_property(side_weapon_4, "rotation_degrees", 0, 0.75 / speed)

	t.set_trans(Tween.TRANS_LINEAR)
	t.tween_property(parts, "rotation_degrees", -360, 0.75 / speed)

	await t.finished

	mech.rotator.position.y = 10
	leg_1.position.y -= 10
	leg_2.position.y -= 10

	t = mech.create_tween()

	# Fall
	t.set_parallel(true)
	t.tween_property(mech.rotator, "position:y", 0, 0.3 / speed)
	t.tween_property(leg_1, "position:y", leg_1.position.y + 10, 0.3 / speed)
	t.tween_property(leg_2, "position:y", leg_2.position.y + 10, 0.3 / speed)


	await t.finished

	parts.position.y += CENTER
	for part in parts.get_children():
		part.position.y -= CENTER

	parts.rotation = 0
	mech.reorganize()
