extends Node3D

const FACE_TELEVISION_MATERIAL = preload("uid://c2y8qfrfql022")
const SPRING = preload("uid://c7ai8a65ryi0u")

func _ready() -> void:
	_replace_materials_recursive(self)

func _replace_materials_recursive(node: Node) -> void:
	for i in node.get_children():
		if i is MeshInstance3D:
			_process_material(i)
			_process_mesh(i)
		# Continua descendo na hierarquia
		if i.get_child_count() > 0:
			_replace_materials_recursive(i)

func _process_mesh(mesh_instance: MeshInstance3D) -> void:
	var mesh_name := mesh_instance.name.to_lower()

	match mesh_name:
		_ when "gspring" in mesh_name:
			spawn_object(mesh_instance, SPRING)

func spawn_object(mesh_instance : MeshInstance3D, object_to_spawn : PackedScene) -> void:
			var new_object = object_to_spawn.instantiate()
			mesh_instance.get_parent().add_child(new_object)

			var from := mesh_instance.global_position + Vector3.UP * 2.0

			var to := from + Vector3.DOWN * 20.0
			var space_state = get_world_3d().direct_space_state
			var query := PhysicsRayQueryParameters3D.create(from, to)
			query.collide_with_areas = false
			query.collide_with_bodies = true
			var result := space_state.intersect_ray(query)
			if result:
				new_object.global_position = result.position
			else:
				new_object.global_position = mesh_instance.global_position
			mesh_instance.hide()

func _process_material(mesh_instance: MeshInstance3D) -> void:
	var mesh := mesh_instance.mesh
	if mesh == null:
		return
	var surface_count := mesh.get_surface_count()
	for surface_idx in surface_count:
		var mat := mesh.surface_get_material(surface_idx)
		if mat == null:
			continue
		match mat.resource_name:
			"FACE_TELEVISION":
				mesh_instance.set_surface_override_material(
					surface_idx,
					FACE_TELEVISION_MATERIAL
					)
