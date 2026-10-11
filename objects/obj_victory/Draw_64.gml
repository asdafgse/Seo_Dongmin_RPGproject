// =====================================
// VICTORY SCREEN
// =====================================

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 화면 어둡게
draw_set_alpha(0.7);
draw_set_color(c_black);

draw_rectangle(
    0, 0,
    gui_w, gui_h,
    false
);

// 설정 복구
draw_set_alpha(1);
draw_set_color(c_white);

// 승리 스프라이트
var victory_w = 550;
var victory_h = 300;

draw_sprite_stretched(
    spr_victory,
    0,
    (gui_w - victory_w) / 2,
    (gui_h - victory_h) / 2,
    victory_w,
    victory_h
);