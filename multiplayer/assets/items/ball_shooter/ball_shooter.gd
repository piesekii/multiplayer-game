extends Item


func item_drop_item() -> void:
	if !is_active:
		return
	Global.drop_item.rpc(pickable_item_id, global_position, hand.player.rotation)
	if is_multiplayer_authority():
		rpc("update_item", false)

func item_pull_trigger() -> void:
	if !is_active:
		return
	shoot()

func shoot():
	var force = 100
	var pos = global_position
	var shoot_dir = get_shoot_direction()
	#Global.drop_item.rpc_id(1, 1, global_position, Vector3(0,0,0))
	Global.shoot_ball.rpc_id(1, pos, shoot_dir, force)
	
func get_shoot_direction():
	var viewport_rect = get_viewport().get_visible_rect().size
	var raycast_start = hand.camera_3d.project_ray_origin(viewport_rect / 2)
	var raycast_end = raycast_start + hand.camera_3d.project_ray_normal(viewport_rect / 2) * 200
	return -(raycast_start - raycast_end).normalized()
