// 메인 메뉴에서는 플레이어 HUD 숨기기
if (room == rm_main_menu)
{
    exit;
}

// =====================================================
// MAIN HUD FRAME
// =====================================================

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var hud_x = gui_w / 2;
var hud_y = gui_h - 75;

draw_sprite_ext(
    spr_hud_frame,
    0,
    hud_x,
    hud_y,
    1.25,
    1.25,
    0,
    c_white,
    1
);


// =====================================================
// TIME CLOCK
// =====================================================

var time_x = hud_x;
var time_y = hud_y - 80;

var time_frame = 0;

var dn = instance_find(obj_daynight, 0);

if (dn != noone)
{
    // obj_daynight의 낮/밤 상태를 시계와 공유
    if (variable_instance_exists(dn, "is_day") && dn.is_day)
    {
        // 낮의 앞 절반 = 08:00, 뒤 절반 = 12:00
        var day_progress = 0;
        if (dn.day_length > 0)
            day_progress = clamp(1 - (dn.day_timer / dn.day_length), 0, 1);

        time_frame = (day_progress < 0.5) ? 0 : 1;
    }
    else
    {
        // 밤 전체 = 16:00 프레임
        time_frame = 2;
    }
}

draw_sprite_ext(
    spr_time_clock,
    time_frame,
    time_x,
    time_y,
    0.8,
    0.8,
    0,
    c_white,
    1
);


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


// =====================================================
// 미니맵 배경
// =====================================================

draw_set_color(c_black);

draw_rectangle(
    map_x,
    map_y,
    map_x + map_w,
    map_y + map_h,
    false
);


// =====================================================
// FACE FRAME
// =====================================================

var face_x = hud_x - 185;
var face_y = hud_y + 2.5;

draw_sprite_ext(
    spr_face_frame,
    0,
    face_x,
    face_y,
    1.55,
    1.55,
    0,
    c_white,
    1
);


// =====================================================
// HP BAR
// =====================================================

var hp_x = face_x + 230;
var hp_y = hud_y - 20;

var hp_scale_x = 1.6;
var hp_scale_y = 1.3;

var hp_ratio = hp / max_hp;
hp_ratio = clamp(hp_ratio, 0, 1);


// =====================================================
// HP BAR FRAME
// =====================================================

draw_sprite_ext(
    spr_hp_bar_frame,
    0,
    hp_x,
    hp_y,
    hp_scale_x,
    hp_scale_y,
    0,
    c_white,
    1
);


// =====================================================
// RED HP FILL
// =====================================================

var hp_fill_w = 245;
var hp_fill_h = 10;

var hp_left = hp_x - (hp_fill_w / 2);
var hp_top = hp_y - (hp_fill_h / 2);

draw_set_color(c_red);

draw_rectangle(
    hp_left,
    hp_top,
    hp_left + (hp_fill_w * hp_ratio),
    hp_top + hp_fill_h,
    false
);

draw_set_color(c_white);


// =====================================================
// HP TEXT
// =====================================================

draw_set_font(fnt_hud);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var hp_text_x = hp_x - 160;
var hp_text_y = hp_y;

var hp_text = "HP";

// 검정 테두리
draw_set_color(c_black);

draw_text(hp_text_x - 2, hp_text_y, hp_text);
draw_text(hp_text_x + 2, hp_text_y, hp_text);
draw_text(hp_text_x, hp_text_y - 2, hp_text);
draw_text(hp_text_x, hp_text_y + 2, hp_text);

draw_text(hp_text_x - 2, hp_text_y - 2, hp_text);
draw_text(hp_text_x + 2, hp_text_y - 2, hp_text);
draw_text(hp_text_x - 2, hp_text_y + 2, hp_text);
draw_text(hp_text_x + 2, hp_text_y + 2, hp_text);

// 빨간 HP 글씨
draw_set_color(c_red);
draw_text(hp_text_x, hp_text_y, hp_text);

// 원상복구
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);


// =====================================================
// GOLD HUD
// =====================================================

var new_gold_x = hp_text_x + 10;
var new_gold_y = hud_y + 15;

