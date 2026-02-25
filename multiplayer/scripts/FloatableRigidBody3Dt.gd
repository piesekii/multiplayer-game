class_name FloatableRigidBody3D
extends RigidBody3D


var time_floating := 500
func _process(delta: float) -> void:
	_handle_water_physics(delta)
	
func _handle_water_physics(delta : float) -> bool:
	if get_tree().get_nodes_in_group("water_area").all(func(area : Node3D) -> bool: return !area.overlaps_body(self)):
		#print("nuh uh")
		return false
	if time_floating >= 0:
		#print("ahan")
		apply_impulse(Vector3(0,.5,0))
		#time_floating -= 1
	else:
		#print("nuh uhjjjhjhhj")
		return false
	#print("AAAAAAA")
	return true
