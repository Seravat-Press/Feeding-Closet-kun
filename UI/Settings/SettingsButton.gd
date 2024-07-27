extends Button

@export var spawn_point : Node2D

const preloadedSettingsScene = preload("res://UI/Settings/Settings.tscn")

func _on_button_up():
	var settings_menu = preloadedSettingsScene.instantiate()
	get_tree().root.add_child(settings_menu)
	settings_menu.get_node("MarginContainer/VBoxContainer/Button").pressed.connect(_on_settings_dead.bind())
	settings_menu.position = spawn_point.position
	disabled = true

func _on_settings_dead():
	disabled = false