// 골드 아이콘
draw_sprite_ext(
    spr_gold_icon,
    0,
    new_gold_x,
    new_gold_y,
    1.5,
    1.5,
    0,
    c_white,
    1
);

// 골드 숫자
draw_set_font(fnt_hud);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var gold_text_x = new_gold_x + 25;
var gold_text_y = new_gold_y;
var gold_text = string(gold);

// 검정 테두리
draw_set_color(c_black);

draw_text(gold_text_x - 2, gold_text_y, gold_text);
draw_text(gold_text_x + 2, gold_text_y, gold_text);
draw_text(gold_text_x, gold_text_y - 2, gold_text);
draw_text(gold_text_x, gold_text_y + 2, gold_text);

// 흰색 숫자
draw_set_color(c_white);
draw_text(gold_text_x, gold_text_y, gold_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);


// =====================================================
// POTION HUD
// =====================================================

var new_potion_x = new_gold_x + 90;
var new_potion_y = new_gold_y;

// 포션 아이콘
draw_sprite_ext(
    spr_potion_icon,
    0,
    new_potion_x,
    new_potion_y,
    1.5,
    1.5,
    0,
    c_white,
    1
);

// 포션 개수
draw_set_font(fnt_hud);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var potion_text_x = new_potion_x + 25;
var potion_text_y = new_potion_y;
var potion_text = string(health_potion);

// 검정 테두리
draw_set_color(c_black);

draw_text(potion_text_x - 2, potion_text_y, potion_text);
draw_text(potion_text_x + 2, potion_text_y, potion_text);
draw_text(potion_text_x, potion_text_y - 2, potion_text);
draw_text(potion_text_x, potion_text_y + 2, potion_text);

// 흰색 숫자
draw_set_color(c_white);
draw_text(potion_text_x, potion_text_y, potion_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);


// =====================================================
// ITEM SLOTS
// =====================================================

var slot_start_x = new_potion_x + 80;
var slot_y = new_potion_y + 5;

var slot_gap = 43;
var slot_scale = 2.5;


// SLOT 1
draw_sprite_ext(
    spr_slot,
    0,
    slot_start_x,
    slot_y,
    slot_scale,
    slot_scale,
    0,
    c_white,
    1
);


// SLOT 2
draw_sprite_ext(
    spr_slot,
    0,
    slot_start_x + slot_gap,
    slot_y,
    slot_scale,
    slot_scale,
    0,
    c_white,
    1
);


// SLOT 3
draw_sprite_ext(
    spr_slot,
    0,
    slot_start_x + (slot_gap * 2),
    slot_y,
    slot_scale,
    slot_scale,
    0,
    c_white,
    1
);


// SLOT 4
draw_sprite_ext(
    spr_slot,
    0,
    slot_start_x + (slot_gap * 3),
    slot_y,
    slot_scale,
    slot_scale,
    0,
    c_white,
    1
);


// =====================================================
// SEAL STONE - SLOT 4 (Captain quest reward)
// =====================================================
if (variable_instance_exists(id, "has_seal_stone") && has_seal_stone)
{
    var seal_size = 36;
    draw_sprite_stretched(
        spr_seal_stone, 0,
        slot_start_x + (slot_gap * 3) - seal_size * 0.5,
        slot_y - seal_size * 0.5,
        seal_size, seal_size
    );
}

// =====================================================
// SLIME GEL - SLOT 1
// =====================================================

var gel_x = slot_start_x;
var gel_y = slot_y;


// Slime Gel 아이콘
draw_sprite_ext(
    spr_slime_gel,
    0,
    gel_x,
    gel_y,
    1,
    1,
    0,
    c_white,
    1
);


// =====================================================
// SLIME GEL COUNT
// =====================================================

draw_set_font(fnt_hud);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var gel_text_x = gel_x + 13;
var gel_text_y = gel_y + 9;

var gel_text = string(slime_gel);


// 검정 테두리
draw_set_color(c_black);

draw_text_transformed(
    gel_text_x - 1,
    gel_text_y,
    gel_text,
    0.6,
    0.6,
    0
);

draw_text_transformed(
    gel_text_x + 1,
    gel_text_y,
    gel_text,
    0.6,
    0.6,
    0
);

