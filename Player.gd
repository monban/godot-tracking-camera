extends KinematicBody

const MAX_SPEED = 20
const ACCELERATION = 40
const GRAVITY_STRENGTH = 4
const JUMP_STRENGTH = 100
var velocity = Vector3.ZERO
onready var camera = get_node('/Camera')

func clampMagnitude(vector, maximum):
	if vector.length() > maximum:
		return vector.normalized() * maximum
	else:
		return vector

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("moveto"):
		 camera.project_ray_origin(event.position)

func _process(delta):
	var playerInput = false
	var facing = Vector3.ZERO
	
	if Input.is_action_pressed("move_d"):
		playerInput = true
		facing += Vector3.BACK
	elif Input.is_action_pressed("move_u"):
		playerInput = true
		facing += Vector3.FORWARD
	if Input.is_action_pressed("move_r"):
		playerInput = true
		facing += Vector3.RIGHT
	elif Input.is_action_pressed("move_l"):
		playerInput = true
		facing += Vector3.LEFT
	facing = facing.normalized()

	if playerInput:
		velocity += facing * ACCELERATION * delta
	elif velocity.length() < 1:
		velocity = Vector3.ZERO
	else:
		velocity *= 0.8
	
	velocity = clampMagnitude(velocity, MAX_SPEED)
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			print("jumping!")
			velocity += Vector3.UP * JUMP_STRENGTH
	else:
		velocity += Vector3.DOWN * GRAVITY_STRENGTH
	velocity = move_and_slide(velocity, Vector3.UP)
	$"Movement Target".translation.x = velocity.x
	$"Movement Target".translation.z = velocity.z

