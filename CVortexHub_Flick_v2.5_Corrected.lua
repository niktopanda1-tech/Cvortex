--[[
    CVortexHub | Flick
    Reworked edition 2.0

    Main changes:
    - Modern Workspace:Raycast visibility checks
    - Frame-rate independent aim smoothing
    - Sticky target support
    - Optional RMB hold-to-aim
    - Prediction for moving targets
    - Proper R6/R15 target-part fallback
    - ESP caching instead of recreating Highlights every update
    - Throttled ESP updates for better performance
    - Working visible/hidden ESP colors
    - Optional names + distance
    - Connection/object cleanup and safe re-execution
    - FOV visibility no longer controls whether targeting works
]]

--// =========================================================
--// Boot / duplicate-run cleanup
--// =========================================================

local ENV = (getgenv and getgenv()) or _G

if ENV.__CVortexHubCleanup then
    pcall(ENV.__CVortexHubCleanup)
    ENV.__CVortexHubCleanup = nil
end

local okRayfield, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not okRayfield or not Rayfield then
    warn("[CVortexHub] Failed to load Rayfield:", Rayfield)
    return
end

--// =========================================================
--// Services
--// =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Mobile detection
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--// =========================================================
--// State
--// =========================================================

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

    Triggerbot = {
        Enabled = false,
        TeamCheck = true,
        VisibilityCheck = true,
        Delay = 0.03,
        Cooldown = 0.10,
    },

    SilentAim = {
        Enabled = false,
        HitChance = 100,
        FOV = 160,
        TargetPart = "Head",
        TeamCheck = true,
        VisibilityCheck = true,
        MaxDistance = 2000,
        Prediction = false,
        PredictionTime = 0.07,
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
local LastTriggerShot = 0
local TriggerPending = false
local TriggerToggleSerial = 0
local UIReady = false

--// =========================================================
--// Utilities
--// =========================================================

local function notify(title, content, duration)
    pcall(function()
        Rayfield:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3,
            Image = 4483362458,
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
    local ignore = {Camera}
    if LocalPlayer.Character then
        table.insert(ignore, LocalPlayer.Character)
    end
    params.FilterDescendantsInstances = ignore
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

    -- Phones/tablets do not have MouseButton2.
    -- On touch devices the main "Enable Aimbot" toggle is the activation switch.
    if IS_MOBILE then
        return true
    end

    if not State.Aimbot.HoldRMB then
        return true
    end

    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end

--// =========================================================
--// Triggerbot
--// =========================================================

local function getPlayerFromDescendant(instance)
    if not instance then
        return nil
    end

    local current = instance
    while current and current ~= Workspace do
        local player = Players:GetPlayerFromCharacter(current)
        if player then
            return player
        end
        current = current.Parent
    end

    return nil
end

local function getCrosshairTarget()
    if not Camera then
        return nil
    end

    local viewport = Camera.ViewportSize
    local centerX = viewport.X * 0.5
    local centerY = viewport.Y * 0.5

    local ray = Camera:ViewportPointToRay(centerX, centerY)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {Camera}
    if LocalPlayer.Character then
        table.insert(ignore, LocalPlayer.Character)
    end
    params.FilterDescendantsInstances = ignore
    params.IgnoreWater = true

    local result = Workspace:Raycast(ray.Origin, ray.Direction * State.Aimbot.MaxDistance, params)
    if not result or not result.Instance then
        return nil
    end

    local player = getPlayerFromDescendant(result.Instance)
    if not player or player == LocalPlayer then
        return nil
    end

    if not isAlive(player) then
        return nil
    end

    if State.Triggerbot.TeamCheck and sameTeam(player) then
        return nil
    end

    return player, result
end

local function firePrimary()
    -- Most PC/mobile executors expose one of these APIs.
    if type(mouse1click) == "function" then
        local success = pcall(mouse1click)
        if success then return true end
    end

    if type(mouse1press) == "function" and type(mouse1release) == "function" then
        local success = pcall(function()
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end)
        if success then return true end
    end

    -- Fallback for environments exposing VirtualInputManager.
    local ok, vim = pcall(function()
        return game:GetService("VirtualInputManager")
    end)

    if ok and vim and Camera then
        local viewport = Camera.ViewportSize
        local x = math.floor(viewport.X * 0.5)
        local y = math.floor(viewport.Y * 0.5)

        local success = pcall(function()
            vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
            task.wait(0.01)
            vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end)

        if success then
            return true
        end
    end

    return false
end

local function updateTriggerbot()
    if not State.Triggerbot.Enabled or TriggerPending then
        return
    end

    local now = os.clock()
    if now - LastTriggerShot < State.Triggerbot.Cooldown then
        return
    end

    local player = getCrosshairTarget()
    if not player then
        return
    end

    TriggerPending = true
    local serial = TriggerToggleSerial

    task.delay(State.Triggerbot.Delay, function()
        TriggerPending = false
        if Unloaded or not State.Triggerbot.Enabled or serial ~= TriggerToggleSerial then
            return
        end

        local currentPlayer = getCrosshairTarget()
        if currentPlayer ~= player then
            return
        end

        LastTriggerShot = os.clock()
        if not firePrimary() then
            State.Triggerbot.Enabled = false
            TriggerToggleSerial += 1
            notify("Triggerbot", "Click API is not supported by this executor.", 4)
        end
    end)
end

--// =========================================================
--// FOV circle
--// =========================================================

local FOVCircle = nil

pcall(function()
    if Drawing and Drawing.new then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Thickness = 2
        FOVCircle.NumSides = 64
        FOVCircle.Radius = State.Aimbot.FOV
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        FOVCircle.Position = Camera and getScreenCenter() or Vector2.new(0, 0)
        -- Keep it hidden until Rayfield has finished building.
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

--// =========================================================
--// Aimbot
--// =========================================================

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

--// =========================================================
--// Flick Silent Aim: GunModules.BulletHandler.Fire interception
--// =========================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BulletHookKey = "__CVortexFlickBulletHook"

local function findSilentTarget(origin)
    if not Camera then return nil end

    local cfg = State.SilentAim
    local nearestDistance = cfg.FOV
    local nearestPart = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isAlive(player) then
            if not cfg.TeamCheck or not sameTeam(player) then
                local character = player.Character
                local part = resolveTargetPart(character, cfg.TargetPart)

                if part and (part.Position - origin).Magnitude <= cfg.MaxDistance then
                    local point, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and point.Z > 0 then
                        local screenDistance = (
                            Vector2.new(point.X, point.Y) - getScreenCenter()
                        ).Magnitude

                        if screenDistance <= nearestDistance then
                            if not cfg.VisibilityCheck or isVisible(character, part) then
                                nearestDistance = screenDistance
                                nearestPart = part
                            end
                        end
                    end
                end
            end
        end
    end

    return nearestPart
end

local function redirectBullet(packet)
    if Unloaded or not State.SilentAim.Enabled then return end
    if type(packet) ~= "table" then return end
    if typeof(packet.Origin) ~= "Vector3" then return end
    if typeof(packet.Direction) ~= "Vector3" then return end
    if math.random(1, 100) > State.SilentAim.HitChance then return end

    local target = findSilentTarget(packet.Origin)
    if not target or not target.Parent then return end

    local position = target.Position
    if State.SilentAim.Prediction then
        position += target.AssemblyLinearVelocity * State.SilentAim.PredictionTime
    end

    local direction = position - packet.Origin
    if direction.Magnitude <= 0.001 then return end

    packet.Direction = direction.Unit
end

local function installSilentHook()
    local moduleFolder = ReplicatedStorage:FindFirstChild("ModuleScripts")
    local gunFolder = moduleFolder and moduleFolder:FindFirstChild("GunModules")
    local bulletModule = gunFolder and gunFolder:FindFirstChild("BulletHandler")

    if not bulletModule or not bulletModule:IsA("ModuleScript") then
        return false, "BulletHandler module was not found. Join a match and try again."
    end

    local okRequire, handler = pcall(require, bulletModule)
    if not okRequire or type(handler) ~= "table" or type(handler.Fire) ~= "function" then
        return false, "BulletHandler.Fire is unavailable in this game version."
    end

    local existing = ENV[BulletHookKey]
    if type(existing) == "table" and existing.installed and existing.module == handler then
        existing.redirect = redirectBullet
        return true
    end

    local original = handler.Fire
    local oldFire = original
    local manager = {
        installed = false,
        module = handler,
        original = original,
        redirect = redirectBullet,
        method = nil,
    }

    local wrappedFire = function(...)
        if manager.redirect then
            local first = select(1, ...)
            local second = select(2, ...)
            local packet = (type(first) == "table" and typeof(first.Origin) == "Vector3")
                and first or second
            if type(packet) == "table" then
                pcall(manager.redirect, packet)
            end
        end
        return oldFire(...)
    end

    manager.wrapper = wrappedFire

    if type(hookfunction) == "function" then
        local hooked, previous = pcall(hookfunction, original, wrappedFire)
        if hooked and type(previous) == "function" then
            oldFire = previous
            manager.method = "hookfunction"
            manager.installed = true
        end
    end

    if not manager.installed then
        local changed = pcall(function() handler.Fire = wrappedFire end)
        if changed and handler.Fire == wrappedFire then
            manager.method = "direct"
            manager.installed = true
        end
    end

    if not manager.installed then
        return false, "Delta could not hook BulletHandler.Fire."
    end

    ENV[BulletHookKey] = manager
    return true
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

    -- Keeps smoothing approximately consistent at different FPS.
    local baseAlpha = math.clamp(State.Aimbot.Smoothing, 0.01, 1)
    local frameFactor = math.max(deltaTime, 1 / 240) * 60
    local alpha = 1 - math.pow(1 - baseAlpha, frameFactor)

    Camera.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(alpha, 0, 1))
end

--// =========================================================
--// ESP
--// =========================================================

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

--// =========================================================
--// Player events
--// =========================================================

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

--// =========================================================
--// UI
--// =========================================================

local uiOk, uiErr = pcall(function()
local Window = Rayfield:CreateWindow({
    Name = "CVortexHub | Flick Reworked",
    LoadingTitle = "CVortexHub",
    LoadingSubtitle = "Reworked 2.5",
    ShowText = "CVortexHub", -- mobile button used to reopen/unhide Rayfield
    ToggleUIKeybind = "K",

    ConfigurationSaving = {
        -- Some Android/iOS executors do not expose filesystem APIs consistently.
        Enabled = not IS_MOBILE,
        FolderName = "CVortexHub",
        FileName = "FlickConfigV2",
    },

    Discord = {
        -- Discord/RPC integration is desktop-oriented in many executors.
        Enabled = not IS_MOBILE,
        Invite = "tHXHQgZBa",
        RememberJoins = true,
    },

    KeySystem = true,

    KeySettings = {
        Title = "CVortexHub Key System",
        Subtitle = "Enter Key",
        Note = "Join discord to get key: discord.gg/tHXHQgZBa",
        FileName = "CVortexKey",
        SaveKey = not IS_MOBILE,
        GrabKeyFromSite = false,
        Key = {"vortex"},
    },
})

--// Aimbot tab

local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

AimbotTab:CreateSection("Main")

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = State.Aimbot.Enabled,
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
    AimbotTab:CreateToggle({
        Name = "Hold RMB to Aim",
        CurrentValue = State.Aimbot.HoldRMB,
        Flag = "AimbotHoldRMBV2",
        Callback = function(value)
            State.Aimbot.HoldRMB = value
        end,
    })
else
    AimbotTab:CreateParagraph({
        Title = "Mobile Mode",
        Content = "Touch device detected. RMB activation is disabled; use the Enable Aimbot toggle to turn aiming on/off.",
    })
end

AimbotTab:CreateToggle({
    Name = "Sticky Target",
    CurrentValue = State.Aimbot.StickyTarget,
    Flag = "AimbotStickyV2",
    Callback = function(value)
        State.Aimbot.StickyTarget = value

        if not value then
            CurrentTarget = nil
        end
    end,
})

AimbotTab:CreateSlider({
    Name = "Aim Smoothing",
    Range = {0.02, 1},
    Increment = 0.01,
    CurrentValue = State.Aimbot.Smoothing,
    Flag = "AimSmoothingV2",
    Callback = function(value)
        State.Aimbot.Smoothing = value
    end,
})

AimbotTab:CreateSection("Target")

AimbotTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {State.Aimbot.TargetPart},
    MultipleOptions = false,
    Flag = "TargetPartV2",
    Callback = function(option)
        local value = type(option) == "table" and option[1] or option
        if value then
            State.Aimbot.TargetPart = value
            CurrentTarget = nil
        end
    end,
})

AimbotTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = State.Aimbot.VisibilityCheck,
    Flag = "VisibilityCheckV2",
    Callback = function(value)
        State.Aimbot.VisibilityCheck = value
        CurrentTarget = nil
    end,
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = State.Aimbot.TeamCheck,
    Flag = "AimbotTeamCheckV2",
    Callback = function(value)
        State.Aimbot.TeamCheck = value
        CurrentTarget = nil
    end,
})

