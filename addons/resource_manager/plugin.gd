@tool
extends EditorPlugin

const manager := preload("res://addons/resource_manager/UI/SeravatManager.tscn")
const PLUGIN_NAME := "ResourceManager"
const PLUGIN_HANDLER_PATH := "res://addons/resource_manager/plugin.gd"

var managerDock : Control
#EditorInterface.get_inspector().resource_selected.emit([resource], [path_to_the_resource])

func _enter_tree() -> void:
	managerDock = manager.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UR, managerDock)
	

func _exit_tree() -> void:
	remove_control_from_docks(managerDock)
	managerDock.queue_free()
