extends Button

signal killed_self

func _on_button_up():
	# kill yourself
	killed_self.emit()
	$"../../..".queue_free()
