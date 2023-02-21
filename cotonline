----------------------------------------------
-- Инициализация библиотек
----------------------------------------------
				 require "lib.moonloader" -- сам мунлоадер
local ev       = require 'lib.samp.events' -- ивенты самп
local inicfg   = require 'inicfg' -- создание кфг
local imgui    = require 'imgui' -- создание окон
local limadd, imadd = pcall(require, 'imgui_addons')
local encoding = require 'encoding' -- кодировка для кирилицы
local font = renderCreateFont("Arial", 15)
--local themes = import "resource/imgui_themes.lua"

encoding.default = 'CP1251'
u8 = encoding.UTF8
------------------------------------------
-- Инициализация конфигурации
----------------------------------------------
local defsets = {
		main = {
			cotton             = 0,
			linen              = 0,
			cashCotton         = 0,
			cashLinen          = 0,
			fontsize           = 20,
			show_message       = true,
			auto_alt           = true,
			show_message_paint = true,
			show_stats         = true,
			achievements       = true,
			wallhack           = false,
			setwhcotton        = false,
			setwhlinen         = false,
			visiblecotton      = false,
			visiblelinen       = false,
			visibleallcash     = false,
			x = 20,
			y = 20
		},
}
if not doesDirectoryExist('moonloader/config') then
	createDirectory('moonloader/config')
end
if not doesFileExist('moonloader/config/ferma.ini') then
	inicfg.save(defsets,'ferma.ini')
end

local sets = inicfg.load(defsets,'ferma.ini')
local settings = sets.main
----------------------------------------------
-- Инициализация переменных
----------------------------------------------
local cotton     = settings.cotton
local linen      = settings.linen
local cashCotton = settings.cashCotton
local cashLinen  = settings.cashLinen
local sizefont   = settings.fontsize
local setMessage = imgui.ImBool(settings.show_message)
local setAlt     = imgui.ImBool(settings.auto_alt)
local setPaint   = imgui.ImBool(settings.show_message_paint)
local setStat    = imgui.ImBool(settings.show_stats)
local setAchiev  = imgui.ImBool(settings.achievements)
local setwh      = imgui.ImBool(settings.wallhack)
local setwhcotton = imgui.ImBool(settings.setwhcotton)
local setwhlinen = imgui.ImBool(settings.setwhlinen)
local visiblecotton = imgui.ImBool(settings.visiblecotton)
local visiblelinen = imgui.ImBool(settings.visiblelinen)
local visibleallcash = imgui.ImBool(settings.visibleallcash)
local x      	 = settings.x
local y          = settings.y
local fontsize   = nil
local fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\Arial.ttf', sizefont, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
local showMainWindow    = imgui.ImBool(false)
local cotton_buffer     = imgui.ImBuffer(6)
local linen_buffer      = imgui.ImBuffer(6)
local cashCotton_buffer = imgui.ImBuffer(6)
local cashLinen_buffer  = imgui.ImBuffer(6)
local font_buffer 		= imgui.ImBuffer(6)
local a1,a2,a3,a4,a5,a6,a7,a8,l1,l2,l3,l4,l5,l6,l7,c1,c2,c3,c4,c5,c6,c7 = false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false

font_buffer.v       = tostring(sizefont)
cotton_buffer.v     = tostring(cotton)
cashCotton_buffer.v = tostring(cashCotton)
linen_buffer.v      = tostring(linen)
cashLinen_buffer.v  = tostring(cashLinen)
----------------------------------------------
-- Функция Main
----------------------------------------------
function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
		sampRegisterChatCommand("ferma",cmd_ferma)
		load_settings()
		sampAddChatMessage("{5bad00}[FarmHelper]:{71d700} Скрипт успешно запущен!",0x5bad00)
		imgui.ShowCursor = false
		lockPlayerControl(false)

	while true do
		wait(0)
		
		if not showMainWindow.v then
			imgui.Process = setStat.v
		end
		if setwh.v then
			wallhack()
		end
		if setAlt.v then 
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local result, _, _, _, _, _, _, _, _, _ = Search3Dtext(x, y, z, 3, "{73B461}Для")
				
			if result then
					setGameKeyState(21, 255)
					wait(5)
					setGameKeyState(21, 0)
					result = false
			end
		end		
				
	end

end


