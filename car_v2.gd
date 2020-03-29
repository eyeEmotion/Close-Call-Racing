extends VehicleBody

const STEER_SPEED = 1
const STEER_LIMIT = 0.4

var steer_target = 0
var velocity = Vector3()
var fwd_mps = 0

export var engine_force_value = 200
export var brake_force_value = 5
export var topspeed = 200
export var reverse_speed_limit = 50

func _physics_process(delta):
	velocity = transform.basis.xform_inv(linear_velocity)
	fwd_mps = stepify(velocity.z * 3.6, 0.01)

	get_node("HUD").update_speed(fwd_mps)
	#get_node("HUD").update_speed_state(engine_force)
	
	steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	steer_target *= STEER_LIMIT
	#steer_target = steer_target * (STEER_LIMIT / (1 + velocity.z))
	#steer_target = steer_target * (STEER_LIMIT - ((velocity.z / 150)*1.6))
	
	if Input.is_action_pressed("accelerate"):
		if (fwd_mps < topspeed):
			get_node("HUD").update_speed_state("Accelerate")
			engine_force = engine_force_value
		else:
			get_node("HUD").update_speed_state("Top Speed")
			engine_force = 0.0
		if (fwd_mps <= -1):
			get_node("HUD").update_speed_state("Torque reverse")
			engine_force = engine_force_value * 1.6
	else:
		get_node("HUD").update_speed_state("")
		engine_force = 0.0
	
	if Input.is_action_pressed("reverse"):
		if (fwd_mps >= 1):
			get_node("HUD").update_speed_state("Brake")
			brake = brake_force_value
		elif (fwd_mps >= -reverse_speed_limit):
			get_node("HUD").update_speed_state("Reverse")
			engine_force = -engine_force_value
		else:
			get_node("HUD").update_speed_state("Max reverse")
			engine_force = 0.0
	else:
	#	get_node("HUD").update_speed_state("???")
		brake = 0.0
	
	steering = move_toward(steering, steer_target, STEER_SPEED * delta)