AimbotTab:CreateSlider({
    Name = "Maximum Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = " studs",
    CurrentValue = State.Aimbot.MaxDistance,
    Flag = "MaxDistanceV2",
    Callback = function(value)
        State.Aimbot.MaxDistance = value
    end,
})

AimbotTab:CreateSection("FOV")

AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = State.Aimbot.ShowFOV,
    Flag = "ShowFOVV2",
    Callback = function(value)
        State.Aimbot.ShowFOV = value
        updateFOVCircle()
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV Radius",
    Range = {25, 600},
    Increment = 5,
    Suffix = " px",
    CurrentValue = State.Aimbot.FOV,
    Flag = "FOVRadiusV2",
    Callback = function(value)
        State.Aimbot.FOV = value
        updateFOVCircle()
        CurrentTarget = nil
    end,
})

AimbotTab:CreateColorPicker({
    Name = "FOV Color",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "FOVColorV2",
    Callback = function(value)
        if FOVCircle then
            FOVCircle.Color = value
        end
    end,
})

AimbotTab:CreateSection("Prediction")

AimbotTab:CreateToggle({
    Name = "Movement Prediction",
    CurrentValue = State.Aimbot.Prediction,
    Flag = "PredictionEnabledV2",
    Callback = function(value)
        State.Aimbot.Prediction = value
    end,
})

