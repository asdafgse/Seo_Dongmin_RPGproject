// ========================
// 슬라임 스프라이트 그리기
// ========================

draw_self();


// ========================
// 체력바 설정
// ========================

var bar_w = 32;
var bar_h = 5;

var bar_x = x - bar_w / 2;
var bar_y = y - 24;

var hp_percent = hp / max_hp;


// ========================
// 체력바 배경
// ========================

draw_set_color(c_black);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    false
);


// ========================
// 현재 HP
// ========================

draw_set_color(c_red);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + (bar_w * hp_percent),
    bar_y + bar_h,
    false
);


// ========================
// 체력바 테두리
// ========================

draw_set_color(c_white);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    true
);


// 색상 초기화
draw_set_color(c_white);