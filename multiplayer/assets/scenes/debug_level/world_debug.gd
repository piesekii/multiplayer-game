extends Node3D

@onready var spawn_container: Node3D = %SpawnContainer
@onready var spawn_players: Node3D = %SpawnPlayers


func _ready() -> void:
	Global.world_debug = self
	Global.spawn_container = spawn_container
