
/// obj_quest_captain - Draw GUI
/// NPC Bubble + Page Dialogue

// =====================================================
// PLAYER CHECK
// =====================================================

var pl = instance_find(obj_player, 0);

if (pl == noone) exit;
if (pl.is_dead) exit;

var dist = point_distance(x, y, pl.x, pl.y);

// 가까이 있거나 대화 중일 때만 표시
if (dist > talk_distance && !dialogue_open) exit;


// =====================================================
// CAMERA TO GUI POSITION
// =====================================================

var cam = view_camera[0];

var cam_x = camera_get_view_x(cam);
var cam_y = camera_get_view_y(cam);
var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// NPC 머리 위에 표시
var bubble_x = (x - cam_x) * gui_w / cam_w;
var bubble_y = (y - 45 - cam_y) * gui_h / cam_h;


// =====================================================
// BUBBLE SIZE
// =====================================================

var bubble_w = 330;
var bubble_h = 100;

// 대화하지 않을 때 작은 말풍선
if (!dialogue_open)
{
    bubble_w = 150;
    bubble_h = 55;
}

// 화면 밖으로 나가지 않게
bubble_x = clamp(
    bubble_x,
    bubble_w / 2 + 5,
    gui_w - bubble_w / 2 - 5
);

bubble_y = clamp(
    bubble_y,
    bubble_h + 5,
    gui_h - 10
);


// =====================================================
// DRAW NPC BUBBLE SPRITE
// =====================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_sprite_stretched(
    spr_npc_bubble,
    0,
    bubble_x - bubble_w / 2,
    bubble_y - bubble_h,
    bubble_w,
    bubble_h
);


// =====================================================
// TEXT SETTINGS
// =====================================================

draw_set_font(fnt_hud);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);


// =====================================================
// DIALOGUE
// =====================================================

if (dialogue_open)
{
    // 현재 대사 한 문장
    var txt = dialogue_pages[dialogue_page];

    // 대사 위치
    var text_x = bubble_x;
    var text_y = bubble_y - 65;

    // 말풍선 너비를 넘지 않도록 텍스트 축소
    var text_scale = 1;
    var available_w = bubble_w - 30;
    var text_w = string_width(txt);

    if (text_w > available_w)
    {
        text_scale = available_w / text_w;
    }

    text_scale = min(1, text_scale);

    // 현재 대사 출력
    draw_text_transformed(
        text_x,
        text_y,
        txt,
        text_scale,
        text_scale,
        0
    );


    // =================================================
    // NEXT / ACCEPT / RECEIVE
    // =================================================

    var next_text = "[E] Next";

    if (dialogue_page == array_length(dialogue_pages) - 1)
    {
        next_text = "[E] Close";

        if (dialogue_action == "accept")
        {
            next_text = "[E] Accept";
        }

        if (dialogue_action == "complete")
        {
            next_text = "[E] Receive";
        }
    }

    // 아래쪽 버튼 안내
    draw_text_transformed(
        bubble_x,
        bubble_y - 30,
        next_text,
        0.7,
        0.7,
        0
    );
}
else
{
    // =================================================
    // E TALK PROMPT
    // =================================================

    draw_text(
        bubble_x,
        bubble_y - bubble_h / 2 - 5,
        "[E] Talk"
    );
}


// =====================================================
// RESTORE DRAW SETTINGS
// =====================================================

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
