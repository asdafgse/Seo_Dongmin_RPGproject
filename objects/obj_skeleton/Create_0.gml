// obj_skeleton - Create
max_hp = 4;
hp = max_hp;
state = "summon";

// 스폰/소환
boss_id = noone; // 마법진에서 생성할 때 소환한 보스 ID를 넣을 예정
spawn_x = x;
spawn_y = y;

// 이동 및 공격
move_speed = 1.1;
detect_range = 220;
attack_range = 28;
attack_damage = 1;
attack_cooldown = 0;
attack_cooldown_max = 50;
attack_hit_done = false;
attack_frame = 0;
attack_anim_speed = 8 / room_speed;

// 피격/넉백
knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 4;
hit_flash_timer = 0;
hit_anim_timer = 0;
hp_bar_timer = 0;

// 사망
is_dead = false;
death_anim_timer = 0;

// 스프라이트
sprite_index = spr_skeleton_summon;
image_index = 0;
image_speed = 8 / room_speed;
image_xscale = 1;
image_blend = c_white;

