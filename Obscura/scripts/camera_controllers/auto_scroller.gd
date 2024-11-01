class_name AutoScroller
extends CameraControllerBase

@export var cross_width:float = 5.0
@export var cross_height:float = 5.0

@export var autoscroll_speed: Vector3 = Vector3(5.0, 0.0, 5.0)

# Where the player can move freely without being pushed by camera
@export var top_left: Vector2 = Vector2(-10.0, 7.0)
@export var bottom_right: Vector2 = Vector2(10.0, -7.0)


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	global_position.x += autoscroll_speed.x * delta
	
	var tpos = target.global_position
	var cpos = global_position
	
	# Frame edges for auto-scrolling, will push player along
	var frame_left_edge = global_position.x + top_left.x
	var frame_right_edge = global_position.x + bottom_right.x
	
	if target.global_position.x < frame_left_edge:
		target.global_position.x = frame_left_edge
	elif target.global_position.x > frame_right_edge:
		target.global_position.x = frame_right_edge
	
	# Frame edges just to keep player within bounds, no scrolling
	var frame_top_edge = global_position.z + top_left.y
	var frame_bottom_edge = global_position.z + bottom_right.y
	
	if target.global_position.z > frame_top_edge:
		target.global_position.z = frame_top_edge
	elif target.global_position.z < frame_bottom_edge:
		target.global_position.z = frame_bottom_edge
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left = top_left.x
	var right = bottom_right.x
	var top = top_left.y
	var bottom = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Box boundaries
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