AimbotTab:CreateSlider({
    Name = "Prediction Time",
    Range = {0, 0.25},
    Increment = 0.01,
    Suffix = " s",
    CurrentValue = State.Aimbot.PredictionTime,
    Flag = "PredictionTimeV2",
    Callback = function(value)
        State.Aimbot.PredictionTime = value
    end,
})

--// Flick-specific Silent Aim tab

local SilentTab = Window:CreateTab("🔇 Silent Aim", 4483362458)

SilentTab:CreateSection("Bullet Redirect")

SilentTab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = State.SilentAim.Enabled,
    Flag = "FlickSilentAimEnabledV24",
    Callback = function(value)
        if not value then
            State.SilentAim.Enabled = false
            notify("Silent Aim", "Disabled", 2)
            return
        end

        local ok, err = installSilentHook()
        State.SilentAim.Enabled = ok
        if ok then
            notify("Silent Aim", "Enabled (Flick BulletHandler)", 3)
        else
            notify("Silent Aim", err, 6)
            warn("[CVortexHub] Silent Aim:", err)
        end
    end,
})

SilentTab:CreateSlider({
    Name = "Hit Chance",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = State.SilentAim.HitChance,
    Flag = "FlickSilentHitChanceV24",
    Callback = function(value)
        State.SilentAim.HitChance = value
    end,
})

