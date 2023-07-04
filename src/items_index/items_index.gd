extends TabContainer
signal item_selected(item: ItemDef)



@export var items_index_tab_scene: PackedScene
@export var item_button_scene: PackedScene



func _ready() -> void:
	NodeUtils.clear(self)



func set_items(items: Array[ItemDef]) -> void:

	NodeUtils.clear(self)

	var dictionary: Dictionary = {}

	for element_key in ItemDef.Element:
		var element = ItemDef.Element[element_key]
		dictionary[element] = {}

		for type_key in ItemDef.Type:
			var type = ItemDef.Type[type_key]
			dictionary[element][type] = []


	for item_def in items:
		dictionary[item_def.element][item_def.type].append(item_def)


	for element in dictionary:

		var tab = items_index_tab_scene.instantiate()
		tab.name = ItemDef.Element.find_key(element).capitalize()
		add_child(tab)
		var container = tab.get_node("%Container")

		for type in dictionary[element]:

			if dictionary[element][type].size() == 0:
				continue

			if container.get_child_count() > 0:
				container.add_child(HSeparator.new())

			var label: Label = Label.new()
			label.text = ItemDef.Type.find_key(type).capitalize()

			if !label.text.ends_with("s"):
				label.text += "s"

			container.add_child(label)

			var grid = GridContainer.new()
			grid.columns = 4
			container.add_child(grid)

			if type in [ItemDef.Type.SIDE_WEAPON, ItemDef.Type.TOP_WEAPON]:
				dictionary[element][type].sort_custom(__sort_by_range)

			for item_def in dictionary[element][type]:

				var item_button = item_button_scene.instantiate()

				grid.add_child(item_button)

				item_button.set_item(Item.new(item_def))
				item_button.pressed.connect(func(): item_selected.emit(item_def))


func set_item_defs(items: Array[ItemDef]) -> void:
	set_items(items)


func __sort_by_range(a: ItemDef, b: ItemDef) -> bool:

	var range_stat: ItemDef.Stat = ItemDef.Stat.RANGE

	if !a.stats.has(range_stat):
		return false

	if !b.stats.has(range_stat):
		return true

	return (
		a.stats[range_stat][0] + a.stats[range_stat][1] <
		b.stats[range_stat][0] + b.stats[range_stat][1]
	)
