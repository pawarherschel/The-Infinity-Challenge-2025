extends Node2D

const enemy_scn = preload("res://scenes/gameplay/auto_battler/enemy/enemy.tscn")

func hit() -> void:
	self.get_children()[0].hit()

func _ready() -> void:
	var e = enemy_scn.instantiate()
	e.health += Singleton.enemies_killed
	e.dead.connect(enemy_killed)
	
	self.add_child(e)

func enemy_killed() -> void:
	self.get_children()[0].queue_free()
	_ready()
