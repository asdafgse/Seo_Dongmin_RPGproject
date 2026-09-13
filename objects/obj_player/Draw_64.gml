// ========================
// HP BAR
// ========================

var bar_x = 20;
var bar_y = 20;

var bar_w = 200;
var bar_h = 20;

var hp_percent = hp / max_hp;


// ========================
// HP BAR 배경
// ========================

draw_set_color(c_black);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    false
);


// ========================
// 현재 HP
// ========================

draw_set_color(c_red);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + (bar_w * hp_percent),
    bar_y + bar_h,
    false
);


// ========================
// HP BAR 테두리
// ========================

draw_set_color(c_white);

draw_rectangle(
    bar_x,
    bar_y,
    bar_x + bar_w,
    bar_y + bar_h,
    true
);


// ========================
// HP 숫자
// ========================

draw_set_color(c_white);

draw_text(
    20,
    48,
    "HP: "
    + string(hp)
    + " / "
    + string(max_hp)
);


// ========================
// Slime Gel
// ========================

draw_text(
    20,
    70,
    "Slime Gel: "
    + string(slime_gel)
);


// ========================
// Health Potion
// ========================

draw_text(
    20,
    90,
    "Health Potion: "
    + string(health_potion)
    + " [C]"
);


// ========================
// Gold
// ========================

draw_set_color(c_yellow);

draw_text(
    20,
    110,
    "Gold: "
    + string(gold)
);


// ========================
// 스탯 표시
// ========================

draw_set_color(c_white);

draw_text(
    20,
    140,
    "ATK: "
    + string(attack_damage)
);

draw_text(
    20,
    160,
    "DEF: "
    + string(defense)
);

draw_text(
    20,
    180,
    "Speed: "
    + string(move_speed)
);

draw_text(
    20,
    200,
    "Potion Heal: "
    + string(potion_heal)
);


// ========================
// 상인 / NPC 대화창
// ========================

if (dialogue_open && !is_dead)
{
    draw_set_color(c_black);

    draw_rectangle(
        50,
        350,
        750,
        470,
        false
    );


    draw_set_color(c_white);

    draw_text(
        80,
        380,
        dialogue_text
    );
}


// ========================
// 랜덤 강화 카드 화면
// ========================

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


    // 제목
    draw_set_halign(fa_center);

    draw_set_color(c_white);

    draw_text(
        gui_w / 2,
        card_y - 50,
        "Choose One Upgrade"
    );


    // ========================
    // 카드 1
    // ========================

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
    {
        text1 = "Attack Up\nATK +1";
    }

    if (card1 == 1)
    {
        text1 = "Max HP Up\nHP +1";
    }

    if (card1 == 2)
    {
        text1 = "Defense Up\nDEF +1";
    }

    if (card1 == 3)
    {
        text1 = "Speed Up\nSpeed +0.5";
    }

    if (card1 == 4)
    {
        text1 = "Potion Up\nHeal +1";
    }


    draw_text(
        start_x + card_w / 2,
        card_y + 80,
        text1
    );


    // ========================
    // 카드 2
    // ========================

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
    {
        text2 = "Attack Up\nATK +1";
    }

    if (card2 == 1)
    {
        text2 = "Max HP Up\nHP +1";
    }

    if (card2 == 2)
    {
        text2 = "Defense Up\nDEF +1";
    }

    if (card2 == 3)
    {
        text2 = "Speed Up\nSpeed +0.5";
    }

    if (card2 == 4)
    {
        text2 = "Potion Up\nHeal +1";
    }


    draw_text(
        card2_x + card_w / 2,
        card_y + 80,
        text2
    );


    // ========================
    // 카드 3
    // ========================

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
    {
        text3 = "Attack Up\nATK +1";
    }

    if (card3 == 1)
    {
        text3 = "Max HP Up\nHP +1";
    }

    if (card3 == 2)
    {
        text3 = "Defense Up\nDEF +1";
    }

    if (card3 == 3)
    {
        text3 = "Speed Up\nSpeed +0.5";
    }

    if (card3 == 4)
    {
        text3 = "Potion Up\nHeal +1";
    }


    draw_text(
        card3_x + card_w / 2,
        card_y + 80,
        text3
    );


    draw_set_halign(fa_left);
}


// ========================
// 사망 화면
// ========================

if (is_dead)
{
    var gui_w2 = display_get_gui_width();
    var gui_h2 = display_get_gui_height();


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