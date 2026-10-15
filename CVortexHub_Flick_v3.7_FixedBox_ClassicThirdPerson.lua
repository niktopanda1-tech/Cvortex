
local ENV = (getgenv and getgenv()) or _G

if ENV.__CVortexHubCleanup then
    pcall(ENV.__CVortexHubCleanup)
    ENV.__CVortexHubCleanup = nil
end

local okWindUI, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

if not okWindUI or type(WindUI) ~= "table" then
    warn("[CVortexHub] Failed to load WindUI:", WindUI)
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")


local HttpService = game:GetService("HttpService")

-- The logo is built into the script, so it also works when loaded from GitHub.
local CVORTEX_LOGO_B64 = [[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]]
local function decodeLogoBase64(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local buffer, bits = 0, 0
    local output = {}
    for i = 1, #data do
        local char = data:sub(i, i)
        if char == "=" then break end
        local index = alphabet:find(char, 1, true)
        if index then
            buffer = buffer * 64 + index - 1
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                table.insert(output, string.char(math.floor(buffer / (2 ^ bits)) % 256))
                buffer = buffer % (2 ^ bits)
            end
        end
    end
    return table.concat(output)
end

local function loadLogoAsset()
    local getAsset = getcustomasset or getsynasset or (syn and syn.getcustomasset)
    if type(getAsset) ~= "function" or type(writefile) ~= "function" then
        return nil
    end
    local path = "CVortexHub_Logo.png"
    local ok, asset = pcall(function()
        writefile(path, decodeLogoBase64(CVORTEX_LOGO_B64))
        return getAsset(path)
    end)
    if ok and type(asset) == "string" and #asset > 0 then
        return asset
    end
    return nil
end



local LogoAsset = loadLogoAsset()
local LogoFallback = "check-circle"

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local State = {
    Aimbot = {
        Enabled = false,
        HoldRMB = not IS_MOBILE,
        StickyTarget = true,
        VisibilityCheck = true,
        TeamCheck = false,

        TargetPart = "Head",
        Smoothing = 0.18,

        FOV = 150,
        ShowFOV = true,

        MaxDistance = 2500,

        Prediction = false,
        PredictionTime = 0.08,
    },

    SilentAim = {
        Enabled = false,
        ShowButton = false,
        TargetPart = "Head",
        FOV = 150,
        ShowFOV = true,
        Wallcheck = true,
        TeamCheck = false,
        MaxDistance = 2500,
        MinDistance = 5,
    },

    Speed = {
        Enabled = false,
        ShowButton = false,
        Value = 32,
        NormalSpeed = 16,
        TimerEnabled = false,
        TimerSeconds = 15,
        Deadline = nil,
    },

    Radar = {
        Enabled = true,
        Size = 160,
        Range = 400,
        ShowTeammates = false,
    },
    ESP = {
        Enabled = true,
        TeamCheck = false,
        VisibilityColors = true,

        VisibleFill = Color3.fromRGB(0, 255, 90),
        VisibleOutline = Color3.fromRGB(0, 205, 70),

        HiddenFill = Color3.fromRGB(255, 65, 65),
        HiddenOutline = Color3.fromRGB(210, 35, 35),

        FillTransparency = 0.5,
        OutlineTransparency = 0,

        ShowNames = true,
        ShowDistance = true,
        Box = false,
        BoxMode = "Fixed", -- identical pixel dimensions for every target, no accessory-based resizing
        Tracers = false,

        UpdateInterval = 0.10,
    },
    ThirdPerson = {
        Enabled = false,
        Distance = 8,
        Height = 2.35,
    },
}

local Connections = {}
local PlayerConnections = {}
local ESPObjects = {}

local CurrentTarget = nil
local Unloaded = false
local ESPAccumulator = 0
local AuthGranted = false
local UIReady = false
local ActiveWindow = nil

local function notify(title, content, duration)
    pcall(function()
        WindUI:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3,
        })
    end)
end

local function addConnection(connection)
    table.insert(Connections, connection)
    return connection
end

-- CVortex v3.4: compact FPS/ping status overlay (mobile + PC)
local StatsOverlayEnabled = true
local StatsOverlayGui = nil
local StatsOverlayText = nil
local StatsOverlayFrameCount = 0
local StatsOverlayFrameTime = 0
local StatsService = game:GetService("Stats")

local function setStatsOverlayEnabled(enabled)
    StatsOverlayEnabled = enabled == true
    if StatsOverlayGui then
        StatsOverlayGui.Enabled = StatsOverlayEnabled and AuthGranted
    end
end

local function createStatsOverlay()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not playerGui or Unloaded then return end

    local previous = playerGui:FindFirstChild("CVortexStatsOverlay")
    if previous then previous:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CVortexStatsOverlay"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = false
    gui.DisplayOrder = 150
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = StatsOverlayEnabled and AuthGranted
    gui.Parent = playerGui
    StatsOverlayGui = gui

    local bar = Instance.new("Frame")
    bar.Name = "StatsBar"
    bar.Size = UDim2.fromOffset(224, 32)
    bar.Position = UDim2.fromOffset(10, 12)
    bar.BackgroundColor3 = Color3.fromRGB(27, 28, 31)
    bar.BackgroundTransparency = 0.04
    bar.BorderSizePixel = 0
    bar.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = bar

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(85, 87, 93)
    stroke.Transparency = 0.18
    stroke.Parent = bar

    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "Logo"
    iconFrame.Size = UDim2.fromOffset(24, 24)
    iconFrame.Position = UDim2.fromOffset(4, 4)
    iconFrame.BackgroundColor3 = Color3.fromRGB(52, 54, 59)
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = bar
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = iconFrame

    local icon = Instance.new("TextLabel")
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.fromScale(1, 1)
    icon.Text = "V"
    icon.TextColor3 = Color3.fromRGB(243, 243, 246)
    icon.TextSize = 16
    icon.Font = Enum.Font.GothamBold
    icon.Parent = iconFrame

    local line = Instance.new("TextLabel")
    line.Name = "Info"
    line.BackgroundTransparency = 1
    line.Position = UDim2.fromOffset(34, 0)
    line.Size = UDim2.new(1, -40, 1, 0)
    line.Text = "Cvortex  |  -- FPS  |  -- ms"
    line.TextColor3 = Color3.fromRGB(218, 220, 225)
    line.TextSize = 12
    line.TextXAlignment = Enum.TextXAlignment.Left
    line.Font = Enum.Font.GothamSemibold
    line.Parent = bar
    StatsOverlayText = line
end

