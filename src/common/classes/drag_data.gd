class_name DragData


var source: Node
var data


@warning_ignore("shadowed_variable")
func _init(source: Node, data) -> void:
	self.source = source
	self.data = data
