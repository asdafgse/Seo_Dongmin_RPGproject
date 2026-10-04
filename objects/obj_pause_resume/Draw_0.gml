if (visible)
{
    draw_self();

    var text_y = y;

    // Hover Frame일 때 글씨도 살짝 아래로
    if (image_index >= 1)
    {
        text_y = y + 5;
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(
        x,
        text_y,
        "RESUME"
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}