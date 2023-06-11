class_name ItemDef



enum Type {
	TORSO,
	LEGS,
	SIDE_WEAPON,
	TOP_WEAPON,
	DRONE,
	CHARGE_ENGINE,
	TELEPORTER,
	GRAPPLING_HOOK,
	SHIELD,
	MODULE,
	PERK,
}

enum Element {
	PHYSICAL,
	EXPLOSIVE,
	ELECTRIC,
	OTHER,
}

enum Tier {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHICAL,
	DIVINE
}

enum Stat {
	WEIGHT,
	HIT_POINTS,
	REPAIRING,
	ENERGY_CAPACITY,
	ENERGY_REGENERATION,
	HEAT_CAPACITY,
	COOLING,
	BULLETS_CAPACITY,
	ROCKETS_CAPACITY,
	PHYSICAL_RESISTANCE,
	EXPLOSIVE_RESISTANCE,
	ELECTRIC_RESISTANCE,
	PHYSICAL_DAMAGE,
	PHYSICAL_RESISTANCE_DAMAGE,
	ELECTRIC_DAMAGE,
	ENERGY_DAMAGE,
	ENERGY_CAPACITY_DAMAGE,
	ENERGY_REGENERATION_DAMAGE,
	ELECTRIC_RESISTANCE_DAMAGE,
	EXPLOSIVE_DAMAGE,
	HEAT_DAMAGE,
	HEAT_CAPACITY_DAMAGE,
	COOLING_DAMAGE,
	EXPLOSIVE_RESISTANCE_DAMAGE,
	WALKING_DISTANCE,
	JUMPING_DISTANCE,
	RANGE,
	KNOCKBACK,
	PULL,
	RECOIL,
	ADVANCE,
	RETREAT,
	USES,
	BACKFIRE,
	HEAT_GENERATION,
	ENERGY_CONSUMPTION,
	BULLETS_CONSUMPTION,
	ROCKETS_CONSUMPTION,
}

enum PerkType {
	NONE,
	HAT,
	TORSO,
	OTHER,
}

enum Joint {
	TORSO,
	LEG_THRUST,
	LEG_1,
	LEG_2,
	SIDE_WEAPON_1,
	SIDE_WEAPON_2,
	SIDE_WEAPON_3,
	SIDE_WEAPON_4,
	TOP_WEAPON_1,
	TOP_WEAPON_2,
	DRONE,
	CHARGE_ENGINE,
	GRAPPLING_HOOK,
	HAT,
}



class ProjectileConfig:
	var id: String
	var place: Vector2 = Vector2.ZERO
	var gfx: MechGFX.Projectile = MechGFX.Projectile.ROCKET

	func _init(source = null) -> void:

		if source == null:
			id = str(randi())
			return

		id = source.id
		place = Vector2(source.place[0], source.place[1])
		gfx = MechGFX.Projectile[source.gfx]

	func to_json() -> Dictionary:
		return {
			"id": id,
			"place": [place.x, place.y],
			"gfx": MechGFX.Projectile.find_key(gfx)
		}


class OrnamentConfig:

	enum Effect {
		NONE,
		BLINK,
		GLOW,
		RECOIL,
	}

	var id: String
	var place: Vector2 = Vector2.ZERO
	var texture: Texture2D
	var effect: Effect = Effect.NONE

	func _init(source = null) -> void:

		if source == null:
			id = str(randi())
			return

		id = source.id
		place = Vector2(source.place[0], source.place[1])
		texture = load(Config.Paths.ITEM_IMAGES.path_join(source.texture))
		effect = Effect[source.effect]

	func to_json() -> Dictionary:
		return {
			"id": id,
			"place": [place.x, place.y],
			"texture": texture.resource_path.replace(Config.Paths.ITEM_IMAGES, ""),
			"effect": Effect.find_key(effect)
		}



var id: int = 0
var display_name: String = "[null]"
var texture: String = Config.Paths.MISSING_TEXTURE
var type: Type = Type.MODULE
var perk_type: PerkType = PerkType.NONE
var element: Element = Element.OTHER
var stats: Dictionary = {}
var tier: Tier = Tier.COMMON
var joints: Dictionary = {}
var mech_movement: MechGFX.Movement = MechGFX.Movement.NONE
var projectiles: Array[ProjectileConfig] = []
var ornaments: Array[OrnamentConfig] = []



func _init(source) -> void:
	id = source.id
	display_name = source.display_name
	texture = source.texture
	type = Type[source.type]
	#perk_type
	element = Element[source.element]
	#stats
	tier = Tier[source.tier]
	#joints
	#mech_movement
	#projectiles
	#ornaments

	if source.has("stats"):
		for key in source.stats:
			stats[Stat[key]] = source.stats[key]

	if type == Type.PERK:
		perk_type = PerkType[source.perk_type]

	if source.has("joints"):
		for joint_value in ItemDef.get_joints_for_type(type):
			var raw_joint = source.joints.get(Joint.find_key(joint_value), [0, 0])
			joints[joint_value] = Vector2(raw_joint[0], raw_joint[1])

	if source.has("mech_movement"):
		mech_movement = MechGFX.Movement[source.mech_movement]

	if source.has("projectiles"):
		for projectile in source.projectiles:
			projectiles.append(ProjectileConfig.new(projectile))

	if source.has("ornaments"):
		for ornament in source.ornaments:
			ornaments.append(OrnamentConfig.new(ornament))



func to_json() -> Dictionary:

	var result = {
		"id": id,
		"display_name": display_name,
		"texture": texture,
		"type": Type.find_key(type),
		#"perk_type": ,
		"element": Element.find_key(element),
		#"stats": ,
		"tier": Tier.find_key(tier),
		#"joints": ,
		#"mech_movement": ,
		#"projectiles": ,
		#"ornaments": ,
	}

	if stats.size() > 0:
		result.stats = {}
		for stat in stats:
			result.stats[Stat.find_key(stat)] = stats[stat]

	if perk_type != PerkType.NONE:
		result.perk_type = PerkType.find_key(perk_type)

	if joints.values().any(func(j): return j != Vector2.ZERO):
		result.joints = {}
		for joint_value in ItemDef.get_joints_for_type(type):
			var joint = joints.get(joint_value, Vector2.ZERO)
			if joint != Vector2.ZERO:
				result.joints[Joint.find_key(joint_value)] = [joint.x, joint.y]

	if mech_movement != MechGFX.Movement.NONE:
		result.mech_movement = MechGFX.Movement.find_key(mech_movement)

	if projectiles.size():
		result.projectiles = projectiles.map(func(p): return p.to_json())

	if ornaments.size():
		result.ornaments = ornaments.map(func(o): return o.to_json())

	return result



static func get_joints_for_type(item_type: ItemDef.Type) -> Array[Joint]:

	match item_type:
		Type.TORSO:
			return [
				Joint.LEG_1,
				Joint.LEG_2,
				Joint.SIDE_WEAPON_1,
				Joint.SIDE_WEAPON_2,
				Joint.SIDE_WEAPON_3,
				Joint.SIDE_WEAPON_4,
				Joint.TOP_WEAPON_1,
				Joint.TOP_WEAPON_2,
				Joint.DRONE,
				Joint.CHARGE_ENGINE,
				Joint.GRAPPLING_HOOK,
				Joint.HAT
			]

		Type.LEGS:
			return [Joint.TORSO, Joint.LEG_THRUST]

		Type.SIDE_WEAPON, Type.TOP_WEAPON, Type.DRONE:
			return [Joint.TORSO]

		_:
			return []
