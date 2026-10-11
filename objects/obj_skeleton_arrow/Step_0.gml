// 일시정지
var pm = instance_find(obj_pause_menu, 0);

if (pm != noone && pm.menu_open)
{
    exit;
}

var pl = instance_find(obj_player, 0);

if (pl != noone && pl.inventory_open)
{
    exit;
}

// 화살 수명
life_timer--;

if (life_timer <= 0)
{
    instance_destroy();
    exit;
}

// 화살 회전
image_angle = direction;

// 플레이어 충돌
if (pl != noone)
{
    if (pl.hp > 0 && !pl.is_dead)
    {
        if (place_meeting(x, y, obj_player))
        {
            if (!pl.is_invincible)
            {
                var block_chance = min(50, pl.defense * 5);

                if (irandom(99) >= block_chance)
                {
                    pl.hp = max(0, pl.hp - damage);

                    var dir = point_direction(
                        x, y, pl.x, pl.y
                    );

                    pl.knockback_x = lengthdir_x(1, dir);
                    pl.knockback_y = lengthdir_y(1, dir);
                    pl.knockback_timer = 6;
                }
            }

            instance_destroy();
            exit;
        }
    }
}