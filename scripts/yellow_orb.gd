extends Area2D

export(String) var next_scene_filename

# Caminho base onde todos os níveis estão localizados
const BASE_SCENE_PATH = "res://scenes/levels/"

func _ready():
	connect("body_entered", self, "_on_Orb_body_entered")

func _on_Orb_body_entered(body):
	print("Corpo entrou na área do orbe.") # Debug
	if body.is_in_group("player"):
		# Constrói o caminho completo para o arquivo da cena
		print("Corpo está no grupo 'player'.") # Debug
		var full_scene_path = BASE_SCENE_PATH + next_scene_filename
		# Carrega e muda para a cena especificada quando o jogador coleta o orbe
		var next_scene = load(full_scene_path)
		get_tree().change_scene_to(next_scene)