local function getPingMilliseconds()
    local ok, value = pcall(function()
        return LocalPlayer:GetNetworkPing() * 1000
    end)
    if ok and type(value) == "number" and value == value then
        return math.floor(value + 0.5)
    end
    local ok2, val2 = pcall(function()
        return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok2 and type(val2) == "number" then
        return math.floor(val2 + 0.5)
    end
    return nil
end

pcall(createStatsOverlay)
addConnection(RunService.RenderStepped:Connect(function(dt)
    if Unloaded or not AuthGranted or not StatsOverlayEnabled or not StatsOverlayText then return end
    StatsOverlayFrameCount = StatsOverlayFrameCount + 1
    StatsOverlayFrameTime = StatsOverlayFrameTime + math.max(dt, 0)
    if StatsOverlayFrameTime >= 0.5 then
        local fps = math.floor(StatsOverlayFrameCount / StatsOverlayFrameTime + 0.5)
        local ping = getPingMilliseconds()
        StatsOverlayText.Text = string.format("Cvortex  |  %d FPS  |  %s ms", fps, ping and tostring(ping) or "--")
        StatsOverlayFrameCount = 0
        StatsOverlayFrameTime = 0
    end
end))

local function disconnectConnection(connection)
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
    end
end

local function getCharacter(player)
    return player and player.Character or nil
end

local function getHumanoid(character)
    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

local function isAlive(player)
    local character = getCharacter(player)
    local humanoid = getHumanoid(character)

    return character ~= nil
        and humanoid ~= nil
        and humanoid.Health > 0
end

local function sameTeam(player)
    if not player or not LocalPlayer then
        return false
    end

    if LocalPlayer.Team == nil or player.Team == nil then
        return false
    end

    return player.Team == LocalPlayer.Team
end

local function resolveTargetPart(character, requestedPart)
    if not character then
        return nil
    end

    if requestedPart == "Head" then
        return character:FindFirstChild("Head")
            or character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("HumanoidRootPart")
    end

    if requestedPart == "Torso" then
        return character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("Head")
    end

    if requestedPart == "HumanoidRootPart" then
        return character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("Head")
    end

    return character:FindFirstChild(requestedPart)
        or character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("Head")
end

local function getLocalRoot()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getDistanceFromLocal(position)
    local root = getLocalRoot()
    if not root then
        return math.huge
    end

    return (root.Position - position).Magnitude
end

local function getScreenCenter()
    local viewport = Camera.ViewportSize
    return Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
end

local function hasClearShot(origin, targetPosition, character)
    if not origin or not targetPosition or not character then return false end
    local direction = targetPosition - origin
    if direction.Magnitude < 0.01 then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {Camera}
    if LocalPlayer.Character then table.insert(ignore, LocalPlayer.Character) end
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true
    -- Ignore see-through non-collidable decorative parts, but not solid walls.
    local rayOrigin = origin
    for _ = 1, 6 do
        local delta = targetPosition - rayOrigin
        if delta.Magnitude < 0.01 then return true end
        local hit = Workspace:Raycast(rayOrigin, delta, params)
        if not hit then return true end
        if hit.Instance and hit.Instance:IsDescendantOf(character) then return true end
        if hit.Instance and not hit.Instance.CanCollide and hit.Instance.Transparency >= 0.95 then
            table.insert(ignore, hit.Instance)
            params.FilterDescendantsInstances = ignore
        else
            return false
        end
    end
    return false
end

local function isVisible(character, targetPartObject)
    if not Camera or not character or not targetPartObject then return false end
    return hasClearShot(Camera.CFrame.Position, targetPartObject.Position, character)
end

local function isAimbotInputActive()
    if not State.Aimbot.Enabled then
        return false
    end
    if IS_MOBILE then
        return true
    end

    if not State.Aimbot.HoldRMB then
        return true
    end

    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end

local FOVCircle = nil

pcall(function()
    if Drawing and Drawing.new then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 2
        FOVCircle.NumSides = 64
        FOVCircle.Radius = State.Aimbot.FOV
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        FOVCircle.Position = Camera and getScreenCenter() or Vector2.new(0, 0)
        FOVCircle.Visible = false
        FOVCircle.Filled = false
        FOVCircle.Transparency = 1
    end
end)

local function updateFOVCircle()
    if not FOVCircle or not Camera then
        return
    end

    FOVCircle.Position = getScreenCenter()
    FOVCircle.Radius = State.Aimbot.FOV
    FOVCircle.Visible = State.Aimbot.ShowFOV and not Unloaded
end

local function getCandidate(player)
    if not player or player == LocalPlayer then
        return nil
    end

    if not isAlive(player) then
        return nil
    end

    if State.Aimbot.TeamCheck and sameTeam(player) then
        return nil
    end

    local character = player.Character
    local part = resolveTargetPart(character, State.Aimbot.TargetPart)

    if not part then
        return nil
    end

    local worldDistance = getDistanceFromLocal(part.Position)
    if worldDistance > State.Aimbot.MaxDistance then
        return nil
    end

    local screenPosition, onScreen = Camera:WorldToViewportPoint(part.Position)

    if not onScreen or screenPosition.Z <= 0 then
        return nil
    end

    local screenPoint = Vector2.new(screenPosition.X, screenPosition.Y)
    local screenDistance = (screenPoint - getScreenCenter()).Magnitude

    if screenDistance > State.Aimbot.FOV then
        return nil
    end

    if State.Aimbot.VisibilityCheck and not isVisible(character, part) then
        return nil
    end

    return {
        Player = player,
        Character = character,
        Part = part,
        ScreenDistance = screenDistance,
        WorldDistance = worldDistance,
    }
end

local function getBestTarget()
    if State.Aimbot.StickyTarget and CurrentTarget then
        local stickyCandidate = getCandidate(CurrentTarget)
        if stickyCandidate then
            return stickyCandidate
        end

        CurrentTarget = nil
    end

    local bestCandidate = nil
    local bestScore = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        local candidate = getCandidate(player)

        if candidate and candidate.ScreenDistance < bestScore then
            bestScore = candidate.ScreenDistance
            bestCandidate = candidate
        end
    end

    if bestCandidate then
        CurrentTarget = bestCandidate.Player
    else
        CurrentTarget = nil
    end

    return bestCandidate
end

local function getPredictedPosition(part)
    local position = part.Position

    if not State.Aimbot.Prediction then
        return position
    end

    local velocity = part.AssemblyLinearVelocity
    return position + velocity * State.Aimbot.PredictionTime
end

local function aimAt(candidate, deltaTime)
    if not candidate or not candidate.Part or not Camera then
        return
    end

    local targetPosition = getPredictedPosition(candidate.Part)

    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
    local baseAlpha = math.clamp(State.Aimbot.Smoothing, 0.01, 1)
    local frameFactor = math.max(deltaTime, 1 / 240) * 60
    local alpha = 1 - math.pow(1 - baseAlpha, frameFactor)

    Camera.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(alpha, 0, 1))
end

local SilentCircle = nil
pcall(function()
    if Drawing and Drawing.new then
        SilentCircle = Drawing.new("Circle")
        SilentCircle.Visible = false
        SilentCircle.Filled = false
        SilentCircle.NumSides = 64
        SilentCircle.Thickness = 1.5
        SilentCircle.Color = Color3.fromRGB(65, 225, 150)
        SilentCircle.Transparency = 0.85
    end
end)

local function updateSilentCircle()
    if not SilentCircle or not Camera then return end
    SilentCircle.Position = getScreenCenter()
    SilentCircle.Radius = State.SilentAim.FOV
    SilentCircle.Visible = State.SilentAim.Enabled
        and State.SilentAim.ShowFOV and not Unloaded
end

local function getSilentTarget(origin)
    if not Camera or not State.SilentAim.Enabled then return nil end
    local config = State.SilentAim
    local center = getScreenCenter()
    local bestPosition = nil
    local bestDistance = config.FOV
    local seen = {}

    local function evaluate(character, player)
        if not character or character == LocalPlayer.Character or seen[character] then return end
        seen[character] = true
        if player and config.TeamCheck and sameTeam(player) then return end
        local hum = getHumanoid(character)
        if not hum or hum.Health <= 0 then return end
        local part = resolveTargetPart(character, config.TargetPart)
        if not part or not part:IsA("BasePart") then return end
        local pos = part.Position
        local distance = (pos - origin).Magnitude
        if distance < config.MinDistance or distance > config.MaxDistance then return end
        local projected, onScreen = Camera:WorldToViewportPoint(pos)
        if not onScreen or projected.Z <= 0 then return end
        local pixelDistance = (Vector2.new(projected.X, projected.Y) - center).Magnitude
        if pixelDistance >= bestDistance then return end

        if config.Wallcheck and not hasClearShot(origin, pos, character) then return end

        bestPosition = pos
        bestDistance = pixelDistance
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            evaluate(player.Character, player)
        end
    end

    -- Flick can also use NPC targets. Only scan top-level models, not every part.
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character and not seen[model] then
            local player = Players:GetPlayerFromCharacter(model)
            if player ~= LocalPlayer and model:FindFirstChildOfClass("Humanoid") then
                evaluate(model, player)
            end
        end
    end

    return bestPosition
end

local BulletHandler = nil
local OriginalBulletFire = nil
local SilentFireWrapper = nil
local SilentHookReady = false

local function installSilentHook()
    local moduleScripts = ReplicatedStorage:WaitForChild("ModuleScripts", 10)
    local gunModules = moduleScripts and moduleScripts:WaitForChild("GunModules", 10)
    local bulletModule = gunModules and gunModules:WaitForChild("BulletHandler", 10)
    if not bulletModule then
        warn("[CVortexHub] Flick BulletHandler was not found.")
        return
    end

    local ok, handler = pcall(require, bulletModule)
    if not ok or type(handler) ~= "table" or type(handler.Fire) ~= "function" then
        warn("[CVortexHub] Could not hook BulletHandler.Fire.", handler)
        return
    end

    BulletHandler = handler
    local previousFire = handler.Fire
    -- Cooperate with previously running public Silent Aim script when possible.
    if type(_G.__SA_OriginalBulletFire) == "function" and _G.__SA_HookInstalled then
        previousFire = _G.__SA_OriginalBulletFire
    end
    OriginalBulletFire = previousFire

    SilentFireWrapper = function(payload, ...)
        if not State.SilentAim.Enabled or type(payload) ~= "table" or typeof(payload.Origin) ~= "Vector3" then
            return previousFire(payload, ...)
        end

        -- Reuse the BulletHandler.Fire direction-based mechanism from the source.
        local origin = payload.Origin
        local character = LocalPlayer.Character
        local humanoid = character and getHumanoid(character)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local airborne = humanoid and humanoid.FloorMaterial == Enum.Material.Air
        if airborne and root then
            origin = root.Position + Vector3.new(0, 1.5, 0)
            payload.Origin = origin
            if typeof(payload.VisualOrigin) == "Vector3" then
                payload.VisualOrigin = origin
            end
        end

        local targetPosition = getSilentTarget(origin)
        local savedCFrame = nil
        if targetPosition then
            local delta = targetPosition - origin
            if delta.Magnitude > 0.001 then
                local direction = delta.Unit
                payload.Direction = direction
                if type(payload.Misc) == "table" then
                    if typeof(payload.Misc.CamCFrame) == "CFrame" then
                        payload.Misc.CamCFrame = CFrame.lookAt(origin, origin + direction)
                    end
                    payload.Misc.Spread = 0
                end

                -- The original implementation briefly spoofs the camera when
                -- the shot deviates too far from the real view direction.
                if Camera and not airborne then
                    local dot = math.clamp(Camera.CFrame.LookVector:Dot(direction), -1, 1)
                    local angle = math.deg(math.acos(dot))
                    if angle > 20 then
                        savedCFrame = Camera.CFrame
                        Camera.CFrame = CFrame.lookAt(origin, origin + direction)
                    end
                end
            end
        end

        local arguments = table.pack(...)
        local result = table.pack(pcall(function()
            return previousFire(payload, table.unpack(arguments, 1, arguments.n))
        end))
        if savedCFrame and Camera then
            Camera.CFrame = savedCFrame
        end
        if not result[1] then
            error(result[2], 0)
        end
        return table.unpack(result, 2, result.n)
    end

    if Unloaded then return end
    BulletHandler.Fire = SilentFireWrapper
    _G.__SA_HookInstalled = false
    SilentHookReady = true
    print("[CVortexHub] Silent Aim hook installed.")
end

