// =====================================================
// 낮 / 밤 시계 HUD
// =====================================================

var gui_w = display_get_gui_width();

var clock_x = gui_w / 2;
var clock_y = 50;

// 시계 크기
var clock_radius = 28;


// =====================================================
// 시간 진행도
// 0 = 시작
// 1 = 낮/밤 끝
// =====================================================

var progress = 1 - (day_timer / day_length);

progress = clamp(
    progress,
    0,
    1
);


// =====================================================
// 시계 바깥 배경
// =====================================================

draw_set_color(c_black);

draw_circle(
    clock_x,
    clock_y,
    clock_radius + 3,
    false
);


// =====================================================
// 낮 / 밤 시계 배경
// =====================================================

if (is_day)
{
    // 낮 = 노란색
    draw_set_color(c_yellow);
}
else
{
    // 밤 = 어두운 회색
    draw_set_color(c_dkgray);
}

draw_circle(
    clock_x,
    clock_y,
    clock_radius,
    false
);


// =====================================================
// 시계 테두리
// =====================================================

draw_set_color(c_white);

draw_circle(
    clock_x,
    clock_y,
    clock_radius,
    true
);


// =====================================================
// 시계 눈금
// =====================================================

if (is_day)
{
    draw_set_color(c_black);
}
else
{
    draw_set_color(c_white);
}

for (var i = 0; i < 12; i++)
{
    var angle = i * 30 - 90;

    var x1 =
        clock_x
        + lengthdir_x(
            clock_radius - 5,
            angle
        );

    var y1 =
        clock_y
        + lengthdir_y(
            clock_radius - 5,
            angle
        );

    var x2 =
        clock_x
        + lengthdir_x(
            clock_radius - 1,
            angle
        );

    var y2 =
        clock_y
        + lengthdir_y(
            clock_radius - 1,
            angle
        );

    draw_line(
        x1,
        y1,
        x2,
        y2
    );
}


// =====================================================
// 움직이는 시계 바늘
// =====================================================

// 시계 방향으로 한 바퀴
var hand_angle =
    -90 - (progress * 360);

var hand_length =
    clock_radius - 8;

var hand_x =
    clock_x
    + lengthdir_x(
        hand_length,
        hand_angle
    );

var hand_y =
    clock_y
    + lengthdir_y(
        hand_length,
        hand_angle
    );


// 낮 = 검은색 바늘
// 밤 = 흰색 바늘

if (is_day)
{
    draw_set_color(c_black);
}
else
{
    draw_set_color(c_white);
}

draw_line_width(
    clock_x,
    clock_y,
    hand_x,
    hand_y,
    2
);


// =====================================================
// 가운데 점
// =====================================================

draw_circle(
    clock_x,
    clock_y,
    3,
    false
);


// =====================================================
// Draw 설정 초기화
// =====================================================

draw_set_color(c_white);

// =====================================================
// 밤 화면 어둡게
// =====================================================

if (!is_day)
{
    draw_set_alpha(0.35);
    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);
}