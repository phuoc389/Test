-- ESP Drawing by lephuoc12
_G.ESPVisible = true
_G.TeamCheck = false
_G.SendNotifications = false
_G.DefaultSettings = false
_G.TextColor = Color3.fromRGB(255, 80, 10)
_G.TextSize = 14
_G.Center = true
_G.Outline = true
_G.OutlineColor = Color3.fromRGB(0, 0, 0)
_G.TextTransparency = 0.7
_G.TextFont = Drawing.Fonts.UI
_G.DisableKey = Enum.KeyCode.Q

local function API_Check()
    if Drawing == nil then
        return "No"
    else
        return "Yes"
    end
end

if API_Check() == "No" then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "lephuoc12";
        Text = "Thiết bị không hỗ trợ Drawing API.";
        Duration = 10;
    })
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Typing = false

local function CreateESP()
    local function AddESP(player)
        if player == LocalPlayer then return end
        local espText = Drawing.new("Text")

        RunService.RenderStepped:Connect(function()
            pcall(function()
                if player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
                    local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart")) and 
                        (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude or 0
                    
                    espText.Size = _G.TextSize
                    espText.Center = _G.Center
                    espText.Outline = _G.Outline
                    espText.OutlineColor = _G.OutlineColor
                    espText.Color = _G.TextColor
                    espText.Transparency = _G.TextTransparency
                    espText.Font = _G.TextFont
                    espText.Position = Vector2.new(pos.X, pos.Y - 25)

                    espText.Text = "("..math.floor(distance)..") "..player.Name.." ["..math.floor(player.Character.Humanoid.Health).."]"
                    if onScreen then
                        if _G.TeamCheck then
                            espText.Visible = LocalPlayer.Team ~= player.Team and _G.ESPVisible
                        else
                            espText.Visible = _G.ESPVisible
                        end
                    else
                        espText.Visible = false
                    end
                else
                    espText.Visible = false
                end
            end)
        end)
    end

    for _, player in ipairs(Players:GetPlayers()) do
        AddESP(player)
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            AddESP(player)
        end)
    end)
end

UserInputService.TextBoxFocused:Connect(function() Typing = true end)
UserInputService.TextBoxFocusReleased:Connect(function() Typing = false end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == _G.DisableKey and not Typing then
        _G.ESPVisible = not _G.ESPVisible
    end
end)

CreateESP()
