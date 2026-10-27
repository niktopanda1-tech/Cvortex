-- CVortex | Player ESP + Local ESP + Smooth Aimbot
-- Based on the IGRIS deobfuscated Player Chams feature.
-- Monster ESP and non-ESP modules are deliberately omitted.
-- Controls: mobile AIM button toggles aiming; on PC hold right mouse button.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

local env = (type(getgenv) == "function" and getgenv()) or _G
if type(env.CVortexPlayerAimCleanup) == "function" then
    pcall(env.CVortexPlayerAimCleanup)
end
-- Also stop the earlier IGRIS version to prevent overlapping camera writers.
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
    WallCheck = true,
    ShowFOV = true,
    FOV = 145,
    Speed = 10,
    Duration = 0, -- 0 = until the activation is released or turned off
    AimPart = "Head",
}

local alive = true
local connections = {}
local highlights = {}
local currentTarget = nil
local activation = nil -- nil, "touch", or "mouse"
local aimStartTime = 0
local espTimer = 0
local rayfield

local function connect(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(connections, conn)
    return conn
end

local function removeESP(player)
    local old = highlights[player]
    highlights[player] = nil
    if old then pcall(function() old:Destroy() end) end
end

local function refreshESP(player)
    if not alive then return end
    local selfPlayer = player == LocalPlayer
    local enabled = selfPlayer and S.LocalESP or (not selfPlayer and S.ESP)
    if not enabled then removeESP(player); return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid or humanoid.Health <= 0 then
        removeESP(player)
        return
    end

    local outline = highlights[player]
    if not outline or not outline.Parent or outline.Adornee ~= character then
        removeESP(player)
        outline = Instance.new("Highlight")
        outline.Name = selfPlayer and "CVortex_LocalESP" or "CVortex_PlayerESP"
        outline.Adornee = character
        outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        outline.Parent = character
        highlights[player] = outline
    end
    outline.Enabled = true
    outline.FillColor = selfPlayer and S.LocalFill or S.Fill
    outline.OutlineColor = selfPlayer and S.LocalOutline or S.Outline
    outline.FillTransparency = S.FillTransparency
    outline.OutlineTransparency = S.OutlineTransparency
end

local function refreshAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
        refreshESP(player)
    end
end

local overlay = Instance.new("ScreenGui")
overlay.Name = "CVortexAimOverlay"
overlay.ResetOnSpawn = false
overlay.IgnoreGuiInset = true
overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
overlay.DisplayOrder = 2500
overlay.Parent = LocalPlayer:WaitForChild("PlayerGui")

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Parent = overlay
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Size = UDim2.fromOffset(2 * S.FOV, 2 * S.FOV)
fovCircle.Visible = false
local roundFOV = Instance.new("UICorner")
roundFOV.CornerRadius = UDim.new(1, 0)
roundFOV.Parent = fovCircle
local fovOutline = Instance.new("UIStroke")
fovOutline.Color = Color3.fromRGB(55, 145, 255)
fovOutline.Thickness = 1.5
fovOutline.Transparency = 0.2
fovOutline.Parent = fovCircle

local aimButton = Instance.new("TextButton")
aimButton.Name = "AIMButton"
aimButton.Parent = overlay
aimButton.Position = UDim2.fromOffset(12, 240)
aimButton.Size = UDim2.fromOffset(72, 36)
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
    fovCircle.Visible = alive and S.AimEnabled and S.ShowFOV
    fovCircle.Size = UDim2.fromOffset(S.FOV * 2, S.FOV * 2)
    aimButton.Visible = alive and S.AimEnabled
    aimButton.Text = activation and "AIM ON" or "AIM OFF"
    aimButton.BackgroundColor3 = activation and Color3.fromRGB(66, 67, 74)
        or Color3.fromRGB(29, 30, 34)
end

local function stopAim()
    activation = nil
    currentTarget = nil
    updateOverlay()
end

local function startAim(mode)
    if not alive or not S.AimEnabled then return end
    activation = mode
    currentTarget = nil
    aimStartTime = os.clock()
    updateOverlay()
end

-- A single input ownership mode avoids mouse release cancelling mobile AIM.
local dragInput, dragStart, dragFrom, dragMoved = nil, nil, nil, false
connect(aimButton.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
        dragStart = input.Position
        dragFrom = aimButton.Position
        dragMoved = false
    end
end)
connect(UserInputService.InputChanged, function(input)
    if not dragInput or not dragStart then return end
    if input ~= dragInput and not (dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement) then return end
    local delta = input.Position - dragStart
    if delta.Magnitude > 8 then dragMoved = true end
    if dragMoved then
        local camera = Workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(600, 400)
        aimButton.Position = UDim2.fromOffset(
            math.clamp(dragFrom.X.Offset + delta.X, 3, math.max(3, viewport.X - 76)),
            math.clamp(dragFrom.Y.Offset + delta.Y, 3, math.max(3, viewport.Y - 40))
        )
    end
end)
connect(UserInputService.InputEnded, function(input)
    if dragInput and (input == dragInput
        or (dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1)) then
        local clicked = not dragMoved
        dragInput = nil
        dragStart = nil
        if clicked and S.AimEnabled then
            if activation == "touch" then
                stopAim()
            else
                startAim("touch")
            end
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2
        and activation == "mouse" then
        stopAim()
    end
end)
connect(UserInputService.InputBegan, function(input, processed)
    if not S.AimEnabled or UserInputService:GetFocusedTextBox() then return end
    -- Some games mark RMB as processed for their own camera controller.
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        startAim("mouse")
    end
end)

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function targetPartFor(player)
    if player == LocalPlayer or not player.Parent then return nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return nil end
    if S.AimPart == "Body" then
        return character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("HumanoidRootPart")
    end
    return character:FindFirstChild("Head")
        or character:FindFirstChild("HumanoidRootPart")
end

local function hasLineOfSight(camera, player, part)
    if not S.WallCheck then return true end
    local localCharacter = LocalPlayer.Character
    rayParams.FilterDescendantsInstances = localCharacter and {localCharacter} or {}
    local origin = camera.CFrame.Position
    local direction = part.Position - origin
    if direction.Magnitude <= 0.05 then return true end
    local hit = Workspace:Raycast(origin, direction, rayParams)
    return hit == nil or (player.Character ~= nil
        and hit.Instance:IsDescendantOf(player.Character))
end

local function targetScreenDistance(camera, player, extraRadius)
    local part = targetPartFor(player)
    if not part then return nil end
    local screen, onScreen = camera:WorldToViewportPoint(part.Position)
    if not onScreen or screen.Z <= 0 then return nil end
    local center = camera.ViewportSize * 0.5
    local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
    if dist > S.FOV + (extraRadius or 0) then return nil end
    if not hasLineOfSight(camera, player, part) then return nil end
    return part, dist
end

local function findClosestTarget(camera)
    local bestPlayer = nil
    local bestDistance = math.huge
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LocalPlayer then
            local part, distance = targetScreenDistance(camera, other, 0)
            if part and distance < bestDistance then
                bestPlayer = other
                bestDistance = distance
            end
        end
    end
    return bestPlayer
end

local function updateAim(dt)
    if not alive or not S.AimEnabled or not activation then return end
    if S.Duration > 0 and os.clock() - aimStartTime >= S.Duration then
        stopAim()
        return
    end
    local camera = Workspace.CurrentCamera
    if not camera or dt <= 0 then return end

    -- Keep the current target with a little FOV hysteresis to prevent jitter.
    local part = currentTarget and targetScreenDistance(camera, currentTarget, S.FOV * 0.12)
    if not part then
        currentTarget = findClosestTarget(camera)
        part = currentTarget and targetScreenDistance(camera, currentTarget, 0)
    end
    if not part then return end

    local current = camera.CFrame
    local direction = part.Position - current.Position
    if direction.Magnitude <= 0.1 then return end

    -- Exponential smoothing independent of the client's rendering FPS.
    -- Speed 1 is gentle, 20 nearly instantaneous. The camera position stays unchanged.
    local response = 0.65 + S.Speed * 1.65
    local alpha = math.clamp(1 - math.exp(-response * math.min(dt, 0.1)), 0, 1)
    local desired = CFrame.lookAt(current.Position, part.Position, Vector3.yAxis)
    camera.CFrame = current:Lerp(desired, alpha)
end

local renderName = "CVortex_PlayerESP_Aimbot_Render"
RunService:BindToRenderStep(renderName, Enum.RenderPriority.Camera.Value + 30, updateAim)

connect(RunService.Heartbeat, function(dt)
    if not alive then return end
    espTimer = espTimer + dt
    if espTimer >= 0.35 then
        espTimer = 0
        refreshAllESP()
    end
end)
connect(Players.PlayerRemoving, function(player)
    removeESP(player)
    if player == currentTarget then currentTarget = nil end
end)
local function listenToPlayer(player)
    connect(player.CharacterAdded, function()
        if player == currentTarget then currentTarget = nil end
        task.defer(function()
            if alive then refreshESP(player) end
        end)
    end)
end
connect(Players.PlayerAdded, listenToPlayer)
for _, player in ipairs(Players:GetPlayers()) do
    listenToPlayer(player)
end

local function cleanup()
    if not alive then return end
    alive = false
    pcall(function() RunService:UnbindFromRenderStep(renderName) end)
    for player in pairs(highlights) do removeESP(player) end
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(connections)
    pcall(function() overlay:Destroy() end)
    if rayfield then pcall(function() rayfield:Destroy() end) end
    if env.CVortexPlayerAimCleanup == cleanup then
        env.CVortexPlayerAimCleanup = nil
    end
end
env.CVortexPlayerAimCleanup = cleanup

local ok, lib = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not ok or type(lib) ~= "table" then
    warn("CVortex: Rayfield failed to load.")
    cleanup()
    return
end
rayfield = lib

local window = rayfield:CreateWindow({
    Name = "CVortex | ESP + Aimbot",
    LoadingTitle = "CVortex",
    LoadingSubtitle = "Player ESP | Smooth Aim",
    KeySystem = false,
    ConfigurationSaving = {Enabled = false},
})

local visuals = window:CreateTab("Player ESP", 4483362458)
visuals:CreateToggle({
    Name = "Player ESP (others)", Flag = "CVortexPlayerESP", CurrentValue = false,
    Callback = function(value)
        S.ESP = value == true
        refreshAllESP()
    end,
})
visuals:CreateToggle({
    Name = "Local Player ESP (self)", Flag = "CVortexLocalESP", CurrentValue = false,
    Callback = function(value)
        S.LocalESP = value == true
        refreshESP(LocalPlayer)
    end,
})
visuals:CreateColorPicker({
    Name = "Local Fill Color", Flag = "CVortexLocalFill", Color = S.LocalFill,
    Callback = function(value) S.LocalFill = value; refreshESP(LocalPlayer) end,
})
visuals:CreateColorPicker({
    Name = "Local Outline Color", Flag = "CVortexLocalOutline", Color = S.LocalOutline,
    Callback = function(value) S.LocalOutline = value; refreshESP(LocalPlayer) end,
})
visuals:CreateColorPicker({
    Name = "Player Fill Color", Flag = "CVortexPlayerFill", Color = S.Fill,
    Callback = function(value) S.Fill = value; refreshAllESP() end,
})
visuals:CreateColorPicker({
    Name = "Player Outline Color", Flag = "CVortexPlayerOutline", Color = S.Outline,
    Callback = function(value) S.Outline = value; refreshAllESP() end,
})
visuals:CreateSlider({
    Name = "Fill Transparency", Flag = "CVortexFillTransparency",
    Range = {0, 1}, Increment = 0.05, CurrentValue = S.FillTransparency,
    Callback = function(value) S.FillTransparency = value; refreshAllESP() end,
})
visuals:CreateSlider({
    Name = "Outline Transparency", Flag = "CVortexOutlineTransparency",
    Range = {0, 1}, Increment = 0.05, CurrentValue = S.OutlineTransparency,
    Callback = function(value) S.OutlineTransparency = value; refreshAllESP() end,
})

local aimTab = window:CreateTab("Aimbot", 4483362458)
aimTab:CreateToggle({
    Name = "Enable Aimbot", Flag = "CVortexAimEnabled", CurrentValue = false,
    Callback = function(value)
        S.AimEnabled = value == true
        if not S.AimEnabled then stopAim() end
        updateOverlay()
    end,
})
aimTab:CreateToggle({
    Name = "Wall Check", Flag = "CVortexAimWallCheck", CurrentValue = true,
    Callback = function(value)
        S.WallCheck = value == true
        currentTarget = nil
    end,
})
aimTab:CreateSlider({
    Name = "FOV Radius", Flag = "CVortexAimFOV", Range = {25, 400},
    Increment = 5, CurrentValue = S.FOV, Suffix = "px",
    Callback = function(value) S.FOV = value; updateOverlay() end,
})
aimTab:CreateToggle({
    Name = "Show FOV Circle", Flag = "CVortexShowFOV", CurrentValue = true,
    Callback = function(value) S.ShowFOV = value == true; updateOverlay() end,
})
aimTab:CreateSlider({
    Name = "Aim Speed", Flag = "CVortexAimSpeed", Range = {1, 20},
    Increment = 1, CurrentValue = S.Speed,
    Callback = function(value) S.Speed = value end,
})
aimTab:CreateSlider({
    Name = "Aim Duration", Flag = "CVortexAimDuration", Range = {0, 10},
    Increment = 0.5, Suffix = "s", CurrentValue = S.Duration,
    Callback = function(value) S.Duration = value end,
})
aimTab:CreateDropdown({
    Name = "Aim Part", Flag = "CVortexAimPart",
    Options = {"Head", "Body"}, CurrentOption = {"Head"}, MultipleOptions = false,
    Callback = function(value)
        local selected = type(value) == "table" and value[1] or value
        if selected == "Head" or selected == "Body" then
            S.AimPart = selected
            currentTarget = nil
        end
    end,
})
aimTab:CreateButton({Name = "Stop Aiming", Callback = stopAim})
updateOverlay()
refreshAllESP()
