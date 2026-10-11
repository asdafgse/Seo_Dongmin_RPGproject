// obj_skeleton - Step
// 일시정지 및 인벤토리
var pause_menu = instance_find(obj_pause_menu, 0);
if (pause_menu != noone)
{
    if (pause_menu.menu_open || keyboard_check_pressed(vk_escape)) exit;
}
var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

if (hp_bar_timer > 0) hp_bar_timer--;

// 보스 소환수는 보스가 사라지면 제거
if (boss_id != noone)
{
    if (!instance_exists(boss_id)) { instance_destroy(); exit; }
    if (variable_instance_exists(boss_id, "is_dead") && boss_id.is_dead)
    { instance_destroy(); exit; }
}

// 사망 시작
if (hp <= 0 && state != "dying")
{
    state = "dying";
    is_dead = true;
    sprite_index = spr_skeleton_death;
    image_index = 0;
    image_speed = 8 / room_speed;
    death_anim_timer = max(1, ceil(sprite_get_number(spr_skeleton_death) / image_speed));
}
if (state == "dying")
{
    death_anim_timer--;
    if (death_anim_timer <= 0) instance_destroy();
    exit;
}

// 소환 애니메이션 동안 행동 불가
if (state == "summon")
{
    if (image_index >= sprite_get_number(spr_skeleton_summon) - 1)
    {
        state = "idle";
        sprite_index = spr_skeleton_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 피격 애니메이션
if (hit_anim_timer > 0)
{
    if (sprite_index != spr_skeleton_hit)
    {
        sprite_index = spr_skeleton_hit;
        image_index = 0;
        image_speed = 0.25;
    }
    hit_anim_timer--;
    if (hit_anim_timer <= 0)
    {
        state = "idle";
        sprite_index = spr_skeleton_idle;
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

// 피격 플래시
image_blend = c_white;
if (hit_flash_timer > 0)
{
    hit_flash_timer--;
    image_blend = c_red;
}

if (attack_cooldown > 0) attack_cooldown--;

// 공격 중: 공격 애니메이션 프레임에 맞춰 한 번만 판정
if (state == "attack")
{
    attack_frame += attack_anim_speed;
    var frames = sprite_get_number(spr_skeleton_attack);
    image_index = min(frames - 1, floor(attack_frame));

    if (!attack_hit_done && attack_frame >= max(1, floor(frames / 2)))
    {
        attack_hit_done = true;
        if (pl != noone && !pl.is_dead && pl.hp > 0 && !pl.is_invincible)
        {
            if (point_distance(x, y, pl.x, pl.y) <= attack_range
                && abs(pl.y - y) <= 20
                && ((image_xscale >= 0 && pl.x >= x) || (image_xscale < 0 && pl.x <= x)))
            {
                var block_chance = min(50, pl.defense * 5);
                if (irandom(99) >= block_chance)
                {
                    pl.hp = max(0, pl.hp - attack_damage);
                    var knock_dir = point_direction(x, y, pl.x, pl.y);
                    pl.knockback_x = lengthdir_x(1, knock_dir);
                    pl.knockback_y = lengthdir_y(1, knock_dir);
                    pl.knockback_timer = 6;
                }
            }
        }
    }

    if (attack_frame >= frames)
    {
        state = "idle";
        attack_cooldown = attack_cooldown_max;
        sprite_index = spr_skeleton_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

// 추적 또는 대기
if (pl == noone || pl.is_dead || pl.hp <= 0)
{
    state = "idle";
    if (sprite_index != spr_skeleton_idle)
    {
        sprite_index = spr_skeleton_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

var dist = point_distance(x, y, pl.x, pl.y);
if (dist > detect_range)
{
    state = "idle";
    if (sprite_index != spr_skeleton_idle)
    {
        sprite_index = spr_skeleton_idle;
        image_index = 0;
        image_speed = 0.15;
    }
    exit;
}

image_xscale = (pl.x < x) ? -1 : 1;

if (dist <= attack_range && attack_cooldown <= 0)
{
    state = "attack";
    attack_frame = 0;
    attack_hit_done = false;
    sprite_index = spr_skeleton_attack;
    image_index = 0;
    image_speed = 0; // 공격 프레임은 Step에서 직접 진행
    exit;
}

if (dist > attack_range)
{
    state = "chase";
    if (sprite_index != spr_skeleton_walk)
    {
        sprite_index = spr_skeleton_walk;
        image_index = 0;
        image_speed = 0.15;
    }
    var dir = point_direction(x, y, pl.x, pl.y);
    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
}
else
{
    state = "idle";
    if (sprite_index != spr_skeleton_idle)
    {
        sprite_index = spr_skeleton_idle;
        image_index = 0;
        image_speed = 0.15;
    }
}