SilentTab:CreateSlider({
    Name = "Silent FOV",
    Range = {25, 600},
    Increment = 5,
    Suffix = " px",
    CurrentValue = State.SilentAim.FOV,
    Flag = "FlickSilentFOVV24",
    Callback = function(value)
        State.SilentAim.FOV = value
    end,
})

SilentTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {State.SilentAim.TargetPart},
    MultipleOptions = false,
    Flag = "FlickSilentPartV24",
    Callback = function(value)
        State.SilentAim.TargetPart = type(value) == "table" and value[1] or value
    end,
})

SilentTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = State.SilentAim.TeamCheck,
    Flag = "FlickSilentTeamV24",
    Callback = function(value)
        State.SilentAim.TeamCheck = value
    end,
})

SilentTab:CreateToggle({
    Name = "Visibility Check",
    CurrentValue = State.SilentAim.VisibilityCheck,
    Flag = "FlickSilentVisibleV24",
    Callback = function(value)
        State.SilentAim.VisibilityCheck = value
    end,
})

SilentTab:CreateSlider({
    Name = "Maximum Distance",
    Range = {100, 4000},
    Increment = 100,
    Suffix = " studs",
    CurrentValue = State.SilentAim.MaxDistance,
    Flag = "FlickSilentDistanceV24",
    Callback = function(value)
        State.SilentAim.MaxDistance = value
    end,
})

