class_name Spawn_offset
extends Node

@export_range(0, 5, 0.1) var x_offset := 0.0
@export_range(0, 5, 0.1) var y_offset := 0.0
@export_range(0, 5, 0.1) var z_offset := 0.0


func _ready() -> void:
	get_parent().global_position += Vector3(x_offset, y_offset, z_offset)
