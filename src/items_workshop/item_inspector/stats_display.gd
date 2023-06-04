extends GridContainer



@export var block_scene: PackedScene



func _ready() -> void:
	clear()



func set_stats(stats: Dictionary) -> void:

	while get_child_count() > stats.size():
		var block = get_child(get_child_count() - 1)
		block.queue_free()
		remove_child(block)

	while get_child_count() < stats.size():
		var block = block_scene.instantiate()
		add_child(block)

	var stat_ids: Array = stats.keys()

	for i in stats.size():
		var block = get_child(i)
		block.set_stat(stat_ids[i], stats[stat_ids[i]])


func clear() -> void:
	for block in get_children():
		block.queue_free()
