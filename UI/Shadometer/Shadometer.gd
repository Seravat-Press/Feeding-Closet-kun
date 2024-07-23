## This node handles the shadometer UI. 
class_name Shadometer extends HBoxContainer

@onready var shad_label = $ShadLabel

func _on_storage_shadow_changed(new_value):
	shad_label.text = str(new_value)
