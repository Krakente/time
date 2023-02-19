script_author('Annanel')
script_version('0.1')

local imgui = require 'imgui'
local inicfg = require 'inicfg'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local arr = os.date("*t")
local session_start = os.time()
local data = {}

function save_data_to_ini()
    local ini = inicfg.save(data, "playtime.ini")
end

function load_data_from_ini()
    data = inicfg.load({
        Monday = 0,
        Tuesday = 0,
        Wednesday = 0,
        Thursday = 0,
        Friday = 0,
        Saturday = 0,
        Sunday = 0,
    }, "playtime.ini")
end

function update_playtime()
    local current_day = os.date("%A")
    if data[current_day] == nil then
        data[current_day] = 0
    end
    local duration = os.time() - session_start
    data[current_day] = data[current_day] + duration
    session_start = os.time()
    save_data_to_ini()
end

load_data_from_ini()

local main_window_state = imgui.ImBool(true)

function imgui.OnDrawFrame()
    local ex, ey = getScreenResolution()
    if main_window_state.v then
        imgui.SetNextWindowSize(imgui.ImVec2(150, 300), imgui.Cond.FirstUseEver) --размер
        imgui.SetNextWindowPos(imgui.ImVec2(ex - 130, ey / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5)) --положение
        imgui.Begin(' ', main_window_state, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
            imgui.Text(u8'Текущее время: '..os.date('%H:%M:%S'))
            imgui.Text(u8'Текущая дата: '..arr.day..':'.. arr.month..':'..arr.year)
            local duration = os.time() - session_start
            imgui.Separator()
            imgui.Text(u8'Время в игре:')
            imgui.Text(u8'Понедельник: '..string.format('%02d:%02d:%02d', data.Monday/3600, data.Monday%3600/60, data.Monday%60))
            imgui.Text(u8'Вторник: '..string.format('%02d:%02d:%02d', data.Tuesday/3600, data.Tuesday%3600/60, data.Tuesday%60))
            imgui.Text(u8'Среда: '..string.format('%02d:%02d:%02d', data.Wednesday/3600, data.Wednesday%3600/60, data.Wednesday%60))
            imgui.Text(u8'Четверг: '..string.format('%02d:%02d:%02d', data.Thursday/3600, data.Thursday%3600/60, data.Thursday%60))
            imgui.Text(u8'Пятница: '..string.format('%02d:%02d:%02d', data.Friday/3600, data.Friday%3600/60, data.Friday%60))
            imgui.Text(u8'Суббота: '..string.format('%02d:%02d:%02d', data.Saturday/3600, data.Saturday%3600/60, data.Saturday%60))
            imgui.Text(u8'Воскресенье: '..string.format('%02d:%02d:%02d', data.Sunday/3600, data.Sunday%3600/60, data.Sunday%60))
        imgui.End()
    end
end
    
function main()
    while true do wait(0)
        imgui.Process = main_window_state.v
        imgui.ShowCursor = false
        update_playtime()
    end
end
