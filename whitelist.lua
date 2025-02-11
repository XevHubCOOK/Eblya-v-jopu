local json = require('json')
local http = require('socket.http')  -- Убедитесь, что у вас есть библиотека "socket"
local ltn12 = require('ltn12')

local webhookNewUser = "https://discord.com/api/webhooks/1338599467397681252/nlIjYRjttLinuVIPkzuzYQsQu0kDqIv9hJ654mXfxzZnFRAyDwlq3A3fbFiJ4CQLut7W"
local webhookInjection = "https://discord.com/api/webhooks/1338599469884903534/TVaoK7mMISrSVXQ7m21DxjcBtJ4YMJV5PG608ZYQhAw3-EPK7f_Gbc_jZ0gb-LCHX8TI"

local whitelist = {
    "969305728600907866",
    "1338578838740799488",
    "717688003354689569",
}

local userHWIDs = {}

-- Функция для отправки сообщения в Discord через webhook
local function sendToDiscord(webhookUrl, message)
    local data = json.encode({content = message})  -- Кодируем сообщение в JSON
    local response_body = {}
    
    -- Отправка POST запроса
    local res, code, response_headers = http.request({
        url = webhookUrl,
        method = "POST",
        headers = {["Content-Type"] = "application/json"},
        source = ltn12.source.string(data),
        sink = ltn12.sink.table(response_body)
    })
    
    if code ~= 204 then
        print("Ошибка отправки сообщения: " .. table.concat(response_body))
    end
end

-- Проверка, есть ли пользователь в whitelist
local function checkUser(discordId)
    for _, id in ipairs(whitelist) do
        if id == discordId then
            return true
        end
    end
    return false
end

-- Получение HWID пользователя
local function generateHWID()
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local hwid = ''
    for i = 1, 20 do
        local randIndex = math.random(1, #chars)
        hwid = hwid .. chars:sub(randIndex, randIndex)
    end
    return hwid
end

local function getHWID()
    return generateHWID()
end


-- Регистрация пользователя
local function registerUser(discordId)
    local hwid = getHWID()

    if not checkUser(discordId) then
        table.insert(whitelist, discordId)  -- Добавляем пользователя в whitelist
        userHWIDs[discordId] = hwid  -- Сохраняя HWID пользователя
        sendToDiscord(webhookNewUser, "Пользователь зарегистрирован: " .. discordId .. " с HWID: " .. hwid)
    else
        sendToDiscord(webhookNewUser, "Пользователь уже зарегистрирован: " .. discordId .. " с HWID: " .. userHWIDs[discordId])
    end
end

-- Обработка инъекции
local function handleInjection(discordId)
    if checkUser(discordId) then
        sendToDiscord(webhookInjection, "Пользователь с ID " .. discordId .. " инжектнул скрипт с HWID: " .. hwid)
        -- Запуск скрипта
        loadstring(game:HttpGet("yourscript"))() -- не забудьте заменить "yourscript" на вашу ссылку
    else
        sendToDiscord(webhookInjection, "Пользователь с ID " .. discordId .. " пытался инжектнуть скрипт, но не в whitelist!")
    end
end

-- Пример использования
local discordId = "717688003354689569" 
registerUser(discordId)
handleInjection(discordId)
