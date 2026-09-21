// =====================================================
// MINI MAP - 플레이어 중심 추적형
// =====================================================

var map_x = 20;
var map_y = 20;

var map_w = 200;
var map_h = 120;


// 미니맵에서 보여주는 실제 게임 범위
var minimap_range_x = 500;
var minimap_range_y = 300;


// 미니맵 중앙
var map_center_x = map_x + map_w / 2;
var map_center_y = map_y + map_h / 2;


// ========================
// 미니맵 배경
// ========================

draw_set_color(c_black);

draw_rectangle(
    map_x,
    map_y,
    map_x + map_w,
    map_y + map_h,
    false
);


// =====================================================
// 슬라임 표시
// =====================================================

var slime_count = instance_number(obj_slime);

for (var i = 0; i < slime_count; i++)
{
    var slime = instance_find(obj_slime, i);

    if (slime != noone)
    {
        // 플레이어 기준 상대 위치
        var relative_x = slime.x - x;
        var relative_y = slime.y - y;


        // 미니맵 좌표로 변환
        var monster_map_x =
            map_center_x
            + (relative_x / minimap_range_x)
            * map_w;

        var monster_map_y =
            map_center_y
            + (relative_y / minimap_range_y)
            * map_h;


        // 미니맵 안에 있을 때만 표시
        if (
            monster_map_x >= map_x
            && monster_map_x <= map_x + map_w
            && monster_map_y >= map_y
            && monster_map_y <= map_y + map_h
        )
        {
            draw_set_color(c_red);

            draw_circle(
                monster_map_x,
                monster_map_y,
                3,
                false
            );
        }
    }
}


// =====================================================
// 상인 NPC 표시
// =====================================================

var npc_count = instance_number(obj_npc);

for (var n = 0; n < npc_count; n++)
{
    var npc_map = instance_find(obj_npc, n);

    if (npc_map != noone)
    {
        // 플레이어 기준 상대 위치
        var npc_relative_x = npc_map.x - x;
        var npc_relative_y = npc_map.y - y;


        // 미니맵 좌표로 변환
        var npc_map_x =
            map_center_x
            + (npc_relative_x / minimap_range_x)
            * map_w;

        var npc_map_y =
            map_center_y
            + (npc_relative_y / minimap_range_y)
            * map_h;


        // 미니맵 안에 있을 때만 표시
        if (
            npc_map_x >= map_x
            && npc_map_x <= map_x + map_w
            && npc_map_y >= map_y
            && npc_map_y <= map_y + map_h
        )
        {
            draw_set_color(c_yellow);

            draw_circle(
                npc_map_x,
                npc_map_y,
                4,
                false
            );
        }
    }
}


// =====================================================
// 플레이어 표시
// 항상 미니맵 중앙
// =====================================================

draw_set_color(c_lime);

draw_circle(
    map_center_x,
    map_center_y,
    4,
    false
);


// ========================
// 미니맵 테두리
// ========================

draw_set_color(c_white);

draw_rectangle(
    map_x,
    map_y,
    map_x + map_w,
    map_y + map_h,
    true
);



// =====================================================
// HP BAR
// =====================================================

var bar_x = 20;
var bar_y = 155;

var bar_w = 200;
var bar_h = 20;

var hp_percent = hp / max_hp;


// HP 바 배경
draw_set_color(c_black);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    false
);


// 현재 HP
draw_set_color(c_red);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + (bar_w * hp_percent),
    bar_y + bar_h,
    false
);


// HP 바 테두리
draw_set_color(c_white);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    true
);



// =====================================================
// GOLD
// =====================================================

draw_set_color(c_yellow);

draw_text(
    20,
    185,
    "Gold: " + string(gold)
);



// =====================================================
// 상인 대화창
// NPC 근처에 표시
// =====================================================

