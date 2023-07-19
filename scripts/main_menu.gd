extends Control

# Botão Play
onready var button_play = $ButtonPlay

# Botão Quit
onready var button_quit = $ButtonQuit

func _ready():
	# Conecte os sinais dos botões às funções correspondentes
	button_play.connect("pressed", self, "_on_PlayButton_pressed")
	button_quit.connect("pressed", self, "_on_QuitButton_pressed")

func _on_PlayButton_pressed():
	# Carrega e muda para a cena level0.tscn quando o botão Play é pressionado
	var level = load("res://scenes/levels/Level0.tscn")
	get_tree().change_scene_to(level)

func _on_QuitButton_pressed():
	# Fecha o jogo quando o botão Quit é pressionado
	get_tree().quit()
