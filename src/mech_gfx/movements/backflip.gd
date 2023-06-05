class_name MechMovementBackflip


const LEG_ROTATION: float = 90


static func play(mech: MechGFX, speed: float) -> void:

	MechMovementBackflip.tween_swing_arms(mech, speed)

	await MechMovementJump.tween_crouch(mech, speed).finished

	# 360
	mech.create_tween().tween_property(
		mech.anim_rotation,
		"rotation",
		-PI * 2,
		MechMovementJump.JUMP_DURATION
	)

	MechMovementBackflip.tween_swing_legs(mech, speed)

	await MechMovementJump.tween_leap(mech, speed).finished
	await MechMovementJump.tween_fall(mech, speed).finished

	mech.reorganize()

	await MechMovementJump.tween_fall_impact(mech, speed).finished

	mech.reorganize()


static func tween_swing_arms(mech: MechGFX, speed: float) -> Tween:

	var time: float = (MechMovementJump.CROUCH_DURATION + MechMovementJump.JUMP_DURATION) / speed
	var melee_weapons = [
		mech.side_weapon_1, mech.side_weapon_2,
		mech.side_weapon_3, mech.side_weapon_4
	].filter(
		func(part):
			return MechGFX.is_part_melee(part)
	)

	var t: Tween = mech.create_tween()

	if melee_weapons.size() > 0:

		t.tween_interval(time)

		for part in melee_weapons:
			var ti: Tween = mech.create_tween()
			ti.set_trans(Tween.TRANS_QUAD)
			ti.set_ease(Tween.EASE_OUT)
			ti.tween_property(part, "rotation_degrees", 50, time * 0.1)
			ti.set_ease(Tween.EASE_IN_OUT)
			ti.tween_property(part, "rotation_degrees", -80, time * 0.15)
			ti.tween_property(part, "rotation_degrees", 0, time * 0.75)

	else:
		t.tween_interval(0.01)

	return t


static func tween_swing_legs(mech: MechGFX, speed: float) -> Tween:

	var time: float = MechMovementJump.JUMP_DURATION / speed
	var t: Tween = mech.create_tween()

	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(mech.leg_1, "rotation_degrees", LEG_ROTATION, time * 0.5)
	t.parallel().tween_property(mech.leg_2, "rotation_degrees", LEG_ROTATION, time * 0.5)

	t.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(mech.leg_1, "rotation_degrees", 0, time * 0.5)
	t.parallel().tween_property(mech.leg_2, "rotation_degrees", 0, time * 0.5)

	return t
