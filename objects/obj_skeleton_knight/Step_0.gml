// 일시정지
var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;

var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

// 보스 사망 시 소환된 기사 제거
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

// 타이머
if (hp_bar_timer > 0) hp_bar_timer--;
if (attack_cooldown > 0) attack_cooldown--;

// 사망 시작
if (hp <= 0 && state != "dying")
{
    hp = 0;
    state = "dying";
    is_dead = true;

    sprite_index = spr_skeleton_knight_death;
    image_index = 0;
    image_speed = 8 / room_speed;

    death_anim_timer = max(
        1,
        ceil(image_number / image_speed)
    );
}

// 사망 애니메이션
if (state == "dying")
{
    death_anim_timer--;

    if (death_anim_timer <= 0)
        instance_destroy();

    exit;
}

// 소환 애니메이션
if (state == "summon")
{
    if (image_index >= image_number - 1)
    {
        state = "idle";
        sprite_index = spr_skeleton_knight_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 피격 애니메이션
if (hit_anim_timer > 0)
{
    if (sprite_index != spr_skeleton_knight_hit)
    {
        sprite_index = spr_skeleton_knight_hit;
        image_index = 0;
        image_speed = 0.25;
    }

    hit_anim_timer--;

    if (hit_anim_timer <= 0)
    {
        state = "idle";
        sprite_index = spr_skeleton_knight_idle;
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

// 플레이어가 없거나 사망했으면 대기
if (pl == noone || pl.is_dead || pl.hp <= 0)
{
    state = "idle";

    if (sprite_index != spr_skeleton_knight_idle)
    {
        sprite_index = spr_skeleton_knight_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

var dist = point_distance(x, y, pl.x, pl.y);
var dir = point_direction(x, y, pl.x, pl.y);

// 플레이어 방향 바라보기
image_xscale = (pl.x < x) ? -1 : 1;

// 공격 애니메이션 진행
if (state == "attack")
{
    attack_frame += attack_anim_speed;

    var frames = sprite_get_number(spr_skeleton_knight_attack);
    image_index = min(frames - 1, floor(attack_frame));

    // 공격 중간 프레임에 피해 적용
    if (!attack_hit_done &&
        attack_frame >= max(1, floor(frames / 2)))
    {
        attack_hit_done = true;

        if (instance_exists(pl) &&
            !pl.is_dead &&
            pl.hp > 0 &&
            !pl.is_invincible)
        {
            var hit_dist = point_distance(
                x, y, pl.x, pl.y
            );

            var facing_ok =
                (image_xscale >= 0 && pl.x >= x) ||
                (image_xscale < 0 && pl.x <= x);

            if (hit_dist <= attack_range && facing_ok)
            {
                var block_chance = min(
                    50, pl.defense * 5
                );

                if (irandom(99) >= block_chance)
                {
                    pl.hp = max(
                        0, pl.hp - attack_damage
                    );

                    var knock_dir = point_direction(
                        x, y, pl.x, pl.y
                    );

                    pl.knockback_x = lengthdir_x(
                        1, knock_dir
                    );
                    pl.knockback_y = lengthdir_y(
                        1, knock_dir
                    );
                    pl.knockback_timer = 8;
                }
            }
        }
    }

    if (attack_frame >= frames)
    {
        state = "idle";
        attack_cooldown = attack_cooldown_max;

        sprite_index = spr_skeleton_knight_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 탐지 범위 밖
if (dist > detect_range)
{
    state = "idle";

    if (sprite_index != spr_skeleton_knight_idle)
    {
        sprite_index = spr_skeleton_knight_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 근접 공격 시작
if (dist <= attack_range && attack_cooldown <= 0)
{
    state = "attack";
    attack_frame = 0;
    attack_hit_done = false;

    sprite_index = spr_skeleton_knight_attack;
    image_index = 0;
    image_speed = 0;
    exit;
}

// 플레이어 추적
if (dist > attack_range)
{
    state = "chase";

    if (sprite_index != spr_skeleton_knight_walk)
    {
        sprite_index = spr_skeleton_knight_walk;
        image_index = 0;
        image_speed = 0.15;
    }

    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
}
else
{
    state = "idle";

    if (sprite_index != spr_skeleton_knight_idle)
    {
        sprite_index = spr_skeleton_knight_idle;
        image_index = 0;
        image_speed = 0.15;
    }
}