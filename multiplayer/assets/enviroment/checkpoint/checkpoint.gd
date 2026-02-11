extends CSGBox3D

var checkpoint_pos : Vector3
@onready var collision_shape : CollisionShape3D = %CollisionShape3D

func _ready() -> void:
	_update_mesh()
	for i in get_children():
		if i is Marker3D:
			checkpoint_pos = i.global_position
	if checkpoint_pos == null:
		push_error("Checkpoint: ", str(self), " não possui um filho target.")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.last_checkpoint_pos = checkpoint_pos

func _update_mesh():
	if get_node_or_null("%CollisionShape3D"):
		collision_shape.shape.size = self.size
