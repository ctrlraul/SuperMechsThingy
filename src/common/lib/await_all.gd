class_name AwaitAll

signal finished()


var __total: int = 0
var __done: int = 0


func _init(array: Array):
	for item in array:

		if item is Tween || item is Tweener:
			item.finished.connect(__check)

		elif item is Timer || item is SceneTreeTimer:
			item.timeout.connect(__check)

		else:
			push_error("Type not awaitable: ", item)
			continue

		__total += 1


func is_finished() -> bool:
	return __done == __total


func __check() -> void:
	__done += 1
	if __done == __total:
		finished.emit()
