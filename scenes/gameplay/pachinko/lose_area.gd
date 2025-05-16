extends Area2D

func _on_gameplay_timer_timeout() -> void:
	self.body_entered.emit()
