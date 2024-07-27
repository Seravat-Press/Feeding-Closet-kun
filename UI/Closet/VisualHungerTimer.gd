## UI Element to track the hunger timer. 
class_name VisualHungerTimer extends ProgressBar

@export var hunger_timer : Timer		## Connect to a timer node in the tree. 

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = hunger_timer.wait_time
	value = hunger_timer.wait_time

## Updates the hunger timer value.
func update_hunger_timer(newValue : float) -> void: 
	self.value = newValue
