/// obj_slime - Draw End

// 밤 공격2 이펙트 유지
if (state == "night_attack2" && attack_frame >= 4 && attack_frame < 9)
{
    var effect_frame = clamp(floor(attack_frame) - 4, 0, 4);

    var offset_x = 28 * attack_facing;

    draw_sprite_ext(
        spr_slime_night_attack_effect,
        effect_frame,
        x + offset_x,
        y,
        attack_facing,
        1,
        0,
        c_white,
        1
    );
}