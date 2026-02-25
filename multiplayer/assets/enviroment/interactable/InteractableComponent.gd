class_name InteractableComponent
extends Node3D

signal interacted()

@export var item_id := 1

@export var pickable := false

func interact_with(player : Player):
	interacted.emit(player)
	
	if pickable and !player.hand.has_item:
		Global.pickup_item.rpc_id(1, str_to_var(player.name), item_id)
		#get_parent().queue_free()
