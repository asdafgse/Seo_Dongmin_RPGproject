/// obj_orc - Create
max_hp = 8;
hp = max_hp;
state = "idle";
detect_range = 180;
day_move_speed = 1.1;
night_move_speed = 1.6;
melee_range = 45;
melee_damage = 2;
melee_hit_done = false;
melee_frame_speed = 8 / room_speed;
attack_count = 0;
attack_count_max = 1;
double_attack_chance = 0.4;
attack_cooldown = 0;
attack_cooldown_max = round(room_speed * 1.2);
knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 3;
hit_flash_timer = 0;
hp_bar_timer = 0;
is_enraged = false;
var dn = instance_find(obj_daynight, 0);
if (dn != noone && variable_instance_exists(dn, "is_day")) is_enraged = !dn.is_day;
night_attack_kind = 0;
night_attack_damage = 0;
night_hit_range = 0;
night_hit_frame = 3;
night_attack_speed = 8 / room_speed;
night_shockwave_radius = 100;
night_shockwave_damage = 4;
night_shockwave_spawned = false;
transform_target_night = is_enraged;
transform_reverse = false;
transform_speed = 10 / room_speed;
// Death animation is advanced manually so it never loops.
death_frame = 0;
death_hold = 0;
death_hold_max = max(1, round(room_speed * 0.25));
death_anim_fps = 8;
death_drop_done = false;

sprite_index = is_enraged ? spr_orc_night_idle : spr_orc_idle;
image_index = 0;
image_speed = 0.15;
image_xscale = 1;
image_blend = c_white;


// ==========================================
// Orc Random Wandering
// ==========================================

// Spawn position
spawn_x = x;
spawn_y = y;

// Wandering settings
wander_radius = 120;
wander_speed = 0.45;
wander_direction = irandom(359);

// Movement and waiting timers
wander_timer = irandom_range(45, 100);
wander_wait = 0;