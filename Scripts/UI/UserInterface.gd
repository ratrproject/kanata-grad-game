extends Control

@onready var hpBar: TextureProgressBar = $"MarginContainer/VBoxContainer/HP Container/HP Bar"
@onready var hpText: Label = $"MarginContainer/VBoxContainer/HP Container/Label2"
@onready var tpBar: TextureProgressBar = $"MarginContainer/VBoxContainer/TP Container/TP Bar"
@onready var gameTimer : Label = $MarginContainer/VBoxContainer/LevelTimer

@onready var lunaBar: TextureProgressBar  = $MarginContainer/VBoxContainer/HBoxContainer2/LunaProgressBar
@onready var watameBar: TextureProgressBar  = $MarginContainer/VBoxContainer/HBoxContainer2/WatameProgressBar
@onready var towaBar: TextureProgressBar  = $MarginContainer/VBoxContainer/HBoxContainer2/TowaProgressBar
@onready var cocoBar: TextureProgressBar  = $MarginContainer/VBoxContainer/HBoxContainer2/CocoProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var players = get_tree().get_nodes_in_group("Player")
	if players.size():
		var player = players[0]
		var healthPercentage = player.health / player.MaxHealth
		
		hpBar.value = 100 * healthPercentage
		hpText.text = ("%.0f" % player.health) + "/" + ("%.0f" % player.MaxHealth)
		
		tpBar.value = 100 * player.power / player.MaxTenshiPower
		
		var time = $"../..".elapsed_time
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		gameTimer.text = "%02d:%02d" % [minutes, seconds]
		
		if player.LunaSupportUnlocked:
			lunaBar.visible = true
		else:
			lunaBar.visible = false
		
		if player.WatameSupportUnlocked:
			watameBar.visible = true
		else:
			watameBar.visible = false
			
		if player.TowaSupportUnlocked:
			towaBar.visible = true
		else:
			towaBar.visible = false
			
		if player.CocoSupportUnlocked:
			cocoBar.visible = true
		else:
			cocoBar.visible = false
			
		if player.LunaSupportAvailable:
			lunaBar.value = 100
		else:
			lunaBar.value = 0
			
		if player.WatameSupportAvailable:
			watameBar.value = 100
		else:
			watameBar.value = 0
			
		if player.TowaSupportAvailable:
			towaBar.value = 100
		else:
			towaBar.value = 0
			
		if player.CocoSupportAvailable:
			cocoBar.value = 100
		else:
			cocoBar.value = 0
