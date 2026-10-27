-- IGRIS | Player ESP + Aimbot
-- Minimal rewrite based on the Player Chams feature of Igris_Hub_deobfuscated.lua.
-- Player ESP and local-player ESP retained. Monster ESP and unrelated features removed.
-- Mouse: hold RMB to aim. Mobile: tap AIM to start/stop a timed aim session.
-- Aim Duration: 0 = unlimited until stopped; otherwise seconds per activation.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local env = (type(getgenv) == "function" and getgenv()) or _G
if type(env.IgrisPlayerAimCleanup) == "function" then
    pcall(env.IgrisPlayerAimCleanup)
end

local S = {
    ESP = false,
    LocalESP = false,
    LocalFill = Color3.fromRGB(80, 180, 255),
    LocalOutline = Color3.fromRGB(170, 220, 255),
    Fill = Color3.fromRGB(0, 200, 100),
    Outline = Color3.fromRGB(120, 255, 170),
    FillTransparency = 0.55,
    OutlineTransparency = 0,
    AimEnabled = false,
    FOV = 145,
    ShowFOV = true,
    Speed = 8,
    Duration = 2,
}

local alive = true
local playerChams = {}
local connections = {}
local aimActive = false
local mouseHeld = false
local aimExpires = math.huge
local target = nil
local lastESPUpdate = 0

local function connect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(connections, conn)
    return conn
end

local function removeHighlight(player)
    local cham = playerChams[player]
    playerChams[player] = nil
    if cham then pcall(function() cham:Destroy() end) end
end

local function refreshESP(player)
    if not alive then return end
    local isLocal = player == LocalPlayer
    if not (isLocal and S.LocalESP or not isLocal and S.ESP) then
        removeHighlight(player)
        return
    end
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not humanoid or humanoid.Health <= 0 then
        removeHighlight(player)
        return
    end

    local cham = playerChams[player]
    if not cham or not cham.Parent or cham.Adornee ~= char then
        removeHighlight(player)
        cham = Instance.new("Highlight")
        cham.Name = isLocal and "Igris_LocalESP" or "Igris_PlayerESP"
        cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        cham.Adornee = char
        cham.Parent = char
        playerChams[player] = cham
    end
    cham.Enabled = true
    cham.FillColor = isLocal and S.LocalFill or S.Fill
    cham.OutlineColor = isLocal and S.LocalOutline or S.Outline
    cham.FillTransparency = S.FillTransparency
    cham.OutlineTransparency = S.OutlineTransparency
end

local function refreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        refreshESP(p)
    end
end

local overlay = Instance.new("ScreenGui")
overlay.Name = "IgrisAimOverlay"
overlay.ResetOnSpawn = false
overlay.IgnoreGuiInset = true
overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
overlay.DisplayOrder = 2000
overlay.Parent = LocalPlayer:WaitForChild("PlayerGui")

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOV"
fovCircle.Parent = overlay
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Size = UDim2.fromOffset(S.FOV * 2, S.FOV * 2)
fovCircle.Visible = false
local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = fovCircle
local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(70, 150, 255)
circleStroke.Thickness = 1.3
circleStroke.Transparency = 0.26
circleStroke.Parent = fovCircle

local aimButton = Instance.new("TextButton")
aimButton.Name = "AIMButton"
aimButton.Parent = overlay
aimButton.Position = UDim2.fromOffset(12, 240)
aimButton.Size = UDim2.fromOffset(66, 36)
aimButton.BackgroundColor3 = Color3.fromRGB(29, 30, 34)
aimButton.TextColor3 = Color3.fromRGB(244, 244, 247)
aimButton.Text = "AIM OFF"
aimButton.TextSize = 12
aimButton.Font = Enum.Font.GothamSemibold
aimButton.AutoButtonColor = false
aimButton.Active = true
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = aimButton
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(103, 105, 110)
buttonStroke.Transparency = 0.3
buttonStroke.Thickness = 1
buttonStroke.Parent = aimButton

local function updateOverlay()
    fovCircle.Size = UDim2.fromOffset(S.FOV * 2, S.FOV * 2)
    fovCircle.Visible = alive and S.AimEnabled and S.ShowFOV
    aimButton.Visible = alive and S.AimEnabled
    aimButton.Text = aimActive and "AIM ON" or "AIM OFF"
    aimButton.BackgroundColor3 = aimActive and Color3.fromRGB(65, 66, 73)
        or Color3.fromRGB(29, 30, 34)
end

