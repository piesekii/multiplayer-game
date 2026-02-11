extends CSGBox3D

@onready var collision_shape : CollisionShape3D = %CollisionShape3D

var players_inside : Array[Player] = []

func _ready() -> void:
	_update_mesh()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		players_inside.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player:
		players_inside.erase(body)

func _update_mesh():
	collision_shape.shape.size = self.size

func _on_timer_timeout() -> void:
	if !players_inside.is_empty():
		#print(players_inside)
		for i in players_inside.size():
			players_inside[i].health -= 10
