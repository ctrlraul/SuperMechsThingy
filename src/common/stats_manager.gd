extends Node



const MECH_STATS: Array[ItemDef.Stat] = [
	ItemDef.Stat.WEIGHT,
	ItemDef.Stat.HIT_POINTS,
	ItemDef.Stat.ENERGY_CAPACITY,
	ItemDef.Stat.ENERGY_REGENERATION,
	ItemDef.Stat.HEAT_CAPACITY,
	ItemDef.Stat.COOLING,
	ItemDef.Stat.PHYSICAL_RESISTANCE,
	ItemDef.Stat.EXPLOSIVE_RESISTANCE,
	ItemDef.Stat.ELECTRIC_RESISTANCE,
	ItemDef.Stat.WALKING_DISTANCE,
	ItemDef.Stat.JUMPING_DISTANCE,
]



func get_stats_for_build(build: MechBuild) -> Dictionary:

	var stats: Dictionary = {}
	var items: Array[Item] = build.get_items()

	for stat in MECH_STATS:
		stats[stat] = 0
		for item in items:
			stats[stat] += item.def.stats.get(stat, 0)

	return stats
