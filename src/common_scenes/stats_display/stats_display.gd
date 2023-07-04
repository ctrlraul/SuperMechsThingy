class_name StatsDisplay
extends GridContainer



@export var block_scene: PackedScene



func _ready() -> void:
	NodeUtils.clear(self)



func set_stats(stats: Dictionary) -> void:

	while get_child_count() > stats.size():
		var block = get_child(get_child_count() - 1)
		block.queue_free()
		remove_child(block)

	while get_child_count() < stats.size():
		var block = block_scene.instantiate()
		add_child(block)

	var stat_list = stats.keys()
	var values = stats.values()

	for i in stats.size():
		get_child(i).set_stat(stat_list[i], values[i])


func clear() -> void:
	NodeUtils.clear(self)
