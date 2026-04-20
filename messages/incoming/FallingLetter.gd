class_name FallingLetter extends Label

const GRAVITY = 500.0
var velocity: Vector2
var angular_velocity: float


func _ready():
	velocity = Vector2(randf_range(-50,50),randf_range(-50,-100))
	angular_velocity = randf_range(-PI,PI)


func _process(delta):
	velocity.y += GRAVITY*delta
	global_position += velocity*delta
	rotation += angular_velocity*delta
	if global_position.y > get_window().size.y + size.length(): queue_free()