----------------------------------------------
-- Загрузка настроек
----------------------------------------------
function load_settings()
cotton     = settings.cotton
linen      = settings.linen
cashCotton = settings.cashCotton
cashLinen  = settings.cashLinen
sizefont   = settings.fontsize
setMessage = imgui.ImBool(settings.show_message)
setAlt     = imgui.ImBool(settings.auto_alt)
setPaint   = imgui.ImBool(settings.show_message_paint)
setAchiev  = imgui.ImBool(settings.achievements)
setStat    = imgui.ImBool(settings.show_stats)
setwh      = imgui.ImBool(settings.wallhack)
setwhcotton = imgui.ImBool(settings.setwhcotton)
setwhlinen = imgui.ImBool(settings.setwhlinen)
visiblecotton = imgui.ImBool(settings.visiblecotton)
visiblelinen = imgui.ImBool(settings.visiblelinen)
visibleallcash = imgui.ImBool(settings.visibleallcash)

x      	   = settings.x
y          = settings.y
end
----------------------------------------------
-- Сохранение настроек
----------------------------------------------
function save_settings()
settings.cotton             = cotton
settings.linen              = linen
settings.cashCotton         = cashCotton
settings.cashLinen          = cashLinen
settings.fontsize           = sizefont
settings.show_message       = setMessage.v
settings.auto_alt           = setAlt.v
settings.show_message_paint = setPaint.v
settings.achievements       = setAchiev.v
settings.show_stats         = setStat.v
settings.wallhack           = setwh.v
settings.setwhcotton        = setwhcotton.v
settings.setwhlinen         = setwhlinen.v
settings.visiblecotton      = visiblecotton.v
settings.visiblelinen       = visiblelinen.v
settings.visibleallcash     = visibleallcash.v
settings.x                  = x
settings.y                  = y
font_buffer.v       = tostring(sizefont)
cotton_buffer.v     = tostring(cotton)
cashCotton_buffer.v = tostring(cashCotton)
linen_buffer.v      = tostring(linen)
cashLinen_buffer.v  = tostring(cashLinen)
fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\Arial.ttf', sizefont, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
inicfg.save(sets,'ferma.ini')
end


----------------------------------------------
-- Шрифт для IMGUI
----------------------------------------------
function imgui.BeforeDrawFrame()
    --if fontsize == nil then
        --fontsize = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\Lucon.ttf',
		--sizefont, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic()) -- вместо 30 любой нужный размер
   -- end
