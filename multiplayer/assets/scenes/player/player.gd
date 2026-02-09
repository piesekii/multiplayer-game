extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var sensitivity : float = 0.002

@onready var camera_3d: Camera3D = %Camera3D
@onready var head: Node3D = $Head
@onready var nameplate: Label3D = %nameplate

@onready var menu: Control = %Menu
@onready var button_leave: Button = %ButtonLeave

@onready var raycast_interactable: RayCast3D = %RayCastInteractable

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _ready() -> void:
	add_to_group('Player')
	nameplate.text = name
	
	if !is_multiplayer_authority(): 
		set_process(false)
		set_physics_process(false)
		return
	
	menu.hide()
	hide_face()
	camera_3d.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	button_leave.pressed.connect(func(): Network.leave_server())

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera_3d.rotate_x(-event.relative.y * sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu") and menu.visible == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		menu.show()
	elif Input.is_action_just_pressed("menu") and menu.visible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		menu.hide()
	
	if Input.is_action_just_pressed("left_click"):
		shoot()
	
	if raycast_interactable.is_colliding():
		var target = raycast_interactable.get_collider() # A CollisionObject3D.
		if target.is_in_group("Interactable"):
			if Input.is_action_just_pressed("interact"):
				print("interact pressed")

func shoot():
	var facing_dir = -head.transform.basis.z
	var force = 100
	var pos = global_position
	Global.shoot_ball.rpc_id(1, pos, facing_dir, force)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func hide_face() -> void:
	%face_visual.visible = false
