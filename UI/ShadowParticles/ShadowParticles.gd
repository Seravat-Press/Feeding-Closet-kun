class_name ShadowParticles extends CPUParticles2D

@export var targetNode : Marker2D

	
func spawn_particles(startPos : Vector2, targetDest : Marker2D, numShadow : int):
	self.global_position = startPos
	targetNode = targetDest
	self.amount = numShadow
	var grav : Vector2 = targetNode.global_position - self.global_position
	self.gravity = grav * 2
	self.emitting = true

func _on_finished():
	self.queue_free()
