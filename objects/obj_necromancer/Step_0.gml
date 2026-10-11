// =====================================
// 일시정지
// =====================================
var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;

var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

// =====================================
// 사망 처리
// =====================================
if (hp <= 0 && !is_dead)
{
    hp = 0;
    is_dead = true;
    state = "dying";

    sprite_index = spr_necro_death;
    image_index = 0;
    image_speed = 8 / room_speed;

    death_anim_timer = max(
        1, ceil(image_number / image_speed)
    );

    // 소환된 해골 제거
    with (obj_skeleton)
    {
        if (boss_id == other.id) instance_destroy();
    }

    with (obj_skeleton_archer)
    {
        if (boss_id == other.id) instance_destroy();
    }

    with (obj_skeleton_knight)
    {
        if (boss_id == other.id) instance_destroy();
    }
}

// =====================================
// 네크로맨서 사망 → 승리
// =====================================

if (state == "dying")
{
    death_anim_timer--;

    if (death_anim_timer <= 0)
    {
        // 승리 화면 중복 생성 방지
        if (!instance_exists(obj_victory))
        {
            instance_create_depth(
                x, y,
                -10000,
                obj_victory
            );
        }

        instance_destroy();
    }

    exit;
}

// =====================================
// 타이머
// =====================================
if (attack_timer > 0) attack_timer--;
if (summon_timer > 0) summon_timer--;

if (phase == 2 && magic_timer > 0)
{
    magic_timer--;
}

if (hp_bar_timer > 0) hp_bar_timer--;

// =====================================
// 2페이즈 전환
// =====================================
if (phase == 1 && hp <= max_hp * 0.5)
{
    phase = 2;
    magic_timer = magic_cooldown;
}

// =====================================
// 피격 애니메이션
// =====================================
if (hit_anim_timer > 0)
{
    hit_anim_timer--;

    if (sprite_index != spr_necro_hit)
    {
        sprite_index = spr_necro_hit;
        image_index = 0;
        image_speed = 0.25;
    }

    if (hit_anim_timer <= 0)
    {
        state = "idle";
        sprite_index = spr_necro_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// =====================================
// 넉백
// =====================================
if (knockback_timer > 0)
{
    x += knockback_x * knockback_speed;
    y += knockback_y * knockback_speed;
    knockback_timer--;
    exit;
}

// =====================================
// 플레이어 확인
// =====================================
if (pl == noone || pl.is_dead || pl.hp <= 0)
{
    state = "idle";
    sprite_index = spr_necro_idle;
    image_speed = 0.15;
    exit;
}

var dist = point_distance(x, y, pl.x, pl.y);
var dir = point_direction(x, y, pl.x, pl.y);

image_xscale = (pl.x < x) ? -1 : 1;

// =====================================
// 스킬 애니메이션 진행
// =====================================
if (state == "summon")
{
    if (image_index >= image_number - 1)
    {
        state = "idle";
        sprite_index = spr_necro_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// =====================================
// 해골 소환 (12초)
// =====================================
if (summon_timer <= 0 && dist <= detect_range)
{
    state = "summon";
    sprite_index = spr_necro_summon;
    image_index = 0;
    image_speed = 8 / room_speed;

    for (var i = 0; i < summon_count; i++)
    {
        var angle = irandom(359);
        var radius = irandom_range(70, 130);

        var sx = x + lengthdir_x(radius, angle);
        var sy = y + lengthdir_y(radius, angle);

        var circle = instance_create_depth(
            sx, sy, depth - 1, obj_magic_circle
        );

        circle.circle_type = "summon";
        circle.boss_id = id;
        circle.summon_type = irandom(2);
    }

    summon_timer = summon_cooldown;
    exit;
}

// =====================================
// 마법 폭발 (2페이즈, 8초)
// =====================================
if (phase == 2 &&
    magic_timer <= 0 &&
    dist <= detect_range)
{
    state = "summon";
    sprite_index = spr_necro_summon;
    image_index = 0;
    image_speed = 8 / room_speed;

    for (var j = 0; j < magic_count; j++)
    {
        var mx = pl.x + irandom_range(-110, 110);
        var my = pl.y + irandom_range(-110, 110);

        var magic = instance_create_depth(
            mx, my, depth - 1, obj_magic_circle
        );

        magic.circle_type = "explosion";
        magic.boss_id = id;
    }

    magic_timer = magic_cooldown;
    exit;
}

// =====================================
// 근접 공격 애니메이션
// =====================================
if (state == "attack")
{
    attack_frame += attack_anim_speed;

    var frames = sprite_get_number(spr_necro_attack);
    image_index = min(frames - 1, floor(attack_frame));

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
        attack_timer = attack_cooldown;

        sprite_index = spr_necro_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// =====================================
// 플레이어 추적 및 근접 공격
// =====================================
if (dist > detect_range)
{
    state = "idle";

    if (sprite_index != spr_necro_idle)
    {
        sprite_index = spr_necro_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

if (dist <= attack_range && attack_timer <= 0)
{
    state = "attack";
    attack_frame = 0;
    attack_hit_done = false;

    sprite_index = spr_necro_attack;
    image_index = 0;
    image_speed = 0;
    exit;
}

if (dist > attack_range)
{
    state = "chase";

    if (sprite_index != spr_necro_walk)
    {
        sprite_index = spr_necro_walk;
        image_index = 0;
        image_speed = 0.15;
    }

    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
}
else
{
    state = "idle";

    if (sprite_index != spr_necro_idle)
    {
        sprite_index = spr_necro_idle;
        image_index = 0;
        image_speed = 0.15;
    }
}