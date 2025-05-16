extends RigidBody2D

@export var reflect_impulse_magnitude: float = 1500


var velocity: Vector2            = Vector2.ZERO
var stuck: bool = false
var stuck_number: int = 0

func _on_body_entered(body_: Node2D) -> void:
	if body_.is_in_group("PlayArea"):
		var body: StaticBody2D         = body_
		var collider: CollisionShape2D = body.get_node("CollisionShape2D")
		var shape_normal: Vector2      = Vector2.from_angle(collider.global_transform.get_rotation())
		var direction: Vector2         = velocity.reflect(shape_normal).normalized()
		self.apply_central_impulse(direction * reflect_impulse_magnitude)

	if body_.is_in_group("Peg"):
		var body: StaticBody2D         = body_
		var collider: CollisionShape2D = body.get_node("CollisionShape2D")
		var shape_normal: Vector2      = collider.position.direction_to(self.position)
		#print("collider.position: ", collider.position)
		#print("self.position: ", self.position)
		#print("shape_normal: ", shape_normal)
		#print("velocity: ", velocity)
		var direction: Vector2         = velocity.reflect(shape_normal).normalized()
		#print("direction: ", direction)
		self.apply_central_impulse(direction * reflect_impulse_magnitude)
		Singleton.pegs_hit += 1


func _physics_process(_delta: float) -> void:
	velocity = self.linear_velocity
	if velocity.is_equal_approx(Vector2.ZERO) && stuck:
		self.apply_central_force(Vector2.from_angle(randf_range(-10, 10)) * reflect_impulse_magnitude)
		stuck_number += 1
	elif velocity.is_equal_approx(Vector2.ZERO) && !stuck:
		stuck = true
	elif !velocity.is_equal_approx(Vector2.ZERO):
		stuck = false
		stuck_number = 0
	
	if stuck_number > 10:
		print("ok")



func _on_lose_area_body_entered(_body: Node2D) -> void:
	print("Score: ", Singleton.pegs_hit)
	pass # Replace with function body.

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	for child: Area2D in get_tree().get_nodes_in_group("PachinkoLoseArea"):
		child.body_entered.connect(_on_lose_area_body_entered)
		pass
	#aimer.add_point(Vector2.RIGHT * 200)
	pass

#func _process(delta: float) -> void:
	#match state:
		#State.AIMING:
			#aimer.look_at(get_global_mouse_position())
			#if Input.is_action_pressed("mouse_down"):
				#state = State.FIRED
				#self.freeze = false
				#self.sleeping = false
				#var thingy = Vector2.from_angle(self.get_angle_to(get_global_mouse_position()))
				##self.apply_central_force(thingy)
				#print("meow, ", thingy)
		#State.FIRED:
			#pass
	#pass
