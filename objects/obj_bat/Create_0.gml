/// obj_bat - Create

// 체력
max_hp = 3;
hp = max_hp;

// 상태
state = "idle";
detect_range = 220;

// 이동
day_move_speed = 1.8;
night_move_speed = 2.5;

// 근접 공격
melee_range = 38;
melee_damage = 1;
melee_hit_done = false;
melee_frame_speed = 8 / room_speed;

// 돌진
dash_trigger_range = 90;
dash_speed = 2.8;
dash_duration = 26;
dash_timer = 0;
dash_direction = 0;
dash_hit_done = false;

// 차징
charge_duration = round(room_speed * 0.7);
charge_timer = 0;

// 공격 후 휴식
attack_cooldown = 0;
attack_cooldown_max = round(room_speed * 1.0);

// 넉백
knockback_x = 0;
knockback_y = 0;
knockback_timer = 0;
knockback_speed = 4;

// 피격
hit_flash_timer = 0;

// 체력바
hp_bar_timer = 0;

// 낮/밤
is_enraged = false;
is_transforming = false;
transform_to_night = false;
transform_frame = 0;
transform_speed = 8 / room_speed;

var dn = instance_find(obj_daynight, 0);

if (dn != noone)
{
    if (variable_instance_exists(dn, "is_day"))
    {
        is_enraged = !dn.is_day;
    }
}

// 스프라이트
sprite_index = is_enraged
    ? spr_bat_night_idle
    : spr_bat_idle;

image_index = 0;
image_speed = 0.15;
image_xscale = 1;
image_blend = c_white;

// ==========================================
// 박쥐 랜덤 배회 시스템
// ==========================================

// 최초 스폰 위치
spawn_x = x;
spawn_y = y;

// 배회 범위
wander_radius = 150;

// 배회 속도
wander_speed = 0.9;

// 이동 방향
wander_direction = irandom(359);

// 방향 변경 타이머
wander_timer = irandom_range(20, 55);

// 잠시 멈추는 시간
wander_wait = 0;