task.spawn(function()
    local ok, err = pcall(installSilentHook)
    if not ok then warn("[CVortexHub] Silent Aim installation failed:", err) end
end)

local SpeedHumanoid = nil
local OriginalWalkSpeed = nil
local SilentToggleControl = nil
local SpeedToggleControl = nil
local SpeedSliderControl = nil
local ScreenGui = nil
local SilentQuick = nil
local SpeedQuick = nil
local SpeedTimerHud = nil

local function syncSpeedCharacter()
    local character = LocalPlayer.Character
    local humanoid = character and getHumanoid(character)
    if humanoid ~= SpeedHumanoid then
        if SpeedHumanoid and OriginalWalkSpeed then
            pcall(function() SpeedHumanoid.WalkSpeed = OriginalWalkSpeed end)
        end
        SpeedHumanoid = humanoid
        OriginalWalkSpeed = humanoid and humanoid.WalkSpeed or 16
        State.Speed.NormalSpeed = OriginalWalkSpeed
    end
    return humanoid
end

local updateQuickButtonStyle

local function setSpeedEnabled(value, fromMenu)
    local wasEnabled = State.Speed.Enabled
    State.Speed.Enabled = not not value
    if not State.Speed.Enabled then
        State.Speed.Deadline = nil
    elseif State.Speed.TimerEnabled and (not wasEnabled or not State.Speed.Deadline) then
        State.Speed.Deadline = os.clock() + State.Speed.TimerSeconds
    end
    local humanoid = syncSpeedCharacter()
    if humanoid then
        pcall(function()
            humanoid.WalkSpeed = State.Speed.Enabled and State.Speed.Value or (OriginalWalkSpeed or 16)
        end)
    end
    if SpeedToggleControl and not fromMenu then
        pcall(function() SpeedToggleControl:Set(State.Speed.Enabled, false) end)
    end
    if SpeedQuick then
        updateQuickButtonStyle(SpeedQuick, State.Speed.Enabled)
    end
end

local function setSilentEnabled(value, fromMenu)
    State.SilentAim.Enabled = not not value
    updateSilentCircle()
    if SilentToggleControl and not fromMenu then
        pcall(function() SilentToggleControl:Set(State.SilentAim.Enabled, false) end)
    end
    if SilentQuick then
        updateQuickButtonStyle(SilentQuick, State.SilentAim.Enabled)
    end
end

updateQuickButtonStyle = function(button, isEnabled)
    if not button then return end
    local status = button:FindFirstChild("Status")
    local dot = button:FindFirstChild("StateDot")
    local outline = button:FindFirstChildOfClass("UIStroke")
    local active = Color3.fromRGB(112, 212, 178)
    local inactive = Color3.fromRGB(145, 154, 171)
    button.BackgroundColor3 = isEnabled and Color3.fromRGB(29, 47, 47) or Color3.fromRGB(22, 26, 36)
    if status then
        status.Text = isEnabled and "ON" or "OFF"
        status.TextColor3 = isEnabled and active or inactive
    end
    if dot then dot.BackgroundColor3 = isEnabled and active or inactive end
    if outline then
        outline.Color = isEnabled and active or Color3.fromRGB(86, 97, 117)
    end
end

local function createQuickButton(name, offsetY, title, onPress)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(132, 52)
    button.Position = UDim2.new(1, -144, 0.47, offsetY)
    button.AnchorPoint = Vector2.new(0, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
    button.Text = ""
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = button

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(86, 97, 117)
    outline.Thickness = 1.1
    outline.Transparency = 0.07
    outline.Parent = button

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 50
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(189, 199, 216)),
    })
    gradient.Parent = button

    local iconTile = Instance.new("Frame")
    iconTile.Size = UDim2.fromOffset(34, 34)
    iconTile.Position = UDim2.fromOffset(9, 9)
    iconTile.BackgroundColor3 = Color3.fromRGB(249, 249, 249)
    iconTile.BorderSizePixel = 0
    iconTile.Parent = button
    local tileCorner = Instance.new("UICorner")
    tileCorner.CornerRadius = UDim.new(0, 8)
    tileCorner.Parent = iconTile

    if LogoAsset then
        local image = Instance.new("ImageLabel")
        image.Name = "Logo"
        image.Size = UDim2.fromScale(1, 1)
        image.BackgroundTransparency = 1
        image.Image = LogoAsset
        image.ScaleType = Enum.ScaleType.Fit
        image.Parent = iconTile
    else
        local fallback = Instance.new("TextLabel")
        fallback.Size = UDim2.fromScale(1, 1)
        fallback.BackgroundTransparency = 1
        fallback.Font = Enum.Font.GothamBlack
        fallback.TextSize = 17
        fallback.TextColor3 = Color3.fromRGB(16, 20, 26)
        fallback.Text = "CV"
        fallback.Parent = iconTile
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.fromOffset(77, 23)
    nameLabel.Position = UDim2.fromOffset(48, 6)
    nameLabel.Name = "Feature"
    nameLabel.Text = title
    nameLabel.TextColor3 = Color3.fromRGB(238, 242, 248)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = button

    local stateDot = Instance.new("Frame")
    stateDot.Name = "StateDot"
    stateDot.Size = UDim2.fromOffset(6, 6)
    stateDot.Position = UDim2.fromOffset(49, 33)
    stateDot.BorderSizePixel = 0
    stateDot.Parent = button
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = stateDot

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.fromOffset(54, 16)
    status.Position = UDim2.fromOffset(61, 27)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.GothamBold
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.Parent = button

    -- Dragging works with touch and mouse, without toggling a feature after a swipe.
    local startInput, startPosition, startUI, moved = nil, nil, nil, false
    addConnection(button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            startInput = input
            startPosition = input.Position
            startUI = button.Position
            moved = false
        end
    end))
    addConnection(UserInputService.InputChanged:Connect(function(input)
        if not startInput or not startPosition then return end
        if input ~= startInput and not (
            startInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement) then return end
        local difference = input.Position - startPosition
        if difference.Magnitude > 8 then moved = true end
        if moved then
            button.Position = UDim2.new(
                startUI.X.Scale, startUI.X.Offset + difference.X,
                startUI.Y.Scale, startUI.Y.Offset + difference.Y
            )
        end
    end))
    addConnection(UserInputService.InputEnded:Connect(function(input)
        if input == startInput then startInput = nil end
    end))
    addConnection(button.Activated:Connect(function()
        if moved then moved = false; return end
        onPress()
    end))
    updateQuickButtonStyle(button, false)
    return button
end

-- Radar is a local two-dimensional overlay; it does not modify game physics.
local RadarGui, RadarCircle, RadarBlips = nil, nil, {}
local function makeRadar()
    RadarGui = Instance.new("ScreenGui")
    RadarGui.Name = "CVortexHubRadar"
    RadarGui.ResetOnSpawn = false
    RadarGui.IgnoreGuiInset = true
    RadarGui.DisplayOrder = 10050
    RadarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RadarGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    RadarCircle = Instance.new("Frame")
    RadarCircle.Name = "Radar"
    RadarCircle.Active = true
    RadarCircle.Position = UDim2.new(1, -18, 0.37, 0)
    RadarCircle.AnchorPoint = Vector2.new(1, 0.5)
    RadarCircle.BackgroundColor3 = Color3.fromRGB(18, 21, 29)
    RadarCircle.BackgroundTransparency = 0
    RadarCircle.BorderSizePixel = 0
    RadarCircle.ClipsDescendants = true
    RadarCircle.Visible = AuthGranted and State.Radar.Enabled
    RadarCircle.Size = UDim2.fromOffset(State.Radar.Size, State.Radar.Size)
    RadarCircle.Parent = RadarGui
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = RadarCircle
    -- Dragging supported on touch screens and mouse.
    local dragStart, startPos, movingInput
    local function beginDrag(input)
        if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        dragStart = input.Position
        startPos = RadarCircle.Position
        movingInput = input
    end
    addConnection(RadarCircle.InputBegan:Connect(beginDrag))
    addConnection(UserInputService.InputChanged:Connect(function(input)
        if not dragStart or not startPos then return end
        if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if movingInput and movingInput.UserInputType == Enum.UserInputType.Touch and input ~= movingInput then return end
        local delta = input.Position - dragStart
        RadarCircle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end))
    addConnection(UserInputService.InputEnded:Connect(function(input)
        if input == movingInput or (movingInput and movingInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1) then
            dragStart, startPos, movingInput = nil, nil, nil
        end
    end))
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(181, 190, 208)
    stroke.Thickness = 1.4
    stroke.Transparency = 0.25
    stroke.Parent = RadarCircle
    local mid = Instance.new("Frame")
    mid.Name = "Me"
    mid.Size = UDim2.fromOffset(9, 9)
    mid.AnchorPoint = Vector2.new(0.5, 0.5)
    mid.Position = UDim2.fromScale(0.5, 0.5)
    mid.BackgroundColor3 = Color3.new(1, 1, 1)
    mid.BorderSizePixel = 0
    mid.ZIndex = 3
    mid.Parent = RadarCircle
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(1, 0)
    cc.Parent = mid
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(23, 27, 35)
    outline.Thickness = 1
    outline.Parent = mid
end
local function radarDot(player)
    if RadarBlips[player] then return RadarBlips[player] end
    local dot = Instance.new("Frame")
    dot.Name = "PlayerDot"
    dot.Size = UDim2.fromOffset(7, 7)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(250, 65, 77)
    dot.BorderSizePixel = 0
    dot.ZIndex = 2
    dot.Parent = RadarCircle
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dot
    RadarBlips[player] = dot
    return dot