draw_text_transformed(
    gel_text_x,
    gel_text_y - 1,
    gel_text,
    0.6,
    0.6,
    0
);

draw_text_transformed(
    gel_text_x,
    gel_text_y + 1,
    gel_text,
    0.6,
    0.6,
    0
);


// 흰색 숫자
draw_set_color(c_white);

draw_text_transformed(
    gel_text_x,
    gel_text_y,
    gel_text,
    0.6,
    0.6,
    0
);


// =====================================================
// BAT WING - SLOT 2
// =====================================================

var wing_x = slot_start_x + slot_gap;
var wing_y = slot_y;

draw_sprite_ext(
    spr_bat_wing, 0,
    wing_x, wing_y,
    1, 1, 0,
    c_white, 1
);

// 박쥐 날개 개수 (검은색 테두리 + 흰색 글자)
draw_set_font(fnt_hud);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var wing_text = string(bat_wing);
var wing_text_x = wing_x + 13;
var wing_text_y = wing_y + 9;

draw_set_color(c_black);
draw_text_transformed(wing_text_x - 1, wing_text_y, wing_text, 0.6, 0.6, 0);
draw_text_transformed(wing_text_x + 1, wing_text_y, wing_text, 0.6, 0.6, 0);
draw_text_transformed(wing_text_x, wing_text_y - 1, wing_text, 0.6, 0.6, 0);
draw_text_transformed(wing_text_x, wing_text_y + 1, wing_text, 0.6, 0.6, 0);

draw_set_color(c_white);
draw_text_transformed(wing_text_x, wing_text_y, wing_text, 0.6, 0.6, 0);


// =====================================================
// ORC HIDE - SLOT 3
// =====================================================

var hide_x = slot_start_x + (slot_gap * 2);
var hide_y = slot_y;

draw_sprite_ext(
    spr_orc_hide, 0,
    hide_x, hide_y,
    1, 1, 0,
    c_white, 1
);

// 오크 가죽 수량 (검은색 테두리 + 흰색 글자)
draw_set_font(fnt_hud);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var hide_text = string(orc_hide);
var hide_text_x = hide_x + 13;
var hide_text_y = hide_y + 9;

draw_set_color(c_black);
draw_text_transformed(hide_text_x - 1, hide_text_y, hide_text, 0.6, 0.6, 0);
draw_text_transformed(hide_text_x + 1, hide_text_y, hide_text, 0.6, 0.6, 0);
draw_text_transformed(hide_text_x, hide_text_y - 1, hide_text, 0.6, 0.6, 0);
draw_text_transformed(hide_text_x, hide_text_y + 1, hide_text, 0.6, 0.6, 0);

draw_set_color(c_white);
draw_text_transformed(hide_text_x, hide_text_y, hide_text, 0.6, 0.6, 0);


// =====================================================
// DRAW 설정 복구
// =====================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);


// =====================================================
// 원래 HUD 설정으로 복구
// =====================================================

draw_set_font(fnt_hud);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);


// =====================================================
// MINI MAP - Slime / Bat / Orc (red)
// =====================================================
var minimap_monsters = [obj_slime, obj_bat, obj_orc];
for (var monster_type = 0; monster_type < array_length(minimap_monsters); monster_type++)
{
    var monster_object = minimap_monsters[monster_type];
    var monster_count = instance_number(monster_object);
    for (var monster_i = 0; monster_i < monster_count; monster_i++)
    {
        var monster = instance_find(monster_object, monster_i);
        if (monster == noone) continue;
        if (variable_instance_exists(monster, "state") && monster.state == "dying") continue;

        var monster_map_x = map_center_x + ((monster.x - x) / minimap_range_x) * map_w;
        var monster_map_y = map_center_y + ((monster.y - y) / minimap_range_y) * map_h;
        if (monster_map_x >= map_x && monster_map_x <= map_x + map_w
            && monster_map_y >= map_y && monster_map_y <= map_y + map_h)
        {
            draw_set_color(c_red);
            draw_circle(monster_map_x, monster_map_y, 3, false);
        }
    }
}