if (dialogue_open && !is_dead)
{
    var shop_npc = instance_nearest(
        x,
        y,
        obj_npc
    );

    if (shop_npc != noone)
    {
        // ========================
        // 카메라 정보
        // ========================

        var shop_cam = view_camera[0];

        var shop_cam_x =
            camera_get_view_x(shop_cam);

        var shop_cam_y =
            camera_get_view_y(shop_cam);

        var shop_cam_w =
            camera_get_view_width(shop_cam);

        var shop_cam_h =
            camera_get_view_height(shop_cam);


        // ========================
        // GUI 크기
        // ========================

        var shop_gui_w =
            display_get_gui_width();

        var shop_gui_h =
            display_get_gui_height();


        // ========================
        // 월드 좌표 → GUI 좌표
        // ========================

        var shop_scale_x =
            shop_gui_w / shop_cam_w;

        var shop_scale_y =
            shop_gui_h / shop_cam_h;

        var npc_gui_x =
            (shop_npc.x - shop_cam_x)
            * shop_scale_x;

        var npc_gui_y =
            (shop_npc.y - shop_cam_y)
            * shop_scale_y;


        // ========================
        // 대화창 크기
        // ========================

        var shop_w = 300;
        var shop_h = 120;

        // NPC 오른쪽 위
        var shop_x =
            npc_gui_x + 40;

        var shop_y =
            npc_gui_y - shop_h - 20;


        // ========================
        // 화면 밖으로 나가지 않게
        // ========================

        shop_x = clamp(
            shop_x,
            10,
            shop_gui_w - shop_w - 10
        );

        shop_y = clamp(
            shop_y,
            10,
            shop_gui_h - shop_h - 10
        );


        // ========================
        // 검은 배경
        // ========================

        draw_set_alpha(0.9);
        draw_set_color(c_black);

        draw_rectangle(
            shop_x,
            shop_y,
            shop_x + shop_w,
            shop_y + shop_h,
            false
        );

        draw_set_alpha(1);


        // ========================
        // 흰색 테두리
        // ========================

        draw_set_color(c_white);

        draw_rectangle(
            shop_x,
            shop_y,
            shop_x + shop_w,
            shop_y + shop_h,
            true
        );


        // ========================
        // 상점 텍스트
        // ========================

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);

        draw_text(
            shop_x + 12,
            shop_y + 10,
            dialogue_text
        );
    }
}



// =====================================================
// 랜덤 강화 카드
// =====================================================

if (upgrade_open)
{
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();

    var card_w = 180;
    var card_h = 220;

    var gap = 30;

    var start_x =
        (gui_w - (card_w * 3 + gap * 2)) / 2;

    var card_y =
        (gui_h - card_h) / 2;


    // ========================
    // 제목
    // ========================

    draw_set_halign(fa_center);
    draw_set_color(c_white);

    draw_text(
        gui_w / 2,
        card_y - 50,
        "Choose One Upgrade"
    );


    // =================================================
    // CARD 1
    // =================================================

    draw_set_color(c_black);

    draw_rectangle(
        start_x,
        card_y,
        start_x + card_w,
        card_y + card_h,
        false
    );


    draw_set_color(c_white);

    draw_rectangle(
        start_x,
        card_y,
        start_x + card_w,
        card_y + card_h,
        true
    );


    draw_text(
        start_x + card_w / 2,
        card_y + 25,
        "1"
    );


    var text1 = "";

    if (card1 == 0)
        text1 = "Attack Up\nATK +1";

    if (card1 == 1)
        text1 = "Max HP Up\nHP +1";

    if (card1 == 2)
        text1 = "Defense Up\nDEF +1";

    if (card1 == 3)
        text1 = "Speed Up\nSpeed +0.5";

    if (card1 == 4)
        text1 = "Potion Up\nHeal +1";


    draw_text(
        start_x + card_w / 2,
        card_y + 80,
        text1
    );


    // =================================================
    // CARD 2
    // =================================================

    var card2_x =
        start_x + card_w + gap;


    draw_set_color(c_black);

    draw_rectangle(
        card2_x,
        card_y,
        card2_x + card_w,
        card_y + card_h,
        false
    );


    draw_set_color(c_white);

    draw_rectangle(
        card2_x,
        card_y,
        card2_x + card_w,
        card_y + card_h,
        true
    );


    draw_text(
        card2_x + card_w / 2,
        card_y + 25,
        "2"
    );


    var text2 = "";

    if (card2 == 0)
        text2 = "Attack Up\nATK +1";

    if (card2 == 1)
        text2 = "Max HP Up\nHP +1";

    if (card2 == 2)
        text2 = "Defense Up\nDEF +1";

    if (card2 == 3)
        text2 = "Speed Up\nSpeed +0.5";

    if (card2 == 4)
        text2 = "Potion Up\nHeal +1";


    draw_text(
        card2_x + card_w / 2,
        card_y + 80,
        text2
    );


    // =================================================
    // CARD 3
    // =================================================

    var card3_x =
        start_x + (card_w + gap) * 2;


    draw_set_color(c_black);

    draw_rectangle(
        card3_x,
        card_y,
        card3_x + card_w,
        card_y + card_h,
        false
    );


    draw_set_color(c_white);

    draw_rectangle(
        card3_x,
        card_y,
        card3_x + card_w,
        card_y + card_h,
        true
    );


    draw_text(
        card3_x + card_w / 2,
        card_y + 25,
        "3"
    );


    var text3 = "";

    if (card3 == 0)
        text3 = "Attack Up\nATK +1";

    if (card3 == 1)
        text3 = "Max HP Up\nHP +1";

    if (card3 == 2)
        text3 = "Defense Up\nDEF +1";

    if (card3 == 3)
        text3 = "Speed Up\nSpeed +0.5";

    if (card3 == 4)
        text3 = "Potion Up\nHeal +1";


    draw_text(
        card3_x + card_w / 2,
        card_y + 80,
        text3
    );


    draw_set_halign(fa_left);
}



