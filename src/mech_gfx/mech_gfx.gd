extends Node2D
class_name MechGFX



enum Movement {
	NONE,
	JUMP,
	MELEE,
	STOMP,
	FLOAT,
	BACKFLIP,
}



const JumpAnimation = preload("animations/jump.gd")
const SwordAnimation = preload("animations/sword.gd")
const BackflipAnimation = preload("animations/backflip.gd")


@onready var torso: MechGFXPart = %Torso
@onready var leg_1: MechGFXPart = %Leg1
@onready var leg_2: MechGFXPart = %Leg2
@onready var side_weapon_1: MechGFXPart = %SideWeapon1
@onready var side_weapon_2: MechGFXPart = %SideWeapon2
@onready var side_weapon_3: MechGFXPart = %SideWeapon3
@onready var side_weapon_4: MechGFXPart = %SideWeapon4
@onready var top_weapon_1: MechGFXPart = %TopWeapon1
@onready var top_weapon_2: MechGFXPart = %TopWeapon2
@onready var drone: MechGFXPart = %Drone
@onready var charge_engine: MechGFXPart = %ChargeEngine
@onready var grappling_hook: MechGFXPart = %GrapplingHook
@onready var hat: MechGFXPart = %Hat

@onready var thrust_1: Node2D = %Thrust1
@onready var thrust_2: Node2D = %Thrust2

@onready var rotator: Node2D = %Rotator
@onready var mech_parts: Node2D = %MechParts

@onready var parts = [
	torso,
	leg_1,
	leg_2,
	side_weapon_1,
	side_weapon_2,
	side_weapon_3,
	side_weapon_4,
	top_weapon_1,
	top_weapon_2,
	drone,
	charge_engine,
	grappling_hook,
	hat,
]


@onready var animation_player: AnimationPlayer = %AnimationPlayer



var build: MechBuild
var animation_speed: float = 1.25



func set_build(value: MechBuild) -> void:

	build = value

	if build.torso == null || build.legs == null:
		__dismount()
		return

	torso.set_item(build.torso)
	leg_1.set_item(build.legs)
	leg_2.set_item(build.legs)
	side_weapon_1.set_item(build.side_weapon_1)
	side_weapon_2.set_item(build.side_weapon_2)
	side_weapon_3.set_item(build.side_weapon_3)
	side_weapon_4.set_item(build.side_weapon_4)
	top_weapon_1.set_item(build.top_weapon_1)
	top_weapon_2.set_item(build.top_weapon_2)
	drone.set_item(build.drone)

	if build.perk && build.perk.style == ItemDef.PerkType.HAT:
		hat.set_item(build.drone)
	else:
		hat.set_item(null)

	reorganize()


func play_jump() -> void:
	JumpAnimation.play(self, animation_speed)


func play_backflip() -> void:
	BackflipAnimation.play(self, animation_speed)


func play_sword(slot: MechBuild.Slot) -> void:
	SwordAnimation.play(self, animation_speed, slot)


func use_item(slot: MechBuild.Slot) -> void:

	var item: ItemDef = build.get_item(slot).def

	match item.mech_movement:

		Movement.JUMP:
			JumpAnimation.play(self, animation_speed)

		Movement.MELEE:
			SwordAnimation.play(self, animation_speed, slot)

		Movement.BACKFLIP:
			BackflipAnimation.play(self, animation_speed)

	get_part_for_slot(slot).play_animation()


func reorganize() -> void:

	mech_parts.position *= 0
	mech_parts.scale = Vector2.ONE

	thrust_1.scale *= 0
	thrust_2.scale *= 0

	for part in parts:
		part.scale = Vector2.ONE
		part.rotation = 0

	__arrange()


func get_part_for_slot(slot: MechBuild.Slot) -> MechGFXPart:

	match slot:
		MechBuild.Slot.SIDE_WEAPON_1: return side_weapon_1
		MechBuild.Slot.SIDE_WEAPON_2: return side_weapon_2
		MechBuild.Slot.SIDE_WEAPON_3: return side_weapon_3
		MechBuild.Slot.SIDE_WEAPON_4: return side_weapon_4
		_:
			push_error("NOT IMPLEMENTED")

	return null



