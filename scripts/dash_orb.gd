extends Area2D

func _ready():
	connect("body_entered", self, "_on_DashOrb_body_entered")

func _on_DashOrb_body_entered(body):
	if body.is_in_group("player") and !body.can_dash:
		body.allow_dash()
		queue_free()  # Remove o orb da cena
