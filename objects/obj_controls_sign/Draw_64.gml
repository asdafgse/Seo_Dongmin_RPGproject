/// obj_controls_sign - Draw GUI

var pl = instance_find(obj_player, 0);
if (pl == noone || pl.is_dead) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var nearby = point_distance(x, y, pl.x, pl.y) <= read_distance;

// =====================================
// [E] Read 말풍선
// =====================================

if (nearby && !sign_open && !pl.dialogue_open)
{
    var cam = view_camera[0];

    var sx = (x - camera_get_view_x(cam))
           * gw / camera_get_view_width(cam);

    var sy = (y - camera_get_view_y(cam))
           * gh / camera_get_view_height(cam);

    var bubble_scale = 0.65;
    var bubble_x = sx;
    var bubble_y = sy - 40;

    draw_sprite_ext(
        spr_npc_bubble, 0,
        bubble_x, bubble_y,
        bubble_scale, bubble_scale,
        0, c_white, 1
    );

    draw_set_font(fnt_npc);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);

    draw_text(bubble_x, bubble_y - 8, "[E] Read");
}

// =====================================
// HOW TO PLAY 안내창
// =====================================

if (sign_open)
{
    // 화면 어둡게
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    // 안내창 크기
    var box_w = min(360, gw - 24);
    var box_h = min(310, gh - 24);

    var bx = (gw - box_w) / 2;
    var by = (gh - box_h) / 2;
    var cx = gw / 2;

    // 갈색 배경
    draw_set_color(make_color_rgb(75, 49, 31));
    draw_rectangle(
        bx, by,
        bx + box_w, by + box_h,
        false
    );

    // 테두리
    draw_set_color(make_color_rgb(180, 130, 70));
    draw_rectangle(
        bx + 4, by + 4,
        bx + box_w - 4, by + box_h - 4,
        true
    );

    // 텍스트 설정
    draw_set_font(fnt_npc);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // 제목
    draw_set_color(make_color_rgb(255, 220, 140));
    draw_text(cx, by + 32, "HOW TO PLAY");

    // 조작법
    draw_set_color(c_white);

    draw_text(cx, by + 78,  "Arrow Keys - Move");
    draw_text(cx, by + 108, "Z - Attack");
    draw_text(cx, by + 138, "X - Dodge");
    draw_text(cx, by + 168, "ESC - Pause");
    draw_text(cx, by + 198, "R - Revive");

    // 게임 목표
    draw_set_color(make_color_rgb(255, 220, 140));
    draw_text(cx, by + 238, "Defeat the Necromancer!");

    // 닫기
    draw_set_color(c_white);
    draw_text(cx, by + 280, "[E] Close");
}

// =====================================
// Draw 설정 초기화
// =====================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);