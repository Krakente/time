script_author('Cosmo')
script_description('ShitCode Prodakshen')
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local se = require 'lib.samp.events'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local cfg = inicfg.load({
    statTimers = {
    	state = true,
    	clock = true,
    	sesOnline = true,
    	sesAfk = true, 
    	sesFull = true,
  		dayOnline = true,
  		dayAfk = true,
  		dayFull = true,
  		weekOnline = true,
  		weekAfk = true,
  		weekFull = true,
        server = nil
    },
	onDay = {
		today = os.date("%a"),
		online = 0,
		afk = 0,
		full = 0
	},
	onWeek = {
		week = 1,
		online = 0,
		afk = 0,
		full = 0
	},
    myWeekOnline = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0
    },
    pos = {
        x = 0,
        y = 0
    },
    style = {
    	round = 10.0,
    	colorW = 4279834905,
    	colorT = 4286677377
    }
}, "TimerOnline")

mcx = 0x0087FF
local sX, sY = getScreenResolution()
local tag = '{0087FF}TimerOnline: {FFFFFF}'
local to = imgui.ImBool(cfg.statTimers.state)
local nowTime = os.date("%H:%M:%S", os.time())
local settings = imgui.ImBool(false)
local myOnline = imgui.ImBool(false)
local pos = false
local restart = false
local recon = false

local sesOnline = imgui.ImInt(0)
local sesAfk = imgui.ImInt(0)
local sesFull = imgui.ImInt(0)
local dayFull = imgui.ImInt(cfg.onDay.full)
local weekFull = imgui.ImInt(cfg.onWeek.full)
local sRound = imgui.ImFloat(cfg.style.round)

local argbW = cfg.style.colorW
local argbT = cfg.style.colorT
local colorW = imgui.ImFloat4(imgui.ImColor(argbW):GetFloat4())
local colorT = imgui.ImFloat4(imgui.ImColor(argbT):GetFloat4())

local posX, posY = cfg.pos.x, cfg.pos.y
local Radio = {
	['clock'] = cfg.statTimers.clock,
	['sesOnline'] = cfg.statTimers.sesOnline,
	['sesAfk'] = cfg.statTimers.sesAfk,
	['sesFull'] = cfg.statTimers.sesFull,
	['dayOnline'] = cfg.statTimers.dayOnline,
	['dayAfk'] = cfg.statTimers.dayAfk,
	['dayFull'] = cfg.statTimers.dayFull,
	['weekOnline'] = cfg.statTimers.weekOnline,
	['weekAfk'] = cfg.statTimers.weekAfk,
	['weekFull'] = cfg.statTimers.weekFull
}

local tWeekdays = {
    [0] = 'Воскресенье',
    [1] = 'Понедельник', 
    [2] = 'Вторник', 
    [3] = 'Среда', 
    [4] = 'Четверг', 
    [5] = 'Пятница', 
    [6] = 'Суббота'
}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

        if not doesFileExist('moonloader/config/TimerOnline.ini') then
            if inicfg.save(cfg, 'TimerOnline.ini') then sampfuncsLog(tag..'Создан файл конфигурации: TimerOnline.ini') end
        end

        if cfg.statTimers.server ~= nil and cfg.statTimers.server ~= sampGetCurrentServerAddress() then 
            sampAddChatMessage(tag..'Вы зашли на свой не основной сервер. Скрипт отключён!', mcx)
            thisScript():unload()
        end

     	if cfg.onDay.today ~= os.date("%a") then 
     		cfg.onDay.today = os.date("%a")
     		cfg.onDay.online = 0
	        cfg.onDay.full = 0
	        cfg.onDay.afk = 0
            dayFull.v = 0
            inicfg.save(cfg, 'TimerOnline.ini')
	    end

	    if cfg.onWeek.week ~= number_week() then
	    	cfg.onWeek.week = number_week()
     		cfg.onWeek.online = 0
	        cfg.onWeek.full = 0
	        cfg.onWeek.afk = 0
            weekFull.v = 0
            for _, v in pairs(cfg.myWeekOnline) do v = 0 end            
            inicfg.save(cfg, 'TimerOnline.ini')
	    end

        sampRegisterChatCommand('toset', function()
            settings.v = not settings.v
        end)

        sampRegisterChatCommand('online', function()
            myOnline.v = not myOnline.v
        end)

        lua_thread.create(time)
        lua_thread.create(autoSave)
        
    while true do 
        imgui.ShowCursor = settings.v or myOnline.v
        imgui.Process = to.v or settings.v or myOnline.v
        wait(0)
    end
