-- Сервисы
local Players = service_or_players_fallback or game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Состояние функций (Toggle-переключатели)
local Config = {
    ESP_Players = true,
    ESP_Weapons = true, -- Пистолет и летящий нож
    Aimbot_Notification = true -- Уведомления об опасности
}

-- Создание красивого GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Minimenu"
-- Защита GUI от детекта (если поддерживает эксплойт)
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Меню можно перетаскивать мышкой
MainFrame.Parent = ScreenGui

-- Скругление углов главного окна
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Шапка меню
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

-- Исправление нижних углов шапки, чтобы были прямыми
local FixCorner = Instance.new("Frame")
FixCorner.Size = UDim2.new(1, 0, 0, 5)
FixCorner.Position = UDim2.new(0, 0, 1, -5)
FixCorner.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
FixCorner.BorderSizePixel = 0
FixCorner.Parent = TopBar

-- Название в шапке
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Text = "MM2 Mini Menu"
Title.Parent = TopBar

-- Кнопка закрытия (Крестик)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -28, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Кнопка сворачивания в мини-квадрат (-)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -58, 0, 2.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- Контейнер для кнопок функций
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -35)
ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Функция создания переключателей (Toggle)
local function createToggle(name, defaultState, callback, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, positionY)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(50, 150, 75) or Color3.fromRGB(60, 60, 70)
    btn.Text = "  " .. name .. ": " .. (defaultState and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ContentContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(50, 150, 75) or Color3.fromRGB(60, 60, 70)
        btn.Text = "  " .. name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

-- Создаем переключатели в меню
createToggle("Player ESP", Config.ESP_Players, function(state)
    Config.ESP_Players = state
end, 10)

createToggle("Weapons/Drops ESP", Config.ESP_Weapons, function(state)
    Config.ESP_Weapons = state
end, 55)

-- Логика свертывания в мини-квадрат
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ContentContainer.Visible = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 120, 0, 30)
        MinimizeButton.Text = "+"
        Title.Text = "MM2 Menu"
    else
        MainFrame.Size = UDim2.new(0, 220, 0, 180)
        MinimizeButton.Text = "-"
        Title.Text = "MM2 Mini Menu"
    end
end)

-- Полное закрытие меню по крестику
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- --- ОСНОВНАЯ ЛОГИКА СКРИПТА ---

-- Определение роли игрока
local function getPlayerRole(player)
    if not player.Character then return "Innocent", Color3.fromRGB(0, 255, 0) end
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if (character:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun"))) then
        if character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
            return "Murderer", Color3.fromRGB(255, 0, 0)
        end
        return "Sheriff", Color3.fromRGB(0, 170, 255)
    elseif (character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))) then
        return "Murderer", Color3.fromRGB(255, 0, 0)
    end
    
    return "Innocent", Color3.fromRGB(0, 255, 0)
end

-- Логика ESP игроков
local function setupESP(player)
    if player == LocalPlayer then return end
    
    local function onCharacterAdded(character)
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        
        if character:FindFirstChild("MM2_ESP_Tag") then
            character.MM2_ESP_Tag:Destroy()
        end
        
        local billBoard = Instance.new("BillboardGui")
        billBoard.Name = "MM2_ESP_Tag"
        billBoard.Size = UDim2.new(0, 200, 0, 50)
        billBoard.StudsOffset = Vector3.new(0, 3, 0)
        billBoard.AlwaysOnTop = true
        billBoard.Adornee = rootPart
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextSize = 13
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = billBoard
        
        billBoard.Parent = character
        
        RunService.RenderStepped:Connect(function()
            if not Config.ESP_Players or not character or not rootPart or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                billBoard.Enabled = false
                return
            end
            
            billBoard.Enabled = true
            local role, color = getPlayerRole(player)
            local distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
            
            textLabel.TextColor3 = color
            textLabel.Text = string.format("[%s]\n%s | %dm", player.Name, role, distance)
        end)
    end
    
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        task.spawn(function() onCharacterAdded(player.Character) end)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    setupESP(p
end
Players.PlayerAdded:Connect(setupESP)

-- ESP на оружие и дропы (с учетом кнопки включения/выключения)
RunService.RenderStepped:Connect(function()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if Config.ESP_Weapons then
            if obj.Name == "GunDrop" or obj.Name == "KnifeProjectile" then
                if not obj:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = (obj.Name == "GunDrop") and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(255, 0, 0)
                    hl.Parent = obj
                end
            end
        else
            -- Удаляем подсветку, если функция выключена
            if obj.Name == "GunDrop" or obj.Name == "KnifeProjectile" then
                local hl = obj:FindFirstChild("Highlight")
                if hl then hl:Destroy() end
            end
        end
    end
end)

print("MM2 Mini Menu Loaded!")
рь
