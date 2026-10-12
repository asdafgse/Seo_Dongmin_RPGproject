
/// obj_quest_captain - Step
/// Knight -> Archer -> Spearman -> Captain

// =====================================
// NPC FACE PLAYER
// =====================================

var pl = instance_find(obj_player, 0);

if (pl == noone) exit;

if (pl.x < x)
{
    image_xscale = -1;
}
else if (pl.x > x)
{
    image_xscale = 1;
}

// 플레이어 사망 시 대화 중단
if (pl.is_dead)
{
    dialogue_open = false;
    dialogue_page = 0;
    exit;
}

// =====================================
// DISTANCE CHECK
// =====================================

var dist = point_distance(x, y, pl.x, pl.y);

if (dist > talk_distance)
{
    dialogue_open = false;
    dialogue_page = 0;
    dialogue_action = "";
    exit;
}

// =====================================
// PREVIOUS QUEST REQUIREMENTS
// =====================================

var knight_done =
    variable_instance_exists(pl, "knight_quest")
    && pl.knight_quest == 2;

var archer_done =
    variable_instance_exists(pl, "archer_quest")
    && pl.archer_quest == 2;

var spearman_done =
    variable_instance_exists(pl, "spearman_quest")
    && pl.spearman_quest == 2;

var all_quests_done =
    knight_done
    && archer_done
    && spearman_done;

// =====================================
// E KEY - DIALOGUE
// =====================================

if (keyboard_check_pressed(ord("E")))
{
    if (dialogue_open)
    {
        dialogue_page++;

        if (dialogue_page >= array_length(dialogue_pages))
        {
            dialogue_open = false;
            dialogue_page = 0;

            // Accept Captain Quest
            if (dialogue_action == "accept")
            {
                if (pl.captain_quest == 0 && all_quests_done)
                {
                    pl.captain_quest = 1;
                }
            }

            // Complete Captain Quest
            if (dialogue_action == "complete")
            {
                if (pl.captain_quest == 1)
                {
                    var kills_done =
                        pl.quest_slime_kills >= pl.quest_slime_target
                        && pl.quest_bat_kills >= pl.quest_bat_target
                        && pl.quest_orc_kills >= pl.quest_orc_target;

                    var materials_done =
                        pl.slime_gel >= pl.quest_slime_gel_target
                        && pl.bat_wing >= pl.quest_bat_wing_target
                        && pl.orc_hide >= pl.quest_orc_hide_target;

                    if (kills_done && materials_done)
                    {
                        pl.slime_gel -= pl.quest_slime_gel_target;
                        pl.bat_wing -= pl.quest_bat_wing_target;
                        pl.orc_hide -= pl.quest_orc_hide_target;

                        pl.captain_quest = 2;
                        pl.has_seal_stone = true;

                        show_debug_message(
                            "Captain Quest Complete! Seal Stone received!"
                        );
                    }
                }
            }

            dialogue_action = "";
        }
    }
    else
    {
        // =====================================
        // START NEW DIALOGUE
        // =====================================

        dialogue_open = true;
        dialogue_page = 0;
        dialogue_action = "";

        // Captain Quest Not Started
        if (pl.captain_quest == 0)
        {
            if (!all_quests_done)
            {
                dialogue_pages = [
                    "You wish to face the Necromancer?",
                    "First, prove yourself to my soldiers.",
                    "Complete the Knight, Archer, and Spearman quests."
                ];
            }
            else
            {
                dialogue_pages = [
                    "You have earned the trust of my soldiers.",
                    "But one final trial remains.",
                    "Defeat monsters and collect materials!"
                ];

                dialogue_action = "accept";
            }
        }

        // Captain Quest In Progress
        else if (pl.captain_quest == 1)
        {
            var kills_done =
                pl.quest_slime_kills >= pl.quest_slime_target
                && pl.quest_bat_kills >= pl.quest_bat_target
                && pl.quest_orc_kills >= pl.quest_orc_target;

            var materials_done =
                pl.slime_gel >= pl.quest_slime_gel_target
                && pl.bat_wing >= pl.quest_bat_wing_target
                && pl.orc_hide >= pl.quest_orc_hide_target;

            if (kills_done && materials_done)
            {
                dialogue_pages = [
                    "You have proven your strength!",
                    "Take this Seal Stone.",
                    "You may now face the Necromancer!"
                ];

                dialogue_action = "complete";
            }
            else
            {
                dialogue_pages = [
                    "Your final trial is not complete.",
                    "Check the quest tracker below the minimap."
                ];
            }
        }

        // Captain Quest Completed
        else
        {
            dialogue_pages = [
                "The Necromancer awaits.",
                "May the Seal Stone protect you."
            ];
        }
    }
}