// =====================================================
// MINI MAP - Priest / Save Point (cyan)
// If your save point has another object name, add it here.
// =====================================================
var priest_names = ["obj_priest", "obj_save_point", "obj_savepoint", "obj_save"];
for (var priest_type = 0; priest_type < array_length(priest_names); priest_type++)
{
    var priest_object = asset_get_index(priest_names[priest_type]);
    if (priest_object == -1) continue;
    if (asset_get_type(priest_object) != asset_object) continue;

    var priest_count = instance_number(priest_object);
    for (var priest_i = 0; priest_i < priest_count; priest_i++)
    {
        var priest = instance_find(priest_object, priest_i);
        if (priest == noone) continue;
        var priest_map_x = map_center_x + ((priest.x - x) / minimap_range_x) * map_w;
        var priest_map_y = map_center_y + ((priest.y - y) / minimap_range_y) * map_h;
        if (priest_map_x >= map_x && priest_map_x <= map_x + map_w
            && priest_map_y >= map_y && priest_map_y <= map_y + map_h)
        {
            draw_set_color(c_aqua);
            draw_circle(priest_map_x, priest_map_y, 4, false);
        }
    }
}


// =====================================================
// 미니맵 - 상인 NPC 표시
// =====================================================

var npc_count = instance_number(obj_npc);

for (var n = 0; n < npc_count; n++)
{
    var npc_map = instance_find(obj_npc, n);

    if (npc_map != noone)
    {
        var npc_relative_x = npc_map.x - x;
        var npc_relative_y = npc_map.y - y;

        var npc_map_x =
            map_center_x
            + (npc_relative_x / minimap_range_x)
            * map_w;

        var npc_map_y =
            map_center_y
            + (npc_relative_y / minimap_range_y)
            * map_h;

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
// 미니맵 - 플레이어 표시
// =====================================================

draw_set_color(c_lime);

draw_circle(
    map_center_x,
    map_center_y,
    4,
    false
);


// =====================================================
// 미니맵 테두리
// =====================================================

draw_set_color(c_white);

draw_rectangle(
    map_x,
    map_y,
    map_x + map_w,
    map_y + map_h,
    true
);


// =====================================================
// DRAW 설정 복구
// =====================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);


// 상인 대화 말풍선은 obj_npc -> Draw GUI에서 표시합니다.

// =====================================================
// RANDOM UPGRADE CARDS
// =====================================================

if (upgrade_open)
{
    var upgrade_gui_w = display_get_gui_width();
    var upgrade_gui_h = display_get_gui_height();

    var card_w = 200;
    var card_h = 280;
    var gap = 30;

    var total_w = (card_w * 3) + (gap * 2);

    var card1_x =
        (upgrade_gui_w / 2)
        - (total_w / 2)
        + (card_w / 2);

    var card_y = upgrade_gui_h / 2;

    var card2_x = card1_x + card_w + gap;
    var card3_x = card2_x + card_w + gap;


    // =================================================
    // CARD SPRITES
    // =================================================

    draw_sprite_ext(
        spr_upgrade_card,
        0,
        card1_x,
        card_y,
        1,
        1,
        0,
        c_white,
        1
    );

    draw_sprite_ext(
        spr_upgrade_card,
        0,
        card2_x,
        card_y,
        1,
        1,
        0,
        c_white,
        1
    );

    draw_sprite_ext(
        spr_upgrade_card,
        0,
        card3_x,
        card_y,
        1,
        1,
        0,
        c_white,
        1
    );


    draw_set_font(fnt_hud);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);


    // =================================================
    // CARD 1
    // =================================================

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
        card1_x,
        card_y - 35,
        text1
    );

    draw_text(
        card1_x,
        card_y + 95,
        "1"
    );


    // =================================================
    // CARD 2
    // =================================================

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
        card2_x,
        card_y - 35,
        text2
    );

    draw_text(
        card2_x,
        card_y + 95,
        "2"
    );


    // =================================================
    // CARD 3
    // =================================================

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
        card3_x,
        card_y - 35,
        text3
    );

    draw_text(
        card3_x,
        card_y + 95,
        "3"
    );


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}


