extends StaticBody2D

var player

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		player.connect("dashing", self, "_on_player_dashing")
	else:
		print("Nó do jogador não encontrado")

func _on_player_dashing(is_dashing):
	# Desativar ou reativar a colisão baseado no estado de is_dashing
	var collision_shape = get_node("CollisionShape2D")
	if collision_shape:
		collision_shape.set_disabled(is_dashing)
	# Verifique se o dash terminou e se o jogador está dentro do obstáculo
	if !is_dashing and _is_player_inside():
		_restart_level()

func _is_player_inside() -> bool:
	# Pegue os limites do jogador e do obstáculo
	var player_bounds = _get_bounds(player)
	var obstacle_bounds = _get_bounds(self)
	# Verifique se os limites estão se sobrepondo
	return player_bounds.intersects(obstacle_bounds)

func _get_bounds(node) -> Rect2:
	var collision_shape = node.get_node("CollisionShape2D")
	var shape = collision_shape.shape
	var extents = shape.extents
	var global_position = collision_shape.global_position
	return Rect2(global_position - extents, extents * 2)

func _restart_level():
	# Reinicie a fase aqui. Isso depende de como seu projeto está configurado.
	# Por exemplo, se você está usando cenas para representar níveis, você pode recarregar a cena atual:
	get_tree().reload_current_scene()

