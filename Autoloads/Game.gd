extends Node

var dynamite_remaining

# these are all the levels in the game, and the order in which they will be played
# when you create a new level, add it to this list.
# it must be saved in Scenes/Levels
var levels = []

var current_level = 0

@onready var world = get_node("/root/World")
@onready var ui = get_node("/root/World/UI")
var current_level_node
var player

var is_dying = false
var dying_timer
const DYING_TIMER_LENGTH = 0.5

const RED_HAZE_DEFAULT = 1
@onready var red_haze = get_node("/root/World/ColorRect")

func _ready():
	var raw_levels = DirAccess.get_files_at("res://Scenes/Levels")
	for i in range(len(raw_levels)):
		if not raw_levels[i].substr(len(raw_levels[i])-5, len(raw_levels[i])) != ".tscn":
			levels.append(raw_levels[i])
	
	
	# for debugging
	current_level = len(levels)-1
	create_level()

func _process(delta:float) -> void:
	if is_dying:
		red_haze.modulate.a = RED_HAZE_DEFAULT*(dying_timer.time_left/DYING_TIMER_LENGTH)
	
	if Input.is_action_just_pressed("reset"):
		reset()
	
	if Input.is_action_just_pressed("escape"):
		current_level = levels.find("xend.tscn")
		reset()


func create_level():
	if current_level >= len(levels):
		current_level = len(levels) -1
	
	current_level_node = load("Scenes/Levels/"+levels[current_level]).instantiate()
	ui.show()
	
	if levels[current_level] == "xend.tscn":
		world.add_child(current_level_node)
		ui.hide()
		return
	
	dynamite_remaining = current_level_node.dynamite
	use_dynamite(0)
	
	world.add_child(current_level_node)
	
	player = load("Scenes/Characters/player.tscn").instantiate()
	world.add_child(player)
	player.position = current_level_node.get_node("StartingPosition").position

func dying():
	is_dying = true
	dying_timer = Timer.new()
	add_child(dying_timer)
	dying_timer.wait_time = DYING_TIMER_LENGTH
	dying_timer.one_shot = true
	dying_timer.start()
	dying_timer.connect("timeout", reset)
	
	red_haze.show()
	world.move_child(red_haze, -1)
	
	

func reset():
	red_haze.modulate.a = RED_HAZE_DEFAULT
	red_haze.hide()
	is_dying = false
	
	current_level_node.queue_free()
	if not player == null:
		player.queue_free()
	
	create_level()
	
	
func next_level():
	current_level += 1
	reset()

func use_dynamite(amount:int):
	dynamite_remaining += amount
	ui.set_dynamite_amount(dynamite_remaining)