end
----------------------------------------------
-- Imgui окна 
----------------------------------------------
function imgui.OnDrawFrame()
	if not showMainWindow.v and not setStat.v then
		imgui.Process = false
		imgui.ShowCursor = false
	end

	if showMainWindow.v then
		imgui.ShowCursor = true
		sw,sh = getScreenResolution() 
		imgui.SetNextWindowPos(imgui.ImVec2(sw/1.2 ,sh/2),imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(250,550),imgui.Cond.FirstUseEver)
		imgui.Begin(u8"FarmHelper настройки",showMainWindow,imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.AlwaysAutoResize)
			imgui.Text(u8"Настройки помощника для фермы",showMainWindow);

			if imadd.ToggleButton("setm",setMessage) then save_settings() end
			 imgui.SameLine() imgui.Text(u8"Включить оповещение в чат") 
			if imadd.ToggleButton("seta",setAlt) then save_settings() end
			imgui.SameLine() imgui.Text(u8"Включить AutoALT") 
			if imadd.ToggleButton("setp",setPaint) then save_settings() end
			 imgui.SameLine() imgui.Text(u8"Убрать сообщения о красителе") 
			if imadd.ToggleButton("setar",setAchiev) then save_settings() end
			 imgui.SameLine() imgui.Text(u8"Включить систему достижений") 
			if imadd.ToggleButton("setwh",setwh) then save_settings() end
			imgui.SameLine() imgui.Text(u8"Включить WallHack") 
			if setwh.v then 
				imgui.Separator()
				imgui.Text(u8"Настройки Wallhack")
				if imadd.ToggleButton("setwhlinen",setwhlinen) then save_settings() end
				imgui.SameLine() imgui.Text(u8"Wallhack на лен") 
				if imadd.ToggleButton("setwhcotton",setwhcotton) then save_settings() end
				imgui.SameLine() imgui.Text(u8"Wallhack на хлопок")
				imgui.Separator()
			end	
			if imadd.ToggleButton("sets",setStat) then save_settings() end
			imgui.SameLine() imgui.Text(u8"Показать статистику") 
		
			if setStat.v then 
				imgui.Separator()
				imgui.Text(u8"Настройки статистики")
				
				if imadd.ToggleButton("visiblelinen",visiblelinen) then save_settings() end
				imgui.SameLine() imgui.Text(u8"Статистика льна")
		
				if visiblelinen.v then
				imgui.BeginChild("child2",imgui.ImVec2(250,50),false,imgui.WindowFlags.AlwaysAutoResize)
				imgui.PushItemWidth(50)
				
					imgui.InputText(u8"Кол-во льна",linen_buffer,4,imgui.InputTextFlags.CharsDecimal)
					imgui.InputText(u8"Стоимость льна",cashLinen_buffer,imgui.InputTextFlags.CharsDecimal)
				imgui.PopItemWidth()
				imgui.EndChild()
				end
						if imadd.ToggleButton("visiblecotton",visiblecotton) then save_settings() end
				imgui.SameLine() imgui.Text(u8"Статистика хлопка")
				if visiblecotton.v then
				imgui.BeginChild("child3",imgui.ImVec2(250,50),false)
				imgui.PushItemWidth(50)
					imgui.InputText(u8"Кол-во хлопка",cotton_buffer,4,imgui.InputTextFlags.CharsDecimal)
					imgui.InputText(u8"Стоимость хлопка",cashCotton_buffer,imgui.InputTextFlags.CharsDecimal)
					imgui.PopItemWidth()
				imgui.EndChild()
				
				end
				if visiblecotton.v and visiblelinen.v then
					if imadd.ToggleButton("visibleallcash",visibleallcash) then save_settings() end
					imgui.SameLine() imgui.Text(u8"Отображение общего заработка")
				end
				if visiblecotton.v or visiblelinen.v then 
					
					if imgui.Button(u8"Обновить значения") then
						a1,a2,a3,a4,a5,a6,a7,a8,l1,l2,l3,l4,l5,l6,l7,c1,c2,c3,c4,c5,c6,c7 = 
						false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false
						sizefont = tostring(font_buffer.v)
						if tonumber(sizefont) < 10 or tonumber(sizefont) > 50 then sampAddChatMessage("[FarmHelper]: Ошибка! Размер шрифта может быть от 10 до 50!",0xb90000) sizefont = "20" end
						cotton = tonumber(cotton_buffer.v)
						linen = tonumber(linen_buffer.v)
						cashCotton = tonumber(cashCotton_buffer.v)
						cashLinen = tonumber(cashLinen_buffer.v)
						save_settings() 
						
						showMainWindow.v = false
					end
				end
				imgui.Separator()
					
			
			end
					
				
				
			if imgui.Button(u8"Закрыть окно",imgui.ImVec2(250,30)) then showMainWindow.v = false end
		imgui.End()
		
	else imgui.ShowCursor = false end
	
	if setStat.v then
		if not showMainWindow.v then
			imgui.Process = setStat.v
			imgui.ShowCursor = false
		end
		
		imgui.SetNextWindowPos(imgui.ImVec2(x,y),imgui.Cond.FirstUseEver)
		imgui.Begin(u8"Статистика",setStat,imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoTitleBar)
			if visiblelinen.v then
			imgui.Text(u8"Собрано льна:" .. linen .. " or $" .. separator(linen * cashLinen))
			end
			if visiblecotton.v then
			imgui.Text(u8"Собрано хлопка:" .. cotton .. " or $" .. separator(cotton * cashCotton))
			end
			if visiblelinen.v and visiblecotton.v and visibleallcash.v then 
			imgui.Text(u8"Общий заработок $" .. separator((linen * cashLinen) + (cotton * cashCotton)))
			end
			if settings.x ~= imgui.GetWindowPos().x or settings.y ~= imgui.GetWindowPos().y then
			
				settings.x = imgui.GetWindowPos().x
				settings.y = imgui.GetWindowPos().y
				inicfg.save(sets,"ferma.ini")
				
			end
			
			
		imgui.End()
		
	end	

