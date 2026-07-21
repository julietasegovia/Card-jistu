extends Node2D

const TURN_TIME_LIMIT = 20

@export var rival_hand_path: NodePath
@export var player_hand_path: NodePath
@export var player_slot_path: NodePath

@onready var rival_hand = get_node(rival_hand_path)
@onready var player_hand = get_node(player_hand_path)
@onready var player_slot = get_node(player_slot_path)

var turn_timer: Timer

func _ready() -> void:
	turn_timer = Timer.new()
	turn_timer.wait_time = TURN_TIME_LIMIT
	turn_timer.one_shot = true
	turn_timer.timeout.connect(_on_turn_timeout)
	add_child(turn_timer)
	start_turn()

func start_turn() -> void:
	rival_hand.play_random_card()
	turn_timer.start()

func stop_turn_timer() -> void:
	turn_timer.stop()
	
func _on_turn_timeout() -> void:
	if not player_slot.card_in_slot:
		play_random_player_card()

func play_random_player_card() -> void:
	if player_hand.player_hand.is_empty():
		return
	var random_index = randi() % player_hand.player_hand.size()
	var chosen_card = player_hand.player_hand[random_index]
	player_hand.player_hand.remove_at(random_index)
	animate_card_into_slot(chosen_card, player_slot)
	player_hand.update_hand_positions()

func animate_card_into_slot(card, slot) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "position", slot.position, 0.4)
	tween.tween_property(card, "scale", slot.CARD_TARGET_SCALE, 0.4)
	tween.set_parallel(false)
	tween.tween_callback(func():
		card.place_in_slot(slot)
		slot.card_in_slot = true)
