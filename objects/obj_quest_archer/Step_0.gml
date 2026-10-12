// Face player (original sprite faces right)
var pl = instance_nearest(x, y, obj_player);
if (pl == noone) exit;

if (pl.x < x) image_xscale = -abs(image_xscale);
else image_xscale = abs(image_xscale);

if (point_distance(x, y, pl.x, pl.y) > talk_distance)
{
    dialogue_open = false;
    dialogue_page = 0;
    exit;
}

if (!keyboard_check_pressed(ord("E"))) exit;

if (!dialogue_open)
{
    dialogue_open = true;
    dialogue_page = 0;
}
else dialogue_page++;

// Locked until Knight quest is completed
if (pl.knight_quest != 2)
{
    dialogue_text = "Archer: Help the Knight first.";
    if (dialogue_page > 0) { dialogue_open = false; dialogue_page = 0; }
    exit;
}

if (pl.archer_quest == 0)
{
    switch (dialogue_page)
    {
        case 0: dialogue_text = "Archer: Bats are troubling our village."; break;
        case 1: dialogue_text = "Archer: Defeat 5 bats for me."; break;
        default:
            pl.archer_quest = 1;
            pl.archer_bat_kills = 0;
            dialogue_open = false;
            dialogue_page = 0;
            break;
    }
}
else if (pl.archer_quest == 1)
{
    if (pl.archer_bat_kills >= 5)
    {
        if (dialogue_page == 0) dialogue_text = "Archer: The skies are safe again!";
        else if (dialogue_page == 1) dialogue_text = "Archer: Take 50 Gold as thanks.";
        else
        {
            pl.gold += 50;
            pl.archer_quest = 2;
            dialogue_open = false;
            dialogue_page = 0;
        }
    }
    else
    {
        dialogue_text = "Archer: Bats defeated: " + string(pl.archer_bat_kills) + "/5";
        if (dialogue_page > 0) { dialogue_open = false; dialogue_page = 0; }
    }
}
else
{
    dialogue_text = "Archer: Thank you, traveler!";
    if (dialogue_page > 0) { dialogue_open = false; dialogue_page = 0; }
}