end
----------------------------------------------
-- Wallhack
----------------------------------------------
function wallhack()
	for id = 0, 2048 do
		local result = sampIs3dTextDefined( id )
		if result then
			local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById( id )
			if setwhlinen.v then 
				if text:match('Лён%((%d+) из (%d+)%)') then
					n1,n2=text:match('Лён%((%d+) из (%d+)%)') 
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
					local resX, resY = getScreenResolution()
					
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						x2,y2,z2 = getCharCoordinates(PLAYER_PED)
						x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
						renderFontDrawText(font, "Лён("..n1..' из '..n2..')', wposX, wposY, -1)			
					end
				end
			
				if text:match('Лён в процессе роста\n{FFFFFF}Осталось 00:(%d+)')  then
					t2=text:match('Лён в процессе роста\n{FFFFFF}Осталось 00:(%d+)')
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
					local resX, resY = getScreenResolution()
					
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1)  then
						x2,y2,z2 = getCharCoordinates(PLAYER_PED)
						x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
						renderFontDrawText(font, "Лён(00:"..t2..")", wposX, wposY,-1)
					end				
				end
			end
			if setwhcotton.v then
				if text:match('Хлопок%((%d+) из (%d+)%)') then
					n1,n2=text:match('Хлопок%((%d+) из (%d+)%)') 
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
					local resX, resY = getScreenResolution()
					
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						x2,y2,z2 = getCharCoordinates(PLAYER_PED)
						x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
						renderFontDrawText(font, "Хлопок("..n1..' из '..n2..')', wposX, wposY, -1)			
					end
				end
				
				if text:match('Хлопок в процессе роста\n{FFFFFF}Осталось 00:(%d+)')  then
					t2=text:match('Хлопок в процессе роста\n{FFFFFF}Осталось 00:(%d+)')
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
					local resX, resY = getScreenResolution()
					
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1)  then
						x2,y2,z2 = getCharCoordinates(PLAYER_PED)
						x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
						renderFontDrawText(font, "Хлопок(00:"..t2..")", wposX, wposY,-1)
					end				
				end		
			end			
		
		end
	end
end
----------------------------------------------
-- Достижения
----------------------------------------------
function achievements()
	local ca = 0xffbb3d
	local allCash = (cotton * cashCotton) + (linen * cashLinen)
	
	
	if     allCash >= 100000   and allCash < 500000   and not a1 then sampAddChatMessage("Получено достижение 'Первые шаги' за $ 100.000 общего заработка",ca) a1 = true
	elseif allCash >= 500000   and allCash < 1000000  and not a2 then sampAddChatMessage("Получено достижение 'Основавшийся' за $ 500.000 общего заработка",ca) a2 = true
	elseif allCash >= 1000000  and allCash < 2000000  and not a3 then sampAddChatMessage("Получено достижение 'Первый миллион!' за $ 1.000.000 общего заработка.",ca) a3 = true
	elseif allCash >= 2000000  and allCash < 5000000  and not a4 then sampAddChatMessage("Получено достижение 'Упорный!' за $ 2.000.000 общего заработка.",ca) a4 = true
	elseif allCash >= 5000000  and allCash < 10000000 and not a5 then sampAddChatMessage("Получено достижение 'Вперед за мечтой!' за $ 5.000.000 общего заработка.",ca) a5 = true
	elseif allCash >= 10000000 and allCash < 20000000 and not a6 then sampAddChatMessage("Получено достижение 'Рекордсмен!' за $ 10.000.000 общего заработка. ",ca) a6 = true
	elseif allCash >= 20000000 and allCash < 40000000 and not a7 then sampAddChatMessage("Получено достижение 'Невозможный!' за $ 20.000.000 общего заработка.",ca) a7 = true
	elseif allCash >= 40000000                        and not a8 then sampAddChatMessage("Получено достижение 'Не, ну это уже взлом...' за $ 40.000.000 общего заработка",ca) a8 = true
	end
	
	if     linen >= 200  and linen < 400  and not l1 then sampAddChatMessage("Получено достижение 'Первый стак' за 200 штук собранного льна",ca) l1 = true 
	elseif linen >= 400  and linen < 800  and not l2 then sampAddChatMessage("Получено достижение 'Второй стак!' за 400 штук собранного льна",ca) l2 = true 
	elseif linen >= 800  and linen < 1000 and not l3 then sampAddChatMessage("Получено достижение 'Серьезные намерения!' за 800 штук собранного льна",ca) l3 = true 
	elseif linen >= 1000 and linen < 2000 and not l4 then sampAddChatMessage("Получено достижение 'ТЫЫЫЩААА!!' за 1000 штук собранного льна",ca) l4 = true 
	elseif linen >= 2000 and linen < 4000 and not l5 then sampAddChatMessage("Получено достижение 'Стремящийся к цели' за 2000 штук собранного льна",ca) l5 = true 
	elseif linen >= 4000 and linen < 8000 and not l6 then sampAddChatMessage("Получено достижение 'Пора отдохнуть...' за 4000 штук собранного льна",ca) l6 = true 
	elseif linen >= 8000                  and not l7 then sampAddChatMessage("Получено достижение 'Кажется я бог' за 8000 штук собранного льна") l7 = true 
	end
	
	if     cotton >= 200  and cotton < 400  and not c1 then sampAddChatMessage("Получено достижение 'Хорошие начинания' за 200 штук собранного хлопка",ca) c1 = true 
	elseif cotton >= 400  and cotton < 600  and not c2 then sampAddChatMessage("Получено достижение 'Дополнительный заработок' за 400 штук собранного хлопка",ca) c2 = true 
	elseif cotton >= 600  and cotton < 1000 and not c3 then sampAddChatMessage("Получено достижение 'Мы открываем бизнес, мы будем делать бабки' за 600 штук собранного хлопка",ca) c3 = true 
	elseif cotton >= 1000 and cotton < 2000 and not c4 then sampAddChatMessage("Получено достижение 'Плавно мутим лавешечку' за  1000 штук собранного хлопка",ca) c4 = true 
	elseif cotton >= 2000 and cotton < 4000 and not c5 then sampAddChatMessage("Получено достижение 'Не, ну это шутка?' за 2000 штук собранного хлопка",ca) c5 = true 
	elseif cotton >= 4000 and cotton < 8000 and not c6 then sampAddChatMessage("Получено достижение 'Читер какой-то' за 4000 штук собранного хлопка",ca) c6 = true 
	elseif cotton >= 8000                   and not c7 then sampAddChatMessage("Получено достижение 'Разработчик скрипта' за 8000 штук собранного льна",ca) c7 = true 
	end
