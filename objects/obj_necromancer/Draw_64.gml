// ==========================================
// NECROMANCER BOSS HP BAR
// ==========================================

if (is_dead || hp <= 0) exit;

// GUI 크기
var gui_w = display_get_gui_width();

// 프레임 크기
var frame_w = 440;
var frame_h = 110;

// 프레임 중앙 위치
var cx = gui_w / 2;
var cy = 65;

// HP 비율
var hp_ratio = clamp(hp / max_hp, 0, 1);

// ==========================================
// HP 바 위치 (위로 이동)
// ==========================================

var bar_x = cx - 185;
var bar_y = cy - 4;  // 기존 +5에서 -4로 변경
var bar_w = 370;
var bar_h = 20;

// ==========================================
// 1. 검은색 HP 배경 (뒤쪽)
// ==========================================

draw_set_alpha(1);
draw_set_color(make_color_rgb(25, 20, 30));

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    false
);

// ==========================================
// 2. 현재 HP (뒤쪽)
// ==========================================

if (phase == 1)
{
    draw_set_color(make_color_rgb(205, 35, 60));
}
else
{
    draw_set_color(make_color_rgb(155, 55, 215));
}

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w * hp_ratio,
    bar_y + bar_h,
    false
);

// ==========================================
// 3. HP 하이라이트
// ==========================================

if (hp_ratio > 0)
{
    if (phase == 1)
        draw_set_color(make_color_rgb(245, 90, 110));
    else
        draw_set_color(make_color_rgb(195, 110, 255));

    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + bar_w * hp_ratio,
        bar_y + 3,
        false
    );
}

// ==========================================
// 4. 테두리 스프라이트 (가장 앞쪽)
// ==========================================

draw_set_color(c_white);

draw_sprite_stretched(
    spr_boss_hp_frame,
    0,
    cx - frame_w / 2,
    cy - frame_h / 2,
    frame_w,
    frame_h
);

// ==========================================
// Draw 설정 복구
// ==========================================

draw_set_color(c_white);
draw_set_alpha(1);