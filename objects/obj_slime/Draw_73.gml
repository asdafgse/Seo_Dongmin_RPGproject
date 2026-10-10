// obj_slime -> Draw End (새 이벤트)
// 기존 슬라임 본체는 GameMaker가 자동으로 그립니다.
// 공격2의 5번째 프레임부터 5프레임 이펙트를 본체 위에 겹쳐 그립니다.
if (state == "night_attack2" && attack_frame >= 4 && attack_frame < 9)
{
    var effect_frame = clamp(floor(attack_frame) - 4, 0, 4);
    // 이펙트 스프라이트 Origin: Middle Center 권장
    // 기본 이미지가 오른쪽을 향한다는 가정
    var offset_x = 28 * attack_facing;
    draw_sprite_ext(spr_slime_night_attack_effect, effect_frame,
        x + offset_x, y, attack_facing, 1, 0, c_white, 1);
}
