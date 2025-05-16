extends Sprite2D

@export var health: int = 6
var curr_health: int

var scale_minus: Transform2D

signal dead

func _ready() -> void:
	curr_health = health
	self.transform = self.transform.scaled(Vector2(health, health))
	scale_minus = self.transform / health
	var _d=  self.transform

func hit() -> void:
	curr_health -= 1
	self.transform.x -= scale_minus.x
	self.transform.y -= scale_minus.y
	if curr_health <= 0:
		self.killed()

func killed() -> void:
	Singleton.enemies_killed += 1
	dead.emit()
