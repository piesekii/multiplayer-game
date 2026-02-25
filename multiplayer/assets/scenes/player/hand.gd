class_name Hand
extends Node3D


@onready var player: Player = $"../../../.."
@onready var head: Node3D = %Head
@onready var camera_3d: Camera3D = %Camera3D

var has_item := false

func _on_child_entered_tree(node: Node) -> void:
	if node is Item:
		node.hand = self
	
	if get_child_count() < 0:
		has_item = true
	else:
		has_item = false
