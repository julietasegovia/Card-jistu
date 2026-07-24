extends Node2D

@export var is_player := true

const DOT_RADIUS := 12.0
const DOT_SPACING := 36.0
const COLOR_INACTIVE := Color(0.45, 0.45, 0.45)
const COLOR_ACTIVE := Color(0.25, 0.55, 1.0)

var points := 0

func _ready() -> void:
	WinManager.turn_resolved.connect(_on_turn_resolved)

func _on_turn_resolved(winner: WinManager.Winner) -> void:
	if is_player and winner == WinManager.Winner.PLAYER:
		points += 1
		queue_redraw()
	elif not is_player and winner == WinManager.Winner.RIVAL:
		points += 1
		queue_redraw()

func _draw() -> void:
	var start_x = -(DOT_SPACING * (WinManager.WINS_NEEDED - 1)) / 2.0
	for i in range(WinManager.WINS_NEEDED):
		var color = COLOR_ACTIVE if i < points else COLOR_INACTIVE
		draw_circle(Vector2(start_x + i * DOT_SPACING, 50), DOT_RADIUS, color)