end
local function updateRadar()
    if not RadarCircle or not RadarCircle.Parent then return end
    RadarCircle.Visible = AuthGranted and State.Radar.Enabled
    if not AuthGranted or not State.Radar.Enabled then return end
    local size = State.Radar.Size
    RadarCircle.Size = UDim2.fromOffset(size, size)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        for _, dot in pairs(RadarBlips) do dot.Visible = false end
        return
    end
    local forward, right = root.CFrame.LookVector, root.CFrame.RightVector
    local radius = size / 2 - 9
    local alive = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            alive[p] = true
            local dot = radarDot(p)
            local character = p.Character
            local part = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local teammate = LocalPlayer.Team ~= nil and p.Team == LocalPlayer.Team
            local visible = part and humanoid and humanoid.Health > 0
                and (State.Radar.ShowTeammates or not teammate)
            if visible then
                local delta = part.Position - root.Position
                local px = delta:Dot(right) / State.Radar.Range * radius
                local py = -delta:Dot(forward) / State.Radar.Range * radius
                local d = Vector2.new(px, py)
                if d.Magnitude > radius then d = d.Unit * radius end
                dot.Position = UDim2.new(0.5, d.X, 0.5, d.Y)
                dot.BackgroundColor3 = teammate and Color3.fromRGB(90, 170, 255) or Color3.fromRGB(250, 65, 77)
                dot.Visible = true
            else
                dot.Visible = false
            end
        end
    end
    for p, dot in pairs(RadarBlips) do
        if not alive[p] then dot:Destroy(); RadarBlips[p] = nil end
    end
end
makeRadar()

local function initializeQuickButtons()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CVortexHubQuickButtons"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 900
    local success = pcall(function()
        local parent = (gethui and gethui()) or CoreGui
        ScreenGui.Parent = parent
    end)
    if not success or not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    SilentQuick = createQuickButton("SilentAimButton", -34, "SILENT", function()
        setSilentEnabled(not State.SilentAim.Enabled, false)
    end)
    SpeedQuick = createQuickButton("SpeedButton", 29, "SPEED", function()
        setSpeedEnabled(not State.Speed.Enabled, false)
    end)
    SilentQuick.Visible = State.SilentAim.ShowButton
    SpeedQuick.Visible = State.Speed.ShowButton
    setSilentEnabled(State.SilentAim.Enabled, true)
    setSpeedEnabled(State.Speed.Enabled, true)
end

initializeQuickButtons()

-- Small live countdown under the speed screen button; also available when its button is hidden.
local function initializeSpeedTimerHud()
    if not ScreenGui then return end
    local label = Instance.new("TextLabel")
    label.Name = "CVortexSpeedTimer"
    label.Size = UDim2.fromOffset(132, 24)
    label.AnchorPoint = Vector2.new(0, 0.5)
    label.BackgroundColor3 = Color3.fromRGB(27, 28, 31)
    label.BackgroundTransparency = 0.04
    label.BorderSizePixel = 0
    label.TextColor3 = Color3.fromRGB(230, 232, 236)
    label.TextSize = 12
    label.Font = Enum.Font.GothamSemibold
    label.Text = "Speed: 15s left"
    label.Visible = false
    label.Parent = ScreenGui
    local round = Instance.new("UICorner")
    round.CornerRadius = UDim.new(0, 7)
    round.Parent = label
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(87, 89, 95)
    border.Transparency = 0.16
    border.Thickness = 1
    border.Parent = label
    SpeedTimerHud = label
end

initializeSpeedTimerHud()

local function updateSpeedCountdown()
    local timed = State.Speed.Enabled and State.Speed.TimerEnabled
        and State.Speed.Deadline and AuthGranted
    local remaining = timed and math.max(0, State.Speed.Deadline - os.clock()) or 0
    if SpeedTimerHud then
        SpeedTimerHud.Visible = timed and not Unloaded
        if timed then
            SpeedTimerHud.Text = string.format("Speed: %ds left", math.ceil(remaining))
            if SpeedQuick and SpeedQuick.Visible then
                SpeedTimerHud.Position = UDim2.new(SpeedQuick.Position.X.Scale,
                    SpeedQuick.Position.X.Offset, SpeedQuick.Position.Y.Scale,
                    SpeedQuick.Position.Y.Offset + 43)
            else
                SpeedTimerHud.Position = UDim2.new(1, -144, 0.47, 68)
            end
        end
    end
    if SpeedQuick and timed then
        local label = SpeedQuick:FindFirstChild("Status")
        if label then label.Text = string.format("%ds", math.ceil(remaining)) end
    end
    if timed and remaining <= 0 then
        setSpeedEnabled(false, false)
        notify("Speed Hack", "Timer finished — normal speed restored.", 2)
    end
end

local function resetSpeed()
    setSpeedEnabled(false, false)
    State.Speed.Value = OriginalWalkSpeed or 16
    if SpeedSliderControl then
        pcall(function() SpeedSliderControl:Set(math.clamp(State.Speed.Value, 16, 150)) end)
    end
end

addConnection(LocalPlayer.CharacterAdded:Connect(function()
    task.defer(function()
        if Unloaded then return end
        local char = LocalPlayer.Character
        if char then char:WaitForChild("Humanoid", 8) end
        if not Unloaded then syncSpeedCharacter() end
    end)
end))

addConnection(RunService.Heartbeat:Connect(function()
    if Unloaded then return end
    updateSpeedCountdown()
    if not State.Speed.Enabled then return end
    local humanoid = syncSpeedCharacter()
    if humanoid and humanoid.Health > 0 and humanoid.WalkSpeed ~= State.Speed.Value then
        humanoid.WalkSpeed = State.Speed.Value
    end
end))

-- Screen-space box / tracer ESP uses Frames, not Drawing, for mobile compatibility.
local ESP2DGui = Instance.new("ScreenGui")
ESP2DGui.Name = "CVortexESP2D"
ESP2DGui.ResetOnSpawn = false
ESP2DGui.IgnoreGuiInset = true -- match Camera:WorldToViewportPoint coordinates
ESP2DGui.DisplayOrder = 125
ESP2DGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ESP2DGui.Enabled = false -- unlock with the CVortex key
ESP2DGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function createLine2D(name)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
    frame.BackgroundTransparency = 0.04
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.ZIndex = 2
    frame.Parent = ESP2DGui
    return frame
end

local function hideESP2D(object)
    if not object then return end
    if object.BoxLines then
        for _, segment in ipairs(object.BoxLines) do segment.Visible = false end
    end
    if object.TracerLine then object.TracerLine.Visible = false end
end

local function setLine2D(line, x1, y1, x2, y2, thickness, color)
    local dx, dy = x2 - x1, y2 - y1
    local length = math.sqrt(dx * dx + dy * dy)
    if length < 1 then line.Visible = false; return end
    line.Position = UDim2.fromOffset((x1 + x2) * 0.5, (y1 + y2) * 0.5)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Size = UDim2.fromOffset(length, thickness)
    line.Rotation = math.deg(math.atan2(dy, dx))
    line.BackgroundColor3 = color
    line.Visible = true
end

-- A stable 2D box centered on HumanoidRootPart. Animations, hats and held
-- guns are deliberately excluded, so they cannot stretch the rectangle.
-- Fixed: same number of screen pixels for all players.
-- Perspective: same avatar-sized dimensions in world units, scaled by depth.
local function updateESP2D(object, character, color)
    if not object or not Camera or not AuthGranted or not State.ESP.Enabled
        or (not State.ESP.Box and not State.ESP.Tracers) then
        hideESP2D(object)
        return
    end

    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then hideESP2D(object); return end
    local viewport = Camera.ViewportSize
    local center = Camera:WorldToViewportPoint(root.Position)
    if center.Z <= 0.1 then hideESP2D(object); return end

    local height
    if State.ESP.BoxMode == "Perspective" then
        -- All players have the same 5.5-stud reference height; only distance
        -- changes the on-screen size, not accessories or current animation.
        local focalLength = viewport.Y / (2 * math.tan(math.rad(Camera.FieldOfView) / 2))
        height = math.clamp(5.5 * focalLength / center.Z, 8, viewport.Y * 1.5)
    else
        height = 82 -- fixed pixel size, even when target distance changes
    end
    local width = height * 0.52
    local minX, maxX = center.X - width / 2, center.X + width / 2
    local minY, maxY = center.Y - height / 2, center.Y + height / 2

    -- Do not clip each corner separately: that would deform box dimensions
    -- near the edges of the screen. Roblox GUI clips outside the viewport.
    if maxX < 0 or minX > viewport.X or maxY < 0 or minY > viewport.Y then
        hideESP2D(object); return
    end

    if object.BoxLines then
        if State.ESP.Box then
            setLine2D(object.BoxLines[1], minX, minY, maxX, minY, 2, color)
            setLine2D(object.BoxLines[2], maxX, minY, maxX, maxY, 2, color)
            setLine2D(object.BoxLines[3], maxX, maxY, minX, maxY, 2, color)
            setLine2D(object.BoxLines[4], minX, maxY, minX, minY, 2, color)
        else
            for _, line in ipairs(object.BoxLines) do line.Visible = false end
        end
    end
    if object.TracerLine then
        if State.ESP.Tracers then
            local x2 = (minX + maxX) * 0.5
            local y2 = maxY
            setLine2D(object.TracerLine, viewport.X / 2, viewport.Y - 12, x2, y2, 2, color)
        else
            object.TracerLine.Visible = false
        end
    end