SilentTab:CreateToggle({
    Name = "Movement Prediction",
    CurrentValue = State.SilentAim.Prediction,
    Flag = "FlickSilentPredictionV24",
    Callback = function(value)
        State.SilentAim.Prediction = value
    end,
})

SilentTab:CreateSlider({
    Name = "Prediction Time",
    Range = {0, 0.25},
    Increment = 0.01,
    Suffix = " s",
    CurrentValue = State.SilentAim.PredictionTime,
    Flag = "FlickSilentPredictionTimeV24",
    Callback = function(value)
        State.SilentAim.PredictionTime = value
    end,
})

SilentTab:CreateParagraph({
    Title = "Flick-specific mode",
    Content = "Redirects BulletHandler.Fire direction without moving the camera. This depends on Flick's current client weapon module; if the game changes, the feature may stop working. You still need to shoot manually.",
})

--// Triggerbot tab

local TriggerTab = Window:CreateTab("⚡ Triggerbot", 4483362458)

TriggerTab:CreateSection("Auto Fire")

TriggerTab:CreateToggle({
    Name = "Enable Triggerbot",
    CurrentValue = State.Triggerbot.Enabled,
    Flag = "TriggerbotEnabledV21",
    Callback = function(value)
        State.Triggerbot.Enabled = value
        LastTriggerShot = 0
        TriggerPending = false
        TriggerToggleSerial += 1

        notify(
            "Triggerbot",
            value and "Triggerbot enabled" or "Triggerbot disabled",
            2
        )
    end,
})

TriggerTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = State.Triggerbot.TeamCheck,
    Flag = "TriggerbotTeamCheckV21",
    Callback = function(value)
        State.Triggerbot.TeamCheck = value
    end,
})

TriggerTab:CreateSlider({
    Name = "Shot Delay",
    Range = {0, 0.30},
    Increment = 0.01,
    Suffix = " s",
    CurrentValue = State.Triggerbot.Delay,
    Flag = "TriggerbotDelayV21",
    Callback = function(value)
        State.Triggerbot.Delay = value
    end,
})

