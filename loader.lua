local CoreGui = game:GetService("CoreGui")

-- Твоє посилання з Render (вже налаштоване під твій проект)
local RENDER_API = "https://my-keys-api.onrender.com/check?key="
-- Твоє посилання на Discord
local DISCORD_LINK = "https://discord.gg/JdTdKv5mdb"

-- Очищення старого GUI, якщо він залишився після попереднього запуску
pcall(function()
    if CoreGui:FindFirstChild("Key") then
        CoreGui.Key:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "Key system"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 320, 0, 210)
frame.Position = UDim2.new(0.5, -160, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
title.Text = "🔑 Key system"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.BorderSizePixel = 0

local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -38, 0, 2)
close.Text = "X"
close.TextScaled = true
close.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.BorderSizePixel = 0

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0, 280, 0, 40)
box.Position = UDim2.new(0, 20, 0, 60)
box.PlaceholderText = "Enter key..."
box.Text = ""
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
box.TextColor3 = Color3.new(1, 1, 1)
box.BorderSizePixel = 0

local status = Instance.new("TextLabel")
status.Parent = frame
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 108)
status.BackgroundTransparency = 1
status.Text = ""
status.TextScaled = true
status.TextColor3 = Color3.new(1, 1, 1)

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(0, 280, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 140)
btn.Text = "LOGIN"
btn.TextScaled = true
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.BorderSizePixel = 0

local keyBtn = Instance.new("TextButton")
keyBtn.Parent = frame
keyBtn.Size = UDim2.new(0, 280, 0, 25)
keyBtn.Position = UDim2.new(0, 20, 0, 183)
keyBtn.Text = "Get Key (Discord)"
keyBtn.TextScaled = true
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
keyBtn.TextColor3 = Color3.new(1, 1, 1)
keyBtn.BorderSizePixel = 0

-- Кнопка для отримання ключа через Discord
keyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_LINK)
        status.Text = "Discord link copied!"
    else
        status.Text = "Discord: " .. DISCORD_LINK
    end
end)

-- Кнопка логіну
btn.MouseButton1Click:Connect(function()
    local key = box.Text

    if key == "" then
        status.Text = "Enter key"
        return
    end

    status.Text = "Checking..."

    local ok, result = pcall(function()
        -- Запит до твого сервера Render з параметром nocache
        return game:HttpGet(RENDER_API .. key .. "&nocache=" .. math.random(1, 99999))
    end)

    if not ok then
        -- Якщо Render спить (Free Tier), він прокидається близько 30 секунд
        status.Text = "Server waking up... wait 30s"
        warn("Render wake-up required: " .. tostring(result))
        return
    end

    -- Обробка відповіді: прибираємо зайві пробіли та переводимо у верхній регістр
    local response = tostring(result):gsub("%s+", ""):upper()
    print("Server Response: [" .. response .. "]") -- Можна перевірити через F9

    if response == "VALID" then
        status.Text = "✅ Success!"
        wait(0.7)
        gui:Destroy()
        -- Завантаження твого основного скрипта з GitHub
        loadstring(game:HttpGet("https://raw.githubusercontent.com/smaikss/lumber-inc/main/main.lua"))()
    elseif response == "EXPIRED" then
        status.Text = "❌ Key expired"
    else
        status.Text = "❌ Invalid key"
    end
end)
