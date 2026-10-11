/// obj_bat_spawner - Step

// ========================
// 박쥐가 살아있는지 확인
// ========================

if (!instance_exists(bat_instance))
{
    // 리스폰 타이머 증가
    respawn_timer++;


    // ========================
    // 5초 지나면 다시 생성
    // ========================

    if (respawn_timer >= respawn_time)
    {
        bat_instance = instance_create_layer(
            x,
            y,
            "Instances",
            obj_bat
        );

        respawn_timer = 0;
    }
}
else
{
    // 박쥐가 살아있으면 타이머 초기화
    respawn_timer = 0;
}