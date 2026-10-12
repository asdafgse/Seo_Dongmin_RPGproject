// obj_quest_spearman - Step (FULL)
var pl = instance_nearest(x, y, obj_player);
if (pl == noone) exit;
// Face player even when there is no dialogue input.
image_xscale = (pl.x < x) ? -abs(image_xscale) : abs(image_xscale);
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

if (pl.archer_quest != 2)
{
    dialogue_text = "Spearman: Help the Archer first.";
    if (dialogue_page > 0) { dialogue_open = false; dialogue_page = 0; }
    exit;
}
if (pl.spearman_quest == 0)
{
    switch (dialogue_page)
    {
        case 0: dialogue_text = "Spearman: Orcs threaten the road."; break;
        case 1: dialogue_text = "Spearman: Defeat 3 Orcs for me."; break;
        default:
            pl.spearman_quest = 1;
            pl.spearman_orc_kills = 0;
            dialogue_open = false;
            dialogue_page = 0;
            break;
    }
}
else if (pl.spearman_quest == 1)
{
    if (pl.spearman_orc_kills >= 3)
    {
        if (dialogue_page == 0) dialogue_text = "Spearman: You defeated the Orcs!";
        else if (dialogue_page == 1) dialogue_text = "Spearman: Take these 2 potions.";
        else
        {
            pl.health_potion += 2;
            pl.spearman_quest = 2;
            dialogue_open = false;
            dialogue_page = 0;
        }
    }
    else
    {
        dialogue_text = "Spearman: Orcs defeated: " + string(pl.spearman_orc_kills) + "/3";
        if (dialogue_page > 0) { dialogue_open = false; dialogue_page = 0; }
    }
}
else
{
    dialogue_text = "Spearman: The road is safe now!";
    if (dialogue_page > 0) { dialogue_open = false; dialogue_page = 0; }
}
