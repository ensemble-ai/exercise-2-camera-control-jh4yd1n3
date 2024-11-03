class_name SpeedupPushZone
extends CameraControllerBase

@export var push_ratio:float = 0.5

@export var push_box_top_left: Vector2 = Vector2(-10, 10)
@export var push_box_bottom_right: Vector2 = Vector2(10, -10)
@export var speedup_zone_top_left: Vector2 = Vector2(-5, 5)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5, -5)


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var target_pos = target.global_position
	var target_velocity = target.velocity
	var target_speed = target_velocity.length()
	var target_direction = target_velocity.normalized()
	var camera_move = Vector3.ZERO

	# Checks if vessel / target / player is within the speedzone, then the camera should stay the same
	if target_pos.x > speedup_zone_top_left.x and target_pos.x < speedup_zone_bottom_right.x and target_pos.z > speedup_zone_bottom_right.y and target_pos.z < speedup_zone_top_left.y:
		return
		
	# Moving right and within the pushbox
	if target_velocity.x > 0 and target_pos.x < push_box_bottom_right.x:
		camera_move.x = lerp(camera_move.x, target_pos.x, push_ratio * delta)
	elif target_velocity.x < 0 and target_pos.x > push_box_top_left.x:
		camera_move.x = lerp(camera_move.x, target_pos.x, -push_ratio * delta)
	
	# Moving up and within the pushbox
	if target_velocity.z > 0 and target_pos.z < push_box_top_left.y:
		camera_move.z = lerp(camera_move.y, target_pos.y, push_ratio * delta)
	elif target_velocity.z < 0 and target_pos.z > push_box_bottom_right.y:
		camera_move.z = lerp(camera_move.y, target_pos.y, -push_ratio * delta)
	
	# Touching the border 
	if target_pos.x <= push_box_top_left.x or target_pos.x >= push_box_bottom_right.x:
		camera_move.x = target_speed * delta * target_direction.x
	if target_pos.z <= push_box_bottom_right.y or target_pos.z >= push_box_top_left.y:
		camera_move.z = target_speed * delta * target_direction.z

	global_position += camera_move

	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Draw outer pushbox
	immediate_mesh.surface_add_vertex(Vector3(push_box_top_left.x, 0, push_box_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_top_left.x, 0, push_box_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_top_left.x, 0, push_box_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_bottom_right.x, 0, push_box_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_bottom_right.x, 0, push_box_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_bottom_right.x, 0, push_box_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_bottom_right.x, 0, push_box_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(push_box_top_left.x, 0, push_box_top_left.y))

	# Draw inner speedup zone
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_bottom_right.x, 0, speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(speedup_zone_top_left.x, 0, speedup_zone_top_left.y))
	
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
