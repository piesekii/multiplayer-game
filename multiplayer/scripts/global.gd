extends Node

var username := ''

var world_debug : Node3D

@onready var spawn_container: Node3D = %SpawnContainer

const BALL = preload("uid://csg6as35svocy")

const PICKABLE_BALL_SHOOTER = preload("uid://cody1i55q7p7k")
const BALL_SHOOTER = preload("uid://60qftp8wow81")

var spawn_players : Node3D

#@rpc("any_peer", "call_local")
#func pickup_item(player_peer : int, item_id : int) -> void:
	#var player_node
	#for i in spawn_players.get_children():
		#if str(player_peer) == i.name:
			#player_node = i
	#match  item_id:
		#1:
			#var new_item = BALL_SHOOTER.instantiate()
			#
			#new_item.position = new_item._position
			#new_item.rotation = new_item._rotation
			#new_item.pickable_item_id = item_id
			#
			#player_node.hand.add_child(new_item)

@rpc("any_peer", "call_local")
func drop_item(item_id : int, position : Vector3, rotation : Vector3) -> void:
	if spawn_container == null:
		print("ESPERANDO")
		await get_tree().create_timer(0.1).timeout
	match item_id:
		1:
			var new_dropped = PICKABLE_BALL_SHOOTER.instantiate()
			new_dropped.position = position
			new_dropped.rotation = rotation
			spawn_container.add_child(new_dropped, true)
			print("INSTANCIADO")

@rpc("any_peer", "call_local")
func shoot_ball(pos, dir, force):
	var new_ball: RigidBody3D = BALL.instantiate()
	new_ball.source = multiplayer.get_remote_sender_id()
	new_ball.position = pos + Vector3(0.0, 0.0, 0.0) + (dir * 1.2)
	spawn_container.add_child(new_ball, true)
	new_ball.apply_central_impulse(dir * force)

@export var counter := 1
@rpc("any_peer")
func _counter():
	counter += 1
	sync_counter.rpc(counter)

@rpc("authority", "call_local")
func sync_counter(value: int):
	counter = value
