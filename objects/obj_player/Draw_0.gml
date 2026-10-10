// 기존 플레이어 표시
draw_self();

// 포션 사용 중 힐 이펙트 표시
if (is_drinking_potion)
{
    var heal_frame = min(
        floor((potion_time - potion_timer) * 0.25),
        3
    );

    draw_sprite(
        spr_player_heal,
        heal_frame,
        x,
        y
    );
}