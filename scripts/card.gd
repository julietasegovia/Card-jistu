extends Node2D

signal hovered
signal hovered_off

const CARD_BACK_TEXTURE = preload("res://sprites/card_back.png")

var is_placed_in_slot = false
var current_slot = null
var starting_position
var card_data: CardData
var card_img_original_scale: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_img_original_scale = $CardImg.scale
	z_index = 1
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func place_in_slot(slot):
	current_slot = slot
	is_placed_in_slot = true
	scale = slot.CARD_TARGET_SCALE
	z_index = 10
	get_node("Area2D/CollisionShape2D").disabled = true

func setup(data: CardData) -> void:
	card_data = data
	$CardImg.texture = data.texture

func hide_from_player() -> void:
	$CardImg.texture = CARD_BACK_TEXTURE
	$Area2D/CollisionShape2D.disabled = true
	z_index = 5

func reveal() -> void:
	var tween = create_tween()
	tween.tween_property($CardImg, "scale:x", 0.0, 0.15)
	tween.tween_callback(func():
		$CardImg.texture = card_data.texture
	)
	tween.tween_property($CardImg, "scale:x", card_img_original_scale.x, 0.15)
