extends Node3D

# Battle Royale — Main Game Manager

var player: BattlePlayer = null
var enemies: Array[Node] = []
var hud: Node = null
var game_started: bool = false
var total_enemies: int = 0
var enemies_remaining: int = 0

# Zone (shrinking circle)
var zone_center: Vector3 = Vector3.ZERO
var zone_radius: float = 60.0
var zone_min_radius: float = 5.0
var zone_shrink_rate: float = 1.0
var zone_phase: int = 0
var zone_warning_time: float = 0.0
var zone_dmg_acc: float = 0.0

func _ready() -> void:
	build_map()
	create_hud()
	create_player()
	spawn_enemies(10)
	total_enemies = 10
	enemies_remaining = 10

func build_map() -> void:
	# Ground
	var ground = MeshInstance3D.new()
	ground.mesh = BoxMesh.new()
	ground.mesh.size = Vector3(120, 0.5, 120)
	var gmat = StandardMaterial3D.new()
	gmat.albedo_color = Color(0.2, 0.25, 0.18)
	gmat.roughness = 0.8
	ground.material = gmat
	ground.position = Vector3(0, -0.25, 0)
	add_child(ground)

	var floor_body = StaticBody3D.new()
	floor_body.position = Vector3(0, -0.5, 0)
	var floor_shape = CollisionShape3D.new()
	floor_shape.shape = BoxShape3D.new()
	floor_shape.shape.size = Vector3(120, 0.2, 120)
	floor_body.add_child(floor_shape)
	add_child(floor_body)

	# Random obstacles
	var obs_mat = StandardMaterial3D.new()
	obs_mat.albedo_color = Color(0.3, 0.28, 0.25, 0.25)
	obs_mat.roughness = 0.7

	for i in range(30):
		var size = Vector3(1 + randf() * 4, 1 + randf() * 3, 1 + randf() * 4)
		var obs = MeshInstance3D.new()
		obs.mesh = BoxMesh.new()
		obs.mesh.size = size
		obs.material = obs_mat
		obs.position = Vector3((randf() - 0.5) * 90, size.y/2, (randf() - 0.5) * 90)
		add_child(obs)

		var obs_body = StaticBody3D.new()
		obs_body.position = obs.position
		var obs_shape = CollisionShape3D.new()
		obs_shape.shape = BoxShape3D.new()
		obs_shape.shape.size = size
		obs_body.add_child(obs_shape)
		add_child(obs_body)

	# Spawn points
	for i in range(10):
		var sp = Marker3D.new()
		sp.name = "Spawn_%d" % i
		sp.position = Vector3((randf() - 0.5) * 80, 0.5, (randf() - 0.5) * 80)
		sp.add_to_group("spawns")
		add_child(sp)

	# Lighting
	var sun = DirectionalLight3D.new()
	sun.light_energy = 1.5
	sun.shadow_enabled = true
	sun.position = Vector3(30, 40, 20)
	sun.look_at(Vector3.ZERO)
	add_child(sun)

	var env = WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_color = Color(0.4, 0.5, 0.6)
	env.environment.ambient_light_color = Color(0.3, 0.35, 0.4)
	env.environment.ambient_light_energy = 0.5
	add_child(env)

func create_hud() -> void:
	hud = CanvasLayer.new()
	hud.name = "HUD"
	var hscript = load("res://scripts/hud.gd")
	if hscript:
		hud.set_script(hscript)
	add_child(hud)

func create_player() -> void:
	player = BattlePlayer.new()
	player.name = "Player"
	var pcol = CollisionShape3D.new()
	pcol.shape = CapsuleShape3D.new()
	pcol.shape.radius = 0.5
	pcol.shape.height = 1.8
	player.add_child(pcol); player.collision_layer = 2; player.collision_mask = 1

	var head = Node3D.new()
	head.name = "Head"
	var cam = Camera3D.new()
	cam.name = "Camera3D"
	head.add_child(cam)
	var muzzle = Node3D.new()
	muzzle.name = "Muzzle"
	muzzle.position = Vector3(0.3, -0.1, -0.5)
	head.add_child(muzzle)
	player.add_child(head)

	var flash = MeshInstance3D.new()
	flash.name = "MuzzleFlash"
	flash.mesh = BoxMesh.new()
	flash.mesh.size = Vector3(0.08, 0.08, 0.3)
	var fmat = StandardMaterial3D.new()
	fmat.albedo_color = Color(1, 1, 0.5)
	fmat.emission = Color(1, 1, 0.5)
	fmat.emission_energy = 2.0
	flash.material = fmat
	flash.position = Vector3(0, 0, -0.4)
	flash.visible = false
	muzzle.add_child(flash)

	var spawns = get_tree().get_nodes_in_group("spawns")
	if spawns.size() > 0:
		var sp = spawns[randi() % spawns.size()]
		player.position = sp.global_position

	add_child(player)
	cam.current = true

func spawn_enemies(count: int) -> void:
	for i in range(count):
		var enemy = EnemyAI.new()
		enemy.name = "Enemy_%d" % i
		enemy.position = Vector3((randf() - 0.5) * 80, 0.5, (randf() - 0.5) * 80)
		add_child(enemy)
		enemies.append(enemy)

func enemy_killed(enemy: Node) -> void:
	enemies_remaining -= 1

	if player and is_instance_valid(player):
		player.add_kill()

	if hud and hud.has_method("update_hud"):
		hud.update_hud()

	# Spawn more enemies until all 30 are done
	if enemies_remaining < 5 and total_enemies < 30:
		spawn_enemies(3)
		total_enemies += 3
		enemies_remaining += 3

func _process(delta: float) -> void:
	if not game_started:
		game_started = true
		return

	update_zone(delta)

func update_zone(delta: float) -> void:
	zone_radius -= zone_shrink_rate * delta
	zone_radius = max(zone_radius, zone_min_radius)

	if zone_radius < 30 and zone_phase == 0:
		zone_phase = 1
		zone_shrink_rate = 2.0
		if hud and hud.has_method("show_zone_warning"):
			hud.show_zone_warning("Zone shrinking!")

	if zone_radius < 15 and zone_phase == 1:
		zone_phase = 2
		zone_shrink_rate = 3.0
		if hud and hud.has_method("show_zone_warning"):
			hud.show_zone_warning("Zone closing fast!")

	# Check if player is outside zone
	if player and is_instance_valid(player) and player.alive:
		var dist = player.global_position.distance_to(zone_center)
		if dist > zone_radius:
			zone_dmg_acc += 2.0 * delta
			while zone_dmg_acc >= 1.0:
				player.take_damage(1, null)
				zone_dmg_acc -= 1.0
