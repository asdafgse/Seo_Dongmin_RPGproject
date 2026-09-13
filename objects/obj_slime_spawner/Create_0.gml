// ========================
// 리스폰 설정
// ========================

respawn_time = room_speed * 5;
respawn_timer = 0;

slime_instance = noone;


// ========================
// 처음 슬라임 생성
// ========================

slime_instance = instance_create_layer(
    x,
    y,
    "Instances",
    obj_slime
);