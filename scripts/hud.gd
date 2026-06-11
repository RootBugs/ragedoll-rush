extends CanvasLayer

# Battle Royale — HUD

var health_bar: ColorRect
var health_label: Label
var ammo_label: Label
var kill_label: Label
var enemy_label: Label
var zone_label: Label
var crosshair: ColorRect

func _ready() -> void:
	build_hud()

func build_hud() -> void:
	# Health bar
	var hb_bg = ColorRect.new()
	hb_bg.color = Color(0.1, 0.1, 0.1, 0.5)
	hb_bg.position = Vector2(20, 20)
	hb_bg.size = Vector2(200, 20)
	add_child(hb_bg)

	health_bar = ColorRect.new()
	health_bar.color = Color(0.2, 0.8, 0.2)
	health_bar.position = Vector2(20, 20)
	health_bar.size = Vector2(200, 20)
	add_child(health_bar)

	health_label = Label.new()
	health_label.position = Vector2(25, 20)
	health_label.size = Vector2(190, 20)
	health_label.add_theme_color_override("font_color", Color(1, 1, 1))
	health_label.add_theme_font_size_override("font_size", 12)
	add_child(health_label)

	# Ammo
	ammo_label = Label.new()
	ammo_label.position = Vector2(20, 50)
	ammo_label.size = Vector2(200, 30)
	ammo_label.add_theme_color_override("font_color", Color(1, 1, 1))
	ammo_label.add_theme_font_size_override("font_size", 18)
	add_child(ammo_label)

	# Kills
	kill_label = Label.new()
	kill_label.position = Vector2(20, 80)
	kill_label.size = Vector2(200, 30)
	kill_label.add_theme_color_override("font_color", Color(1, 0.8, 0.3))
	kill_label.add_theme_font_size_override("font_size", 16)
	add_child(kill_label)

	# Enemies remaining
	enemy_label = Label.new()
	enemy_label.anchor_right = 1.0
	enemy_label.position = Vector2(0, 20)
	enemy_label.size = Vector2(0, 30)
	enemy_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	enemy_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4))
	enemy_label.add_theme_font_size_override("font_size", 18)
	add_child(enemy_label)

	# Zone warning
	zone_label = Label.new()
	zone_label.anchor_left = 0.5
	zone_label.anchor_right = 0.5
	zone_label.position = Vector2(-150, 60)
	zone_label.size = Vector2(300, 40)
	zone_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	zone_label.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
	zone_label.add_theme_font_size_override("font_size", 24)
	zone_label.hide()
	add_child(zone_label)

	# Crosshair
	crosshair = ColorRect.new()
	crosshair.color = Color(1, 1, 1, 0.8)
	crosshair.size = Vector2(4, 4)
	add_child(crosshair)

	update_hud()

func _process(_delta: float) -> void:
	# Update crosshair position on every frame (handles window resize)
	var vp = get_viewport().size
	crosshair.position = Vector2(vp.x / 2.0 - 2.0, vp.y / 2.0 - 2.0)

func update_hud() -> void:
	var player = get_player()
	if not player: return

	var health_pct = float(player.health) / player.max_health
	health_bar.size.x = 200 * health_pct
	if health_pct > 0.6:
		health_bar.color = Color(0.2, 0.8, 0.2)
	elif health_pct > 0.3:
		health_bar.color = Color(0.8, 0.8, 0.2)
	else:
		health_bar.color = Color(0.8, 0.2, 0.2)

	health_label.text = "HP: %d/%d" % [player.health, player.max_health]
	ammo_label.text = "%d / %d" % [player.ammo, player.max_ammo]
	kill_label.text = "KILLS: %d" % player.kills

	var game = get_node("/root/Game")
	if game:
		enemy_label.text = "ENEMIES: %d" % game.enemies_remaining

func get_player():
	return get_node_or_null("/root/Game/Player")

func show_zone_warning(text: String) -> void:
	zone_label.text = text
	zone_label.show()
	await get_tree().create_timer(3.0).timeout
	zone_label.hide()
