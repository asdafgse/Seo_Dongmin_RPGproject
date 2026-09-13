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
        player.slime_gel += 1;

        show_debug_message(
            "Slime Gel: " + string(player.slime_gel)
        );

        instance_destroy();
    }
}