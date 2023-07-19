extends Control

var a = -1

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		a *= -1
	
	if a == -1:
		hide()
		get_tree().paused = false
		
	if a== 1:
		show()
		get_tree().paused = true

func _on_Resume_pressed():
	a *= -1
	
	if a == -1:
		hide()
		get_tree().paused = false

func _on_Exit_pressed():
	get_tree().quit()
