class_name InteractableComponent
extends Node3D

signal interacted()

@export var item_id := 1

@export var pickable := false

func interact_with(player : Player):
	interacted.emit(player)
	
	if pickable:
		Global.pickup_item.rpc_id(1, str_to_var(player.name), item_id)
		rpc("delete")

@rpc("any_peer","call_local")
func delete() -> void:
	get_parent().queue_free()
