
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
        TeamCheck = false,
        MaxDistance = 2500,
        MinDistance = 5,
    },

    Speed = {
        Enabled = false,
        ShowButton = false,
        Value = 32,
        NormalSpeed = 16,
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

        UpdateInterval = 0.10,
    },
}

local Connections = {}
local PlayerConnections = {}
local ESPObjects = {}

local CurrentTarget = nil
local Unloaded = false
local ESPAccumulator = 0
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

local function isVisible(character, targetPartObject)
    if not Camera or not character or not targetPartObject then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = targetPartObject.Position - origin

    if direction.Magnitude <= 0.001 then
        return true
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        LocalPlayer.Character,
        Camera,
    }
    params.IgnoreWater = true

    local result = Workspace:Raycast(origin, direction, params)

    if result == nil then
        return true
    end

    return result.Instance ~= nil
        and result.Instance:IsDescendantOf(character)
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
    FOVCircle.Visible = UIReady and State.Aimbot.ShowFOV and not Unloaded
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
    SilentCircle.Visible = UIReady and State.SilentAim.Enabled
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

        local filter = {character}
        if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
        if Camera then table.insert(filter, Camera) end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = filter
        params.IgnoreWater = true
        local hit = Workspace:Raycast(origin, pos - origin, params)
        if hit and hit.Distance < distance - 0.5 then return end

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

local function setSpeedEnabled(value, fromMenu)
    State.Speed.Enabled = not not value
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
        SpeedQuick.Text = State.Speed.Enabled and "SPEED  ON" or "SPEED  OFF"
        SpeedQuick.BackgroundColor3 = State.Speed.Enabled and Color3.fromRGB(28, 142, 106) or Color3.fromRGB(25, 32, 52)
    end
end

local function setSilentEnabled(value, fromMenu)
    State.SilentAim.Enabled = not not value
    updateSilentCircle()
    if SilentToggleControl and not fromMenu then
        pcall(function() SilentToggleControl:Set(State.SilentAim.Enabled, false) end)
    end
    if SilentQuick then
        SilentQuick.Text = State.SilentAim.Enabled and "SILENT  ON" or "SILENT  OFF"
        SilentQuick.BackgroundColor3 = State.SilentAim.Enabled and Color3.fromRGB(28, 142, 106) or Color3.fromRGB(25, 32, 52)
    end
end

local function createQuickButton(name, offsetY, onPress)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(112, 41)
    button.Position = UDim2.new(1, -125, 0.48, offsetY)
    button.AnchorPoint = Vector2.new(0, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(25, 32, 52)
    button.TextColor3 = Color3.fromRGB(248, 248, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Active = true
    button.Parent = ScreenGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(65, 145, 255)
    outline.Thickness = 1.4
    outline.Transparency = 0.15
    outline.Parent = button
    addConnection(button.Activated:Connect(onPress))
    return button
end

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

    SilentQuick = createQuickButton("SilentAimButton", -30, function()
        setSilentEnabled(not State.SilentAim.Enabled, false)
    end)
    SpeedQuick = createQuickButton("SpeedButton", 22, function()
        setSpeedEnabled(not State.Speed.Enabled, false)
    end)
    SilentQuick.Visible = State.SilentAim.ShowButton
    SpeedQuick.Visible = State.Speed.ShowButton
    setSilentEnabled(State.SilentAim.Enabled, true)
    setSpeedEnabled(State.Speed.Enabled, true)
end

initializeQuickButtons()

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
    if Unloaded or not State.Speed.Enabled then return end
    local humanoid = syncSpeedCharacter()
    if humanoid and humanoid.Health > 0 and humanoid.WalkSpeed ~= State.Speed.Value then
        humanoid.WalkSpeed = State.Speed.Value
    end
end))

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

local uiOk, uiErr = pcall(function()
local Window = WindUI:CreateWindow({
    Title = "CVortexHub | Flick",
    Icon = "crosshair",
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
        Key = {"vortex"},
        SaveKey = false,
    },
})
ActiveWindow = Window
if not Window then error("WindUI window creation failed") end

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

local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings"})

SettingsTab:Section({Title = "UI"})


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
else
    UIReady = false
    warn("[CVortexHub] WindUI UI failed to build:", uiErr)
end

local renderConnection

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

    ESPAccumulator += deltaTime

    if ESPAccumulator >= State.ESP.UpdateInterval then
        ESPAccumulator = 0

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

    Unloaded = true
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

print("CVortexHub v2.8 | WindUI loaded")
