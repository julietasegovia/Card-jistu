extends CanvasLayer

signal play_again_pressed

@onready var winner_label = $WinnerLabel
@onready var play_again_button = $PlayAgainButton

func _ready() -> void:
	hide()
	WinManager.round_over.connect(_on_round_over)
	play_again_button.pressed.connect(_on_play_again_pressed)

func _on_round_over(winner_name: String) -> void:
	if winner_name == "player":
		winner_label.text = "YOU WIN!"
	else:
		winner_label.text = "YOU LOSE..."

func _on_play_again_pressed() -> void:
	play_again_pressed.emit()
	hide()
