extends Node2D

signal hovered
signal hovered_off

var is_placed_in_slot = false
var current_slot = null
var starting_position
var card_data: CardData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	get_node("Area2D/CollisionShape2D").disabled = true

func setup(data: CardData) -> void:
	card_data = data
	$CardImg.texture = data.texture
