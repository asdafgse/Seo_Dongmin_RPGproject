/// obj_orc_spawner - Step

// ========================
// 오크가 살아있는지 확인
// ========================

if (!instance_exists(orc_instance))
{
    // 리스폰 타이머 시작
    respawn_timer++;


    // ========================
    // 5초 후 다시 생성
    // ========================

    if (respawn_timer >= respawn_time)
    {
        orc_instance = instance_create_layer(
            x,
            y,
            "Instances",
            obj_orc
        );

        respawn_timer = 0;
    }
}
else
{
    // 살아있으면 타이머 초기화
    respawn_timer = 0;
}