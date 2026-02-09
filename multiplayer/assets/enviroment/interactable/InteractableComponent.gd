class_name InteractableComponent
extends Node3D

signal interacted()

func interact_with():
	interacted.emit()
