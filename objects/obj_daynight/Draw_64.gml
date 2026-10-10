// =====================================
// 낮 / 밤 점진적 어둠 효과
// =====================================

// 밤 최대 어둠: 50%
var max_darkness = 0.5;
var darkness = 0;

// 낮
if (is_day)
{
    var progress = 1 - (day_timer / day_length);
    progress = clamp(progress, 0, 1);

    // 낮의 마지막 30%부터 어두워짐
    if (progress >= 0.7)
    {
        darkness = max_darkness
                 * ((progress - 0.7) / 0.3);
    }
}
// 밤
else
{
    var progress = 1 - (day_timer / night_length);
    progress = clamp(progress, 0, 1);

    // 밤의 마지막 30%부터 밝아짐
    if (progress < 0.7)
    {
        darkness = max_darkness;
    }
    else
    {
        darkness = max_darkness
                 * (1 - (progress - 0.7) / 0.3);
    }
}

// =====================================
// 화면에 어둠 적용
// =====================================

if (darkness > 0)
{
    draw_set_alpha(darkness);
    draw_set_color(c_black);

    draw_rectangle(
        0,
        0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );
}

draw_set_alpha(1);
draw_set_color(c_white);