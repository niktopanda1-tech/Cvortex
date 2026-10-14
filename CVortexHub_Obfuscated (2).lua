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
local _c21 = {}
local _c22 = {}
local _c23 = {}
local _c24 = nil
local _c25 = false
local _c1f = 0
local _c26 = false
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
table.insert(_c21, connection)
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
FOVCircle.Visible = _c26 and State.Aimbot.ShowFOV and not _c25
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
if State.Aimbot.StickyTarget and _c24 then
local stickyCandidate = getCandidate(_c24)
if stickyCandidate then
return stickyCandidate
end
_c24 = nil
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
_c24 = bestCandidate.Player
else
_c24 = nil
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
local _c17 = getPredictedPosition(candidate.Part)
local currentCFrame = Camera.CFrame
local targetCFrame = CFrame.new(currentCFrame.Position, _c17)
local baseAlpha = math.clamp(State.Aimbot.Smoothing, 0.01, 1)
local frameFactor = math.max(deltaTime, 1 / 240) * 60
local alpha = 1 - math.pow(1 - baseAlpha, frameFactor)
Camera.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(alpha, 0, 1))
end
local _c1 = nil
pcall(function()
if Drawing and Drawing.new then
_c1 = Drawing.new("Circle")
_c1.Visible = false
_c1.Filled = false
_c1.NumSides = 64
_c1.Thickness = 1.5
_c1.Color = Color3.fromRGB(65, 225, 150)
_c1.Transparency = 0.85
end
end)
local function _c2()
if not _c1 or not Camera then return end
_c1.Position = getScreenCenter()
_c1.Radius = State.SilentAim.FOV
_c1.Visible = _c26 and State.SilentAim.Enabled
and State.SilentAim.ShowFOV and not _c25
end
local function _c3(origin)
if not Camera or not State.SilentAim.Enabled then return nil end
local config = State.SilentAim
local center = getScreenCenter()
local _c1a = nil
local _c19 = config.FOV
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
if pixelDistance >= _c19 then return end
if config.Wallcheck then
local filter = {character}
if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
if Camera then table.insert(filter, Camera) end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = filter
params.IgnoreWater = true
local hit = Workspace:Raycast(origin, pos - origin, params)
if hit and hit.Distance < distance - 0.5 then return end
end
_c1a = pos
_c19 = pixelDistance
end
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
evaluate(player.Character, player)
end
end
for _, model in ipairs(Workspace:GetChildren()) do
if model:IsA("Model") and model ~= LocalPlayer.Character and not seen[model] then
local player = Players:GetPlayerFromCharacter(model)
if player ~= LocalPlayer and model:FindFirstChildOfClass("Humanoid") then
evaluate(model, player)
end
end
end
return _c1a
end
local _c4 = nil
local _c5 = nil
local _c6 = nil
local _c7 = false
local function _c8()
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
_c4 = handler
local _c1b = handler.Fire
if type(_G.__SA_OriginalBulletFire) == "function" and _G.__SA_HookInstalled then
_c1b = _G.__SA_OriginalBulletFire
end
_c5 = _c1b
_c6 = function(payload, ...)
if not State.SilentAim.Enabled or type(payload) ~= "table" or typeof(payload.Origin) ~= "Vector3" then
return _c1b(payload, ...)
end
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
local _c17 = _c3(origin)
local _c1c = nil
if _c17 then
local delta = _c17 - origin
if delta.Magnitude > 0.001 then
local direction = delta.Unit
payload.Direction = direction
if type(payload.Misc) == "table" then
if typeof(payload.Misc.CamCFrame) == "CFrame" then
payload.Misc.CamCFrame = CFrame.lookAt(origin, origin + direction)
end
payload.Misc.Spread = 0
end
if Camera and not airborne then
local dot = math.clamp(Camera.CFrame.LookVector:Dot(direction), -1, 1)
local angle = math.deg(math.acos(dot))
if angle > 20 then
_c1c = Camera.CFrame
Camera.CFrame = CFrame.lookAt(origin, origin + direction)
end
end
end
end
local _c1e = table.pack(...)
local result = table.pack(pcall(function()
return _c1b(payload, table.unpack(_c1e, 1, _c1e.n))
end))
if _c1c and Camera then
Camera.CFrame = _c1c
end
if not result[1] then
error(result[2], 0)
end
return table.unpack(result, 2, result.n)
end
if _c25 then return end
_c4.Fire = _c6
_G.__SA_HookInstalled = false
_c7 = true
print("[CVortexHub] Silent Aim hook installed.")
end
task.spawn(function()
local ok, err = pcall(_c8)
if not ok then warn("[CVortexHub] Silent Aim installation failed:", err) end
end)
local _c9 = nil
local _ca = nil
local _cb = nil
local _cc = nil
local _cd = nil
local _ce = nil
local _cf = nil
local _c10 = nil
local function _c11()
local character = LocalPlayer.Character
local humanoid = character and getHumanoid(character)
if humanoid ~= _c9 then
if _c9 and _ca then
pcall(function() _c9.WalkSpeed = _ca end)
end
_c9 = humanoid
_ca = humanoid and humanoid.WalkSpeed or 16
State.Speed.NormalSpeed = _ca
end
return humanoid
end
local function _c12(value, fromMenu)
State.Speed.Enabled = not not value
local humanoid = _c11()
if humanoid then
pcall(function()
humanoid.WalkSpeed = State.Speed.Enabled and State.Speed.Value or (_ca or 16)
end)
end
if _cc and not fromMenu then
pcall(function() _cc:Set(State.Speed.Enabled) end)
end
if _c10 then
_c10.Text = State.Speed.Enabled and "SPEED  ON" or "SPEED  OFF"
_c10.BackgroundColor3 = State.Speed.Enabled and Color3.fromRGB(28, 142, 106) or Color3.fromRGB(25, 32, 52)
end
end
local function _c13(value, fromMenu)
State.SilentAim.Enabled = not not value
_c2()
if _cb and not fromMenu then
pcall(function() _cb:Set(State.SilentAim.Enabled) end)
end
if _cf then
_cf.Text = State.SilentAim.Enabled and "SILENT  ON" or "SILENT  OFF"
_cf.BackgroundColor3 = State.SilentAim.Enabled and Color3.fromRGB(28, 142, 106) or Color3.fromRGB(25, 32, 52)
end
end
local function _c14(name, offsetY, onPress)
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
button.Parent = _ce
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
local function _c15()
_ce = Instance.new("ScreenGui")
_ce.Name = "CVortexHubQuickButtons"
_ce.ResetOnSpawn = false
_ce.IgnoreGuiInset = true
_ce.DisplayOrder = 900
local success = pcall(function()
local parent = (gethui and gethui()) or CoreGui
_ce.Parent = parent
end)
if not success or not _ce.Parent then
_ce.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
_cf = _c14("SilentAimButton", -30, function()
_c13(not State.SilentAim.Enabled, false)
end)
_c10 = _c14("SpeedButton", 22, function()
_c12(not State.Speed.Enabled, false)
end)
_cf.Visible = State.SilentAim.ShowButton
_c10.Visible = State.Speed.ShowButton
_c13(State.SilentAim.Enabled, true)
_c12(State.Speed.Enabled, true)
end
_c15()
local function _c16()
_c12(false, false)
State.Speed.Value = _ca or 16
if _cd then
pcall(function() _cd:Set(math.clamp(State.Speed.Value, 16, 150)) end)
end
end
addConnection(LocalPlayer.CharacterAdded:Connect(function()
task.defer(function()
if _c25 then return end
local char = LocalPlayer.Character
if char then char:WaitForChild("Humanoid", 8) end
if not _c25 then _c11() end
end)
end))
addConnection(RunService.Heartbeat:Connect(function()
if _c25 or not State.Speed.Enabled then return end
local humanoid = _c11()
if humanoid and humanoid.Health > 0 and humanoid.WalkSpeed ~= State.Speed.Value then
humanoid.WalkSpeed = State.Speed.Value
end
end))
local function destroyESP(player)
local object = _c23[player]
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
_c23[player] = nil
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
local old = _c23[player]
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
_c23[player] = object
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
local function _c20()
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
updateESPObject(player)
end
end
if not State.ESP.Enabled then
for player in pairs(_c23) do
destroyESP(player)
end
end
end
local function hookPlayer(player)
if not player or player == LocalPlayer then
return
end
if _c22[player] then
for _, connection in ipairs(_c22[player]) do
disconnectConnection(connection)
end
end
_c22[player] = {}
local characterAddedConnection = player.CharacterAdded:Connect(function(character)
_c24 = (_c24 == player) and nil or _c24
destroyESP(player)
task.spawn(function()
character:WaitForChild("HumanoidRootPart", 5)
if _c25 then
return
end
if State.ESP.Enabled then
updateESPObject(player)
end
end)
end)
table.insert(_c22[player], characterAddedConnection)
if player.Character then
task.spawn(function()
if not _c25 and State.ESP.Enabled then
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
if _c24 == player then
_c24 = nil
end
destroyESP(player)
local playerConnections = _c22[player]
if playerConnections then
for _, connection in ipairs(playerConnections) do
disconnectConnection(connection)
end
end
_c22[player] = nil
end))
addConnection(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
Camera = Workspace.CurrentCamera
end))
local uiOk, uiErr = pcall(function()
local Window = Rayfield:CreateWindow({
Name = "CVortexHub | Flick",
LoadingTitle = "CVortexHub",
LoadingSubtitle = "Loading...",
ShowText = "CVortexHub",
ToggleUIKeybind = "K",
ConfigurationSaving = {
Enabled = not IS_MOBILE,
FolderName = "CVortexHub",
FileName = "FlickConfigV26",
},
Discord = {
Enabled = not IS_MOBILE,
Invite = "ESQv2sc5p",
RememberJoins = true,
},
KeySystem = true,
KeySettings = {
Title = "CVortexHub Key System",
Subtitle = "Enter Key",
Note = "discord.gg/ESQv2sc5p",
FileName = "CVortexKey",
SaveKey = not IS_MOBILE,
GrabKeyFromSite = false,
Key = {"vortex"},
},
})
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)
AimbotTab:CreateSection("Main")
AimbotTab:CreateToggle({
Name = "Enable Aimbot",
CurrentValue = State.Aimbot.Enabled,
Flag = "AimbotEnabledV2",
Callback = function(value)
State.Aimbot.Enabled = value
if not value then
_c24 = nil
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
end
AimbotTab:CreateToggle({
Name = "Sticky Target",
CurrentValue = State.Aimbot.StickyTarget,
Flag = "AimbotStickyV2",
Callback = function(value)
State.Aimbot.StickyTarget = value
if not value then
_c24 = nil
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
_c24 = nil
end
end,
})
AimbotTab:CreateToggle({
Name = "Visibility Check",
CurrentValue = State.Aimbot.VisibilityCheck,
Flag = "VisibilityCheckV2",
Callback = function(value)
State.Aimbot.VisibilityCheck = value
_c24 = nil
end,
})
AimbotTab:CreateToggle({
Name = "Team Check",
CurrentValue = State.Aimbot.TeamCheck,
Flag = "AimbotTeamCheckV2",
Callback = function(value)
State.Aimbot.TeamCheck = value
_c24 = nil
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
_c24 = nil
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
local SilentTab = Window:CreateTab("🔇 Silent Aim", 4483362458)
SilentTab:CreateSection("Silent Aim")
_cb = SilentTab:CreateToggle({
Name = "Enable Silent Aim",
CurrentValue = State.SilentAim.Enabled,
Flag = "SilentAimEnabledV26",
Callback = function(value)
_c13(value, true)
end,
})
SilentTab:CreateToggle({
Name = "Show Silent Aim Screen Button",
CurrentValue = State.SilentAim.ShowButton,
Flag = "SilentAimScreenButtonV26",
Callback = function(value)
State.SilentAim.ShowButton = value
if _cf then _cf.Visible = value end
end,
})
SilentTab:CreateDropdown({
Name = "Hit Part",
Options = {"Head", "Torso", "HumanoidRootPart"},
CurrentOption = {State.SilentAim.TargetPart},
MultipleOptions = false,
Flag = "SilentAimPartV26",
Callback = function(value)
State.SilentAim.TargetPart = type(value) == "table" and value[1] or value
end,
})
SilentTab:CreateSlider({
Name = "Silent Aim FOV",
Range = {25, 600},
Increment = 5,
Suffix = " px",
CurrentValue = State.SilentAim.FOV,
Flag = "SilentAimFOVV26",
Callback = function(value)
State.SilentAim.FOV = value
_c2()
end,
})
SilentTab:CreateToggle({
Name = "Show Silent FOV Circle",
CurrentValue = State.SilentAim.ShowFOV,
Flag = "SilentAimShowFOVV26",
Callback = function(value)
State.SilentAim.ShowFOV = value
_c2()
end,
})
SilentTab:CreateToggle({
Name = "Wall Check",
CurrentValue = State.SilentAim.Wallcheck,
Flag = "SilentAimWallcheckV26",
Callback = function(value)
State.SilentAim.Wallcheck = value
end,
})
SilentTab:CreateToggle({
Name = "Team Check",
CurrentValue = State.SilentAim.TeamCheck,
Flag = "SilentAimTeamCheckV26",
Callback = function(value)
State.SilentAim.TeamCheck = value
end,
})
local SpeedTab = Window:CreateTab("⚡ Speed", 4483362458)
SpeedTab:CreateSection("Speed Hack")
_cc = SpeedTab:CreateToggle({
Name = "Enable Speed Hack",
CurrentValue = State.Speed.Enabled,
Flag = "SpeedEnabledV26",
Callback = function(value)
_c12(value, true)
end,
})
SpeedTab:CreateToggle({
Name = "Show Speed Screen Button",
CurrentValue = State.Speed.ShowButton,
Flag = "SpeedScreenButtonV26",
Callback = function(value)
State.Speed.ShowButton = value
if _c10 then _c10.Visible = value end
end,
})
_cd = SpeedTab:CreateSlider({
Name = "Walk Speed",
Range = {16, 150},
Increment = 1,
Suffix = " studs/s",
CurrentValue = State.Speed.Value,
Flag = "SpeedValueV26",
Callback = function(value)
State.Speed.Value = value
if State.Speed.Enabled then _c12(true, true) end
end,
})
SpeedTab:CreateButton({
Name = "Reset Speed (Normal + OFF)",
Callback = function()
_c16()
notify("Speed", "Speed restored to normal.", 2)
end,
})
local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)
ESPTab:CreateSection("Main")
ESPTab:CreateToggle({
Name = "Enable ESP",
CurrentValue = State.ESP.Enabled,
Flag = "ESPEnabledV2",
Callback = function(value)
State.ESP.Enabled = value
_c20()
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
_c20()
end,
})
ESPTab:CreateToggle({
Name = "Visibility Colors",
CurrentValue = State.ESP.VisibilityColors,
Flag = "ESPVisibilityColorsV2",
Callback = function(value)
State.ESP.VisibilityColors = value
_c20()
end,
})
ESPTab:CreateToggle({
Name = "Show Names",
CurrentValue = State.ESP.ShowNames,
Flag = "ESPShowNamesV2",
Callback = function(value)
State.ESP.ShowNames = value
_c20()
end,
})
ESPTab:CreateToggle({
Name = "Show Distance",
CurrentValue = State.ESP.ShowDistance,
Flag = "ESPShowDistanceV2",
Callback = function(value)
State.ESP.ShowDistance = value
_c20()
end,
})
ESPTab:CreateSection("Visible Player Colors")
ESPTab:CreateColorPicker({
Name = "Visible Fill",
Color = State.ESP.VisibleFill,
Flag = "ESPVisibleFillV2",
Callback = function(value)
State.ESP.VisibleFill = value
_c20()
end,
})
ESPTab:CreateColorPicker({
Name = "Visible Outline",
Color = State.ESP.VisibleOutline,
Flag = "ESPVisibleOutlineV2",
Callback = function(value)
State.ESP.VisibleOutline = value
_c20()
end,
})
ESPTab:CreateSection("Hidden Player Colors")
ESPTab:CreateColorPicker({
Name = "Hidden Fill",
Color = State.ESP.HiddenFill,
Flag = "ESPHiddenFillV2",
Callback = function(value)
State.ESP.HiddenFill = value
_c20()
end,
})
ESPTab:CreateColorPicker({
Name = "Hidden Outline",
Color = State.ESP.HiddenOutline,
Flag = "ESPHiddenOutlineV2",
Callback = function(value)
State.ESP.HiddenOutline = value
_c20()
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
_c20()
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
_c20()
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
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("UI")
if not IS_MOBILE then
SettingsTab:CreateKeybind({
Name = "Toggle UI",
CurrentKeybind = "RightShift",
HoldToInteract = false,
Flag = "UIToggleV2",
Callback = function()
end,
})
end
SettingsTab:CreateSection("Utilities")
SettingsTab:CreateButton({
Name = "Copy Discord Invite",
Callback = function()
if setclipboard then
setclipboard("https://discord.gg/ESQv2sc5p")
notify("Discord", "Invite copied to clipboard!", 4)
else
notify("Discord", "Clipboard API is unavailable in this environment.", 4)
end
end,
})
SettingsTab:CreateButton({
Name = "Reset Current Target",
Callback = function()
_c24 = nil
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
end)
if uiOk then
_c26 = true
else
_c26 = false
warn("[CVortexHub] Rayfield UI failed to build:", uiErr)
end
local renderConnection
renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
if _c25 then
return
end
if Workspace.CurrentCamera ~= Camera then
Camera = Workspace.CurrentCamera
end
if not Camera then
return
end
updateFOVCircle()
_c2()
_c1f += deltaTime
if _c1f >= State.ESP.UpdateInterval then
_c1f = 0
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
_c24 = nil
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
if _c25 then
return
end
_c25 = true
_c24 = nil
State.Speed.Enabled = false
if _c9 and _ca then
pcall(function() _c9.WalkSpeed = _ca end)
end
if _c4 and _c6 and _c4.Fire == _c6 then
_c4.Fire = _c5
end
_c7 = false
if _ce then
pcall(function() _ce:Destroy() end)
_ce = nil
end
if _c1 then
pcall(function() _c1.Visible = false; _c1:Remove() end)
_c1 = nil
end
for _, connection in ipairs(_c21) do
disconnectConnection(connection)
end
table.clear(_c21)
for player, playerConnections in pairs(_c22) do
for _, connection in ipairs(playerConnections) do
disconnectConnection(connection)
end
_c22[player] = nil
end
for player in pairs(_c23) do
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
task.spawn(function()
task.wait(0.25)
if not _c25 then
_c20()
end
end)
print("CVortexHub v2.6 loaded")
