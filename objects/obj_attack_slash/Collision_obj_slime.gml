// ========================
// 플레이어 찾기
// ========================

var player = instance_nearest(
    x,
    y,
    obj_player
);


// ========================
// 슬라임 데미지
// ========================

if (player != noone)
{
    other.hp -= player.attack_damage;

    other.hit_flash_timer = 8;

    // 슬라임 피격 효과음
    audio_play_sound(
        snd_slime_hit,
        1,
        false
    );


    // ========================
    // 슬라임 넉백
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


// =====================================================
// 슬라임 사망
// =====================================================

if (other.hp <= 0)
{
    var drop_x = other.x;
    var drop_y = other.y;

    // ========================
    // 슬라임 사망 효과음
    // ========================

    audio_play_sound(
        snd_slime_death,
        1,
        false
    );

    // ========================
    // Slime Gel - 70%
    // ========================

    if (irandom(99) < 70)
    {
        instance_create_layer(
            drop_x - 12,
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


    // ========================
    // Gold - 40%
    // ========================

    if (irandom(99) < 40)
    {
        instance_create_layer(
            drop_x,
            drop_y + 12,
            layer,
            obj_gold
        );
    }


    // ========================
    // 슬라임 제거
    // ========================

    instance_destroy(other);
}


// ========================
// 검 공격 제거
// ========================

instance_destroy();