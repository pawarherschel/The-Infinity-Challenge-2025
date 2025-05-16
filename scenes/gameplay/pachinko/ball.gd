extends RigidBody2D

var velocity: Vector2 = Vector2.ZERO
var unprocessed_impulse: Vector2 = Vector2.ZERO
@export var reflect_impulse_magnitude: float = 1500

func _on_body_entered(body_: Node) -> void:
	if body_.is_in_group("PlayArea"):
		var body: StaticBody2D = body_
		var collider: CollisionShape2D = body.get_node("CollisionShape2D")
		var shape_normal: Vector2 = Vector2.from_angle(collider.global_transform.get_rotation())
		var direction: Vector2 = velocity.reflect(shape_normal).normalized()
		unprocessed_impulse = direction * reflect_impulse_magnitude

func _physics_process(_delta: float) -> void:
	velocity = self.linear_velocity

func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if unprocessed_impulse != Vector2.ZERO:
		self.apply_central_impulse(unprocessed_impulse)
		unprocessed_impulse = Vector2.ZERO
	pass
