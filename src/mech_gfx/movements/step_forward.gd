class_name MechMovementStepForward


static func play(mech: MechGFX, speed: float) -> void:

	MechMovementMelee.tween_lift_font_leg(mech, speed)
	await MechMovementMelee.tween_move_front_leg_forward(mech, speed).finished

	await mech.get_tree().create_timer(MechMovementMelee.STEP_DURATION).timeout

	MechMovementMelee.tween_lift_font_leg(mech, speed)
	await MechMovementMelee.tween_move_front_leg_backward(mech, speed).finished

	mech.reorganize()
