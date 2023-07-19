extends YSort

# Assumindo que "Player" é o nome do nó do jogador.
onready var player = get_node("Player")

func _ready():
	# Conectar ao sinal do player.
	player.connect("dashing", self, "_on_player_dashing")

func _on_player_dashing(is_dashing):
	# Habilitar/desabilitar a classificação com base em is_dashing.
	print("pegou o dash")
	self.sort_enabled = !is_dashing
