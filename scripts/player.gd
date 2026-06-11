extends CharacterBody3D

class_name BattlePlayer

# Movement
@export var walk_speed: float = 6.0
@export var sprint_speed: float = 10.0
@export var jump_velocity: float = 10.0
@export var mouse_sens: float = 0.002
@export var acceleration: float = 0.12
@export var air_control: float = 0.05

# Health
@export var max_health: int = 100
var health: int = 100
var alive: bool = true
var kills: int = 0

# Weapon
var weapon: Node3D = null
var ammo: int = 30
var max_ammo: int = 30
var total_ammo: int = 90
var is_reloading: bool = false
var reload_time: float = 2.0
var fire_rate: float = 0.1
var fire_cooldown: float = 0.0
var bullet_damage: int = 20

# References
var head: Node3D
var camera: Camera3D
var muzzle: Node3D
var audio_shoot: AudioStreamPlayer
var audio_reload: AudioStreamPlayer

# Animation
var current_anim: String = "idle"
var model_root: Node3D
var anim_player: AnimationPlayer

func _ready() -> void:
	head = $Head
	camera = $Head/Camera3D
	muzzle = $Head/Muzzle

	if not is_multiplayer_authority():
		camera.current = false
		camera.queue_free()

	# Audio
	audio_shoot = AudioStreamPlayer.new()
	audio_shoot.stream = load("res://shoot.wav") if ResourceLoader.exists("res://shoot.wav") else null
	add_child(audio_shoot)
	audio_reload = AudioStreamPlayer.new()
	audio_reload.stream = load("res://reload.wav") if ResourceLoader.exists("res://reload.wav") else null
	add_child(audio_reload)

	# Model
	if ResourceLoader.exists("res://player_rigged.fbx"):
		var model = load("res://player_rigged.fbx")
		if model:
			var inst = model.instantiate()
			model_root = inst
			add_child(inst)
			anim_player = inst.find_child("AnimationPlayer") if inst.find_child("AnimationPlayer") else null
	else:
		# Placeholder capsule
		var capsule = MeshInstance3D.new()
		capsule.mesh = CapsuleMesh.new()
		capsule.mesh.radius = 0.5
		capsule.mesh.height = 1.8
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.6, 0.9)
		capsule.material = mat
		add_child(capsule)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if is_multiplayer_authority():
		$Head/Camera3D.current = true

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if not alive: return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * mouse_sens)
		camera.rotate_x(-event.relative.y * mouse_sens)
		camera.rotation.x = clamp(camera.rotation.x, -1.4, 1.4)

	if event.is_action_pressed("shoot") and not is_reloading:
		shoot()

	if event.is_action_pressed("reload") and ammo < max_ammo and total_ammo > 0:
		start_reload()

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	if not alive: return

	# Movement
	var sprint = Input.is_action_pressed("sprint")
	var speed = sprint_speed if sprint else walk_speed
	var accel = acceleration if is_on_floor() else air_control

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = (head.transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()

	var target_vel = dir * speed
	velocity.x = lerp(velocity.x, target_vel.x, accel)
	velocity.z = lerp(velocity.z, target_vel.z, accel)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if not is_on_floor():
		velocity.y -= 25 * delta

	move_and_slide()

	# Fire cooldown
	if fire_cooldown > 0:
		fire_cooldown -= delta

	# Animation
	update_animation(input_dir, sprint)

func update_animation(input_dir: Vector2, sprint: bool) -> void:
	if not anim_player: return
	var moving = input_dir.length() > 0.1
	if not moving:
		play_anim("idle")
	elif sprint and is_on_floor():
		play_anim("sprint")
	elif is_on_floor():
		play_anim("run")

	if not is_on_floor():
		play_anim("jump")

func play_anim(name: String) -> void:
	if current_anim == name: return
	current_anim = name
	if anim_player and anim_player.has_animation(name):
		anim_player.play(name)

func shoot() -> void:
	if fire_cooldown > 0: return
	if ammo <= 0: start_reload(); return
	if is_reloading: return

	fire_cooldown = fire_rate
	ammo -= 1

	if audio_shoot and audio_shoot.stream:
		audio_shoot.pitch_scale = 1.0 + randf() * 0.05
		audio_shoot.play()

	play_anim("shoot")

	# Hitscan
	var space = get_world_3d().direct_space_state
	var from = camera.global_position
	var to = from - camera.global_transform.basis.z * 1000

	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1
	var result = space.intersect_ray(query)

	$Head/Muzzle/MuzzleFlash.visible = true
	await get_tree().create_timer(0.05).timeout
	$Head/Muzzle/MuzzleFlash.visible = false

	if result:
		var hit = result.collider
		if hit and hit.has_method("take_damage"):
			hit.take_damage(bullet_damage, self)

func start_reload() -> void:
	if is_reloading: return
	is_reloading = true
	play_anim("reload")
	if audio_reload and audio_reload.stream:
		audio_reload.play()
	await get_tree().create_timer(reload_time).timeout

	var need = max_ammo - ammo
	var give = mini(need, total_ammo)
	ammo += give
	total_ammo -= give
	is_reloading = false

func take_damage(dmg: int, attacker = null) -> void:
	if not alive: return
	health -= dmg
	play_anim("hitreact")

	if health <= 0:
		die()

func die() -> void:
	alive = false
	health = 0
	play_anim("death")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Respawn in 5s
	await get_tree().create_timer(5.0).timeout
	respawn()

func respawn() -> void:
	health = max_health
	alive = true
	ammo = max_ammo
	total_ammo = 90

	var spawns = get_tree().get_nodes_in_group("spawns")
	if spawns.size() > 0:
		var sp = spawns[randi() % spawns.size()]
		global_position = sp.global_position

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var hud = get_node_or_null("/root/Game/HUD")
	if hud:
		hud.update_hud()

func add_kill() -> void:
	kills += 1
