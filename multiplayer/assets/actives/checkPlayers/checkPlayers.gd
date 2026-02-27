extends CSGBox3D

@export var one_time := false
@export var amount_players_needed = 0

@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var check_players_area: Area3D = %CheckPlayersArea

var _one_time_emmited := false

signal all_players_inside
signal half_players_inside
signal x_players_inside

func _update_mesh():
	if get_node_or_null("%CollisionShape3D"):
		collision_shape_3d.shape.size = self.size

func _process(_delta):
	_update_mesh()

var amount_players_inside = 0

func _on_check_players_area_body_entered(body: Node) -> void:
	if body is Player:
		amount_players_inside += 1
		if one_time and !_one_time_emmited:
			_one_time_emmited = true
			if amount_players_inside == multiplayer.get_peers().size():
				all_players_inside.emit()
			if amount_players_inside == multiplayer.get_peers().size() / 2:
				half_players_inside.emit()
			if amount_players_needed != 0 and amount_players_inside == amount_players_needed:
				x_players_inside.emit()
		elif !one_time:
			if amount_players_inside == multiplayer.get_peers().size():
				all_players_inside.emit()
			if amount_players_inside == multiplayer.get_peers().size() / 2:
				half_players_inside.emit()
			if amount_players_needed != 0 and amount_players_inside == amount_players_needed:
				x_players_inside.emit()


		

func _on_check_players_area_body_exited(body: Node) -> void:
	if body is Player:
		amount_players_inside -= 1
