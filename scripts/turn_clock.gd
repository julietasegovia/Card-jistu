extends Node2D

@export var radius: float = 115.0
@export var background_color: Color = Color.GREEN
@export var fill_color: Color = Color.RED
@export var done_color: Color = Color.GRAY
@export var text_color: Color = Color.WHITE
@export var font: Font  
@export var font_size: int = 64
@export var segments: int = 64

var progress: float = 0.0
var seconds_left: int = 0

func update_display(time_left: float, total_time: float) -> void:
	progress = clamp(1.0 - (time_left / total_time), 0.0, 1.0)
	seconds_left = int(ceil(time_left))
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, background_color)
	if progress > 0.0:
		var color = done_color if progress >= 1.0 else fill_color
		draw_pie_slice(progress, color)
	draw_countdown_text()

func draw_pie_slice(p: float, color: Color) -> void:
	var points = PackedVector2Array()
	points.append(Vector2.ZERO)

	var angle_start = -PI / 2
	var angle_end = angle_start + TAU * p
	var arc_segments = max(2, int(segments * p))

	for i in range(arc_segments + 1):
		var angle = lerp(angle_start, angle_end, float(i) / arc_segments)
		points.append(Vector2(cos(angle), sin(angle)) * radius)

	draw_colored_polygon(points, color)

func draw_countdown_text() -> void:
	var active_font = font if font else ThemeDB.fallback_font
	var text = str(seconds_left)
	var text_size = active_font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size)
	var text_pos = Vector2(-text_size.x / 2.0, text_size.y / 4.0)
	draw_string(active_font, text_pos, text, HORIZONTAL_ALIGNMENT_CENTER, -1, font_size, text_color)