end

local function destroyESP(player)
    local object = ESPObjects[player]
    if not object then
        return
    end

    if object.Highlight then
        pcall(function()
            object.Highlight:Destroy()
        end)
    end

    if object.Billboard then
        pcall(function()
            object.Billboard:Destroy()
        end)
    end

    if object.BoxLines then
        for _, segment in ipairs(object.BoxLines) do pcall(function() segment:Destroy() end) end
    end
    if object.TracerLine then pcall(function() object.TracerLine:Destroy() end) end
    ESPObjects[player] = nil
end

local function createESP(player)
    if not State.ESP.Enabled then
        return nil
    end

    if not player or player == LocalPlayer then
        return nil
    end

    if State.ESP.TeamCheck and sameTeam(player) then
        destroyESP(player)
        return nil
    end

    local character = player.Character
    if not character or not isAlive(player) then
        destroyESP(player)
        return nil
    end

    local adornee = resolveTargetPart(character, "HumanoidRootPart")
    if not adornee then
        return nil
    end

    local old = ESPObjects[player]
    if old and old.Character == character then
        return old
    end

    destroyESP(player)

    local highlight = Instance.new("Highlight")
    highlight.Name = "CVortexESP"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = State.ESP.FillTransparency
    highlight.OutlineTransparency = State.ESP.OutlineTransparency
    highlight.FillColor = State.ESP.VisibleFill
    highlight.OutlineColor = State.ESP.VisibleOutline
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CVortexESPInfo"
    billboard.Adornee = adornee
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(220, 44)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.MaxDistance = State.Aimbot.MaxDistance
    billboard.Parent = character

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 0.25
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = ""
    label.Parent = billboard

    local object = {
        Character = character,
        Highlight = highlight,
        Billboard = billboard,
        Label = label,
        BoxLines = {
            createLine2D("BoxTop"), createLine2D("BoxRight"),
            createLine2D("BoxBottom"), createLine2D("BoxLeft"),
        },
        TracerLine = createLine2D("Tracer"),
        OverlayColor = State.ESP.VisibleOutline,
    }

    ESPObjects[player] = object
    return object
end

local function updateESPObject(player)
    if not State.ESP.Enabled then
        destroyESP(player)
        return
    end

    if not player or player == LocalPlayer then
        return
    end

    if State.ESP.TeamCheck and sameTeam(player) then
        destroyESP(player)
        return
    end

    if not isAlive(player) then
        destroyESP(player)
        return
    end

    local object = createESP(player)
    if not object then
        return
    end

    local character = player.Character
    local target = resolveTargetPart(character, State.Aimbot.TargetPart)
        or resolveTargetPart(character, "HumanoidRootPart")

    if not target then
        return
    end

    local visible = true
    if State.ESP.VisibilityColors then
        visible = isVisible(character, target)
    end

    if visible then
        object.Highlight.FillColor = State.ESP.VisibleFill
        object.Highlight.OutlineColor = State.ESP.VisibleOutline
    else
        object.Highlight.FillColor = State.ESP.HiddenFill
        object.Highlight.OutlineColor = State.ESP.HiddenOutline
    end

    object.Highlight.FillTransparency = State.ESP.FillTransparency
    object.Highlight.OutlineTransparency = State.ESP.OutlineTransparency

    local textParts = {}

    if State.ESP.ShowNames then
        local display = player.DisplayName or player.Name

        if display ~= player.Name then
            table.insert(textParts, string.format("%s (@%s)", display, player.Name))
        else
            table.insert(textParts, player.Name)
        end
    end

    if State.ESP.ShowDistance then
        local distance = getDistanceFromLocal(target.Position)
        table.insert(textParts, string.format("[%dm]", math.floor(distance + 0.5)))
    end

    object.Label.Text = table.concat(textParts, "\n")
    object.Billboard.Enabled = #textParts > 0
    object.Billboard.MaxDistance = State.Aimbot.MaxDistance

    if State.ESP.VisibilityColors then
        object.Label.TextColor3 = visible
            and State.ESP.VisibleFill
            or State.ESP.HiddenFill
    else
        object.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    local overlayColor = State.ESP.VisibilityColors
        and (visible and State.ESP.VisibleOutline or State.ESP.HiddenOutline)
        or Color3.fromRGB(218, 220, 225)
    object.OverlayColor = overlayColor
    updateESP2D(object, character, overlayColor)
end

local function refreshAllESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            updateESPObject(player)
        end
    end

    if not State.ESP.Enabled then
        for player in pairs(ESPObjects) do
            destroyESP(player)
        end
    end
end

local function hookPlayer(player)
    if not player or player == LocalPlayer then
        return
    end

    if PlayerConnections[player] then
        for _, connection in ipairs(PlayerConnections[player]) do
            disconnectConnection(connection)
        end
    end

    PlayerConnections[player] = {}

    local characterAddedConnection = player.CharacterAdded:Connect(function(character)
        CurrentTarget = (CurrentTarget == player) and nil or CurrentTarget
        destroyESP(player)

        task.spawn(function()
            character:WaitForChild("HumanoidRootPart", 5)

            if Unloaded then
                return
            end

            if State.ESP.Enabled then
                updateESPObject(player)
            end
        end)
    end)

    table.insert(PlayerConnections[player], characterAddedConnection)

    if player.Character then
        task.spawn(function()
            if not Unloaded and State.ESP.Enabled then
                updateESPObject(player)
            end
        end)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    hookPlayer(player)
end

addConnection(Players.PlayerAdded:Connect(function(player)
    hookPlayer(player)
end))

addConnection(Players.PlayerRemoving:Connect(function(player)
    if CurrentTarget == player then
        CurrentTarget = nil
    end

    destroyESP(player)

    local playerConnections = PlayerConnections[player]
    if playerConnections then
        for _, connection in ipairs(playerConnections) do
            disconnectConnection(connection)
        end
    end

    PlayerConnections[player] = nil
end))

addConnection(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end))

-- Classic third-person camera: let Roblox handle touch / mouse free-look.
-- Unlike v3.6, this never forces a CFrame behind HumanoidRootPart.
-- The game may still enforce its own first-person camera; in that case this
-- local override cannot guarantee that every custom camera controller yields.
local ThirdPersonBinding = "CVortexClassicThirdPerson"
local ThirdPersonPostBinding = "CVortexClassicThirdPersonPost"
local ThirdPersonBound = false
local SavedCameraSettings = nil

local function applyClassicThirdPerson()
    if Unloaded or not AuthGranted or not State.ThirdPerson.Enabled then return end
    local current = Workspace.CurrentCamera
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not current or not humanoid then return end
    local distance = math.clamp(tonumber(State.ThirdPerson.Distance) or 8, 4, 16)

    -- Restore the Roblox camera controller before its own camera update.
    if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
    if current.CameraType ~= Enum.CameraType.Custom then
        current.CameraType = Enum.CameraType.Custom
    end
    if current.CameraSubject ~= humanoid then
        current.CameraSubject = humanoid
    end
    -- A fixed zoom prevents Flick's first-person zoom (0.5 studs) while the
    -- native controller still handles free rotation with mouse or touch.
    if LocalPlayer.CameraMaxZoomDistance ~= distance then
        LocalPlayer.CameraMaxZoomDistance = distance
    end
    if LocalPlayer.CameraMinZoomDistance ~= distance then
        LocalPlayer.CameraMinZoomDistance = distance
    end
end

local function setThirdPersonEnabled(enabled)
    local want = enabled == true
    if want == State.ThirdPerson.Enabled and (not want or ThirdPersonBound) then return end
    State.ThirdPerson.Enabled = want
    if want then
        if not SavedCameraSettings then
            local current = Workspace.CurrentCamera
            SavedCameraSettings = {
                camera = current,
                type = current and current.CameraType or Enum.CameraType.Custom,
                subject = current and current.CameraSubject,
                mode = LocalPlayer.CameraMode,
                minZoom = LocalPlayer.CameraMinZoomDistance,
                maxZoom = LocalPlayer.CameraMaxZoomDistance,
            }
        end
        pcall(applyClassicThirdPerson)
        if not ThirdPersonBound then
            -- Run just before the native Roblox camera script. A second pass
            -- restores the mode if the game changes it later in that frame.
            RunService:BindToRenderStep(ThirdPersonBinding,
                Enum.RenderPriority.Camera.Value - 1, function()
                    pcall(applyClassicThirdPerson)
                end)
            RunService:BindToRenderStep(ThirdPersonPostBinding,
                Enum.RenderPriority.Camera.Value + 2, function()
                    pcall(applyClassicThirdPerson)
                end)
            ThirdPersonBound = true
        end
    else
        if ThirdPersonBound then
            RunService:UnbindFromRenderStep(ThirdPersonBinding)
            RunService:UnbindFromRenderStep(ThirdPersonPostBinding)
            ThirdPersonBound = false
        end
        if SavedCameraSettings then
            pcall(function()
                LocalPlayer.CameraMode = SavedCameraSettings.mode
                -- Restore maximum before minimum to avoid clamping errors.
                LocalPlayer.CameraMaxZoomDistance = SavedCameraSettings.maxZoom
                LocalPlayer.CameraMinZoomDistance = SavedCameraSettings.minZoom
                local current = Workspace.CurrentCamera
                if current then
                    current.CameraType = SavedCameraSettings.type
                    if SavedCameraSettings.subject then
                        current.CameraSubject = SavedCameraSettings.subject
                    end
                end
            end)
            SavedCameraSettings = nil
        end
    end
end

