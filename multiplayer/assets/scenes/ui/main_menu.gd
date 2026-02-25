extends CanvasLayer

@onready var button_join: Button = %ButtonJoin
@onready var button_quit: Button = %ButtonQuit

@onready var line_edit_session: LineEdit = %LineEditSession
@onready var line_edit_username: LineEdit = %LineEditUsername
@onready var button_join_tube: Button = %ButtonJoinTube
@onready var button_quit_tube: Button = %ButtonQuitTube
@onready var button_create_tube: Button = %ButtonCreateTube

@onready var enet_menu: VBoxContainer = %ENet
@onready var tube_menu: VBoxContainer = %Tube

const WORLD_DEBUG = preload("uid://ce6thikstj7tl")

func _ready() -> void:
	if Network.tube_enabled:
		enet_menu.hide()
	else:
		tube_menu.hide()
	button_join.pressed.connect(on_join)
	button_quit.pressed.connect(func(): get_tree().quit())
	
	line_edit_session.text_changed.connect(update_session)
	line_edit_username.text_changed.connect(update_username)
	button_join_tube.disabled = true
	button_join_tube.pressed.connect(on_join_tube)
	button_quit_tube.pressed.connect(func(): get_tree().quit())
	button_create_tube.pressed.connect(on_create_tube)
	
	Network.tube_client.error_raised.connect(on_error_raised)
	
	if OS.has_feature("SERVER"):
		Network.start_server()
		await get_tree().create_timer(0.1).timeout
		get_tree().debug_collisions_hint = true
		add_world()
		

func on_create_tube():
	Network.tube_create()
	add_world()

func on_join_tube():
	Network.tube_join(line_edit_session.text)
	multiplayer.connected_to_server.connect(add_world)

func on_error_raised(_code, _message):
	line_edit_session.text = ''
	button_join_tube.add_theme_color_override("font_disabled_color", Color.DARK_RED)
	button_join_tube.disabled = true
	Network.clean_up_signals()

func update_username(new_username: String):
	Global.username = new_username

func update_session(new_text: String):
	if new_text != '':
		button_join_tube.disabled = false

func on_join() -> void:
	Network.join_server()
	add_world()
	%AnimationPlayer.play("transition")

func add_world() -> void:
	var new_world = WORLD_DEBUG.instantiate()
	get_tree().current_scene.add_child(new_world)
	%AnimationPlayer.play("transition")
