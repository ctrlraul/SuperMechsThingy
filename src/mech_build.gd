class_name MechBuild

enum Slot {
	TORSO,
	LEGS,
	SIDE_WEAPON_1,
	SIDE_WEAPON_2,
	SIDE_WEAPON_3,
	SIDE_WEAPON_4,
	TOP_WEAPON_1,
	TOP_WEAPON_2,
	DRONE,
	CHARGE_ENGINE,
	TELEPORTER,
	GRAPPLING_HOOK,
	MODULE_1,
	MODULE_2,
	MODULE_3,
	MODULE_4,
	MODULE_5,
	MODULE_6,
	MODULE_7,
	MODULE_8,
	PERK,
}



var __parts: Dictionary = {}


var torso: Item :
	get: return get_item(Slot.TORSO)
	set(value): set_item(Slot.TORSO, value)

var legs: Item :
	get: return get_item(Slot.LEGS)
	set(value): set_item(Slot.LEGS, value)

var side_weapon_1: Item :
	get: return get_item(Slot.SIDE_WEAPON_1)
	set(value): set_item(Slot.SIDE_WEAPON_1, value)

var side_weapon_2: Item :
	get: return get_item(Slot.SIDE_WEAPON_2)
	set(value): set_item(Slot.SIDE_WEAPON_2, value)

var side_weapon_3: Item :
	get: return get_item(Slot.SIDE_WEAPON_3)
	set(value): set_item(Slot.SIDE_WEAPON_3, value)

var side_weapon_4: Item :
	get: return get_item(Slot.SIDE_WEAPON_4)
	set(value): set_item(Slot.SIDE_WEAPON_4, value)

var top_weapon_1: Item :
	get: return get_item(Slot.TOP_WEAPON_1)
	set(value): set_item(Slot.TOP_WEAPON_1, value)

var top_weapon_2: Item :
	get: return get_item(Slot.TOP_WEAPON_2)
	set(value): set_item(Slot.TOP_WEAPON_2, value)

var drone: Item :
	get: return get_item(Slot.DRONE)
	set(value): set_item(Slot.DRONE, value)

var perk: Item :
	get: return get_item(Slot.PERK)
	set(value): set_item(Slot.PERK, value)



func set_item(slot: Slot, item: Item) -> void:
	__parts[slot] = item


func get_item(slot: Slot) -> Item:
	return __parts.get(slot)


func has(item: ItemDef) -> bool:
	# Room for optimization
	for part in __parts.values():
		if part && part.def == item:
			return true
	return false
