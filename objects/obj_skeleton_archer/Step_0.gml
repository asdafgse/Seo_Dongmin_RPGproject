// 일시정지
var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;

var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

// 보스 사망 시 소환된 궁수 제거
if (boss_id != noone)
{
    if (!instance_exists(boss_id))
    {
        instance_destroy();
        exit;
    }
    if (boss_id.is_dead)
    {
        instance_destroy();
        exit;
    }
}

if (hp_bar_timer > 0) hp_bar_timer--;
if (attack_cooldown > 0) attack_cooldown--;

// 사망 시작
if (hp <= 0 && state != "dying")
{
    hp = 0;
    state = "dying";
    is_dead = true;
    sprite_index = spr_skeleton_archer_death;
    image_index = 0;
    image_speed = 8 / room_speed;
    death_anim_timer = max(1, ceil(image_number / image_speed));
}

// 사망 애니메이션
if (state == "dying")
{
    death_anim_timer--;
    if (death_anim_timer <= 0) instance_destroy();
    exit;
}

// 소환 애니메이션
if (state == "summon")
{
    if (image_index >= image_number - 1)
    {
        state = "idle";
        sprite_index = spr_skeleton_archer_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 피격 애니메이션
if (hit_anim_timer > 0)
{
    if (sprite_index != spr_skeleton_archer_hit)
    {
        sprite_index = spr_skeleton_archer_hit;
        image_index = 0;
        image_speed = 0.25;
    }

    hit_anim_timer--;

    if (hit_anim_timer <= 0)
    {
        state = "idle";
        sprite_index = spr_skeleton_archer_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 넉백
if (knockback_timer > 0)
{
    x += knockback_x * knockback_speed;
    y += knockback_y * knockback_speed;
    knockback_timer--;
    exit;
}

// 피격 색상
image_blend = c_white;
if (hit_flash_timer > 0)
{
    hit_flash_timer--;
    image_blend = c_red;
}

// 플레이어가 없거나 사망했다면 대기
if (pl == noone || pl.is_dead || pl.hp <= 0)
{
    state = "idle";
    sprite_index = spr_skeleton_archer_idle;
    image_speed = 0.15;
    exit;
}

var dist = point_distance(x, y, pl.x, pl.y);
var dir = point_direction(x, y, pl.x, pl.y);

// 플레이어 방향 바라보기
image_xscale = (pl.x < x) ? -1 : 1;

// 활 공격 진행
if (state == "attack")
{
    attack_frame += attack_anim_speed;

    var frames = sprite_get_number(spr_skeleton_archer_attack);
    image_index = min(frames - 1, floor(attack_frame));

    // 공격 중간에 화살 발사
    if (!attack_hit_done && attack_frame >= max(1, floor(frames / 2)))
    {
        attack_hit_done = true;

        if (instance_exists(pl))
        {
            var arrow = instance_create_depth(
                x, y - 8, depth - 1, obj_skeleton_arrow
            );

            arrow.direction = point_direction(x, y - 8, pl.x, pl.y);
            arrow.speed = 5;
            arrow.damage = attack_damage;
            arrow.owner_id = id;
        }
    }

    if (attack_frame >= frames)
    {
        state = "idle";
        attack_cooldown = attack_cooldown_max;
        sprite_index = spr_skeleton_archer_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 탐지 범위 밖
if (dist > detect_range)
{
    state = "idle";
    if (sprite_index != spr_skeleton_archer_idle)
    {
        sprite_index = spr_skeleton_archer_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 너무 가까우면 후퇴
if (dist < retreat_distance)
{
    state = "retreat";

    if (sprite_index != spr_skeleton_archer_walk)
    {
        sprite_index = spr_skeleton_archer_walk;
        image_index = 0;
        image_speed = 0.15;
    }

    x -= lengthdir_x(move_speed, dir);
    y -= lengthdir_y(move_speed, dir);
    exit;
}

// 멀리 있으면 접근
if (dist > preferred_distance)
{
    state = "chase";

    if (sprite_index != spr_skeleton_archer_walk)
    {
        sprite_index = spr_skeleton_archer_walk;
        image_index = 0;
        image_speed = 0.15;
    }

    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
}

// 사거리 안에서 화살 공격
if (dist <= attack_range && attack_cooldown <= 0)
{
    state = "attack";
    attack_frame = 0;
    attack_hit_done = false;
    sprite_index = spr_skeleton_archer_attack;
    image_index = 0;
    image_speed = 0;
}
else if (state != "chase")
{
    state = "idle";
    sprite_index = spr_skeleton_archer_idle;
    image_speed = 0.15;
}