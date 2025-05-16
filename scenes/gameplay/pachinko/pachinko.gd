extends Node2D

@onready var aimer: Line2D = %BallAimer
@onready var lose_area: Area2D = %LoseArea
@onready var walls: Node2D = %Walls
const Ball: PackedScene    = preload("res://scenes/gameplay/pachinko/ball/ball.tscn")
enum State {
	AIMING,
	FIRED,
}
var state: State = State.AIMING


func _ready() -> void:
	aimer.add_point(Vector2.RIGHT * 200)
	pass


func _process(_delta: float) -> void:
	match state:
		State.AIMING:
			aimer.look_at(get_global_mouse_position())
			if Input.is_action_pressed("mouse_down"):
				state = State.FIRED
				var ball   = Ball.instantiate()
				var thingy = Vector2.from_angle(aimer.transform.get_rotation())
				ball.apply_central_impulse(thingy * ball.reflect_impulse_magnitude)
				ball.global_position = aimer.global_position

				aimer.queue_free()

				self.add_child(ball)
		State.FIRED:
			pass
	pass
