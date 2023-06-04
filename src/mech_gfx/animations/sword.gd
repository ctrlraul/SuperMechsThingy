const __FRONT_SLOTS: Array[MechBuild.Slot] = [
	MechBuild.Slot.SIDE_WEAPON_1,
	MechBuild.Slot.SIDE_WEAPON_3
]

static func play(mech: MechGFX, speed: float, slot: MechBuild.Slot) -> void:

	if speed <= 0:
		return

	var leg_1 = mech.leg_1
	var leg_2 = mech.leg_2
	var parts = mech.mech_parts
	var weapon = mech.get_part_for_slot(slot)

	var step_towards_opponent: bool = slot in __FRONT_SLOTS
	var swing: Tween = mech.create_tween()
	var step: Tween
	var step2: Tween

	if step_towards_opponent:
		step = mech.create_tween()
		step.set_parallel(true)
		step.tween_property(parts, "position", Vector2(80, 0), 0.3  / speed)
		step.tween_property(leg_2, "position:x", leg_2.position.x - 80, 0.3  / speed)
		step.set_parallel(false)
		step.tween_interval(0.5)
		step.tween_property(parts, "position", Vector2.ZERO, 0.4  / speed)
		step.set_parallel(true)
		step.tween_property(leg_2, "position:x", leg_2.position.x, 0.4  / speed)

		step2 = mech.create_tween()
		step2.tween_property(leg_1, "position", leg_1.position + Vector2(40, -30), 0.15  / speed)
		step2.tween_property(leg_1, "position", leg_1.position + Vector2(80, 0), 0.15  / speed)
		step2.tween_interval(0.5)
		step2.tween_property(leg_1, "position", leg_1.position + Vector2(40, -30), 0.2  / speed)
		step2.tween_property(leg_1, "position", leg_1.position, 0.2  / speed)

	swing.tween_property(weapon, "rotation_degrees", -100, 0.3  / speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	swing.tween_property(weapon, "rotation_degrees", 80, 0.15  / speed)
	swing.tween_property(weapon, "rotation_degrees", 0, 0.8  / speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	if step_towards_opponent:
		await step2.finished
	else:
		await swing.finished

	mech.reorganize()
