/// obj_orc_hide - Step

// ==========================================
// 사라지는 시간
// ==========================================

life--;

if (life <= 0)
{
    instance_destroy();
    exit;
}

// ==========================================
// 플레이어 찾기
// ==========================================

var player = instance_nearest(x, y, obj_player);

// ==========================================
// 플레이어가 가까우면 자동 획득
// ==========================================

if (player != noone)
{
    var dist = point_distance(
        x, y,
        player.x, player.y
    );

    if (dist <= 20)
    {
        // 오크 가죽 획득
        if (!variable_instance_exists(player, "orc_hide"))
        {
            player.orc_hide = 0;
        }

        player.orc_hide += 1;

        // 아이템 획득 효과음
        audio_play_sound(
            snd_item_pickup,
            1,
            false
        );

        show_debug_message("Orc Hide +1");

        instance_destroy();
    }
}