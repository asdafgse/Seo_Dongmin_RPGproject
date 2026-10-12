// =====================================
// KNIGHT - STEP (full)
// =====================================
// Face player (original sprite faces right)
var pl = instance_nearest(x, y, obj_player);
if (pl == noone) exit;

if (pl.x < x) image_xscale = -abs(image_xscale);
else image_xscale = abs(image_xscale);

var dist = point_distance(x, y, pl.x, pl.y);

if (dist > talk_distance)
{
    dialogue_open = false;
    dialogue_page = 0;
    exit;
}

if (keyboard_check_pressed(ord("E")))
{
    if (!dialogue_open)
    {
        dialogue_open = true;
        dialogue_page = 0;
    }
    else
    {
        dialogue_page++;
    }

    if (pl.knight_quest == 0)
    {
        switch (dialogue_page)
        {
            case 0:
                dialogue_text = "Knight: Hey, traveler. Can you help me?";
                break;
            case 1:
                dialogue_text = "Knight: Bring me 5 Slime Gels.";
                break;
            default:
                pl.knight_quest = 1;
                dialogue_open = false;
                dialogue_page = 0;
                break;
        }
    }
    else if (pl.knight_quest == 1)
    {
        if (pl.slime_gel >= 5)
        {
            switch (dialogue_page)
            {
                case 0:
                    dialogue_text = "Knight: You brought the Slime Gels!";
                    break;
                case 1:
                    dialogue_text = "Knight: Here's 30 Gold. Well done!";
                    break;
                default:
                    pl.slime_gel -= 5;
                    pl.gold += 30;
                    pl.knight_quest = 2;
                    dialogue_open = false;
                    dialogue_page = 0;
                    break;
            }
        }
        else
        {
            dialogue_text = "Knight: Slime Gels " + string(pl.slime_gel) + "/5. Keep looking!";
            if (dialogue_page >= 1)
            {
                dialogue_open = false;
                dialogue_page = 0;
            }
        }
    }
    else
    {
        dialogue_text = "Knight: Good work, adventurer!";
        if (dialogue_page >= 1)
        {
            dialogue_open = false;
            dialogue_page = 0;
        }
    }
}
