extends RigidBody2D

@export var reflect_impulse_magnitude: float = 1500

const particle_system = preload("res://assets/particle_system/gpu_particles_2d.tscn")

var velocity: Vector2 = Vector2.ZERO
var stuck: bool       = false
var stuck_number: int = 0

signal ball_stuck

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
		var direction: Vector2 = velocity.reflect(shape_normal).normalized()
		#print("direction: ", direction)
		self.apply_central_impulse(direction * reflect_impulse_magnitude)
		Singleton.pegs_hit += 1
		
		var particles_instance1 = particle_system.instantiate()
		var particles_instance2 = particle_system.instantiate()
		
		particles_instance1.look_at(self.position)
		particles_instance2.look_at(body.position)
		
		particles_instance1.emitting = true
		particles_instance2.emitting = true
		
		particles_instance1.global_position = self.global_position
		particles_instance2.global_position = self.global_position
		
		self.add_sibling(particles_instance1)
		self.add_sibling(particles_instance2)
		


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
		ball_stuck.emit()


func _on_lose_area_body_entered(_body: Node2D) -> void:
	#var x: PackedScene = preload("res://scenes/gameplay/auto_battler/auto_battler.tscn")
	Game.change_scene_to_file("res://scenes/gameplay/auto_battler/auto_battler.tscn")
	pass # Replace with function body.


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	for child: Area2D in get_tree().get_nodes_in_group("PachinkoLoseArea"):
		child.body_entered.connect(_on_lose_area_body_entered)
		pass
	#aimer.add_point(Vector2.RIGHT * 200)
	pass

func _on_ball_stuck() -> void:
	_on_lose_area_body_entered(null)
	pass # Replace with function body.
