## This Component detects mouse entrance/exits. 
## @experimental
class_name MouseDetection extends ColorRect

## Parent Node
var parent_node 

var mouseHovered : bool = false

func _ready():
	setup_parent()


## Set up parent's functionality for this component. 
func setup_parent():
	parent_node = get_parent()
	parent_node.add_user_signal("mouse_detected", { "name": "nodeEntered", "type": TYPE_OBJECT })
	parent_node.add_user_signal("mouse_lost", { "name": "nodeLeft", "type": TYPE_OBJECT })

func _on_mouse_entered():
	parent_node.emit_signal("mouse_detected", parent_node)


func _on_mouse_exited():
	parent_node.emit_signal("mouse_lost", parent_node)
