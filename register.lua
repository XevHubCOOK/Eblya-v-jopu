local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = "XEV | Registration",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Main'),

}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Registration')

LeftGroupBox:AddLabel('Enter your Discord user ID')

local userIdBox = LeftGroupBox:AddInput('UserIdInput', {
    Default = '',
    Numeric = false,
    Finished = false,
    Text = 'Discord ID',
    Tooltip = 'Enter your Discord user ID',
    Placeholder = 'sent your ID',
    Callback = function(Value)
        print('[cb] Discord ID updated. New text:', Value)
    end
})

local registerButton = LeftGroupBox:AddButton({
    Text = 'Register',
    Func = function()
        local userId = Options.UserIdInput.Value
        if userId ~= "" then
            print("Registered Discord ID: " .. userId)
            -- Здесь можно добавить логику для обработки регистрации
        else
            print("Please enter a valid Discord ID")
        end
    end,
    DoubleClick = false,
    Tooltip = 'Click to register'
})

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('XevHub')
SaveManager:SetFolder('XevHub/games')



SaveManager:LoadAutoloadConfig()
