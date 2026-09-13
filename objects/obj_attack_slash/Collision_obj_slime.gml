// ========================
// 플레이어 찾기
// ========================

var player = instance_nearest(
    x,
    y,
    obj_player
);


// ========================
// 플레이어가 있을 때
// ========================

if (player != noone)
{
    // ========================
    // 슬라임 데미지
    // ========================

    other.hp -= player.attack_damage;


    // ========================
    // 피격 효과
    // ========================

    other.hit_flash_timer = 8;


    // ========================
    // 슬라임 넉백 방향
    // 플레이어 -> 슬라임 방향
    // ========================

    var knock_dir = point_direction(
        player.x,
        player.y,
        other.x,
        other.y
    );


    other.knockback_x =
        lengthdir_x(
            1,
            knock_dir
        );

    other.knockback_y =
        lengthdir_y(
            1,
            knock_dir
        );


    other.knockback_timer = 5;


    show_debug_message(
        "Slime HP: "
        + string(other.hp)
    );
}


// ========================
// 슬라임 사망
// ========================

if (other.hp <= 0)
{
    var drop_x = other.x;
    var drop_y = other.y;


    // ========================
    // Slime Gel - 70%
    // ========================

    if (irandom(99) < 70)
    {
        instance_create_layer(
            drop_x,
            drop_y,
            layer,
            obj_slime_gel
        );
    }


    // ========================
    // Health Potion - 30%
    // ========================

    if (irandom(99) < 30)
    {
        instance_create_layer(
            drop_x + 12,
            drop_y,
            layer,
            obj_health_potion
        );
    }


    instance_destroy(other);
}


// ========================
// Slash 제거
// ========================

instance_destroy();