func __sword(part: MechGFXPart, step_towards_opponent: bool = false) -> void:

	var S = 1.0 # speed

	var swing: Tween = create_tween()
	var step: Tween
	var step2: Tween

	if step_towards_opponent:
		step = create_tween()
		step.set_parallel(true)
		step.tween_property(mech_parts, "position", Vector2(80, 0), 0.3 / S)
		step.tween_property(leg_2, "position:x", leg_2.position.x - 80, 0.3 / S)
		step.set_parallel(false)
		step.tween_interval(0.5)
		step.tween_property(mech_parts, "position", Vector2.ZERO, 0.4 / S)
		step.set_parallel(true)
		step.tween_property(leg_2, "position:x", leg_2.position.x, 0.4 / S)

		step2 = create_tween()
		step2.tween_property(leg_1, "position", leg_1.position + Vector2(40, -30), 0.15 / S)
		step2.tween_property(leg_1, "position", leg_1.position + Vector2(80, 0), 0.15 / S)
		step2.tween_interval(0.5)
		step2.tween_property(leg_1, "position", leg_1.position + Vector2(40, -30), 0.2 / S)
		step2.tween_property(leg_1, "position", leg_1.position, 0.2 / S)

	swing.tween_property(part, "rotation_degrees", -100, 0.3 / S).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	swing.tween_property(part, "rotation_degrees", 80, 0.15 / S)
	swing.tween_property(part, "rotation_degrees", 0, 0.8 / S).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	if step_towards_opponent:
		await step2.finished
	else:
		await swing.finished

	reorganize()


func __dismount() -> void:
	for part in parts:
		part.set_item(null)


func __arrange() -> void:

	var torso_to_leg_1 = build.torso.def.joints[ItemDef.Joint.LEG_1]
	var torso_to_leg_2 = build.torso.def.joints[ItemDef.Joint.LEG_2]
	var torso_to_side_weapon_1 = build.torso.def.joints[ItemDef.Joint.SIDE_WEAPON_1]
	var torso_to_side_weapon_2 = build.torso.def.joints[ItemDef.Joint.SIDE_WEAPON_2]
	var torso_to_side_weapon_3 = build.torso.def.joints[ItemDef.Joint.SIDE_WEAPON_3]
	var torso_to_side_weapon_4 = build.torso.def.joints[ItemDef.Joint.SIDE_WEAPON_4]
	var torso_to_top_weapon_1 = build.torso.def.joints[ItemDef.Joint.TOP_WEAPON_1]
	var torso_to_top_weapon_2 = build.torso.def.joints[ItemDef.Joint.TOP_WEAPON_2]
	var legs_to_torso: Vector2 = build.legs.def.joints[ItemDef.Joint.TORSO]
	var legs_to_thrust: Vector2 = build.legs.def.joints[ItemDef.Joint.LEG_THRUST]

	leg_1.position.x = (-leg_1.size.x - (torso_to_leg_2.x - torso_to_leg_1.x)) * 0.5 + legs_to_torso.x
	leg_1.position.y = -leg_1.size.y + legs_to_torso.y

	torso.position = leg_1.position - torso_to_leg_1 + torso.size * 0.5

	leg_2.position = torso.position + torso_to_leg_2 - torso.size * 0.5
	side_weapon_1.position = torso.position + torso_to_side_weapon_1 - torso.size * 0.5
	side_weapon_2.position = torso.position + torso_to_side_weapon_2 - torso.size * 0.5
	side_weapon_3.position = torso.position + torso_to_side_weapon_3 - torso.size * 0.5
	side_weapon_4.position = torso.position + torso_to_side_weapon_4 - torso.size * 0.5
	top_weapon_1.position = torso.position + torso_to_top_weapon_1 - torso.size * 0.5
	top_weapon_2.position = torso.position + torso_to_top_weapon_2 - torso.size * 0.5

	thrust_1.position = legs_to_thrust - legs_to_torso
	thrust_2.position = legs_to_thrust - legs_to_torso
