// =====================================================
// 사라지는 시간
// =====================================================

life--;

if (life <= 0)
{
    instance_destroy();
    exit;
}


// =====================================================
// 플레이어 찾기
// =====================================================

var player = instance_nearest(
    x,
    y,
    obj_player
);


// =====================================================
// 플레이어가 가까우면 획득
// =====================================================

if (player != noone)
{
    var dist = point_distance(
        x,
        y,
        player.x,
        player.y
    );

    if (dist <= 20)
    {
        // Health Potion 획득
        player.health_potion += 1;


        // 전리품 획득 효과음
        audio_play_sound(
            snd_item_pickup,
            1,
            false
        );


        show_debug_message(
            "Health Potion +1"
        );


        instance_destroy();
    }
}