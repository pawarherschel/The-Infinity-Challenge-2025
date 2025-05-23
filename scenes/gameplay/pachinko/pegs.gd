extends Node2D

@export var distance: float = 50.0
@export var ball_radius: float = 25.0
const peg_scn: PackedScene = preload("res://scenes/gameplay/pachinko/peg/peg.tscn")
@onready var tl: Vector2 = %TL.position + Vector2(ball_radius*3, ball_radius*1.5)
@onready var tr_: Vector2 = %TR.position + Vector2(-ball_radius*3, ball_radius*1.5)
@onready var bl: Vector2 = %BL.position + Vector2(ball_radius*3, -ball_radius*1.5)
@onready var br: Vector2 = %BR.position + Vector2(-ball_radius*3, -ball_radius*1.5)
@onready var v: float = (tr_ - tl).length()
@onready var h: float = (tr_ - br).length()*2
@onready var vd: float = v / (distance + ball_radius * 2)
@onready var hd: float = h / (distance + ball_radius * 2)


func _ready() -> void:
	for i in range(floor(hd) - 0):
		var i_perc: float = float(i) / float(floor(hd))
		for j in range(floor(vd)):
			if randf() < 0.25:
				continue

			var j_perc: float = float(j) / float(floor(vd))
			var pos_x         = tl.x + i_perc * h
			var pos_y         = tl.y + j_perc * v

			var peg = peg_scn.instantiate()
			peg.position = Vector2(pos_x + randfn(-distance/4, distance/4), pos_y + randfn(-distance/4, distance/4))

			self.add_child(peg)
