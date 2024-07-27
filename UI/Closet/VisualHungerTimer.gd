## UI Element to track the hunger timer. 
class_name VisualHungerTimer extends ProgressBar

# Called when the node enters the scene tree for the first time.
func install_hunger_values(maxDuration : float):
	max_value = maxDuration
	value = maxDuration

## Updates the hunger timer value.
func update_hunger_timer(newValue : float) -> void: 
	self.value = newValue
