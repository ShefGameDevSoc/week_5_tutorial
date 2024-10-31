extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(Game.levels)):
		var button = Button.new()
		add_child(button)
		button.text = Game.levels[i].substr(0, (len(Game.levels[i])-5))
		
		# hiding button to go to current level
		if button.text == "xend":
			button.hide()
		
		button.position = $ListStartLoc.position
		button.position.y += 50*i
		
		button.connect("pressed", load_level.bind(i))
		

func load_level(id):
	Game.current_level = id
	Game.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
