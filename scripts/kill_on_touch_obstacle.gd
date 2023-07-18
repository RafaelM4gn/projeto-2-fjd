extends Area2D

export var can_pass_while_dashing = true

var player
var player_inside = false

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		player.connect("dashing", self, "_on_player_dashing")
		connect("body_entered", self, "_on_body_entered")
		connect("body_exited", self, "_on_body_exited")
	else:
		print("Nó do jogador não encontrado")

func _on_player_dashing(is_dashing):
	# Verifique se o dash terminou e se o jogador está dentro do obstáculo
	if !is_dashing and player_inside:
		_restart_level()

func _on_body_entered(body):
	if body == player:
		player_inside = true
		# Se o jogador não pode passar enquanto estiver usando o dash, reinicie a fase
		if !can_pass_while_dashing and player.is_dashing:
			_restart_level()
		# Caso contrário, se o jogador não está em dash, também reinicie a fase
		elif !player.is_dashing:
			_restart_level()

func _on_body_exited(body):
	if body == player:
		player_inside = false

func _restart_level():
	# Reinicie a fase aqui. Isso depende de como seu projeto está configurado.
	# Por exemplo, se você está usando cenas para representar níveis, você pode recarregar a cena atual:
	get_tree().reload_current_scene()
