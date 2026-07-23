local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()
local BRAND = {name = "hygg脚本", version = "v1.0", author = "hygg", folder = "hyggHub", icon = "zap", theme = "Dark", accent = "#FF6B35"}
local Window = WindUI:CreateWindow({
Title = BRAND.name, Icon = BRAND.icon, IconThemed = true, Author = BRAND.version, Folder = BRAND.folder,
Size = UDim2.fromOffset(640, 420), Transparent = true, Theme = BRAND.theme, HideSearchBar = false, Resizable = true,
SideBarWidth = 240,
BackgroundTransparency = 0.5,
Search = {Enabled = true, Placeholder = "搜索...", Callback = function(text) end},
User = {Enabled = true, Callback = function() WindUI:Notify({Title = "玩家信息", Content = game.Players.LocalPlayer.Name, Duration = 2, Icon = "user"}) end},
})
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = "https://hygg3795-debug.github.io/111/bg.jpg"
bg.BackgroundTransparency = 1
bg.ScaleType = Enum.ScaleType.Fit
bg.Parent = Window.UIElements.Main
Window:CreateTopbarButton("ThemeToggle", "moon", function()
local current = WindUI:GetCurrentTheme()
if current == "Light" then WindUI:SetTheme("Dark") WindUI:Notify({Title = "已切换暗黑主题", Duration = 2, Icon = "moon"})
else WindUI:SetTheme("Light") WindUI:Notify({Title = "已切换明亮主题", Duration = 2, Icon = "sun"}) end
end, 990)
Window:EditOpenButton({
Title = BRAND.name, Icon = BRAND.icon, CornerRadius = UDim.new(0, 26), StrokeThickness = 4,
Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("ADD8E6")), ColorSequenceKeypoint.new(0.5, Color3.fromHex("4169E1")), ColorSequenceKeypoint.new(1, Color3.fromHex("ADD8E6"))}),
Draggable = true,
})
Window:Tag({Title = BRAND.name .. " " .. BRAND.version, Color = Color3.fromHex(BRAND.accent)})
local timeTag = Window:Tag({Title = os.date("%H:%M:%S"), Color = Color3.fromHex("#00ffff")})
task.spawn(function() while Window do task.wait(1) pcall(function() timeTag:SetTitle(os.date("%H:%M:%S")) end) end end)

local tab = Window:Tab({Title = "通用", Icon = "settings"})

local jumpApi = nil
local walkApi = nil
local spinApi = nil
local espApi = nil

tab:Toggle({
Title = "防踢",
Value = false,
Callback = function(val)
if val then
local vu = game:GetService("VirtualUser")
local con = game.Players.LocalPlayer.Idled:Connect(function()
vu:CaptureController()
vu:ClickButton2(Vector2.new())
end)
_G.AntiAFKCon = con
else
if _G.AntiAFKCon then _G.AntiAFKCon:Disconnect() _G.AntiAFKCon = nil end
end
end,
})

local flyEnabled = false
local flyConnections = {}
local flyBody = {}
tab:Toggle({
Title = "飞行",
Value = false,
Callback = function(val)
flyEnabled = val
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")
if val then
if hum then
for _,state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
hum:SetStateEnabled(state, false)
end
hum:ChangeState(Enum.HumanoidStateType.Swimming)
end
if char.Animate then char.Animate.Disabled = true end
local bg = Instance.new("BodyGyro", root)
bg.P = 9e4
bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
bg.CFrame = root.CFrame
local bv = Instance.new("BodyVelocity", root)
bv.Velocity = Vector3.new(0,0,0)
bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
if hum then hum.PlatformStand = true end
flyBody = {bg = bg, bv = bv}
local conn
conn = game:GetService("RunService").RenderStepped:Connect(function()
if not flyEnabled or not char or not hum or hum.Health <= 0 then
conn:Disconnect()
return
end
if root then bg.CFrame = workspace.CurrentCamera.CoordinateFrame end
end)
table.insert(flyConnections, conn)
local conn2
conn2 = game:GetService("RunService").Heartbeat:Connect(function()
if not flyEnabled or not char or not hum then return end
if hum.MoveDirection.Magnitude > 0 then
char:TranslateBy(hum.MoveDirection * 1)
end
end)
table.insert(flyConnections, conn2)
else
if hum then
for _,state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
hum:SetStateEnabled(state, true)
end
hum:ChangeState(Enum.HumanoidStateType.Running)
hum.PlatformStand = false
end
if char.Animate then char.Animate.Disabled = false end
if flyBody.bg then flyBody.bg:Destroy() end
if flyBody.bv then flyBody.bv:Destroy() end
flyBody = {}
for _,c in pairs(flyConnections) do pcall(function() c:Disconnect() end) end
flyConnections = {}
end
end,
})

