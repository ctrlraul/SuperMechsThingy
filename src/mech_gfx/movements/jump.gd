class_name MechMovementJump


const CROUCH_DURATION: float = 0.3
const JUMP_DURATION: float = 1.2
const FALL_IMPACT_DURATION: float = 0.2

const CROUCHING_LEG_SCALE: float = 0.95
const JUMP_HEIGHT: float = 400
const FALL_IMPACT_DISPLACEMENT: float = 10


static func play(mech: MechGFX, speed: float) -> void:
	await MechMovementJump.tween_crouch(mech, speed).finished
	mech.reorganize()
	await MechMovementJump.tween_leap(mech, speed).finished
	await MechMovementJump.tween_fall(mech, speed).finished
	await MechMovementJump.tween_fall_impact(mech, speed).finished
	mech.reorganize()


static func tween_crouch(mech: MechGFX, speed: float) -> Tween:

	var tuck: float = mech.leg_1.size.y * (1 - CROUCHING_LEG_SCALE)
	var time: float = CROUCH_DURATION / speed
	var t: Tween = mech.create_tween()

	t.set_parallel(true)
	t.tween_property(mech.leg_1, "scale:y", CROUCHING_LEG_SCALE, time)
	t.tween_property(mech.leg_2, "scale:y", CROUCHING_LEG_SCALE, time)
	t.tween_property(mech.leg_1, "position:y", mech.leg_1.position.y - tuck, time)
	t.tween_property(mech.leg_2, "position:y", mech.leg_2.position.y - tuck, time)
	t.tween_property(mech.anim_position, "position:y", tuck * 2, time)

	return t


static func tween_leap(mech: MechGFX, speed: float) -> Tween:

	var time: float = JUMP_DURATION * 0.5 / speed
	var t: Tween = mech.create_tween()

	t.set_parallel(true)
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(mech.thrust_2, "scale", Vector2.ONE, time * 0.5)
	t.tween_property(mech.thrust_1, "scale", Vector2.ONE, time * 0.5)
	t.tween_property(mech.anim_position, "position:y", -JUMP_HEIGHT, time)

	return t


static func tween_fall(mech: MechGFX, speed: float) -> Tween:

	var time: float = JUMP_DURATION * 0.5 / speed
	var t: Tween = mech.create_tween()

	t.set_parallel(true)
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_QUAD)
	t.tween_property(mech.thrust_2, "scale", Vector2.ZERO, time * 0.5)
	t.tween_property(mech.thrust_1, "scale", Vector2.ZERO, time * 0.5)
	t.tween_property(mech.anim_position, "position:y", 0, time)

	return t


static func tween_fall_impact(mech: MechGFX, speed: float) -> Tween:

	var time: float = FALL_IMPACT_DURATION / speed
	var t: Tween = mech.create_tween()

	t.set_parallel(true)
	t.tween_property(mech.leg_1, "position:y", mech.leg_1.position.y, time)
	t.tween_property(mech.leg_2, "position:y", mech.leg_2.position.y, time)
	t.tween_property(mech.anim_position, "position:y", mech.anim_position.position.y, time)

	mech.leg_1.position.y -= FALL_IMPACT_DISPLACEMENT
	mech.leg_2.position.y -= FALL_IMPACT_DISPLACEMENT
	mech.anim_position.position.y += FALL_IMPACT_DISPLACEMENT

	return t