end

----------------------------------------------
-- Скрытие сообщений о добыче Красителя
----------------------------------------------
function ev.onServerMessage(color,text)
	if setPaint.v then
		if string.find(text,'Краситель',1,true) then
			return false
		end
	end	
end
----------------------------------------------
-- Поиск куста для AutoAlt 
----------------------------------------------
function Search3Dtext(x, y, z, radius, patern) -- https://www.blast.hk/threads/13380/post-119168
    local text = ""
    local color = 0
    local posX = 0.0
    local posY = 0.0
    local posZ = 0.0
    local distance = 0.0
    local ignoreWalls = false
    local player = -1
    local vehicle = -1
    local result = false

    for id = 0, 2048 do
        if sampIs3dTextDefined(id) then
            local text2, color2, posX2, posY2, posZ2, distance2, ignoreWalls2, player2, vehicle2 = sampGet3dTextInfoById(id)
            if getDistanceBetweenCoords3d(x, y, z, posX2, posY2, posZ2) < radius then
                if string.len(patern) ~= 0 then
                    if string.match(text2, patern, 0) ~= nil then result = true end
                else
                    result = true
                end
                if result then
                    text = text2
                    color = color2
                    posX = posX2
                    posY = posY2
                    posZ = posZ2
                    distance = distance2
                    ignoreWalls = ignoreWalls2
                    player = player2
                    vehicle = vehicle2
                    radius = getDistanceBetweenCoords3d(x, y, z, posX, posY, posZ)
                end
            end
        end
    end

    return result, text, color, posX, posY, posZ, distance, ignoreWalls, player, vehicle
end
----------------------------------------------
-- Отображение уведомлений о добыче хлопка
----------------------------------------------
function ev.onDisplayGameText(style,time,text)

			if text == "cotton + 1" then cotton = cotton + 1 achievements() end
			if text == "linen + 1" then linen = linen + 1 achievements() end
			if text == "cotton + 2" then cotton = cotton + 2 achievements() end
			if text == "linen + 2" then linen = linen + 2  end
			if setMessage.v then
				if text == "cotton + 1" or text == "cotton + 2" then 
					sampAddChatMessage("{B7B7B7}Хлопка собрано: {5CF5FF}" .. cotton .. "{B7B7B7} or {079400}" .. separator(cotton * cashCotton) .. "$",0xB7B7B7)
				end
				if text == "linen + 1" or text == "linen + 2" then
					sampAddChatMessage("{B7B7B7}Льна собрано: {5CF5FF}" .. linen .. "{B7B7B7} or {079400}" .. separator(linen * cashLinen) .. "$",0xB7B7B7)
				end
			end	
			if setAchiev.v then
				if text == "cotton + 1" or text == "cotton + 2" then achievements() end
				if text == "linen + 1"  or text == "linen + 2"  then achievements() end
			end	
			save_settings()
end
----------------------------------------------
-- Вызов главного меню настроек
----------------------------------------------
function cmd_ferma()
	showMainWindow.v = not showMainWindow.v
	imgui.Process = showMainWindow.v
end
----------------------------------------------
-- Деление числа на разряды
----------------------------------------------
function separator(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end