local uiOk, uiErr = pcall(function()
local Window = WindUI:CreateWindow({
    Title = "CVortexHub | Flick",
    Icon = "circle-check",
    Author = "CVortex",
    Folder = "CVortexHub",
    Theme = "Dark",
    NewElements = true,
    ToggleKey = Enum.KeyCode.RightShift,
    Size = IS_MOBILE and UDim2.fromOffset(
        math.clamp((Camera and Camera.ViewportSize.X or 400) - 24, 280, 440),
        math.clamp((Camera and Camera.ViewportSize.Y or 600) - 80, 310, 480)
    ) or UDim2.fromOffset(615, 525),
    OpenButton = {
        Enabled = true,
        Title = "CVortex",
        Draggable = true,
        OnlyMobile = IS_MOBILE,
        Scale = 0.65,
    },
    KeySystem = {
        Title = "CVortexHub | Key",
        Note = "discord.gg/ESQv2sc5p",
        Key = {"cvortex"},
        SaveKey = false,
        KeyValidator = function(key)
            if key ~= "cvortex" or Unloaded then return false end
            AuthGranted = true
            if ESP2DGui then ESP2DGui.Enabled = true end
            task.defer(function()
                if Unloaded then return end
                setStatsOverlayEnabled(StatsOverlayEnabled)
                updateRadar()
            end)
            return true
        end,
    },
})
ActiveWindow = Window
if not Window then error("WindUI window creation failed") end

local HomeTab = Window:Tab({Title = "Home", Icon = "house"})
HomeTab:Section({Title = "CVortexHub"})
HomeTab:Section({Title = "Ⓥ  CVORTEX  |  FLICK"})
pcall(function()
    HomeTab:Paragraph({
        Title = "CVortexHub",
        Desc = "FLICK  •  WINDUI",
        Image = LogoAsset or LogoFallback,
        ImageSize = 88,
    })
end)
HomeTab:Button({
    Title = "Discord",
    Icon = "link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/ESQv2sc5p")
            notify("CVortexHub", "Invite copied", 3)
        end
    end,
})

local AimbotTab = Window:Tab({Title = "Aimbot", Icon = "crosshair"})

AimbotTab:Section({Title = "Main"})

AimbotTab:Toggle({
    Title = "Enable Aimbot",
    Value = State.Aimbot.Enabled,
    Flag = "AimbotEnabledV2",
    Callback = function(value)
        State.Aimbot.Enabled = value

        if not value then
            CurrentTarget = nil
        end

        notify(
            "Aimbot",
            value and "Aimbot enabled" or "Aimbot disabled"
        )
    end,
})

if not IS_MOBILE then
    AimbotTab:Toggle({
        Title = "Hold RMB to Aim",
        Value = State.Aimbot.HoldRMB,
        Flag = "AimbotHoldRMBV2",
        Callback = function(value)
            State.Aimbot.HoldRMB = value
        end,
    })
end

AimbotTab:Toggle({
    Title = "Sticky Target",
    Value = State.Aimbot.StickyTarget,
    Flag = "AimbotStickyV2",
    Callback = function(value)
        State.Aimbot.StickyTarget = value

        if not value then
            CurrentTarget = nil
        end
    end,
})

AimbotTab:Slider({
    Title = "Aim Smoothing",
    Value = {Min = 0.02, Max = 1, Default = State.Aimbot.Smoothing},
    Step = 0.01,

    Flag = "AimSmoothingV2",
    Callback = function(value)
        State.Aimbot.Smoothing = value
    end,
})

AimbotTab:Section({Title = "Target"})

AimbotTab:Dropdown({
    Title = "Target Part",
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Value = State.Aimbot.TargetPart,

    Flag = "TargetPartV2",
    Callback = function(option)
        local value = type(option) == "table" and option[1] or option
        if value then
            State.Aimbot.TargetPart = value
            CurrentTarget = nil
        end
    end,
})

AimbotTab:Toggle({
    Title = "Visibility Check",
    Value = State.Aimbot.VisibilityCheck,
    Flag = "VisibilityCheckV2",
    Callback = function(value)
        State.Aimbot.VisibilityCheck = value
        CurrentTarget = nil
    end,
})

AimbotTab:Toggle({
    Title = "Team Check",
    Value = State.Aimbot.TeamCheck,
    Flag = "AimbotTeamCheckV2",
    Callback = function(value)
        State.Aimbot.TeamCheck = value
        CurrentTarget = nil
    end,
})

AimbotTab:Slider({
    Title = "Maximum Distance",
    Value = {Min = 100, Max = 5000, Default = State.Aimbot.MaxDistance},
    Step = 100,

    Flag = "MaxDistanceV2",
    Callback = function(value)
        State.Aimbot.MaxDistance = value
    end,
})

AimbotTab:Section({Title = "FOV"})

AimbotTab:Toggle({
    Title = "Show FOV Circle",
    Value = State.Aimbot.ShowFOV,
    Flag = "ShowFOVV2",
    Callback = function(value)
        State.Aimbot.ShowFOV = value
        updateFOVCircle()
    end,
})

AimbotTab:Slider({
    Title = "FOV Radius",
    Value = {Min = 25, Max = 600, Default = State.Aimbot.FOV},
    Step = 5,

    Flag = "FOVRadiusV2",
    Callback = function(value)
        State.Aimbot.FOV = value
        updateFOVCircle()
        CurrentTarget = nil
    end,
})

AimbotTab:Colorpicker({
    Title = "FOV Color",
    Default = Color3.fromRGB(255, 255, 255),
    Flag = "FOVColorV2",
    Callback = function(value)
        if FOVCircle then
            FOVCircle.Color = value
        end
    end,
})

AimbotTab:Section({Title = "Prediction"})

AimbotTab:Toggle({
    Title = "Movement Prediction",
    Value = State.Aimbot.Prediction,
    Flag = "PredictionEnabledV2",
    Callback = function(value)
        State.Aimbot.Prediction = value
    end,
})

AimbotTab:Slider({
    Title = "Prediction Time",
    Value = {Min = 0, Max = 0.25, Default = State.Aimbot.PredictionTime},
    Step = 0.01,

    Flag = "PredictionTimeV2",
    Callback = function(value)
        State.Aimbot.PredictionTime = value
    end,
})

local SilentTab = Window:Tab({Title = "Silent Aim", Icon = "target"})
SilentTab:Section({Title = "Silent Aim"})

SilentToggleControl = SilentTab:Toggle({
    Title = "Enable Silent Aim",
    Value = State.SilentAim.Enabled,
    Flag = "SilentAimEnabledV26",
    Callback = function(value)
        setSilentEnabled(value, true)
    end,
})

SilentTab:Toggle({
    Title = "Show Silent Aim Screen Button",
    Value = State.SilentAim.ShowButton,
    Flag = "SilentAimScreenButtonV26",
    Callback = function(value)
        State.SilentAim.ShowButton = value
        if SilentQuick then SilentQuick.Visible = value end
    end,
})

SilentTab:Dropdown({
    Title = "Hit Part",
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Value = State.SilentAim.TargetPart,

    Flag = "SilentAimPartV26",
    Callback = function(value)
        State.SilentAim.TargetPart = type(value) == "table" and value[1] or value
    end,
})

SilentTab:Slider({
    Title = "Silent Aim FOV",
    Value = {Min = 25, Max = 600, Default = State.SilentAim.FOV},
    Step = 5,

    Flag = "SilentAimFOVV26",
    Callback = function(value)
        State.SilentAim.FOV = value
        updateSilentCircle()
    end,
})

SilentTab:Toggle({
    Title = "Show Silent FOV Circle",
    Value = State.SilentAim.ShowFOV,
    Flag = "SilentAimShowFOVV26",
    Callback = function(value)
        State.SilentAim.ShowFOV = value
        updateSilentCircle()
    end,
})


SilentTab:Toggle({
    Title = "Wall Check",
    Value = State.SilentAim.Wallcheck,
    Flag = "SilentAimWallcheckV33",
    Callback = function(value)
        State.SilentAim.Wallcheck = value
    end,
})

SilentTab:Toggle({
    Title = "Team Check",
    Value = State.SilentAim.TeamCheck,
    Flag = "SilentAimTeamCheckV26",
    Callback = function(value)
        State.SilentAim.TeamCheck = value
    end,
})

local SpeedTab = Window:Tab({Title = "Speed", Icon = "zap"})
SpeedTab:Section({Title = "Speed Hack"})

SpeedToggleControl = SpeedTab:Toggle({
    Title = "Enable Speed Hack",
    Value = State.Speed.Enabled,
    Flag = "SpeedEnabledV26",
    Callback = function(value)
        setSpeedEnabled(value, true)
    end,
})

SpeedTab:Toggle({
    Title = "Show Speed Screen Button",
    Value = State.Speed.ShowButton,
    Flag = "SpeedScreenButtonV26",
    Callback = function(value)
        State.Speed.ShowButton = value
        if SpeedQuick then SpeedQuick.Visible = value end
    end,
})

SpeedSliderControl = SpeedTab:Slider({
    Title = "Walk Speed",
    Value = {Min = 16, Max = 150, Default = State.Speed.Value},
    Step = 1,

    Flag = "SpeedValueV26",
    Callback = function(value)
        State.Speed.Value = value
        if State.Speed.Enabled then setSpeedEnabled(true, true) end
    end,
})

