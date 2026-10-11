/// obj_orc_spawner - Create

// ========================
// 리스폰 설정
// ========================

respawn_time = room_speed * 5;
respawn_timer = 0;

orc_instance = noone;


// ========================
// 처음 오크 생성
// ========================

orc_instance = instance_create_layer(
    x,
    y,
    "Instances",
    obj_orc
);