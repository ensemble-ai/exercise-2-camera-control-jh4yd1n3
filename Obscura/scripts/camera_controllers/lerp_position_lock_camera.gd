class_name LerpPositionLock
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0

@export var cross_width:float = 5.0
@export var cross_height:float = 5.0

@export var follow_speed:float = 3.0
@export var catchup_speed:float = 5.0
@export var leash_distance:float = 5.0


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var distance_to_target = global_position.distance_to(target.global_position)
	
	if distance_to_target > leash_distance:
		global_position = global_position.lerp(target.global_position, catchup_speed * delta)
	else:
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
	
	var tpos = target.global_position
	var cpos = global_position
	
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
	
	# Drawing Horizontal Cross Line
	immediate_mesh.surface_add_vertex(Vector3(-cross_width / 2, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(cross_width / 2, 0, 0))
	
	# Draw Vertical Cross Line (centered on Z axis)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_height / 2))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_height / 2))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