SpeedTab:Section({Title = "Speed Timer"})
SpeedTab:Toggle({
    Title = "Enable Speed Timer",
    Desc = "Turn speed off automatically after the chosen time",
    Value = State.Speed.TimerEnabled,
    Flag = "CVortexSpeedTimerEnabledV36",
    Callback = function(value)
        State.Speed.TimerEnabled = value == true
        if State.Speed.Enabled then
            State.Speed.Deadline = State.Speed.TimerEnabled
                and (os.clock() + State.Speed.TimerSeconds) or nil
        end
        updateSpeedCountdown()
    end,
})
SpeedTab:Input({
    Title = "Timer Duration (seconds)",
    Desc = "Type a number from 1 to 3600. Applied on the next activation.",
    Value = tostring(State.Speed.TimerSeconds),
    Placeholder = "15",
    Flag = "CVortexSpeedTimerSecondsV36",
    Callback = function(value)
        local seconds = tonumber(value)
        if seconds and seconds == seconds then
            State.Speed.TimerSeconds = math.clamp(math.floor(seconds), 1, 3600)
        end
    end,
})
SpeedTab:Paragraph({
    Title = "Countdown",
    Desc = "When Speed Timer is ON, remaining seconds appear below the on-screen SPEED button. Speed resets automatically at 0.",
})

SpeedTab:Button({
    Title = "Reset Speed (Normal + OFF)",
    Callback = function()
        resetSpeed()
        notify("Speed", "Speed restored to normal.", 2)
    end,
})

local ESPTab = Window:Tab({Title = "ESP", Icon = "eye"})

ESPTab:Section({Title = "Main"})

ESPTab:Toggle({
    Title = "Enable ESP",
    Value = State.ESP.Enabled,
    Flag = "ESPEnabledV2",
    Callback = function(value)
        State.ESP.Enabled = value
        refreshAllESP()

        notify(
            "ESP",
            value and "ESP enabled" or "ESP disabled"
        )
    end,
})

ESPTab:Toggle({
    Title = "ESP Team Check",
    Value = State.ESP.TeamCheck,
    Flag = "ESPTeamCheckV2",
    Callback = function(value)
        State.ESP.TeamCheck = value
        refreshAllESP()
    end,
})

ESPTab:Toggle({
    Title = "Visibility Colors",
    Value = State.ESP.VisibilityColors,
    Flag = "ESPVisibilityColorsV2",
    Callback = function(value)
        State.ESP.VisibilityColors = value
        refreshAllESP()
    end,
})

ESPTab:Toggle({
    Title = "Show Names",
    Value = State.ESP.ShowNames,
    Flag = "ESPShowNamesV2",
    Callback = function(value)
        State.ESP.ShowNames = value
        refreshAllESP()
    end,
})

ESPTab:Toggle({
    Title = "Show Distance",
    Value = State.ESP.ShowDistance,
    Flag = "ESPShowDistanceV2",
    Callback = function(value)
        State.ESP.ShowDistance = value
        refreshAllESP()
    end,
})

ESPTab:Section({Title = "2D ESP (Mobile + PC)"})
ESPTab:Toggle({
    Title = "Box ESP",
    Desc = "Stable box around player; weapon and accessories are ignored",
    Value = State.ESP.Box,
    Flag = "CVortexESPBoxV36",
    Callback = function(value)
        State.ESP.Box = value == true
        refreshAllESP()
    end,
})
ESPTab:Dropdown({
    Title = "Box Size Mode",
    Desc = "Fixed: same pixel size for all players; Perspective: scales by distance",
    Values = {"Fixed", "Perspective"},
    Value = State.ESP.BoxMode,
    Flag = "CVortexESPBoxModeV37",
    Callback = function(selection)
        local value = type(selection) == "table" and selection[1] or selection
        if value == "Fixed" or value == "Perspective" then
            State.ESP.BoxMode = value
            refreshAllESP()
        end
    end,
})
ESPTab:Toggle({
    Title = "Tracers",
    Desc = "Lines from the bottom of the screen to players",
    Value = State.ESP.Tracers,
    Flag = "CVortexESPTracersV36",
    Callback = function(value)
        State.ESP.Tracers = value == true
        refreshAllESP()
    end,
})

ESPTab:Section({Title = "Visible Player Colors"})

ESPTab:Colorpicker({
    Title = "Visible Fill",
    Default = State.ESP.VisibleFill,
    Flag = "ESPVisibleFillV2",
    Callback = function(value)
        State.ESP.VisibleFill = value
        refreshAllESP()
    end,
})

ESPTab:Colorpicker({
    Title = "Visible Outline",
    Default = State.ESP.VisibleOutline,
    Flag = "ESPVisibleOutlineV2",
    Callback = function(value)
        State.ESP.VisibleOutline = value
        refreshAllESP()
    end,
})

ESPTab:Section({Title = "Hidden Player Colors"})

ESPTab:Colorpicker({
    Title = "Hidden Fill",
    Default = State.ESP.HiddenFill,
    Flag = "ESPHiddenFillV2",
    Callback = function(value)
        State.ESP.HiddenFill = value
        refreshAllESP()
    end,
})

ESPTab:Colorpicker({
    Title = "Hidden Outline",
    Default = State.ESP.HiddenOutline,
    Flag = "ESPHiddenOutlineV2",
    Callback = function(value)
        State.ESP.HiddenOutline = value
        refreshAllESP()
    end,
})

ESPTab:Section({Title = "Appearance"})

ESPTab:Slider({
    Title = "Fill Transparency",
    Value = {Min = 0, Max = 1, Default = State.ESP.FillTransparency},
    Step = 0.05,

    Flag = "ESPFillTransparencyV2",
    Callback = function(value)
        State.ESP.FillTransparency = value
        refreshAllESP()
    end,
})

ESPTab:Slider({
    Title = "Outline Transparency",
    Value = {Min = 0, Max = 1, Default = State.ESP.OutlineTransparency},
    Step = 0.05,

    Flag = "ESPOutlineTransparencyV2",
    Callback = function(value)
        State.ESP.OutlineTransparency = value
        refreshAllESP()
    end,
})

ESPTab:Slider({
    Title = "ESP Update Interval",
    Value = {Min = 0.05, Max = 0.5, Default = State.ESP.UpdateInterval},
    Step = 0.05,

    Flag = "ESPUpdateIntervalV2",
    Callback = function(value)
        State.ESP.UpdateInterval = value
    end,
})


ESPTab:Section({Title = "Radar"})
ESPTab:Toggle({
    Title = "Enable Radar",
    Value = State.Radar.Enabled,
    Flag = "CVortexRadarEnabledV30",
    Callback = function(value)
        State.Radar.Enabled = value
        updateRadar()
    end,
})
ESPTab:Slider({
    Title = "Radar Size",
    Value = {Min = 110, Max = 260, Default = State.Radar.Size},
    Step = 5,
    Flag = "CVortexRadarSizeV30",
    Callback = function(value)
        State.Radar.Size = value
        updateRadar()
    end,
})
ESPTab:Slider({
    Title = "Radar Distance",
    Value = {Min = 50, Max = 1200, Default = State.Radar.Range},
    Step = 25,
    Flag = "CVortexRadarRangeV30",
    Callback = function(value)
        State.Radar.Range = value
        updateRadar()
    end,
})
ESPTab:Toggle({
    Title = "Show Teammates (Blue)",
    Value = State.Radar.ShowTeammates,
    Flag = "CVortexRadarTeamV30",
    Callback = function(value)
        State.Radar.ShowTeammates = value
        updateRadar()
    end,
})

local ConfigTab = Window:Tab({Title = "Configs", Icon = "save"})
ConfigTab:Section({Title = "Profiles"})
local ConfigManager = Window.ConfigManager
local ConfigName = "default"
local ConfigInput = ConfigTab:Input({
    Title = "Config name",
    Value = ConfigName,
    Placeholder = "default",
    Callback = function(value)
        ConfigName = tostring(value or "default")
    end,
})

local function configNameSafe()
    local name = tostring(ConfigName):gsub("[^%w_%-]", "_"):sub(1, 32)
    if name == "" then name = "default" end
    return name
end

local function getVisibleConfigNames()
    if not ConfigManager then return {} end
    local profiles = {}
    for _, name in ipairs(ConfigManager:AllConfigs()) do
        if name ~= "__cvortex_factory" then
            table.insert(profiles, name)
        end
    end
    table.sort(profiles)
    return profiles
end

local ConfigList
local function refreshConfigList()
    if ConfigList then
        pcall(function() ConfigList:Refresh(getVisibleConfigNames()) end)
    end
end

if ConfigManager then
    ConfigList = ConfigTab:Dropdown({
        Title = "Saved profiles",
        Values = getVisibleConfigNames(),
        AllowNone = true,
        Callback = function(value)
            local name = type(value) == "table" and value[1] or value
            if type(name) == "string" then
                ConfigName = name
                if ConfigInput then pcall(function() ConfigInput:Set(name) end) end
            end
        end,
    })
end

ConfigTab:Button({
    Title = "Save config",
    Icon = "save",
    Callback = function()
        if not ConfigManager then
            notify("Configs", "File access unavailable in this executor", 4)
            return
        end
        local name = configNameSafe()
        local ok, result = pcall(function()
            return ConfigManager:Config(name):Save()
        end)
        if ok and result then
            ConfigName = name
            refreshConfigList()
            notify("Configs", "Saved: " .. name, 3)
        else
            notify("Configs", "Save failed: " .. tostring(result), 4)
        end
    end,
})