local function beginAim()
    if not alive or not S.AimEnabled then return end
    aimActive = true
    target = nil
    aimExpires = S.Duration > 0 and (os.clock() + S.Duration) or math.huge
    updateOverlay()
end

local function stopAim()
    aimActive = false
    target = nil
    updateOverlay()
end

-- Reposition AIM on touch/mouse drag; clicking toggles a timed aim session.
local dragging, dragInput, dragStart, buttonStart, moved = false, nil, nil, nil, false
connect(aimButton.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragInput = input
        dragStart = input.Position
        buttonStart = aimButton.Position
        moved = false
    end
end)
connect(UIS.InputChanged, function(input)
    if not dragging or not dragStart then return end
    if input ~= dragInput and not (dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement) then return end
    local delta = input.Position - dragStart
    if delta.Magnitude > 9 then moved = true end
    if moved then
        local camera = Workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(600, 400)
        aimButton.Position = UDim2.fromOffset(
            math.clamp(buttonStart.X.Offset + delta.X, 2, math.max(2, viewport.X - 70)),
            math.clamp(buttonStart.Y.Offset + delta.Y, 2, math.max(2, viewport.Y - 40))
        )
    end
end)
connect(UIS.InputEnded, function(input)
    if dragging and (input == dragInput or
        (dragInput.UserInputType == Enum.UserInputType.MouseButton1
         and input.UserInputType == Enum.UserInputType.MouseButton1)) then
        dragging = false
        dragInput = nil
        if not moved and S.AimEnabled then
            if aimActive then stopAim() else beginAim() end
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        mouseHeld = false
        if aimActive then stopAim() end
    end
end)
connect(UIS.InputBegan, function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and S.AimEnabled then
        mouseHeld = true
        beginAim()
    end
end)

local function isValidAimTarget(player)
    if player == LocalPlayer then return nil end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return nil end
    return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function chooseTarget(camera)
    local viewport = camera.ViewportSize
    local center = viewport * 0.5
    local best, bestDist = nil, S.FOV
    for _, p in ipairs(Players:GetPlayers()) do
        local part = isValidAimTarget(p)
        if part then
            local point, visible = camera:WorldToViewportPoint(part.Position)
            if visible and point.Z > 0 then
                local dist = (Vector2.new(point.X, point.Y) - center).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = p
                end
            end
        end
    end
    return best
end

local function updateAim(dt)
    if not alive or not S.AimEnabled or not aimActive then return end
    if os.clock() >= aimExpires then
        stopAim()
        return
    end
    local camera = Workspace.CurrentCamera
    if not camera then return end

    -- Keep the current target while it stays within FOV; otherwise retarget.
    local part = target and isValidAimTarget(target)
    if part then
        local point, visible = camera:WorldToViewportPoint(part.Position)
        if not visible or point.Z <= 0 or
            (Vector2.new(point.X, point.Y) - camera.ViewportSize * 0.5).Magnitude > S.FOV then
            part = nil
        end
    end
    if not part then
        target = chooseTarget(camera)
        part = target and isValidAimTarget(target)
    end
    if not part then return end

    local current = camera.CFrame
    local difference = part.Position - current.Position
    if difference.Magnitude < 0.01 then return end
    local desired = CFrame.lookAt(current.Position, part.Position)
    -- Frame-rate independent turn speed: 1 = slow, 20 = quick.
    local alpha = math.clamp(1 - math.exp(-S.Speed * dt), 0, 1)
    camera.CFrame = current:Lerp(desired, alpha)
end

local renderName = "Igris_PlayerESP_Aimbot_Smooth"
RunService:BindToRenderStep(renderName, Enum.RenderPriority.Camera.Value + 15, function(dt)
    if not alive then return end
    updateAim(dt)
    if os.clock() - lastESPUpdate > 0.5 then
        lastESPUpdate = os.clock()
        refreshAllESP()
    end
end)

connect(Players.PlayerRemoving, function(p)
    removeHighlight(p)
    if target == p then target = nil end
end)
connect(Players.PlayerAdded, function(p)
    connect(p.CharacterAdded, function()
        task.defer(function() if alive then refreshESP(p) end end)
    end)
end)
for _, p in ipairs(Players:GetPlayers()) do
    connect(p.CharacterAdded, function()
        task.defer(function() if alive then refreshESP(p) end end)
    end)
end

