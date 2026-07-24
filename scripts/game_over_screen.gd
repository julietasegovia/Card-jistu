extends CanvasLayer

signal play_again_pressed

const WIN_TEXTURE = preload("res://sprites/win_scene.webp")
const LOSE_TEXTURE = preload("res://sprites/tie_scene.webp")

@onready var winner_label = $WinnerLabel
@onready var play_again_button = $PlayAgainButton
@onready var panel_image = $Background/PanelImage

func _ready() -> void:
	hide()
	WinManager.round_over.connect(_on_round_over)
	play_again_button.pressed.connect(_on_play_again_pressed)

func _on_round_over(winner_name: String) -> void:
	await get_tree().create_timer(1.5).timeout   
	if winner_name == "player":
		winner_label.text = "YOU WIN!"
		panel_image.texture = WIN_TEXTURE
	elif winner_name == "rival":
		winner_label.text = "YOU LOSE..."
		panel_image.texture = LOSE_TEXTURE
	else:
		winner_label.text = "TIE GAME!"
	show()

func _on_play_again_pressed() -> void:
	WinManager.reset()
	get_tree().reload_current_scene()
