class_name SmoothLerpPositionLock
extends CameraControllerBase

@export var cross_width:float = 5.0
@export var cross_height:float = 5.0

@export var lead_speed:float = 10.0
@export var catchup_speed:float = 10.0
@export var leash_distance:float = 6.0
@export var catchup_delay_duration:float = 0.001

var time_stopped_moving: float = 0.0
var target_position: Vector3
var camera_position: Vector3


func _ready() -> void:
	super()
	target_position = target.position
	camera_position = position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	target_position = target.position
	var target_velocity = target.velocity.length()
	
	if target_velocity > 0: # Target is moving
		time_stopped_moving = 0.0 # Reset the timer
		
		# Calculate a point in front of the target's position based on its movement direction
		# by using the target position, the targets direction in a unit vector without speed 
		# and multiplying by leash distance
		var lead_target = target_position + target.velocity.normalized() * leash_distance
		
		# moves the camera from its current position towards the lead_target 
		# at a rate determined by lead_speed, scaled by delta (frame time)
		camera_position = lerp(camera_position, lead_target, lead_speed * delta)
	else:
		time_stopped_moving += delta # Counting the seconds that player has stopped moving
		if time_stopped_moving >= catchup_delay_duration:
			camera_position = lerp(camera_position, target_position, catchup_speed * delta)
	
	position = camera_position
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
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
