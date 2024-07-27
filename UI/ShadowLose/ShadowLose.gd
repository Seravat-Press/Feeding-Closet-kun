## Label that appears when CS is added or subtracted. 
class_name ShadowLose extends Label

const ADD_LABEL : String = "+%d"
const MIN_LABEL : String = "-%d"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var posTween = create_tween()
	self.rotation = randf_range(-20.0, 20.0)
	posTween.tween_property(self, "position", Vector2(self.position.x + randf_range(-40.0, 40.0), self.position.y + 80), 0.4).set_ease(Tween.EASE_IN_OUT)
	await posTween.finished
	queue_free()

## Set up a new value for the shadometer. 
func setup_value(newVal : int) -> void:
	if newVal < 0:
		self.text = MIN_LABEL % abs(newVal)
	else:
		self.text = ADD_LABEL % newVal