end

local fsClock = nil
function imgui.BeforeDrawFrame()
	if fsClock == nil then
        fsClock = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 25.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function imgui.OnDrawFrame()
    -- timer window >>
    if to.v and not recon then
    	imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(imgui.ImColor(argbW):GetFloat4()))
	    imgui.PushStyleColor(imgui.Col.Text, imgui.ImVec4(imgui.ImColor(argbT):GetFloat4()))
    	imgui.PushStyleVar(imgui.StyleVar.WindowRounding, sRound.v)
        imgui.SetNextWindowPos(imgui.ImVec2(posX, posY), imgui.Cond.Always)
        imgui.Begin(u8'##timer', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
        
        if cfg.statTimers.clock then
	        imgui.PushFont(fsClock)
	        imgui.CenterTextColoredRGB(nowTime)
            imgui.PopFont()
            imgui.SetCursorPosY(30)
            imgui.CenterTextColoredRGB(getStrDate(os.time()))
	        if cfg.statTimers.sesOnline or cfg.statTimers.sesAfk or cfg.statTimers.sesFull or cfg.statTimers.dayOnline or cfg.statTimers.dayAfk or cfg.statTimers.dayFull or cfg.statTimers.weekOnline or cfg.statTimers.weekAfk or cfg.statTimers.weekFull then
	       		imgui.Separator()
	    	end
	    end

        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(5, 2))
        if sampGetGamestate() ~= 3 then 
            imgui.CenterTextColoredRGB("Подключение: "..get_clock(connectingTime))
        else
            if cfg.statTimers.sesOnline then imgui.CenterTextColoredRGB("Сессия (чистый): "..get_clock(sesOnline.v)) end
            if cfg.statTimers.sesAfk then imgui.CenterTextColoredRGB("AFK за сессию: "..get_clock(sesAfk.v)) end
            if cfg.statTimers.sesFull then imgui.CenterTextColoredRGB("Онлайн за сессию: "..get_clock(sesFull.v)) end
            if cfg.statTimers.dayOnline then imgui.CenterTextColoredRGB("За день (чистый): "..get_clock(cfg.onDay.online)) end
            if cfg.statTimers.dayAfk then imgui.CenterTextColoredRGB("АФК за день: "..get_clock(cfg.onDay.afk)) end
            if cfg.statTimers.dayFull then imgui.CenterTextColoredRGB("Онлайн за день: "..get_clock(cfg.onDay.full)) end
            if cfg.statTimers.weekOnline then imgui.CenterTextColoredRGB("За неделю (чистый): "..get_clock(cfg.onWeek.online)) end
            if cfg.statTimers.weekAfk then imgui.CenterTextColoredRGB("АФК за неделю: "..get_clock(cfg.onWeek.afk)) end
            if cfg.statTimers.weekFull then imgui.CenterTextColoredRGB("Онлайн за неделю: "..get_clock(cfg.onWeek.full)) end
        end
        imgui.PopStyleVar()

        imgui.End()
        imgui.PopStyleVar()
        imgui.PopStyleColor(2)
    end

    -- settings menu >>
    if settings.v then
        imgui.SetNextWindowSize(imgui.ImVec2(500, 315), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sX / 2, sY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8'#Settings', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.NoTitleBar)
            imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('Timer Online') imgui.PopFont()
        	imgui.BeginChild('##RadioButtons', imgui.ImVec2(190, 245), true)
        	   	if imgui.RadioButton(u8'Текущее дата и время', Radio['clock']) then Radio['clock'] = not Radio['clock']; cfg.statTimers.clock = Radio['clock'] end
	            if imgui.RadioButton(u8'Онлайн сессию', Radio['sesOnline']) then Radio['sesOnline'] = not Radio['sesOnline']; cfg.statTimers.sesOnline = Radio['sesOnline'] end
	            imgui.Hint(u8'Без учёта АФК (Чистый онлайн)')
	            if imgui.RadioButton(u8'AFK за сессию', Radio['sesAfk']) then Radio['sesAfk'] = not Radio['sesAfk']; cfg.statTimers.sesAfk = Radio['sesAfk'] end
	            if imgui.RadioButton(u8'Общий за сессию', Radio['sesFull']) then Radio['sesFull'] = not Radio['sesFull']; cfg.statTimers.sesFull = Radio['sesFull'] end
	            if imgui.RadioButton(u8'Онлайн за день', Radio['dayOnline']) then Radio['dayOnline'] = not Radio['dayOnline']; cfg.statTimers.dayOnline = Radio['dayOnline'] end
	            imgui.Hint(u8'Без учёта АФК (Чистый онлайн)')
	            if imgui.RadioButton(u8'АФК за день', Radio['dayAfk']) then Radio['dayAfk'] = not Radio['dayAfk']; cfg.statTimers.dayAfk = Radio['dayAfk'] end
	            if imgui.RadioButton(u8'Общий за день', Radio['dayFull']) then Radio['dayFull'] = not Radio['dayFull']; cfg.statTimers.dayFull = Radio['dayFull'] end
	            if imgui.RadioButton(u8'Онлайн за неделю', Radio['weekOnline']) then Radio['weekOnline'] = not Radio['weekOnline']; cfg.statTimers.weekOnline = Radio['weekOnline'] end
	            imgui.Hint(u8'Без учёта АФК (Чистый онлайн)')
	            if imgui.RadioButton(u8'АФК за неделю', Radio['weekAfk']) then Radio['weekAfk'] = not Radio['weekAfk']; cfg.statTimers.weekAfk = Radio['weekAfk'] end
	            if imgui.RadioButton(u8'Общий за неделю', Radio['weekFull']) then Radio['weekFull'] = not Radio['weekFull']; cfg.statTimers.weekFull = Radio['weekFull'] end
        	imgui.EndChild()
        	imgui.SameLine()
        	imgui.BeginChild('##Customisation', imgui.ImVec2(-1, 245), true)
        	    if imgui.Checkbox(u8('##State'), to) then 
		    		cfg.statTimers.state = to.v
		    		inicfg.save(cfg, 'TimerOnline.ini')
		    	end
		    	imgui.SameLine()
		    	if to.v then
		    		imgui.TextColored(imgui.ImVec4(0.00, 0.53, 0.76, 1.00), u8'Включено')
		    	else
		    		imgui.TextDisabled(u8'Выключено')
		    	end
        	    if imgui.Button(u8'Местоположение', imgui.ImVec2(-1, 20)) then
	                lua_thread.create(function ()
	                    checkCursor = true
	                    settings.v = false
	                    sampSetCursorMode(4)
	                	sampAddChatMessage(tag..'Нажмите {0087FF}SPACE{FFFFFF} что-бы сохранить позицию', mcx)
	                    while checkCursor do
	                        local cX, cY = getCursorPos()
	                        posX, posY = cX, cY
	                        if isKeyDown(32) then
	                        	sampSetCursorMode(0)
	                        	cfg.pos.x, cfg.pos.y = posX, posY
	                            checkCursor = false
	                            settings.v = true
	                            if inicfg.save(cfg, 'TimerOnline.ini') then sampAddChatMessage(tag..'Позиция сохранена!', mcx) end
	                        end
	                        wait(0)
	                    end
	                end)
	            end
	            if cfg.statTimers.server == sampGetCurrentServerAddress() then
	                if imgui.Button(u8(sampGetCurrentServerName()), imgui.ImVec2(-1, 20)) then 
	                    cfg.statTimers.server = nil
	                    sampAddChatMessage(tag..'Теперь этот сервер не считается основным!', mcx)
	                end
	            else
	                if imgui.Button(u8'Установить этот сервер основным', imgui.ImVec2(-1, 20)) then 
	                    cfg.statTimers.server = sampGetCurrentServerAddress()
	                    sampAddChatMessage(tag..'Теперь онлайн будет считаться только на этом сервере!', mcx)
	                end
	                imgui.Hint(u8'Скрипт будет запускаться только на этом сервере!')
	            end
        	    imgui.PushItemWidth(-1)
        	    if imgui.SliderFloat('##Round', sRound, 0.0, 10.0, u8"Скругление краёв: %.2f") then 
                    cfg.style.round = sRound.v 
                    style()
                end
                imgui.PopItemWidth()

                if imgui.ColorEdit4(u8'Цвет фона', colorW, imgui.ColorEditFlags.NoInputs) then
		            argbW = imgui.ImColor.FromFloat4(colorW.v[1], colorW.v[2], colorW.v[3], colorW.v[4]):GetU32()
		            cfg.style.colorW = argbW
		        end
		        if imgui.ColorEdit4(u8'Цвет текста', colorT, imgui.ColorEditFlags.NoInputs) then
		            argbT = imgui.ImColor.FromFloat4(colorT.v[1], colorT.v[2], colorT.v[3], colorT.v[4]):GetU32()
		            cfg.style.colorT = argbT
		        end

                imgui.SetCursorPosY(imgui.GetWindowHeight() - 20)
                imgui.CenterTextColoredRGB('{707070}Сбросить все настройки')
	            if imgui.IsItemHovered() and imgui.IsMouseDoubleClicked(0) then
	                restart = true
	                os.remove(getWorkingDirectory()..'\\config\\TimerOnline.ini')
	                thisScript():reload()
	            else
	                imgui.Hint(u8'Двойной клик что-бы\nсбросить все настройки и таймеры')
	            end

        	imgui.EndChild()
            if imgui.Button(u8'Сохранить и закрыть', imgui.ImVec2(-1, 20)) then
                if inicfg.save(cfg, 'TimerOnline.ini') then 
                	sampAddChatMessage(tag..'Настройки сохранены!', mcx)
                	settings.v = false 
                end
            end
        imgui.End()
    end

    if myOnline.v then 
        imgui.SetNextWindowSize(imgui.ImVec2(400, 230), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(sX / 2, sY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8'#WeekOnline', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.ShowBorders + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
            imgui.SetCursorPos(imgui.ImVec2(15, 10))
            imgui.PushFont(fsClock) imgui.CenterTextColoredRGB('Онлайн за неделю') imgui.PopFont()
            imgui.CenterTextColoredRGB('{0087FF}Всего отыграно: '..get_clock(cfg.onWeek.full))
            imgui.NewLine()
            for day = 1, 6 do -- ПН -> СБ
                imgui.Text(u8(tWeekdays[day])); imgui.SameLine(250)
                imgui.Text(get_clock(cfg.myWeekOnline[day]))
            end 
            --> ВС
            imgui.Text(u8(tWeekdays[0])); imgui.SameLine(250)
            imgui.Text(get_clock(cfg.myWeekOnline[0]))

            imgui.SetCursorPosX((imgui.GetWindowWidth() - 200) / 2)
            if imgui.Button(u8'Закрыть', imgui.ImVec2(200, 25)) then myOnline.v = false end
        imgui.End()
    end
end

function se.onTogglePlayerSpectating(state) recon = state end -- если вы админ, то в реконе скрипт будет отключать табличку, сделал чисто для себя, если надо - удалите

function time()
	startTime = os.time()                                               -- "Точка отсчёта"
    connectingTime = 0
    while true do
        wait(1000)
        nowTime = os.date("%H:%M:%S", os.time())
        if sampGetGamestate() == 3 then 								-- Игровой статус равен "Подключён к серверу" (Что бы онлайн считало только, когда, мы подключены к серверу)
	        sesOnline.v = sesOnline.v + 1 								-- Онлайн за сессию без учёта АФК
	        sesFull.v = os.time() - startTime 							-- Общий онлайн за сессию
	        sesAfk.v = sesFull.v - sesOnline.v							-- АФК за сессию

	        cfg.onDay.online = cfg.onDay.online + 1 					-- Онлайн за день без учёта АФК
	        cfg.onDay.full = dayFull.v + sesFull.v 						-- Общий онлайн за день
	        cfg.onDay.afk = cfg.onDay.full - cfg.onDay.online			-- АФК за день

	        cfg.onWeek.online = cfg.onWeek.online + 1 					-- Онлайн за неделю без учёта АФК
	        cfg.onWeek.full = weekFull.v + sesFull.v 					-- Общий онлайн за неделю
	        cfg.onWeek.afk = cfg.onWeek.full - cfg.onWeek.online		-- АФК за неделю

            local today = tonumber(os.date('%w', os.time()))
            cfg.myWeekOnline[today] = cfg.onDay.full

            connectingTime = 0
	    else
            connectingTime = connectingTime + 1                         -- Вермя подключения к серверу
	    	startTime = startTime + 1									-- Смещение начала отсчета таймеров
	    end
    end
end

function autoSave()
	while true do 
		wait(60000) -- сохранение каждые 60 секунд
		inicfg.save(cfg, "TimerOnline")
	end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() and not restart then 
		if inicfg.save(cfg, 'TimerOnline.ini') then sampfuncsLog('{00FF00}TimerOnline: {FFFFFF}Ваш онлайн сохранён!') end
	end
end

function number_week() -- получение номера недели в году
    local current_time = os.date'*t'
    local start_year = os.time{ year = current_time.year, day = 1, month = 1 }
    local week_day = ( os.date('%w', start_year) - 1 ) % 7
    return math.ceil((current_time.yday + week_day) / 7)
end

function getStrDate(unixTime)
    local tMonths = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}
    local day = tonumber(os.date('%d', unixTime))
    local month = tMonths[tonumber(os.date('%m', unixTime))]
    local weekday = tWeekdays[tonumber(os.date('%w', unixTime))]
    return string.format('%s, %s %s', weekday, day, month)
end

function get_clock(time)
    local timezone_offset = 86400 - os.date('%H', 0) * 3600
    if tonumber(time) >= 86400 then onDay = true else onDay = false end
    return os.date((onDay and math.floor(time / 86400)..'д ' or '')..'%H:%M:%S', time + timezone_offset)
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

function imgui.Hint(text, delay)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5 -- скорость появления
        if os.clock() >= go_hint then 
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextUnformatted(text)
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar()
        end
    end
end

function style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

   	style.WindowPadding 		= imgui.ImVec2(8, 8)
    style.WindowRounding 		= 6
    style.ChildWindowRounding 	= 5
    style.FramePadding 			= imgui.ImVec2(5, 3)
    style.FrameRounding 		= 3.0
    style.ItemSpacing 			= imgui.ImVec2(5, 4)
    style.ItemInnerSpacing 		= imgui.ImVec2(4, 4)
    style.IndentSpacing 		= 21
    style.ScrollbarSize 		= 10.0
    style.ScrollbarRounding 	= 13
    style.GrabMinSize 			= 8
    style.GrabRounding			= 1
    style.WindowTitleAlign 		= imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign 		= imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                                = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]                        = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.WindowBg]                            = ImVec4(0.09, 0.09, 0.09, 1.00)
    colors[clr.ChildWindowBg]                       = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                             = ImVec4(0.05, 0.05, 0.05, 1.00)
    colors[clr.ComboBg]                             = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.Border]                              = ImVec4(0.43, 0.43, 0.50, 0.10)
    colors[clr.BorderShadow]                        = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                             = ImVec4(0.30, 0.30, 0.30, 0.10)
    colors[clr.FrameBgHovered]                      = ImVec4(0.00, 0.53, 0.76, 0.30)
    colors[clr.FrameBgActive]                       = ImVec4(0.00, 0.53, 0.76, 0.80)
    colors[clr.TitleBg]                             = ImVec4(0.13, 0.13, 0.13, 0.99)
    colors[clr.TitleBgActive]                       = ImVec4(0.13, 0.13, 0.13, 0.99)
    colors[clr.TitleBgCollapsed]                    = ImVec4(0.05, 0.05, 0.05, 0.79)
    colors[clr.MenuBarBg]                           = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]                         = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]                       = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]                = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]                 = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CheckMark]                           = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.SliderGrab]                          = ImVec4(0.28, 0.28, 0.28, 1.00)
    colors[clr.SliderGrabActive]                    = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.Button]                              = ImVec4(0.26, 0.26, 0.26, 0.30)
    colors[clr.ButtonHovered]                       = ImVec4(0.00, 0.53, 0.76, 1.00)
    colors[clr.ButtonActive]                        = ImVec4(0.00, 0.43, 0.76, 1.00)
    colors[clr.Header]                              = ImVec4(0.12, 0.12, 0.12, 0.94)
    colors[clr.HeaderHovered]                       = ImVec4(0.34, 0.34, 0.35, 0.89)
    colors[clr.HeaderActive]                        = ImVec4(0.12, 0.12, 0.12, 0.94)
    colors[clr.Separator]                           = ImVec4(0.30, 0.30, 0.30, 1.00)
    colors[clr.SeparatorHovered]                    = ImVec4(0.26, 0.59, 0.98, 0.78)
    colors[clr.SeparatorActive]                     = ImVec4(0.26, 0.59, 0.98, 1.00)
    colors[clr.ResizeGrip]                          = ImVec4(0.26, 0.59, 0.98, 0.25)
    colors[clr.ResizeGripHovered]                   = ImVec4(0.26, 0.59, 0.98, 0.67)
    colors[clr.ResizeGripActive]                    = ImVec4(0.26, 0.59, 0.98, 0.95)
    colors[clr.CloseButton]                         = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]                  = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]                   = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]                           = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]                    = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]                       = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]                = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]                      = ImVec4(0.00, 0.43, 0.76, 1.00)
    colors[clr.ModalWindowDarkening]                = ImVec4(0.20, 0.20, 0.20,  0.0)
end
style()
