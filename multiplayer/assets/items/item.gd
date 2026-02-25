class_name Item
extends Node3D

var hand : Hand

var pickable_item_id := 1

signal signal_pull_trigger
signal signal_released_trigger
signal signal_drop_item

@export var _position : Vector3
@export var _rotation : Vector3
@export var _scale : Vector3

func _ready() -> void:
	#position = _position
	#rotation = _rotation
	#scale = _scale
	signal_pull_trigger.connect(item_pull_trigger)
	signal_released_trigger.connect(item_release_trigger)
	signal_drop_item.connect(item_drop_item)

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	if event.is_action_pressed("left_click"):
		signal_pull_trigger.emit()
	if event.is_action_released("left_click"):
		signal_released_trigger.emit()
	if event.is_action_pressed("drop"):
		signal_drop_item.emit()
func item_drop_item() -> void:
	pass

func item_pull_trigger() -> void:
	pass

func item_release_trigger() -> void:
	pass
