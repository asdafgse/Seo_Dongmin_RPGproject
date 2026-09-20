// ========================
// 광폭화 변신 애니메이션 종료
// ========================

if (is_transforming)
{
    is_transforming = false;
    is_enraged = true;

    sprite_index = spr_slime_night;

    image_index = 0;
    image_speed = 1;

    state = "idle";
}