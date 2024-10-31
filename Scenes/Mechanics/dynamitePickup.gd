extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Game.dynamite_remaining += 4
	Game.use_dynamite(0)
	queue_free()
