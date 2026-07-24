extends Node2D

const SLOT_SCALE = Vector2(1.5, 1.5)
const CARD_TARGET_SCALE = Vector2(1.5, 1.5)

@export var is_player_slot: bool = true

var card_in_slot = false
var placed_card: Node2D = null

func _ready() -> void:
	scale = SLOT_SCALE
	if is_player_slot:
		add_to_group("card_slot")

func clear() -> void:
	if placed_card:
		placed_card.queue_free()
		placed_card = null
		card_in_slot = false
