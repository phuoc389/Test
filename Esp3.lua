local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Hàm vẽ ESP
local function createESP(player)
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name
    espFolder.Parent = game.CoreGui
    
    -- Tạo box hiển thị quanh nhân vật
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 100, 0, 100)
    box.Position = UDim2.new(0, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Màu viền Box
    box.BorderSizePixel = 2
    box.Visible = false
    box.Parent = espFolder
    
    -- Tạo tên hiển thị trên đầu nhân vật
    local nameTag = Instance.new("TextLabel")
    nameTag.Size = UDim2.new(0, 100, 0, 20)
    nameTag.Position = UDim2.new(0, 0, 0, -20)
    nameTag.BackgroundTransparency = 1
    nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Màu chữ
    nameTag.TextSize = 14
    nameTag.Text = player.Name
    nameTag.Parent = espFolder

    -- Tạo khoảng cách hiển thị
    local distanceTag = Instance.new("TextLabel")
    distanceTag.Size = UDim2.new(0, 100, 0, 20)
    distanceTag.Position = UDim2.new(0, 0, 0, 20)
    distanceTag.BackgroundTransparency = 1
    distanceTag.TextColor3 = Color3.fromRGB(255, 255, 255)  -- Màu chữ
    distanceTag.TextSize = 14
    distanceTag.Text = "0 studs"
    distanceTag.Parent = espFolder
    
    -- Cập nhật thông tin ESP mỗi frame
    RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Lấy vị trí của người chơi
            local headPosition, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            
            -- Nếu player nằm trong tầm nhìn
            if onScreen then
                -- Hiển thị Box và tên
                box.Visible = true
                nameTag.Visible = true
                distanceTag.Visible = true
                
                -- Cập nhật vị trí Box, tên và khoảng cách
                box.Position = UDim2.new(0, headPosition.X - 50, 0, headPosition.Y - 50)
                nameTag.Position = UDim2.new(0, headPosition.X - 50, 0, headPosition.Y - 70)
                distanceTag.Position = UDim2.new(0, headPosition.X - 50, 0, headPosition.Y + 20)
                
                -- Cập nhật khoảng cách
                local distance = (player.Character.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
                distanceTag.Text = string.format("%.0f studs", distance)
            else
                -- Ẩn Box và tên nếu người chơi ngoài tầm nhìn
                box.Visible = false
                nameTag.Visible = false
                distanceTag.Visible = false
            end
        else
            -- Ẩn ESP khi nhân vật chết hoặc không có humanoid
            box.Visible = false
            nameTag.Visible = false
            distanceTag.Visible = false
        end
    end)
end

-- Gọi hàm tạo ESP cho mỗi người chơi
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        createESP(player)
    end
end

-- Lắng nghe khi có người chơi mới vào game
Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        createESP(player)
    end
end)

-- Xóa ESP khi người chơi rời game
Players.PlayerRemoving:Connect(function(player)
    if player ~= Players.LocalPlayer then
        local espFolder = game.CoreGui:FindFirstChild(player.Name)
        if espFolder then
            espFolder:Destroy()
        end
    end
end)
