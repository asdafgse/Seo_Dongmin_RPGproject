if (!dialogue_open) exit;

var pl = instance_nearest(x, y, obj_player);
if (pl == noone) exit;

var cam = view_camera[0];

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);

var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var bx = (x - cam_x) * gui_w / cam_w;
var by = (y - cam_y - 65) * gui_h / cam_h;

var bubble_w = 330;
var bubble_h = 100;

draw_sprite_stretched(
    spr_npc_bubble,
    0,
    bx - bubble_w / 2,
    by - bubble_h / 2,
    bubble_w,
    bubble_h
);

draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text_transformed(
    bx,
    by,
    dialogue_text,
    0.75,
    0.75,
    0
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);