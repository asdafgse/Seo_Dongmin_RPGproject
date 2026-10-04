// =====================================================
// QUIT 버튼
// =====================================================

// 버튼
draw_self();

// 버튼이 어느 정도 나타난 후에만 글씨 표시
if (image_xscale > 0.5)
{
    var text_y = y;

    // Hover 시 글씨만 아래로
    if (image_index >= 1)
    {
        text_y = y + 5;
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(x, text_y, "QUIT");
}

// Draw 설정 복구
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);