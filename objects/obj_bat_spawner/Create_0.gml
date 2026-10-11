// ========================
// 리스폰 설정
// ========================

respawn_time = room_speed * 5;
respawn_timer = 0;

bat_instance = noone;


// ========================
// 처음 박쥐 생성
// ========================

bat_instance = instance_create_layer(
    x,
    y,
    "Instances",
    obj_bat
);