TriggerTab:CreateSlider({
    Name = "Shot Cooldown",
    Range = {0.03, 0.50},
    Increment = 0.01,
    Suffix = " s",
    CurrentValue = State.Triggerbot.Cooldown,
    Flag = "TriggerbotCooldownV21",
    Callback = function(value)
        State.Triggerbot.Cooldown = value
    end,
})

TriggerTab:CreateParagraph({
    Title = "How it works",
    Content = "When the exact center of the screen is on an enemy character, Triggerbot automatically fires. It re-checks the target after the configured delay before shooting.",
})

--// ESP tab

local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)

ESPTab:CreateSection("Main")

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = State.ESP.Enabled,
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

ESPTab:CreateToggle({
    Name = "ESP Team Check",
    CurrentValue = State.ESP.TeamCheck,
    Flag = "ESPTeamCheckV2",
    Callback = function(value)
        State.ESP.TeamCheck = value
        refreshAllESP()
    end,
})

ESPTab:CreateToggle({
    Name = "Visibility Colors",
    CurrentValue = State.ESP.VisibilityColors,
    Flag = "ESPVisibilityColorsV2",
    Callback = function(value)
        State.ESP.VisibilityColors = value
        refreshAllESP()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Names",
    CurrentValue = State.ESP.ShowNames,
    Flag = "ESPShowNamesV2",
    Callback = function(value)
        State.ESP.ShowNames = value
        refreshAllESP()
    end,
})

ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = State.ESP.ShowDistance,
    Flag = "ESPShowDistanceV2",
    Callback = function(value)
        State.ESP.ShowDistance = value
        refreshAllESP()
    end,
})

ESPTab:CreateSection("Visible Player Colors")

ESPTab:CreateColorPicker({
    Name = "Visible Fill",
    Color = State.ESP.VisibleFill,
    Flag = "ESPVisibleFillV2",
    Callback = function(value)
        State.ESP.VisibleFill = value
        refreshAllESP()
    end,
})

ESPTab:CreateColorPicker({
    Name = "Visible Outline",
    Color = State.ESP.VisibleOutline,
    Flag = "ESPVisibleOutlineV2",
    Callback = function(value)
        State.ESP.VisibleOutline = value
        refreshAllESP()
    end,
})

ESPTab:CreateSection("Hidden Player Colors")

ESPTab:CreateColorPicker({
    Name = "Hidden Fill",
    Color = State.ESP.HiddenFill,
    Flag = "ESPHiddenFillV2",
    Callback = function(value)
        State.ESP.HiddenFill = value
        refreshAllESP()
    end,
})

ESPTab:CreateColorPicker({
    Name = "Hidden Outline",
    Color = State.ESP.HiddenOutline,
    Flag = "ESPHiddenOutlineV2",
    Callback = function(value)
        State.ESP.HiddenOutline = value
        refreshAllESP()
    end,
})

ESPTab:CreateSection("Appearance")

ESPTab:CreateSlider({
    Name = "Fill Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = State.ESP.FillTransparency,
    Flag = "ESPFillTransparencyV2",
    Callback = function(value)
        State.ESP.FillTransparency = value
        refreshAllESP()
    end,
})

ESPTab:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = State.ESP.OutlineTransparency,
    Flag = "ESPOutlineTransparencyV2",
    Callback = function(value)
        State.ESP.OutlineTransparency = value
        refreshAllESP()
    end,
})

ESPTab:CreateSlider({
    Name = "ESP Update Interval",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = " s",
    CurrentValue = State.ESP.UpdateInterval,
    Flag = "ESPUpdateIntervalV2",
    Callback = function(value)
        State.ESP.UpdateInterval = value
    end,
})

ESPTab:CreateParagraph({
    Title = "Visibility ESP",
    Content = "Visible and hidden players use separate configurable colors. ESP updates are throttled instead of recalculating every render frame.",
})

--// Settings tab

local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

