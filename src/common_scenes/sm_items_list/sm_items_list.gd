class_name SMItemsList
extends PanelContainer

signal item_selected(item: Item)



@export var SMItemsListItemScene: PackedScene



@onready var container: Control = %Container



var current_grid: GridContainer = null



func _ready() -> void:
	clear()



func set_items(items: Array[Item]) -> void:

	clear()

	for item in items:
		add_item(item)


func add_item(item: Item) -> void:

	if !current_grid:
		current_grid = GridContainer.new()
		container.add_child(current_grid)

	var list_item = SMItemsListItemScene.instantiate()
	current_grid.add_child(list_item)
	list_item.set_item(item)
	list_item.selected.connect(_on_list_item_selected.bind(list_item))


func add_section(label: String) -> void:

	if container.get_child_count() > 0:
		container.add_child(HSeparator.new())

	if label:
		add_label(label)

	current_grid = GridContainer.new()
	container.add_child(current_grid)
	current_grid.columns = 4
	current_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func add_label(text: String) -> void:
	var node: Label = Label.new()
	node.text = text
	container.add_child(node)


func clear() -> void:
	NodeUtils.clear(container)
	current_grid = null



func _on_list_item_selected(list_item: SMItemsListItem) -> void:
	item_selected.emit(list_item.item)
