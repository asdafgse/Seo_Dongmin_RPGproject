// =====================================
// 일시정지
// =====================================
var pm = instance_find(obj_pause_menu, 0);

if (pm != noone && pm.menu_open)
{
    image_speed = 0;
    exit;
}

var pl = instance_find(obj_player, 0);

if (pl != noone && pl.inventory_open)
{
    image_speed = 0;
    exit;
}

image_speed = 8 / room_speed;

// =====================================
// 보스 사망 확인
// =====================================
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

// =====================================
// 폭발 데미지 (한 번만)
// =====================================
if (!damage_done)
{
    damage_done = true;

    if (pl != noone)
    {
        var dist = point_distance(
            x, y, pl.x, pl.y
        );

        if (dist <= damage_radius
            && !pl.is_dead
            && pl.hp > 0
            && !pl.is_invincible)
        {
            var block_chance = min(
                50, pl.defense * 5
            );

            if (irandom(99) >= block_chance)
            {
                pl.hp = max(0, pl.hp - damage);

                // 넉백
                var dir = point_direction(
                    x, y, pl.x, pl.y
                );

                pl.knockback_x = lengthdir_x(1, dir);
                pl.knockback_y = lengthdir_y(1, dir);
                pl.knockback_timer = 8;
            }
        }
    }
}

// =====================================
// 폭발 애니메이션 종료
// =====================================
life_timer--;

if (life_timer <= 0)
{
    instance_destroy();
}