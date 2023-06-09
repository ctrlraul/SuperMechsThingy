extends Node2D
class_name MechGFX
signal animation_finished()



enum Movement {
	NONE,
	JUMP,
	MELEE,
	STOMP,
	FLOAT,
	BACKFLIP,
}

enum Projectile {
	ROCKET,
	BIG_ROCKET,
	BULLETS,
}



const ProjectileRocketScene = preload("res://mech_gfx/projectiles/rocket.tscn")



@onready var anim_position: Node2D = %AnimPosition
@onready var anim_rotation: Node2D = %AnimRotation

@onready var drone_spot: Node2D = %DroneSpot

# Parts
@onready var side_weapon_2: Node2D = %SideWeapon2
@onready var side_weapon_4: Node2D = %SideWeapon4
@onready var top_weapon_2: Node2D = %TopWeapon2
@onready var leg_2: Node2D = %Leg2
@onready var torso: Node2D = %Torso
@onready var leg_1: Node2D = %Leg1
@onready var top_weapon_1: Node2D = %TopWeapon1
@onready var side_weapon_1: Node2D = %SideWeapon1
@onready var side_weapon_3: Node2D = %SideWeapon3
@onready var hat: Node2D = %Hat
@onready var drone: Node2D = %Drone

# Other GFX
@onready var charge_engine: Node2D = %ChargeEngine
@onready var grappling_hook: Node2D = %GrapplingHook
@onready var thrust_1: Node2D = %Thrust1
@onready var thrust_2: Node2D = %Thrust2

@onready var parts = [
	side_weapon_2,
	side_weapon_4,
	top_weapon_2,
	leg_2,
	torso,
	leg_1,
	top_weapon_1,
	side_weapon_1,
	side_weapon_3,
	hat,
	drone,
]



var build: MechBuild
var movement_speed: float = 1



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
	await MechMovementJump.play(self, movement_speed)
	animation_finished.emit()


func play_backflip() -> void:
	await MechMovementBackflip.play(self, movement_speed)
	animation_finished.emit()


func play_melee(slot: MechBuild.Slot) -> void:
	await MechMovementMelee.play(self, movement_speed, slot)
	animation_finished.emit()


func play_for_slot(slot: MechBuild.Slot) -> void:

	var item: ItemDef = build.get_item(slot).def
	var part: MechGFXPart = get_part_for_slot(slot)
	var target: Vector2 = part.global_position + Vector2(1000, 0)

	match item.mech_movement:
		Movement.JUMP: play_jump()
		Movement.MELEE: play_melee(slot)
		Movement.BACKFLIP: play_backflip()

	part.play_animation(target)


func reorganize() -> void:

	anim_position.position = Vector2.ZERO
	anim_rotation.rotation = 0

	for part in parts:
		if part != drone: # don't overthink it
			part.scale = Vector2.ONE
			part.rotation = 0

	__arrange()


func get_part_for_slot(slot: MechBuild.Slot) -> MechGFXPart:

	# can probably make this dynamic

	match slot:
		MechBuild.Slot.LEGS: return leg_1
		MechBuild.Slot.SIDE_WEAPON_1: return side_weapon_1
		MechBuild.Slot.SIDE_WEAPON_2: return side_weapon_2
		MechBuild.Slot.SIDE_WEAPON_3: return side_weapon_3
		MechBuild.Slot.SIDE_WEAPON_4: return side_weapon_4
		MechBuild.Slot.TOP_WEAPON_1: return top_weapon_1
		MechBuild.Slot.TOP_WEAPON_2: return top_weapon_2
		MechBuild.Slot.DRONE: return drone
		_:
			assert(false, "NOT IMPLEMENTED")

	return null



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
	var torso_to_drone = build.torso.def.joints[ItemDef.Joint.DRONE]
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

	drone_spot.position = torso.position + torso_to_drone - torso.size * 0.5
	drone.position = drone_spot.global_position



static func is_frontal_slot(slot: MechBuild.Slot) -> bool:
	return slot in [
		MechBuild.Slot.SIDE_WEAPON_1,
		MechBuild.Slot.SIDE_WEAPON_3,
		MechBuild.Slot.TOP_WEAPON_1,
	]


static func is_part_melee(part: MechGFXPart) -> bool:
	return part.item && part.item.def.mech_movement == Movement.MELEE
