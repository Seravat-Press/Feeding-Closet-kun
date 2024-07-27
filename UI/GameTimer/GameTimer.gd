class_name GameTimer extends MarginContainer

const INCREMENT : float = 60.0	## One minute per increment

signal increment_reached

@onready var time_label: Label = $TimeLabel

var time_elapsed := 0.0		## Seconds elapsed.
var incrementsPassed : int = 0

func _ready() -> void:
	stop()
	
func _process(delta: float) -> void:
	time_elapsed += delta
	time_label.text = str(time_elapsed).pad_decimals(2)
	if floor(time_elapsed / INCREMENT) > incrementsPassed:
		incrementsPassed += 1
		emit_signal("increment_reached")

## Call to start the game timer. 
func start() -> void:
	set_process(true)

## Reset the timer. 
func reset() -> void:
	time_elapsed = 0.0

## Call to stop the game timer. 
func stop() -> void:
	set_process(false)

## Returns the current time elapsed. 
func get_time_elapsed() -> float:
	return time_elapsed
