class_name Hand
extends Node3D


@onready var player: Player = $"../../../.."
@onready var head: Node3D = %Head
@onready var camera_3d: Camera3D = %Camera3D

var current_item : Item
