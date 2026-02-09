extends Node

var world_debug : Node3D
var spawn_container : Node3D

var jukebox

const BALL = preload("uid://csg6as35svocy")


@rpc("any_peer")
func shoot_ball(pos, dir, force):
	var new_ball : RigidBody3D = BALL.instantiate()
	
	new_ball.position = pos + Vector3(0.0, 1.0, 0.0) + (dir * 2.0)
	spawn_container.add_child(new_ball, true)
	new_ball.apply_central_impulse(dir * force)

@rpc("any_peer")
func play_jukebox():
	jukebox.play_jukebox()
