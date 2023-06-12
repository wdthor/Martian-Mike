extends Node2D

signal touched_player

func _on_area_2d_body_entered(body):
	if body is Player:
#		1st way to emit signal
#		emit_signal("touched_player")
#		2nd (new) way to emit signal
		touched_player.emit()
		