SettingsTab:CreateSection("UI")

if not IS_MOBILE then
    SettingsTab:CreateKeybind({
        Name = "Toggle UI",
        CurrentKeybind = "RightShift",
        HoldToInteract = false,
        Flag = "UIToggleV2",
        Callback = function()
            -- Rayfield handles its UI bind internally.
        end,
    })
else
    SettingsTab:CreateLabel("Mobile mode: use Rayfield's on-screen controls.")
end

SettingsTab:CreateSection("Utilities")

SettingsTab:CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/tHXHQgZBa")
            notify("Discord", "Invite copied to clipboard!", 4)
        else
            notify("Discord", "Clipboard API is unavailable in this environment.", 4)
        end
    end,
})

SettingsTab:CreateButton({
    Name = "Reset Current Target",
    Callback = function()
        CurrentTarget = nil
        notify("Aimbot", "Current target cleared.", 2)
    end,
})

SettingsTab:CreateButton({
    Name = "Unload CVortexHub",
    Callback = function()
        if ENV.__CVortexHubCleanup then
            ENV.__CVortexHubCleanup()
        end
    end,
})

SettingsTab:CreateSection("Credits")
SettingsTab:CreateLabel("CVortexHub | Flick")
SettingsTab:CreateLabel("Reworked Edition: 2.5")

--// Info tab

local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

InfoTab:CreateSection("About")

InfoTab:CreateParagraph({
    Title = "CVortexHub 2.5",
    Content = "Flick hub with Aimbot, Triggerbot, ESP and game-specific Silent Aim via BulletHandler.Fire. Includes mobile UI support and separate Silent Aim settings.",
})

InfoTab:CreateLabel("RMB hold mode can be disabled.")
InfoTab:CreateLabel("FOV circle can be hidden without disabling target selection.")
InfoTab:CreateLabel("ESP colors and transparency are now functional.")
InfoTab:CreateLabel("ESP is throttled to reduce render-loop cost.")


end)

if uiOk then
    UIReady = true
else
    UIReady = false
    warn("[CVortexHub] Rayfield UI failed to build:", uiErr)
end

--// =========================================================
--// Main loop
--// =========================================================

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

    updateTriggerbot()

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

--// =========================================================
--// Cleanup
--// =========================================================

local function cleanup()
    if Unloaded then
        return
    end

    Unloaded = true
    CurrentTarget = nil
    State.SilentAim.Enabled = false

    local bulletHook = ENV[BulletHookKey]
    if type(bulletHook) == "table" and bulletHook.redirect == redirectBullet then
        bulletHook.redirect = nil
        if bulletHook.method == "direct" and bulletHook.module and bulletHook.wrapper then
            local restored = pcall(function()
                if bulletHook.module.Fire == bulletHook.wrapper then
                    bulletHook.module.Fire = bulletHook.original
                end
            end)
            if restored and bulletHook.module.Fire == bulletHook.original then
                bulletHook.installed = false
            end
        end
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
        if Rayfield.Destroy then
            Rayfield:Destroy()
        end
    end)

    if ENV.__CVortexHubCleanup == cleanup then
        ENV.__CVortexHubCleanup = nil
    end
end

ENV.__CVortexHubCleanup = cleanup

if not UIReady then
    warn("[CVortexHub] Interface could not start. Cleaning up this run.")
    cleanup()
    return
end

--// Initial ESP refresh
task.spawn(function()
    task.wait(0.25)

    if not Unloaded then
        refreshAllESP()
    end
end)

notify(
    "CVortexHub",
    IS_MOBILE
        and "Mobile mode detected. CVortexHub 2.5 loaded!"
        or "CVortexHub 2.5 loaded successfully!",
    5
)

print(
    IS_MOBILE
        and "✅ CVortexHub 2.5 Loaded | Mobile Mode"
        or "✅ CVortexHub 2.5 Loaded | Desktop Mode"
)
