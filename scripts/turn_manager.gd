extends Node2D

const TURN_TIME_LIMIT = 20
const RESOLVE_DELAY = 0.8
const RESULT_DISPLAY_TIME = 1.5

@export var rival_hand_path: NodePath
@export var player_hand_path: NodePath
@export var player_slot_path: NodePath
@export var timer_clock_path: NodePath
@export var main_menu_path: NodePath
@export var card_manager_path: NodePath 

@onready var rival_hand = get_node(rival_hand_path)
@onready var player_hand = get_node(player_hand_path)
@onready var player_slot = get_node(player_slot_path)
@onready var rival_slot = rival_hand.rival_slot
@onready var timer_clock = get_node(timer_clock_path)
@onready var main_menu = get_node(main_menu_path)
@onready var card_manager = get_node(card_manager_path)


var turn_timer: Timer
var is_resolving = false
var result_label: Label

func _process(_delta: float) -> void:
	timer_clock.update_display(turn_timer.time_left, TURN_TIME_LIMIT)

func _ready() -> void:
	turn_timer = Timer.new()
	turn_timer.wait_time = TURN_TIME_LIMIT
	turn_timer.one_shot = true
	turn_timer.timeout.connect(_on_turn_timeout)
	add_child(turn_timer)
	result_label = Label.new()
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_label.position = Vector2(760, 400)
	result_label.size = Vector2(400, 80)
	result_label.add_theme_font_size_override("font_size", 64)
	result_label.add_theme_color_override("font_color", Color.YELLOW)
	result_label.add_theme_color_override("font_outline_color", Color.BLACK)
	result_label.add_theme_constant_override("outline_size", 4)
	result_label.visible = false
	add_child(result_label)
	card_manager.hide()
	main_menu.game_started.connect(_on_game_started)

func _on_game_started() -> void:
	card_manager.show()
	start_turn()


func start_turn() -> void:
	is_resolving = false
	rival_hand.play_random_card()
	turn_timer.start()
	timer_clock.update_display(TURN_TIME_LIMIT, TURN_TIME_LIMIT)
	
func stop_turn_timer() -> void:
	turn_timer.stop()
	check_resolve_turn()

func _on_turn_timeout() -> void:
	if not player_slot.card_in_slot and not is_resolving:
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
		slot.card_in_slot = true
		slot.placed_card = card
		check_resolve_turn()
	)

func check_resolve_turn() -> void:
	if is_resolving:
		return
	if not (player_slot.card_in_slot and rival_slot.card_in_slot):
		return

	is_resolving = true
	turn_timer.stop()

	await get_tree().create_timer(RESOLVE_DELAY).timeout

	var rival_card = rival_slot.placed_card
	if rival_card:
		rival_card.reveal()

	var player_card = player_slot.placed_card
	if not player_card or not rival_card:
		is_resolving = false
		return

	var winner = WinManager.resolve_turn(player_card.card_data, rival_card.card_data)
	WinManager.player_total_power += player_card.card_data.power
	WinManager.rival_total_power += rival_card.card_data.power

	await get_tree().create_timer(RESULT_DISPLAY_TIME).timeout
	result_label.visible = false

	player_slot.clear()
	rival_slot.clear()

	player_hand.replenish()
	rival_hand.replenish()

	if WinManager.player_wins >= WinManager.WINS_NEEDED or WinManager.rival_wins >= WinManager.WINS_NEEDED:
		return

	if player_hand.player_hand.is_empty() or rival_hand.rival_hand.is_empty():
		determine_winner_by_score()
		return

	start_turn()

func determine_winner_by_score() -> void:
	if WinManager.player_wins > WinManager.rival_wins:
		WinManager.round_over.emit("player")
	elif WinManager.rival_wins > WinManager.player_wins:
		WinManager.round_over.emit("rival")
	elif WinManager.player_total_power > WinManager.rival_total_power:
		WinManager.round_over.emit("player")
	elif WinManager.rival_total_power > WinManager.player_total_power:
		WinManager.round_over.emit("rival")
	else:
		WinManager.round_over.emit("player")
