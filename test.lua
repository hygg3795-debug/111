loadstring(game:HttpGet("https://hygg3795-debug.github.io/111/kskbl.lua"))()

local win = WindUI.Window({
    Title = "测试窗口",
    Folder = "TestConfig",
    Size = UDim2.new(0, 400, 0, 350),
})

local tab = win:Tab({Title = "功能"})

tab:Button({
    Title = "点击我",
    Callback = function()
        win:Notify({Title = "提示", Content = "你点击了按钮！", Duration = 3})
    end,
})

tab:Toggle({
    Title = "开关测试",
    Value = false,
    Callback = function(val) print("开关:", val) end,
})

win:Open()
