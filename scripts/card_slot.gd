extends Node2D

const SLOT_SCALE = Vector2(1.5, 1.5)
const CARD_TARGET_SCALE = Vector2(1.5, 1.5)

var card_in_slot = false

func _ready() -> void:
	scale = SLOT_SCALE
	add_to_group("card_slot")