ConfigTab:Button({
    Title = "Load config",
    Icon = "folder-open",
    Callback = function()
        if not ConfigManager then
            notify("Configs", "File access unavailable in this executor", 4)
            return
        end
        local name = configNameSafe()
        local ok, result = pcall(function()
            return ConfigManager:Config(name):Load()
        end)
        if ok and result then
            notify("Configs", "Loaded: " .. name, 3)
        else
            notify("Configs", "Config not found: " .. name, 3)
        end
    end,
})

ConfigTab:Button({
    Title = "Delete config",
    Icon = "trash-2",
    Callback = function()
        if not ConfigManager then return end
        local name = configNameSafe()
        local ok, success = pcall(function()
            return ConfigManager:DeleteConfig(name)
        end)
        refreshConfigList()
        notify("Configs", (ok and success) and ("Deleted: " .. name) or "Deletion failed", 3)
    end,
})

-- Native WindUI load updates flags and their respective UI controls.
-- This one file determines which profile to load on the next start.
local AutoLoadPath = "CVortexHub_Autoload.txt"
ConfigTab:Button({
    Title = "Auto-load selected config",
    Icon = "repeat",
    Callback = function()
        local name = configNameSafe()
        local exists = ConfigManager and ConfigManager:GetConfig(name)
        if not exists and ConfigManager then
            exists = ConfigManager:Config(name)
        end
        if not exists or not isfile or not isfile(exists.Path) then
            notify("Configs", "Save the config first", 3)
            return
        end
        if writefile then
            local ok = pcall(function() writefile(AutoLoadPath, name) end)
            notify("Configs", ok and ("Auto-load: " .. name) or "Cannot enable auto-load", 3)
        end
    end,
})

ConfigTab:Button({
    Title = "Disable auto-load",
    Icon = "x",
    Callback = function()
        if delfile and isfile and isfile(AutoLoadPath) then
            pcall(function() delfile(AutoLoadPath) end)
        elseif writefile then
            pcall(function() writefile(AutoLoadPath, "") end)
        end
        notify("Configs", "Auto-load disabled", 3)
    end,
})

-- Stored before auto-loading any profile, so it always reflects factory defaults.
if ConfigManager then
    pcall(function() ConfigManager:Config("__cvortex_factory"):Save() end)
end
ConfigTab:Button({
    Title = "Reset all settings",
    Icon = "rotate-ccw",
    Callback = function()
        if ConfigManager then
            local ok, result = pcall(function()
                return ConfigManager:Config("__cvortex_factory"):Load()
            end)
            if ok and result then
                notify("Configs", "Restored default settings", 3)
                return
            end
        end
        setSilentEnabled(false, false)
        setSpeedEnabled(false, false)
        notify("Configs", "Silent Aim and Speed disabled", 3)
    end,
})

if ConfigManager and isfile and readfile and isfile(AutoLoadPath) then
    task.defer(function()
        local ok, name = pcall(function() return readfile(AutoLoadPath) end)
        if ok and type(name) == "string" and name:match("^[%w_%-]+$") then
            task.wait(0.25)
            if Unloaded then return end
            local loaded, result = pcall(function()
                return ConfigManager:Config(name):Load()
            end)
            if loaded and result then
                notify("Configs", "Auto-loaded: " .. name, 3)
            end
        end
    end)
end

local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings"})

SettingsTab:Section({Title = "UI"})

SettingsTab:Toggle({
    Title = "Show FPS / Ping Overlay",
    Desc = "Show Cvortex, FPS and ping in the top-left corner",
    Flag = "CVortexStatsOverlay",
    Value = true,
    Callback = function(value)
        setStatsOverlayEnabled(value)
    end,
})

SettingsTab:Section({Title = "Camera"})
SettingsTab:Toggle({
    Title = "Classic Third Person (Free Look)",
    Desc = "Roblox camera controls: rotate by dragging or moving the mouse",
    Value = State.ThirdPerson.Enabled,
    Flag = "CVortexThirdPersonEnabledV36",
    Callback = function(value)
        setThirdPersonEnabled(value)
    end,
})
SettingsTab:Slider({
    Title = "Camera Distance",
    Desc = "Fixed camera distance; drag to look around normally",
    Value = {Min = 4, Max = 16, Default = State.ThirdPerson.Distance},
    Step = 1,
    Flag = "CVortexThirdPersonDistanceV36",
    Callback = function(value)
        State.ThirdPerson.Distance = value
        if State.ThirdPerson.Enabled then
            pcall(applyClassicThirdPerson)
        end
    end,
})

SettingsTab:Section({Title = "Utilities"})

SettingsTab:Button({
    Title = "Copy Discord Invite",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/ESQv2sc5p")
            notify("Discord", "Invite copied to clipboard!", 4)
        else
            notify("Discord", "Clipboard API is unavailable in this environment.", 4)
        end
    end,
})

SettingsTab:Button({
    Title = "Reset Current Target",
    Callback = function()
        CurrentTarget = nil
        notify("Aimbot", "Current target cleared.", 2)
    end,
})

SettingsTab:Button({
    Title = "Unload CVortexHub",
    Callback = function()
        if ENV.__CVortexHubCleanup then
            ENV.__CVortexHubCleanup()
        end
    end,
})

end)
if uiOk then
    UIReady = true
    updateFOVCircle()
    updateSilentCircle()
    updateRadar()
else
    UIReady = false
    warn("[CVortexHub] WindUI UI failed to build:", uiErr)
    pcall(function()
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "CVortexHubUIError"
        errorGui.ResetOnSpawn = false
        errorGui.DisplayOrder = 10000
        errorGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        local message = Instance.new("TextLabel")
        message.Size = UDim2.new(0.85, 0, 0, 95)
        message.Position = UDim2.new(0.075, 0, 0.08, 0)
        message.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        message.TextColor3 = Color3.fromRGB(255, 150, 150)
        message.TextWrapped = true
        message.TextSize = 15
        message.Text = "CVortexHub UI error: " .. tostring(uiErr)
        message.Parent = errorGui
        task.delay(30, function() if errorGui then errorGui:Destroy() end end)
    end)
end

local renderConnection
local ESP2DAccumulator = 0

renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
    if Unloaded then
        return
    end

    if Workspace.CurrentCamera ~= Camera then
        Camera = Workspace.CurrentCamera
    end

    if not Camera then
        return
    end

    updateFOVCircle()
    updateSilentCircle()

    -- More fluid 2D boxes / tracers on mobile without recomputing highlights.
    ESP2DAccumulator += deltaTime
    if ESP2DAccumulator >= 1 / 30 then
        ESP2DAccumulator = 0
        if AuthGranted and State.ESP.Enabled and (State.ESP.Box or State.ESP.Tracers) then
            for player, object in pairs(ESPObjects) do
                local character = player.Character
                if character and object.Character == character then
                    updateESP2D(object, character, object.OverlayColor or State.ESP.VisibleOutline)
                else
                    hideESP2D(object)
                end
            end
        end
    end

    ESPAccumulator += deltaTime

    if ESPAccumulator >= State.ESP.UpdateInterval then
        ESPAccumulator = 0
        updateRadar()

        if State.ESP.Enabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    updateESPObject(player)
                end
            end
        end
    end

    if not isAimbotInputActive() then
        if not State.Aimbot.StickyTarget then
            CurrentTarget = nil
        end
        return
    end

    local candidate = getBestTarget()

    if candidate then
        aimAt(candidate, deltaTime)
    end
end)

addConnection(renderConnection)

local function cleanup()
    if Unloaded then
        return
    end

    setThirdPersonEnabled(false)
    Unloaded = true
    if ESP2DGui then pcall(function() ESP2DGui:Destroy() end); ESP2DGui = nil end
    if StatsOverlayGui then
        pcall(function() StatsOverlayGui:Destroy() end)
        StatsOverlayGui = nil
        StatsOverlayText = nil
    end
    if RadarGui then RadarGui:Destroy(); RadarGui = nil end
    table.clear(RadarBlips)
    CurrentTarget = nil
    State.Speed.Enabled = false
    if SpeedHumanoid and OriginalWalkSpeed then
        pcall(function() SpeedHumanoid.WalkSpeed = OriginalWalkSpeed end)
    end
    if BulletHandler and SilentFireWrapper and BulletHandler.Fire == SilentFireWrapper then
        BulletHandler.Fire = OriginalBulletFire
    end
    SilentHookReady = false
    if ScreenGui then
        pcall(function() ScreenGui:Destroy() end)
        ScreenGui = nil
    end
    if SilentCircle then
        pcall(function() SilentCircle.Visible = false; SilentCircle:Remove() end)
        SilentCircle = nil
    end

    for _, connection in ipairs(Connections) do
        disconnectConnection(connection)
    end

    table.clear(Connections)

    for player, playerConnections in pairs(PlayerConnections) do
        for _, connection in ipairs(playerConnections) do
            disconnectConnection(connection)
        end

        PlayerConnections[player] = nil
    end

    for player in pairs(ESPObjects) do
        destroyESP(player)
    end

    if FOVCircle then
        pcall(function()
            FOVCircle.Visible = false
            FOVCircle:Remove()
        end)

        FOVCircle = nil
    end

    pcall(function()
        if ActiveWindow then
            ActiveWindow:Destroy()
            ActiveWindow = nil
        end
    end)

    if ENV.__CVortexHubCleanup == cleanup then
        ENV.__CVortexHubCleanup = nil
    end
end

ENV.__CVortexHubCleanup = cleanup
task.spawn(function()
    task.wait(0.25)

    if not Unloaded then
        refreshAllESP()
    end
end)

print("CVortexHub v3.7 | Fixed Box ESP + Classic Third Person")
