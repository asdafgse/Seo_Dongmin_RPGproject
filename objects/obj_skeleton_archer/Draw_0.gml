
draw_self();

// 체력바 표시 시간 감소
if (hp_bar_timer > 0)
{
    hp_bar_timer--;
}

// 체력바
if (hp_bar_timer > 0 && hp > 0)
{
    var bar_width = 40;
    var bar_height = 5;

    var bar_x = x - bar_width / 2;
    var bar_y = y - 30;

    var hp_ratio = clamp(hp / max_hp, 0, 1);

    draw_set_color(c_black);
    draw_rectangle(
        bar_x - 1,
        bar_y - 1,
        bar_x + bar_width + 1,
        bar_y + bar_height + 1,
        false
    );

    draw_set_color(c_dkgray);
    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + bar_width,
        bar_y + bar_height,
        false
    );

    draw_set_color(c_red);
    draw_rectangle(
        bar_x,
        bar_y,
        bar_x + bar_width * hp_ratio,
        bar_y + bar_height,
        false
    );

    draw_set_color(c_white);
}