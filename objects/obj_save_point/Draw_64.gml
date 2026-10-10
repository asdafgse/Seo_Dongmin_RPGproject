/// Priest Speech Bubble - Draw GUI

var pl = instance_find(obj_player, 0);
if (pl == noone) exit;
if (pl.is_dead) exit;

// 카메라 및 GUI 크기
var cam = view_camera[0];

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var sx = (x - camera_get_view_x(cam))
       * gw / camera_get_view_width(cam);

var sy = (y - camera_get_view_y(cam))
       * gh / camera_get_view_height(cam);

// 프리스트와 플레이어 거리
var nearby = point_distance(
    x, y,
    pl.x, pl.y
) <= interact_range;

// 대화 상태
var open_now = priest_dialogue_open;

if (!nearby && !open_now) exit;

// 말풍선 크기
var scale_x = open_now ? 1.3 : 0.65;
var scale_y = open_now ? 1.3 : 0.65;

var bw = sprite_get_width(spr_npc_bubble) * scale_x;
var bh = sprite_get_height(spr_npc_bubble) * scale_y;

// 프리스트 머리 위 위치
var bx = clamp(
    sx,
    bw / 2 + 4,
    gw - bw / 2 - 4
);

var by = clamp(
    sy - 55 - bh / 2,
    bh / 2 + 4,
    gh - bh / 2 - 4
);

// 스프라이트 원점 보정
var ox = sprite_get_xoffset(spr_npc_bubble);
var oy = sprite_get_yoffset(spr_npc_bubble);

var draw_x = bx
    + (ox - sprite_get_width(spr_npc_bubble) / 2) * scale_x;

var draw_y = by
    + (oy - sprite_get_height(spr_npc_bubble) / 2) * scale_y;

// 말풍선 스프라이트 출력
draw_sprite_ext(
    spr_npc_bubble,
    0,
    draw_x,
    draw_y,
    scale_x,
    scale_y,
    0,
    c_white,
    1
);

// NPC 전용 폰트
draw_set_font(fnt_npc);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);

if (open_now)
{
    // NPC 이름
    draw_text(
        bx,
        by - 28,
        "Priest"
    );

    // 프리스트 대사
    draw_text(
        bx,
        by - 9,
        "May the light guide you."
    );

    // 회복 및 세이브
    draw_text(
        bx,
        by + 12,
        "[F] Pray & Save"
    );
}
else
{
    draw_text(
        bx,
        by - 5,
        "[E] Talk"
    );
}

// Draw 설정 복구
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);