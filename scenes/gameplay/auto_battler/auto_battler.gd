extends Node2D

@onready var player: Sprite2D = %Player
@onready var player_attack_timer: Timer = %PlayerAttackTimer
@onready var enemy_manager: Node2D = %EnemyManager


func _ready() -> void:
	player_attack_timer.wait_time = 1.0 / Singleton.pegs_hit if Singleton.pegs_hit > 0 else 1.0
	player_attack_timer.start(player_attack_timer.wait_time)


func _on_player_attack_timer_timeout() -> void:
	enemy_manager.hit()


func _on_gameplay_timer_timeout() -> void:
	#preload("res://scenes/gameplay/pachinko/pachinko.tscn")
	Game.change_scene_to_file("res://scenes/gameplay/pachinko/pachinko.tscn")
	pass # Replace with function body.