local function noFall()local plr=game.Players.LocalPlayer local con=nil local charCon=nil local z=Vector3.zero local function bind(c)local r=c:WaitForChild("HumanoidRootPart")if r then if con then con:Disconnect()con=nil end con=game:GetService("RunService").Heartbeat:Connect(function()if not r.Parent then con:Disconnect()con=nil return end local v=r.AssemblyLinearVelocity r.AssemblyLinearVelocity=z game:GetService("RunService").RenderStepped:Wait()r.AssemblyLinearVelocity=v end)end end local function start()if charCon then charCon:Disconnect()end bind(plr.Character)charCon=plr.CharacterAdded:Connect(bind)end local function stop()if con then con:Disconnect()con=nil end if charCon then charCon:Disconnect()charCon=nil end end return{start=start,stop=stop}end
tab:Toggle({Title="防摔",Value=false,Callback=function(val)local api=_G.NoFallAPI if not api then api=noFall()_G.NoFallAPI=api end if val then api.start()else api.stop()end end})

tab:Toggle({
Title = "无限跳",
Value = false,
Callback = function(val)
local uis = game:GetService("UserInputService")
if val then
local conn
conn = uis.JumpRequest:Connect(function()
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local hum = plr.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end)
_G.InfJumpCon = conn
else
if _G.InfJumpCon then _G.InfJumpCon:Disconnect() _G.InfJumpCon = nil end
end
end,
})

local jumpHeight = 50
local walkSpeed = 16

local function createStepControl(title, minVal, maxVal, step, getVal, setVal)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundTransparency = 1
    frame.Parent = tab

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.35, 0, 1, 0)
    label.Text = title
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local display = Instance.new("TextLabel")
    display.Size = UDim2.new(0.15, 0, 1, 0)
    display.Position = UDim2.new(0.4, 0, 0, 0)
    display.Text = tostring(getVal())
    display.TextColor3 = Color3.fromRGB(255, 255, 255)
    display.BackgroundTransparency = 1
    display.Font = Enum.Font.GothamBold
    display.TextSize = 16
    display.Parent = frame

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0, 30, 0, 30)
    minus.Position = UDim2.new(0.65, 0, 0.5, -15)
    minus.Text = "-"
    minus.TextColor3 = Color3.fromRGB(255, 255, 255)
    minus.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 20
    minus.Parent = frame
    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 6)
    mc.Parent = minus

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0, 30, 0, 30)
    plus.Position = UDim2.new(0.8, 0, 0.5, -15)
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(255, 255, 255)
    plus.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 20
    plus.Parent = frame
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(0, 6)
    pc.Parent = plus

    local function updateDisplay()
        display.Text = tostring(getVal())
    end

    minus.MouseButton1Click:Connect(function()
        local newVal = math.max(minVal, getVal() - step)
        setVal(newVal)
        updateDisplay()
    end)

    plus.MouseButton1Click:Connect(function()
        local newVal = math.min(maxVal, getVal() + step)
        setVal(newVal)
        updateDisplay()
    end)

    return {update = updateDisplay}
end

local jumpControl = createStepControl("跳跃高度", 7.2, 200, 5,
    function() return jumpHeight end,
    function(val)
        jumpHeight = val
        if not jumpApi then
            loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/6.txt"))()
            jumpApi = getgenv().JumpControl
            if jumpApi then jumpApi:start() end
        end
        if jumpApi then jumpApi:setJumpHeight(val) end
    end
)

local walkControl = createStepControl("步行速度", 16, 400, 10,
    function() return walkSpeed end,
    function(val)
        walkSpeed = val
        if not walkApi then
            loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/7.txt"))()
            walkApi = getgenv().WalkControl
            if walkApi then walkApi:start() end
        end
        if walkApi then walkApi:setWalkSpeed(val) end
    end
)

tab:Toggle({
Title = "旋转模式",
Value = false,
Callback = function(val)
if not spinApi then
loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/8.txt"))()
spinApi = getgenv().SpinControl
if spinApi then spinApi:start() end
end
if spinApi then spinApi:setSpinEnabled(val) end
end,
})

