extends CanvasLayer

@onready var button_join: Button = %ButtonJoin
@onready var button_quit: Button = %ButtonQuit

const WORLD_DEBUG = preload("res://assets/enviroment/debug_level/world_debug.tscn")



func _ready() -> void:
	button_join.pressed.connect(on_join)
	button_quit.pressed.connect(func(): get_tree().quit())
	
	if OS.has_feature("SERVER"):
		Network.start_server()
		get_tree().debug_collisions_hint = true
		add_world()
		%AnimationPlayer.play("transition")

func on_join() -> void:
	Network.join_server()
	add_world()
	%AnimationPlayer.play("transition")

func add_world() -> void:
	var new_world = WORLD_DEBUG.instantiate()
	get_tree().current_scene.add_child.call_deferred(new_world)
