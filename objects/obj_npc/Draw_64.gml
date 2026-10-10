/// obj_npc - Draw GUI : Wizard speech bubble
var pl = instance_find(obj_player, 0);
if (pl == noone) exit;
if (pl.is_dead) exit;

var cam = view_camera[0];
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var sx = (x - camera_get_view_x(cam)) * gw / camera_get_view_width(cam);
var sy = (y - camera_get_view_y(cam)) * gh / camera_get_view_height(cam);
var nearby = point_distance(x, y, pl.x, pl.y) <= 50;
var open_now = pl.dialogue_open && instance_nearest(pl.x, pl.y, obj_npc) == id;
if (!nearby && !open_now) exit;

var scale_x = open_now ? 1.3 : 0.65;
var scale_y = open_now ? 1.3 : 0.65;
var bw = sprite_get_width(spr_npc_bubble) * scale_x;
var bh = sprite_get_height(spr_npc_bubble) * scale_y;
var bx = clamp(sx, bw * 0.5 + 4, gw - bw * 0.5 - 4);
var by = clamp(sy - 55 - bh * 0.5, bh * 0.5 + 4, gh - bh * 0.5 - 4);
var dx = bx + (sprite_get_xoffset(spr_npc_bubble) - sprite_get_width(spr_npc_bubble) * 0.5) * scale_x;
var dy = by + (sprite_get_yoffset(spr_npc_bubble) - sprite_get_height(spr_npc_bubble) * 0.5) * scale_y;

draw_sprite_ext(spr_npc_bubble, 0, dx, dy, scale_x, scale_y, 0, c_white, 1);
draw_set_font(fnt_npc);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (open_now)
{
    draw_text(bx, by - 34, "Wizard");
    draw_text(bx, by - 16, pl.dialogue_text);
    draw_text(bx, by + 3, "[F] Sell +5G   [B] Potion 10G");
    draw_text(bx, by + 21, "[U] Upgrade " + string(pl.upgrade_cost) + "G   [E] Leave");
}
else
{
    draw_text(bx, by - 5, "[E] Talk");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
