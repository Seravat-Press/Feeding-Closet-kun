extends ProgressBar

@onready var hunger_timer = $"../HungerTimer"

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = hunger_timer.wait_time
	value = hunger_timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = hunger_timer.time_left / hunger_timer.wait_time