// =====================================================
// INVENTORY
// =====================================================

if (inventory_open && !is_dead)
{
    var inv_w = 500;
    var inv_h = 400;

    var gui_w_inv = display_get_gui_width();
    var gui_h_inv = display_get_gui_height();

    var inv_x = (gui_w_inv - inv_w) / 2;
    var inv_y = (gui_h_inv - inv_h) / 2;


    // 배경
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


    // 테두리
    draw_set_color(c_white);

    draw_rectangle(
        inv_x,
        inv_y,
        inv_x + inv_w,
        inv_y + inv_h,
        true
    );


    // 제목
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

    // Bat Wing - 박쥐 날개 수량
    draw_text(
        inv_x + 40,
        inv_y + 175,
        "Bat Wing: "
        + string(bat_wing)
    );


    // Orc Hide - 오크 가죽 수량
    draw_text(
        inv_x + 40,
        inv_y + 205,
        "Orc Hide: "
        + string(orc_hide)
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


    // ESC
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
// DEATH SCREEN - SPRITE
// =====================================================

if (is_dead)
{
    var gui_w2 = display_get_gui_width();
    var gui_h2 = display_get_gui_height();

    // 화면 어둡게
    draw_set_alpha(0.65);
    draw_set_color(c_black);

    draw_rectangle(
        0, 0,
        gui_w2, gui_h2,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_white);

    // 게임 오버 스프라이트
    var death_w = 500;
    var death_h = 260;

    draw_sprite_stretched(
        spr_game_over,
        0,
        (gui_w2 - death_w) / 2,
        (gui_h2 - death_h) / 2,
        death_w,
        death_h
    );
}

// Draw 설정 복구
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);


// =====================================================
// KNIGHT QUEST TRACKER - BELOW MINIMAP
// =====================================================
if (knight_quest == 1)
{
    var knight_qx = map_x;
    var knight_qy = map_y + map_h + 10;
    var knight_qw = map_w;
    var knight_qh = 85;

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(knight_qx, knight_qy, knight_qx + knight_qw, knight_qy + knight_qh, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(knight_qx, knight_qy, knight_qx + knight_qw, knight_qy + knight_qh, true);

    draw_set_font(fnt_hud);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(knight_qx + 10, knight_qy + 8, "Knight's Request");
    draw_set_color(slime_gel >= 5 ? c_lime : c_white);
    draw_text(knight_qx + 10, knight_qy + 34, "Slime Gel: " + string(min(slime_gel, 5)) + "/5");
    draw_set_color(c_white);
    draw_text(knight_qx + 10, knight_qy + 58, "Reward: 30 Gold");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// =====================================================
// ARCHER QUEST TRACKER - BELOW MINIMAP
// =====================================================
if (variable_instance_exists(id, "archer_quest") && archer_quest == 1)
{
    var archer_qx = map_x;
    var archer_qy = map_y + map_h + 10;
    var archer_qw = map_w;
    var archer_qh = 85;
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(archer_qx, archer_qy, archer_qx + archer_qw, archer_qy + archer_qh, false);
    draw_set_color(c_white);
    draw_rectangle(archer_qx, archer_qy, archer_qx + archer_qw, archer_qy + archer_qh, true);
    draw_set_font(fnt_hud);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_yellow);
    draw_text(archer_qx + 10, archer_qy + 8, "Archer's Request");
    draw_set_color(archer_bat_kills >= 5 ? c_lime : c_white);
    draw_text(archer_qx + 10, archer_qy + 34, "Bat Kills: " + string(min(archer_bat_kills, 5)) + "/5");
    draw_set_color(c_white);
    draw_text(archer_qx + 10, archer_qy + 58, "Reward: 50 Gold");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// =====================================================
// CAPTAIN'S FINAL TRIAL - QUEST TRACKER
// =====================================================

// 퀘스트 진행 중일 때만 표시
if (captain_quest == 1)
{
    // 미니맵 바로 아래
    var quest_x = map_x;
    var quest_y = map_y + map_h + 10;

    var quest_w = map_w;
    var quest_h = 245;

    // 배경
    draw_set_alpha(1);
    draw_set_color(c_black);

    draw_rectangle(
        quest_x,
        quest_y,
        quest_x + quest_w,
        quest_y + quest_h,
        false
    );

    draw_set_alpha(1);

    // 테두리
    draw_set_color(c_white);

    draw_rectangle(
        quest_x,
        quest_y,
        quest_x + quest_w,
        quest_y + quest_h,
        true
    );

    // 텍스트 설정
    draw_set_font(fnt_hud);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var tx = quest_x + 10;
    var ty = quest_y + 10;
    var gap = 22;

    // 제목
    draw_set_color(c_yellow);
    draw_text(tx, ty, "Captain's Final Trial");

    ty += 30;

    // =====================================
    // MONSTER KILLS
    // =====================================

    draw_set_color(c_yellow);
    draw_text(tx, ty, "Defeat Monsters");
    ty += gap;

    draw_set_color(
        quest_slime_kills >= quest_slime_target
        ? c_lime : c_white
    );

    draw_text(
        tx, ty,
        "Slime: " + string(quest_slime_kills)
        + "/" + string(quest_slime_target)
    );

    ty += gap;

    draw_set_color(
        quest_bat_kills >= quest_bat_target
        ? c_lime : c_white
    );

    draw_text(
        tx, ty,
        "Bat: " + string(quest_bat_kills)
        + "/" + string(quest_bat_target)
    );

    ty += gap;

    draw_set_color(
        quest_orc_kills >= quest_orc_target
        ? c_lime : c_white
    );

    draw_text(
        tx, ty,
        "Orc: " + string(quest_orc_kills)
        + "/" + string(quest_orc_target)
    );

    ty += 28;

    // =====================================
    // MATERIAL COLLECTION
    // =====================================

    draw_set_color(c_yellow);
    draw_text(tx, ty, "Collect Materials");
    ty += gap;

    draw_set_color(
        slime_gel >= quest_slime_gel_target
        ? c_lime : c_white
    );

    draw_text(
        tx, ty,
        "Slime Gel: " + string(slime_gel)
        + "/" + string(quest_slime_gel_target)
    );

    ty += gap;

    draw_set_color(
        bat_wing >= quest_bat_wing_target
        ? c_lime : c_white
    );

    draw_text(
        tx, ty,
        "Bat Wing: " + string(bat_wing)
        + "/" + string(quest_bat_wing_target)
    );

    ty += gap;

    draw_set_color(
        orc_hide >= quest_orc_hide_target
        ? c_lime : c_white
    );

    draw_text(
        tx, ty,
        "Orc Hide: " + string(orc_hide)
        + "/" + string(quest_orc_hide_target)
    );

    // =====================================
    // QUEST COMPLETE CHECK
    // =====================================

    var kills_done =
        quest_slime_kills >= quest_slime_target
        && quest_bat_kills >= quest_bat_target
        && quest_orc_kills >= quest_orc_target;

    var materials_done =
        slime_gel >= quest_slime_gel_target
        && bat_wing >= quest_bat_wing_target
        && orc_hide >= quest_orc_hide_target;

    if (kills_done && materials_done)
    {
        draw_set_color(c_lime);

        draw_text(
            tx,
            quest_y + quest_h - 22,
            "Return to Captain!"
        );
    }

    // Draw 설정 복구
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// =====================================
// SPEARMAN QUEST - MINIMAP TRACKER
// =====================================
if (variable_instance_exists(id, "spearman_quest") && spearman_quest == 1)
{
    var sq_x = 18;
    var sq_y = 185; // Adjust to directly below your minimap if needed
    var sq_w = 205;
    var sq_h = 67;
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(sq_x, sq_y, sq_x + sq_w, sq_y + sq_h, false);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(sq_x + 10, sq_y + 8, "Spearman: Orc Hunt");
    draw_text(sq_x + 10, sq_y + 29, "Orc Kills: " + string(spearman_orc_kills) + "/3");
    draw_text(sq_x + 10, sq_y + 48, spearman_orc_kills >= 3 ? "Return to Spearman!" : "Reward: 2 Potions");
    draw_set_color(c_white);
    draw_set_alpha(1);
}
