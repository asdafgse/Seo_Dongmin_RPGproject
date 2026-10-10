// =====================================
// 낮 / 밤 타이머
// =====================================

day_timer--;

// =====================================
// 시간이 끝나면 낮 / 밤 변경
// =====================================

if (day_timer <= 0)
{
    is_day = !is_day;

    if (is_day)
    {
        day_timer = day_length;
        show_debug_message("DAY");
    }
    else
    {
        day_timer = night_length;
        show_debug_message("NIGHT");
    }
}