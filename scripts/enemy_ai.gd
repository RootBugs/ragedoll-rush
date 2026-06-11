extends CharacterBody3D

class_name EnemyAI

@export var health: int = 80
@export var walk_speed: float = 3.0
@export var run_speed: float = 6.0
@export var damage: int = 10
@export var fire_rate: float = 0.5
@export var detection_range: float = 40.0
@export var attack_range: float = 25.0

enum State { PATROL, CHASE, ATTACK, SEARCH }
var state: State = State.PATROL
var alive: bool = true
var fire_cooldown: float = 0.0

var patrol_points: Array[Vector3] = []
var current_patrol_idx: int = 0
var patrol_wait: float = 0.0
var target: Node3D = null
var last_known_pos: Vector3
var search_timer: float = 0.0

var audio_shoot: AudioStreamPlayer
var model_root: Node3D
var anim_player: AnimationPlayer

func _ready() -> void:
	add_to_group("enemies")
	collision_layer = 1
	collision_mask = 1

	# Collision shape
	var cshape = CollisionShape3D.new()
	cshape.shape = CapsuleShape3D.new()
	cshape.shape.radius = 0.5
	cshape.shape.height = 1.8
	add_child(cshape)

	# Audio
	audio_shoot = AudioStreamPlayer.new()
	var wav = load("res://shoot.wav") if ResourceLoader.exists("res://shoot.wav") else null
	audio_shoot.stream = wav
	audio_shoot.volume_db = -10
	add_child(audio_shoot)

	# Visual
	var capsule = MeshInstance3D.new()
	capsule.mesh = CapsuleMesh.new()
	capsule.mesh.radius = 0.5
	capsule.mesh.height = 1.8
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.2, 0.2)
	capsule.material = mat
	add_child(capsule)

	if ResourceLoader.exists("res://player_rigged.fbx"):
		var model = load("res://player_rigged.fbx")
		if model:
			var inst = model.instantiate()
			model_root = inst
			add_child(inst)
			anim_player = inst.find_child("AnimationPlayer") if inst.find_child("AnimationPlayer") else null
			capsule.visible = false

	generate_patrol_points()

func generate_patrol_points() -> void:
	for i in range(5):
		var pt = Vector3((randf() - 0.5) * 90, 0, (randf() - 0.5) * 90)
		patrol_points.append(pt)

func _physics_process(delta: float) -> void:
	if not alive: return
	fire_cooldown -= delta
	match state:
		State.PATROL: patrol(delta)
		State.CHASE: chase(delta)
		State.ATTACK: attack(delta)
		State.SEARCH: search(delta)
	move_and_slide()

func patrol(delta: float) -> void:
	if patrol_points.is_empty(): return
	var target_pos = patrol_points[current_patrol_idx]
	var dir = target_pos - global_position; dir.y = 0
	if dir.length() < 2.0:
		patrol_wait += delta
		velocity = Vector3.ZERO
		if patrol_wait > 2.0:
			current_patrol_idx = (current_patrol_idx + 1) % patrol_points.size()
			patrol_wait = 0.0
		return
	velocity = dir.normalized() * walk_speed
	var player = find_nearest_player()
	if player and global_position.distance_to(player.global_position) < detection_range:
		state = State.CHASE; target = player

func chase(delta: float) -> void:
	if not target or not is_instance_valid(target): state = State.SEARCH; return
	var dist = global_position.distance_to(target.global_position)
	last_known_pos = target.global_position
	if dist < attack_range: state = State.ATTACK; return
	var dir = target.global_position - global_position; dir.y = 0
	velocity = dir.normalized() * run_speed

func attack(delta: float) -> void:
	if not target or not is_instance_valid(target): state = State.PATROL; return
	var dist = global_position.distance_to(target.global_position)
	if dist > attack_range * 1.5: state = State.CHASE; return
	var dir = target.global_position - global_position
	var target_basis = Basis.looking_at(Vector3(dir.x, 0, dir.z).normalized(), Vector3.UP)
	global_transform.basis = global_transform.basis.slerp(target_basis, 0.1)
	velocity = Vector3.ZERO
	if fire_cooldown <= 0:
		fire_cooldown = fire_rate
		shoot_at(target)

func search(delta: float) -> void:
	var dir = last_known_pos - global_position; dir.y = 0
	if dir.length() < 2.0:
		search_timer += delta; velocity = Vector3.ZERO
		if search_timer > 5.0: search_timer = 0.0; state = State.PATROL; return
	velocity = dir.normalized() * walk_speed
	var player = find_nearest_player()
	if player and global_position.distance_to(player.global_position) < detection_range:
		state = State.CHASE; target = player

func shoot_at(target_node: Node3D) -> void:
	if audio_shoot and audio_shoot.stream: audio_shoot.play()
	var space = get_world_3d().direct_space_state
	var from = global_position + Vector3(0, 1.5, 0)
	var to = target_node.global_position + Vector3(0, 1, 0)
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 2
	var result = space.intersect_ray(query)
	if result and result.collider and result.collider.has_method("take_damage"):
		result.collider.take_damage(damage, self)

func find_nearest_player() -> Node3D:
	var players = get_tree().get_nodes_in_group("players")
	var nearest = null; var nearest_dist = detection_range
	for p in players:
		if p and is_instance_valid(p) and p.alive:
			var d = global_position.distance_to(p.global_position)
			if d < nearest_dist: nearest = p; nearest_dist = d
	return nearest

func take_damage(dmg: int, attacker = null) -> void:
	if not alive: return
	health -= dmg
	if attacker and attacker is Node3D: state = State.CHASE; target = attacker; last_known_pos = attacker.global_position
	if health <= 0: die()

func die() -> void:
	alive = false; health = 0
	var game = get_node("/root/Game")
	if game and game.has_method("enemy_killed"): game.enemy_killed(self)
	queue_free()
