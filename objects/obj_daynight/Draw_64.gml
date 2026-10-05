// =====================================================
// 화면 어둡게
// Frame 2 = 16:00일 때만 어두움
// =====================================================

var progress = 1 - (day_timer / day_length);
progress = clamp(progress, 0, 1);

// 16:00 구간
if (progress >= 0.66)
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