local rayfield = nil
local function cleanup()
    if not alive then return end
    alive = false
    pcall(function() RunService:UnbindFromRenderStep(renderName) end)
    for p in pairs(playerChams) do removeHighlight(p) end
    for _, conn in ipairs(connections) do pcall(function() conn:Disconnect() end) end
    table.clear(connections)
    pcall(function() overlay:Destroy() end)
    if rayfield then pcall(function() rayfield:Destroy() end) end
    if env.IgrisPlayerAimCleanup == cleanup then env.IgrisPlayerAimCleanup = nil end
end
env.IgrisPlayerAimCleanup = cleanup

-- Keep Rayfield, as used by the original IGRIS Hub. No monster tab or other features.
local ok, lib = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not ok or type(lib) ~= "table" then
    warn("IGRIS: Rayfield did not load; player ESP / aimbot UI unavailable.")
    cleanup()
    return
end
rayfield = lib

local window = rayfield:CreateWindow({
    Name = "IGRIS | ESP + Aim",
    LoadingTitle = "IGRIS",
    LoadingSubtitle = "Player ESP | Aimbot",
    KeySystem = false,
    ConfigurationSaving = { Enabled = false },
})
local visuals = window:CreateTab("Player ESP", 4483362458)
visuals:CreateToggle({
    Name = "Player ESP (others)", Flag = "IgrisPlayerOnlyESP", CurrentValue = false,
    Callback = function(v)
        S.ESP = v == true
        refreshAllESP()
    end,
})
visuals:CreateToggle({
    Name = "Local Player ESP (self)", Flag = "IgrisLocalESP", CurrentValue = false,
    Callback = function(v)
        S.LocalESP = v == true
        refreshESP(LocalPlayer)
    end,
})
visuals:CreateColorPicker({
    Name = "Local Fill Color", Flag = "IgrisLocalFill", Color = S.LocalFill,
    Callback = function(v) S.LocalFill = v; refreshESP(LocalPlayer) end,
})
visuals:CreateColorPicker({
    Name = "Local Outline Color", Flag = "IgrisLocalOutline", Color = S.LocalOutline,
    Callback = function(v) S.LocalOutline = v; refreshESP(LocalPlayer) end,
})
visuals:CreateColorPicker({
    Name = "Player Fill Color", Flag = "IgrisPlayerFill", Color = S.Fill,
    Callback = function(v) S.Fill = v; refreshAllESP() end,
})
visuals:CreateColorPicker({
    Name = "Player Outline Color", Flag = "IgrisPlayerOutline", Color = S.Outline,
    Callback = function(v) S.Outline = v; refreshAllESP() end,
})
visuals:CreateSlider({
    Name = "Fill Transparency", Flag = "IgrisFillTransparency",
    Range = {0, 1}, Increment = 0.05, CurrentValue = S.FillTransparency,
    Callback = function(v) S.FillTransparency = v; refreshAllESP() end,
})
visuals:CreateSlider({
    Name = "Outline Transparency", Flag = "IgrisOutlineTransparency",
    Range = {0, 1}, Increment = 0.05, CurrentValue = S.OutlineTransparency,
    Callback = function(v) S.OutlineTransparency = v; refreshAllESP() end,
})

local aim = window:CreateTab("Aimbot", 4483362458)
aim:CreateToggle({
    Name = "Enable Aimbot", Flag = "IgrisAimEnabled", CurrentValue = false,
    Callback = function(v)
        S.AimEnabled = v == true
        if not S.AimEnabled then stopAim() end
        updateOverlay()
    end,
})
aim:CreateSlider({
    Name = "FOV Radius", Flag = "IgrisAimFOV", Range = {25, 400},
    Increment = 5, CurrentValue = S.FOV, Suffix = "px",
    Callback = function(v) S.FOV = v; updateOverlay() end,
})
aim:CreateToggle({
    Name = "Show FOV Circle", Flag = "IgrisAimShowFOV", CurrentValue = true,
    Callback = function(v) S.ShowFOV = v == true; updateOverlay() end,
})
aim:CreateSlider({
    Name = "Aim Speed", Flag = "IgrisAimSpeed", Range = {1, 20},
    Increment = 1, CurrentValue = S.Speed,
    Callback = function(v) S.Speed = v end,
})
aim:CreateSlider({
    Name = "Aim Duration", Flag = "IgrisAimDuration", Range = {0, 10},
    Increment = 0.5, Suffix = "s", CurrentValue = S.Duration,
    Callback = function(v) S.Duration = v end,
})
aim:CreateButton({ Name = "Stop Aiming", Callback = stopAim })

updateOverlay()
refreshAllESP()
