/// obj_boss_portal - Draw GUI

if (message_timer > 0)
{
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    draw_set_font(fnt_npc);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_black);
    draw_set_alpha(0.8);

    draw_rectangle(
        gw / 2 - 240,
        gh - 130,
        gw / 2 + 240,
        gh - 40,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_text(
        gw / 2,
        gh - 85,
        portal_message
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}