life--;

if (life <= 0)
{
    instance_destroy();
}


// ========================
// 플레이어 획득
// ========================

var player = instance_nearest(x, y, obj_player);

if (player != noone)
{
    var dist = point_distance(x, y, player.x, player.y);

    if (dist <= 20)
    {
        player.health_potion += 1;

        show_debug_message(
            "Health Potion: " + string(player.health_potion)
        );

        instance_destroy();
    }
}