// HP
max_hp = 10;
hp = max_hp;
is_dead = false;

// 상태
state = "idle";
phase = 1;

// 이동
move_speed = 0.8;
detect_range = 350;

// 근접 공격
attack_damage = 2;
attack_range = 38;
attack_cooldown = room_speed * 2;
attack_timer = 0;
attack_hit_done = false;
attack_frame = 0;
attack_anim_speed = 8 / room_speed;

// 해골 소환
summon_cooldown = room_speed * 12;
summon_timer = summon_cooldown;
summon_count = 2;

// 마법 폭발
magic_cooldown = room_speed * 8;
magic_timer = magic_cooldown;
magic_count = 15;

// 스킬 애니메이션
skill_timer = 0;

// 피격 및 사망
hit_anim_timer = 0;
hit_flash_timer = 0;
hp_bar_timer = 0;
death_anim_timer = 0;

// 넉백
knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 1;

// 스프라이트
sprite_index = spr_necro_idle;
image_index = 0;
image_speed = 0.15;
image_xscale = 1;
image_blend = c_white;