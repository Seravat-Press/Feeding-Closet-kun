## This node handles the shadometer UI. 
class_name Shadometer extends HBoxContainer

const SHADOW_LOSE = preload("res://UI/ShadowLose/ShadowLose.tscn")

@onready var shad_label = $ShadLabel
@onready var particle_destination = $ParticleDestination
@onready var shad_tex = $ShadTex

func _ready():
	particle_destination.global_position = shad_tex.global_position

## Called when the shadometer value changes. 
func _on_storage_shadow_changed(new_value):
	shad_label.text = str(new_value)
	var newShadowLabel : ShadowLose = SHADOW_LOSE.instantiate()
	newShadowLabel.setup_value(new_value)
	particle_destination.add_child(newShadowLabel)

## Return the destination of the particles. 
func get_particle_destination() -> Marker2D:
	return particle_destination
