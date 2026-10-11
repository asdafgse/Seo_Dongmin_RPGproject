/// obj_orc_shockwave - Step

var pm = instance_find(obj_pause_menu, 0);
if (pm != noone && pm.menu_open) exit;

var pl = instance_find(obj_player, 0);
if (pl != noone && pl.inventory_open) exit;

// 충격파 확산
var previous_radius = radius;
radius = min(max_radius, radius + growth_speed);

// 플레이어 충돌 판정
if (!hit_player && pl != noone && !pl.is_dead && pl.hp > 0)
{
    var d = point_distance(x, y, pl.x, pl.y);

    if (d >= max(0, previous_radius - ring_width)
        && d <= radius + ring_width)
    {
        hit_player = true;

        // 구르기 중에는 데미지를 받지 않음
        if (!pl.is_invincible)
        {
            var block_chance = min(50, pl.defense * 5);

            if (irandom(99) >= block_chance)
            {
                pl.hp = max(0, pl.hp - damage);

                var kd = point_direction(
                    x, y, pl.x, pl.y
                );

                pl.knockback_x = lengthdir_x(1, kd);
                pl.knockback_y = lengthdir_y(1, kd);
                pl.knockback_timer = 6;
            }
        }
    }
}

// 최대 범위에 도달하면 제거
if (radius >= max_radius)
{
    instance_destroy();
}