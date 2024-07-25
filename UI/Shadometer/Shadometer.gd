## This node handles the shadometer UI. 
class_name Shadometer extends HBoxContainer

@onready var shad_label = $ShadLabel
@onready var particle_destination = $ParticleDestination
@onready var shad_tex = $ShadTex

func _ready():
	particle_destination.global_position = shad_tex.global_position
	
func _on_storage_shadow_changed(new_value):
	shad_label.text = str(new_value)

func get_particle_destination() -> Marker2D:
	return particle_destination
