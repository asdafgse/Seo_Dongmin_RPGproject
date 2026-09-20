// ========================
// 낮 / 밤 타이머
// ========================

day_timer--;


// ========================
// 시간이 끝나면 낮/밤 변경
// ========================

if (day_timer <= 0)
{
    is_day = !is_day;

    day_timer = day_length;


    // ========================
    // Debug 확인
    // ========================

    if (is_day)
    {
        show_debug_message("DAY");
    }
    else
    {
        show_debug_message("NIGHT");
    }
}