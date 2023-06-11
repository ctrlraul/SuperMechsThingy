class_name MechMovementMelee


const WEAPON_SWING_DURATION: float = 1
const STEP_DURATION: float = 0.3
const STEP_DISTANCE: float = 60
const STEP_HEIGHT: float = 30


static func play(mech: MechGFX, speed: float, slot: MechBuild.Slot) -> void:

	if MechGFX.is_frontal_slot(slot):

		MechMovementMelee.tween_swing_weapon(mech, speed, slot)

		MechMovementMelee.tween_lift_font_leg(mech, speed)
		await MechMovementMelee.tween_move_front_leg_forward(mech, speed).finished

		await mech.get_tree().create_timer(STEP_DURATION).timeout

		MechMovementMelee.tween_lift_font_leg(mech, speed)
		await MechMovementMelee.tween_move_front_leg_backward(mech, speed).finished

	else:

		await MechMovementMelee.tween_swing_weapon(mech, speed, slot).finished

	mech.reorganize()


static func tween_swing_weapon(mech: MechGFX, speed: float, slot: MechBuild.Slot) -> Tween:

	var time: float = WEAPON_SWING_DURATION / speed
	var weapon = mech.get_part_for_slot(slot)
	var t: Tween = mech.create_tween()

	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(weapon, "rotation_degrees", -100, time * 0.4).set_ease(Tween.EASE_OUT)
	t.tween_property(weapon, "rotation_degrees", 80, time * 0.15)
	t.tween_property(weapon, "rotation_degrees", 0, time * 0.45).set_ease(Tween.EASE_IN_OUT)

	return t


static func tween_lift_font_leg(mech: MechGFX, speed: float) -> Tween:

	var time: float = STEP_DURATION / speed
	var t: Tween = mech.create_tween()

	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(mech.leg_1, "position:y", mech.leg_1.position.y - STEP_HEIGHT, time * 0.5).set_ease(Tween.EASE_OUT)
	t.tween_property(mech.leg_1, "position:y", mech.leg_1.position.y, time * 0.5).set_ease(Tween.EASE_IN)

	return t


static func tween_move_front_leg_forward(mech: MechGFX, speed: float) -> Tween:

	var time: float = STEP_DURATION / speed
	var t: Tween = mech.create_tween()

	t.set_parallel(true)
	t.tween_property(mech.anim_position, "position:x", STEP_DISTANCE, time)
	t.tween_property(mech.leg_1, "position:x", mech.leg_1.position.x + STEP_DISTANCE, time)
	t.tween_property(mech.leg_2, "position:x", mech.leg_2.position.x - STEP_DISTANCE, time)

	return t


static func tween_move_front_leg_backward(mech: MechGFX, speed: float) -> Tween:

	var time: float = STEP_DURATION / speed
	var t: Tween = mech.create_tween()

	t.set_parallel(true)
	t.tween_property(mech.anim_position, "position:x", 0, time)
	t.tween_property(mech.leg_1, "position:x", mech.leg_1.position.x - STEP_DISTANCE, time)
	t.tween_property(mech.leg_2, "position:x", mech.leg_2.position.x + STEP_DISTANCE, time)

	return t
