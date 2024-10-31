extends Area2D

@onready var can_kb = true
@onready var first_frame = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a = $SpriteTimer.time_left/$SpriteTimer.wait_time
	
	
	


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("destroy"):
		body.destroy()
	
	if body.has_method("recieved_knockback") and can_kb:
		var difference : Vector2 = Vector2()
		difference.x = (body.position.x - position.x)
		difference.y = (body.position.y - position.y)
		
		var fraction = $MainCollision.shape.radius/difference.length()
		fraction = min(fraction, 2)
		
		body.recieved_knockback(difference.normalized()*fraction)


func _on_timer_timeout() -> void:
	queue_free()


func _on_physics_timer_timeout() -> void:
	can_kb = false


func _on_small_explosion_area_entered(area: Area2D) -> void:
	if area.has_method("hard_destroy"):
		area.hard_destroy()
