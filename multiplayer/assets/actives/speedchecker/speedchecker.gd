extends Area3D

var last_speed : int

@export_range(0.0, 100.0, 1.0, "prefer_slider") var max_speed

@onready var label_front: Label3D = %LabelFront
@onready var label_back: Label3D = %LabelBack

signal reached_max_speed

func _ready() -> void:
	label_back.text = ""
	label_front.text = ""

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		last_speed = body.total_speed
		label_back.text = str(last_speed)
		label_front.text = str(last_speed)
