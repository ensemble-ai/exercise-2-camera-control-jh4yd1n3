class_name AutoScroller
extends CameraControllerBase


@export var box_width:float = 30.0
@export var box_height:float = 20.0

@export var cross_width:float = 5.0
@export var cross_height:float = 5.0

@export var autoscroll_speed: Vector3 = Vector3(5.0, 0.0, 5.0)

# Where the player can move freely without being pushed by camera
@export var top_left: Vector2 = Vector2(-5.0, 5.0)
@export var bottom_right: Vector2 = Vector2(5.0, -5.0)


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
		
	##boundary checks
	##left
	#var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	#if diff_between_left_edges < 0:
		#global_position.x += diff_between_left_edges
	##right
	#var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	#if diff_between_right_edges > 0:
		#global_position.x += diff_between_right_edges
	##top
	#var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	#if diff_between_top_edges < 0:
		#global_position.z += diff_between_top_edges
	##bottom
	#var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	#if diff_between_bottom_edges > 0:
		#global_position.z += diff_between_bottom_edges
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
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
