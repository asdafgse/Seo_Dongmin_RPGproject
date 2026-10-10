// obj_slime -> Create (전체 교체)
max_hp = 2;
hp = max_hp;
state = "idle";
detect_range = 180;
knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 4;
hit_flash_timer = 0;
hit_anim_timer = 0;
death_anim_timer = 0;

// 낮 근접 공격
melee_range = 38;
melee_damage = 1;
melee_cooldown = 0;
melee_cooldown_max = 45;
melee_attacking = false;
melee_hit_done = false;
melee_frame_speed = 8 / room_speed;
melee_original_sprite = spr_slime_idle;

// 밤: 근접 공격 1 -> 공격 2, 돌진 없음
night_move_speed = 1.7;
day_move_speed = 1.2;
night_attack_range = 65;
night_damage = 1;
night_cooldown_max = 35;
night_anim_speed = 8 / room_speed;
attack_frame = 0; // 프레임 진행 누적값
attack_hit_done = false;
attack_facing = 1;

// 광폭화 변신 (8프레임)
is_day_now = true;

// 낮/밤 상태 안전하게 확인
is_day_now = true;

var dn = instance_find(obj_daynight, 0);

if (dn != noone)
{
    if (variable_instance_exists(dn, "is_day"))
    {
        is_day_now = dn.is_day;
    }
}
last_is_day = is_day_now;
is_enraged = !is_day_now;
is_transforming = false;
transform_to_night = false;
transform_frame = 0;
transform_speed = 8 / room_speed;

sprite_index = is_enraged ? spr_slime_night_idle : spr_slime_idle;
image_index = 0;
image_speed = 0.15;
image_xscale = 1;
image_blend = c_white;
