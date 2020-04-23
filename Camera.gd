extends Camera

export (NodePath) var follow_this_path = null
export var target_distance = 4.0
export var target_height = 1.0

var follow_this = null
var last_lookat
var look_around = 0

var minFOV = 70.0
var maxFOV = 85.0
var boostFOV = 110.0
var currentFOV = minFOV
var spdChangeFOV = 0.01

func _ready():
	follow_this = get_node(follow_this_path)
	last_lookat = follow_this.global_transform.origin

func _physics_process(delta):
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	var target_pos = global_transform.origin

	# ignore y
	delta_v.y = 0.0
	
	if (delta_v.length() > target_distance):
		delta_v = delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_pos = follow_this.global_transform.origin + delta_v
	else:
		target_pos.y = follow_this.global_transform.origin.y + target_height

	global_transform.origin = global_transform.origin.linear_interpolate(target_pos, delta * 80.0)
	
	last_lookat = last_lookat.linear_interpolate(follow_this.global_transform.origin, delta * 60.0)
	
	look_at(last_lookat, Vector3(0.0, 0.6, 0.0))


func _process(delta: float) -> void:
	#this part is obviously wrong
	
	look_around = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
	h_offset = look_around * 3
	
	#--end wrong--

	if (follow_this.boost):
		currentFOV = boostFOV
	else:
		currentFOV = maxFOV

	if (follow_this.fwd_mps > 150):
		if (get_fov() < currentFOV):
			set_fov(get_fov() + delta * 7)
			target_distance = lerp(target_distance, 3.0, spdChangeFOV)
			target_height = lerp(target_height, 0.5, spdChangeFOV)
	else:
		if (get_fov() > minFOV):
			set_fov(get_fov() - delta * 7)			
			target_distance = lerp(target_distance, 4.0, spdChangeFOV)
			target_height = lerp(target_height, 1.0, spdChangeFOV)
