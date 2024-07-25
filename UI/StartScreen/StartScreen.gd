## Basic Start Screen  
class_name StartScreen extends MarginContainer

signal start_pressed

func _ready() -> void:
	connect("start_pressed", Callable(get_parent(), "_on_start_pressed"))
	
func _on_start_button_pressed():
	emit_signal("start_pressed")


func _on_exit_button_pressed():
	get_tree().quit()
