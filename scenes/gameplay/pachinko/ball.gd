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