tab:Slider({
Title = "旋转速度",
Value = {Min = 0, Max = 50, Default = 0},
Callback = function(val)
if not spinApi then
loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/8.txt"))()
spinApi = getgenv().SpinControl
if spinApi then spinApi:start() end
end
if spinApi then spinApi:setSpinSpeed(val) end
end,
})

tab:Toggle({
Title = "透视",
Value = false,
Callback = function(val)
if val then
if not espApi then
loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/10.txt"))()
espApi = getgenv().ESPControl
end
if espApi then espApi:start() end
else
if espApi then espApi:stop() end
end
end,
})

local blackholeTab = Window:Tab({Title = "黑洞", Icon = "circle"})

local bhConfig = {radius = 50, height = 100, speed = 10, strength = 1000}
local bhRunning = false
local bhApi = nil
local function toggleBlackhole(val)
bhRunning = val
if val then
if not bhApi then
local success, err = pcall(function()
loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/5.txt"))()
end)
if success then
bhApi = getgenv().RingControl
end
end
if bhApi then
bhApi:setRadius(bhConfig.radius)
bhApi:setHeight(bhConfig.height)
bhApi:setSpeed(bhConfig.speed)
bhApi:setStrength(bhConfig.strength)
bhApi:start()
WindUI:Notify({Title = "黑洞1", Content = "已开启", Duration = 2, Icon = "check"})
end
else
if bhApi then bhApi:stop() end
WindUI:Notify({Title = "黑洞1", Content = "已关闭", Duration = 2, Icon = "x"})
end
end
local section = blackholeTab:Section({
Title = "黑洞1",
Box = true,
})
section:Toggle({
Title = "开关",
Value = false,
Callback = function(val) toggleBlackhole(val) end,
})

local bh2Config = {radius = 50, height = 100, speed = 10, strength = 1000}
local bh2Running = false
local bh2Api = nil
local function toggleBH2(val)
bh2Running = val
if val then
if not bh2Api then
local success, err = pcall(function()
loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/9.txt"))()
end)
if success then
bh2Api = getgenv().RingControl2
end
end
if bh2Api then
bh2Api:setRadius(bh2Config.radius)
bh2Api:setHeight(bh2Config.height)
bh2Api:setSpeed(bh2Config.speed)
bh2Api:setStrength(bh2Config.strength)
bh2Api:start()
WindUI:Notify({Title = "黑洞2", Content = "已开启", Duration = 2, Icon = "check"})
end
else
if bh2Api then bh2Api:stop() end
WindUI:Notify({Title = "黑洞2", Content = "已关闭", Duration = 2, Icon = "x"})
end
end
local bh2Section = blackholeTab:Section({
Title = "黑洞2",
Box = true,
})
bh2Section:Toggle({
Title = "开关",
Value = false,
Callback = function(val) toggleBH2(val) end,
})

local superTab = Window:Tab({Title = "超人", Icon = "zap"})
superTab:Button({
Title = "祖国人",
Desc = "点击加载祖国人脚本",
Callback = function()
local success, err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/homelander-by-GioBolqv1-/refs/heads/main/homelander.lua"))()
end)
if success then
WindUI:Notify({Title = "祖国人", Content = "已加载", Duration = 2, Icon = "check"})
else
WindUI:Notify({Title = "加载失败", Content = tostring(err), Duration = 3, Icon = "alert"})
end
end,
})
superTab:Button({
Title = "无敌少侠",
Desc = "点击加载无敌少侠脚本",
Callback = function()
local success, err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/invincible-characters-animations-by-GioBolqv1-/refs/heads/main/universal.lua"))()
end)
if success then
WindUI:Notify({Title = "无敌少侠", Content = "已加载", Duration = 2, Icon = "check"})
else
WindUI:Notify({Title = "加载失败", Content = tostring(err), Duration = 3, Icon = "alert"})
end
end,
})
superTab:Button({
Title = "火车头",
Desc = "点击加载火车头脚本",
Callback = function()
local success, err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/A-Train-by-GioBolqv1-/refs/heads/main/train.lua"))()
end)
if success then
WindUI:Notify({Title = "火车头", Content = "已加载", Duration = 2, Icon = "check"})
else
WindUI:Notify({Title = "加载失败", Content = tostring(err), Duration = 3, Icon = "alert"})
end
end,
})

_G._LCF_WindUI = WindUI
_G._LCF_TmplWin = Window
print("[" .. BRAND.name .. "] UI 加载完成 ✅")