// =====================================================
// INVENTORY
// =====================================================

if (inventory_open && !is_dead)
{
    var inv_w = 500;
    var inv_h = 400;


    var gui_w_inv =
        display_get_gui_width();

    var gui_h_inv =
        display_get_gui_height();


    var inv_x =
        (gui_w_inv - inv_w) / 2;

    var inv_y =
        (gui_h_inv - inv_h) / 2;


    // ========================
    // 인벤토리 배경
    // ========================

    draw_set_alpha(0.9);
    draw_set_color(c_black);

    draw_rectangle(
        inv_x,
        inv_y,
        inv_x + inv_w,
        inv_y + inv_h,
        false
    );

    draw_set_alpha(1);


    // ========================
    // 인벤토리 테두리
    // ========================

    draw_set_color(c_white);

    draw_rectangle(
        inv_x,
        inv_y,
        inv_x + inv_w,
        inv_y + inv_h,
        true
    );


    // ========================
    // 제목
    // ========================

    draw_set_halign(fa_center);
    draw_set_color(c_white);

    draw_text(
        gui_w_inv / 2,
        inv_y + 25,
        "INVENTORY"
    );


    draw_set_halign(fa_left);


    // =================================================
    // ITEMS
    // =================================================

    draw_set_color(c_yellow);

    draw_text(
        inv_x + 40,
        inv_y + 80,
        "ITEMS"
    );


    draw_set_color(c_white);

    draw_text(
        inv_x + 40,
        inv_y + 115,
        "Slime Gel: "
        + string(slime_gel)
    );


    draw_text(
        inv_x + 40,
        inv_y + 145,
        "Health Potion: "
        + string(health_potion)
    );


    // =================================================
    // STATS
    // =================================================

    draw_set_color(c_yellow);

    draw_text(
        inv_x + 280,
        inv_y + 80,
        "STATS"
    );


    draw_set_color(c_white);

    draw_text(
        inv_x + 280,
        inv_y + 115,
        "Attack: "
        + string(attack_damage)
    );


    draw_text(
        inv_x + 280,
        inv_y + 145,
        "Defense: "
        + string(defense)
    );


    draw_text(
        inv_x + 280,
        inv_y + 175,
        "Speed: "
        + string(move_speed)
    );


    draw_text(
        inv_x + 280,
        inv_y + 205,
        "Potion Heal: "
        + string(potion_heal)
    );


    // ========================
    // ESC 안내
    // ========================

    draw_set_halign(fa_center);
    draw_set_color(c_white);

    draw_text(
        gui_w_inv / 2,
        inv_y + inv_h - 40,
        "[ESC] Close"
    );


    draw_set_halign(fa_left);
}



// =====================================================
// 사망 화면
// =====================================================

if (is_dead)
{
    var gui_w2 =
        display_get_gui_width();

    var gui_h2 =
        display_get_gui_height();


    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);


    draw_set_color(c_red);

    draw_text(
        gui_w2 / 2,
        gui_h2 / 2 - 20,
        "YOU DIED"
    );


    draw_set_color(c_white);

    draw_text(
        gui_w2 / 2,
        gui_h2 / 2 + 20,
        "Press R to Restart"
    );


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}