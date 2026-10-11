// HP
max_hp = 8;
hp = max_hp;

// 상태
state = "summon";
is_dead = false;
boss_id = noone;

// 이동 및 탐지
move_speed = 0.7;
detect_range = 200;

// 근접 공격
attack_range = 35;
attack_damage = 2;
attack_cooldown = 0;
attack_cooldown_max = room_speed * 2;

attack_hit_done = false;
attack_frame = 0;
attack_anim_speed = 6 / room_speed;

// 피격 및 넉백
knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 2;

hit_anim_timer = 0;
hit_flash_timer = 0;
hp_bar_timer = 0;
death_anim_timer = 0;

// 스프라이트
sprite_index = spr_skeleton_knight_summon;
image_index = 0;
image_speed = 8 / room_speed;
image_xscale = 1;
image_blend = c_white;