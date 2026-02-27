extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is Player and %AnimationPlayer.current_animation != "reload":
		body.velocity.y = body.jump_velocity * 2
		%AnimationPlayer.play("jump")
		%AnimationPlayer.queue("reload")
