extends Camera

export (NodePath) var follow_this_path = null
export var target_distance = 3.0
export var target_height = 2.0

var follow_this = null
var last_lookat

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
	
	# This part is the stuff I added to make the camera look in the direction of where you are steering at
	# the equation works, but h_offset is the wrong property to adress
	# need to be able to pass this of to the x-value of where the camera is looking at
	#	
	#if (follow_this.fwd_mps >= 0):
	#	h_offset = (follow_this.fwd_mps / 8) * -(follow_this.steering / 3)
	
	global_transform.origin = global_transform.origin.linear_interpolate(target_pos, delta * 80.0)
	
	last_lookat = last_lookat.linear_interpolate(follow_this.global_transform.origin, delta * 60.0)
	
	look_at(last_lookat, Vector3(0.0, 0.6, 0.0))
