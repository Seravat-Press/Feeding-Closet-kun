## Basic Start Screen  
class_name StartScreen extends Control

signal start_pressed
@onready var audio_stream_player = $AudioStreamPlayer

func _ready() -> void:
	connect("start_pressed", Callable(get_parent(), "_on_start_pressed"))
	
func _on_start_button_pressed():
	audio_stream_player.stream = Globals.GOOD_BOOP
	audio_stream_player.play()
	emit_signal("start_pressed")


func _on_exit_button_pressed():
	audio_stream_player.stream = Globals.BAD_BOOP
	audio_stream_player.play()
	await audio_stream_player.finished
	get_tree().quit()
