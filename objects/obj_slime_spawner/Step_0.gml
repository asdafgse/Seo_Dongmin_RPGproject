// ========================
// 슬라임이 살아있는지 확인
// ========================

if (!instance_exists(slime_instance))
{
    // 타이머 시작
    respawn_timer++;


    // ========================
    // 5초 지나면 다시 생성
    // ========================

    if (respawn_timer >= respawn_time)
    {
        slime_instance = instance_create_layer(
            x,
            y,
            "Instances",
            obj_slime
        );

        respawn_timer = 0;
    }
}
else
{
    // 살아있으면 타이머 초기화
    respawn_timer = 0;
}