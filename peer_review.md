# Code Review for Programming Exercise 2 #

#### Perfect #### 
    Can't find any flaws in relation to the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not really converging to a solution. Pervasive Major flaws. Objective largely unmet.


### Stage 1 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
Camera is centered on the `Vessel` however, the when we enable `draw_logic` the box is there along with the cross. The exercise asks us to only provide the cross

### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justification ##### 
Autoscroller works exactly as intended. The `draw_logic` is also implemented correctly

### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justifaction ##### 
Position lock and lerp smoothing works as intended. The `draw_logic` is also implemented correctly

### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

#### Justifaction ##### 
Stage 4, lerp smoothing target focus, was not implemented.

### Stage 5 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

#### Justifaction ##### 
Stage 5, way speedup push zone, works as intended. The `draw_logic` is also implemented correctly

## Code Style ##

### Code Style Review ###

Following this style guide: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

#### Style Guide Infractions ####

##### scripts/camera_controller_base.gd
`#camera tilt around the z axis in radians
#var _camera_tilt_rad:float = 0.0
#var _camera_tilt_speed:float = 0.1` line 12-14

`camera tilt code for the brave
	#if Input.is_action_pressed("camera_tilt_left"):
		#_camera_tilt_rad += _camera_tilt_speed * delta
		#rotation.z = _camera_tilt_rad
	#elif Input.is_action_pressed("camera_tilt_right"):
		#_camera_tilt_rad -= _camera_tilt_speed * delta
		#rotation.z = _camera_tilt_rad
	#else:
		#_camera_tilt_rad += -signf(_camera_tilt_rad) * _camera_tilt_speed * delta
		#if abs(_camera_tilt_rad) < 0.01:
			#_camera_tilt_rad = 0.0
		#rotation.z = _camera_tilt_rad`

The # in comments need to be preceeded by a whitespace. These comments provide no explanation about the code but is unused or discarded code.

##### scripts/position_lock_camera.gd
line 28-29 `#boundary checks
#left`
line 33 `#right`
line 37 `#top`
line 41 `#bottom`

The # in comments need to be preceeded by a whitespace

#### Style Guide Exemplars ####

Student provided detailed comments and explanation in a neat and tidy manner for the function `_process(delta: float) -> void` in `smooth_lerp_position_lock_camera_2.gd`

## Best Practices ##

Almost no critical violations found except for a few comments. Here are my suggestions to improve the code!

1. Inside `camera_controller_base.gd` the zoom logic in _process is functional, but it could be refactored into a dedicated function for clarity
2. Inside `auto_scoller.gd` the variable `mesh_instance` is created inside the draw_logic method but freed after a single process frame. Consider optimizing its usage or explaining its lifecycle with comments.
3. Inside `smooth_lerp_position_lock_camera_2.gd` the logic for checking target_velocity and updating camera_position is clear but could be refactored into smaller functions:

