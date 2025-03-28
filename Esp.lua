local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.UseTeamColor = true

local function createESP(player)
    local esp = {}

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = player.Character
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character

    -- Name + Distance Tag
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character:FindFirstChild("Head") or player.Character:WaitForChild("HumanoidRootPart")

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextStrokeTransparency = 0.5
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = player.Name
    text.Parent = billboard

    esp.Highlight = highlight
    esp.TextLabel = text
    esp.BillboardGui = billboard

    return esp
end

local function updateESP(espTable, player)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local distance = (Camera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude
    espTable.TextLabel.Text = string.format("%s\n%.0f studs", player.Name, distance)

    if _G.UseTeamColor then
        local color = (player.Team and player.Team.TeamColor.Color) or Color3.fromRGB(255, 255, 255)
        espTable.Highlight.OutlineColor = color
        espTable.TextLabel.TextColor3 = color
    else
        espTable.Highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        espTable.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

local ESPObjects = {}

local function setupESP(player)
    player.CharacterAdded:Connect(function()
        repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        ESPObjects[player] = createESP(player)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            ESPObjects[player] = createESP(player)
        end
        setupESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        setupESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Highlight then ESPObjects[player].Highlight:Destroy() end
        if ESPObjects[player].BillboardGui then ESPObjects[player].BillboardGui:Destroy() end
        ESPObjects[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            updateESP(esp, player)
        end
    end
end)
