local _z1 = (getgenv and getgenv()) or _G
if _z1.__CVortexHubCleanup then
pcall(_z1.__CVortexHubCleanup)
_z1.__CVortexHubCleanup = nil
end
local _z2, _z3 = pcall(function()
return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)
if not _z2 or not _z3 then
warn("[CVortexHub] Failed to load Rayfield:", _z3)
return
end
local _z4 = game:GetService("Players")
local _z5 = game:GetService("RunService")
local _z6 = game:GetService("Workspace")
local _z7 = game:GetService("UserInputService")
local _z8 = _z4.LocalPlayer
local _z9 = _z6.CurrentCamera
local _za = _z7.TouchEnabled and not _z7.KeyboardEnabled
local _zb = {
Aimbot = {
Enabled = false,
HoldRMB = not _za,
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
local _zc = {}
local _zd = {}
local _ze = {}
local _zf = nil
local _z10 = false
local _z11 = 0
local _z12 = false
local function _z13(title, content, duration)
pcall(function()
_z3:Notify({
Title = title,
Content = content,
Duration = duration or 3,
Image = 4483362458,
})
end)
end
local function _z14(connection)
table.insert(_zc, connection)
return connection
end
local function _z15(connection)
if connection then
pcall(function()
connection:Disconnect()
end)
end
end
local function _z16(player)
return player and player.Character or nil
end
local function _z17(character)
if not character then
return nil
end
return character:FindFirstChildOfClass("Humanoid")
end
local function _z18(player)
local character = _z16(player)
local humanoid = _z17(character)
return character ~= nil
and humanoid ~= nil
and humanoid.Health > 0
end
local function _z19(player)
if not player or not _z8 then
return false
end
if _z8.Team == nil or player.Team == nil then
return false
end
return player.Team == _z8.Team
end
local function _z1a(character, requestedPart)
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
local function _z1b()
local character = _z8.Character
if not character then
return nil
end
return character:FindFirstChild("HumanoidRootPart")
end
local function _z1c(position)
local root = _z1b()
if not root then
return math.huge
end
return (root.Position - position).Magnitude
end
local function _z1d()
local viewport = _z9.ViewportSize
return Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
end
local function _z1e(character, targetPartObject)
if not _z9 or not character or not targetPartObject then
return false
end
local origin = _z9.CFrame.Position
local direction = targetPartObject.Position - origin
if direction.Magnitude <= 0.001 then
return true
end
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances = {
_z8.Character,
_z9,
}
params.IgnoreWater = true
local result = _z6:Raycast(origin, direction, params)
if result == nil then
return true
end
return result.Instance ~= nil
and result.Instance:IsDescendantOf(character)
end
local function _z1f()
if not _zb.Aimbot.Enabled then
return false
end
if _za then
return true
end
if not _zb.Aimbot.HoldRMB then
return true
end
return _z7:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end
local _z20 = nil
pcall(function()
if Drawing and Drawing.new then
_z20 = Drawing.new("Circle")
_z20.Thickness = 2
_z20.NumSides = 64
_z20.Radius = _zb.Aimbot.FOV
_z20.Color = Color3.fromRGB(255, 255, 255)
_z20.Position = _z9 and _z1d() or Vector2.new(0, 0)
_z20.Visible = false
_z20.Filled = false
_z20.Transparency = 1
end
end)
local function _z21()
if not _z20 or not _z9 then
return
end
_z20.Position = _z1d()
_z20.Radius = _zb.Aimbot.FOV
_z20.Visible = _z12 and _zb.Aimbot.ShowFOV and not _z10
end
local function _z22(player)
if not player or player == _z8 then
return nil
end
if not _z18(player) then
return nil
end
if _zb.Aimbot.TeamCheck and _z19(player) then
return nil
end
local character = player.Character
local part = _z1a(character, _zb.Aimbot.TargetPart)
if not part then
return nil
end
local worldDistance = _z1c(part.Position)
if worldDistance > _zb.Aimbot.MaxDistance then
return nil
end
local screenPosition, onScreen = _z9:WorldToViewportPoint(part.Position)
if not onScreen or screenPosition.Z <= 0 then
return nil
end
local screenPoint = Vector2.new(screenPosition.X, screenPosition.Y)
local screenDistance = (screenPoint - _z1d()).Magnitude
if screenDistance > _zb.Aimbot.FOV then
return nil
end
if _zb.Aimbot.VisibilityCheck and not _z1e(character, part) then
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
local function _z23()
if _zb.Aimbot.StickyTarget and _zf then
local stickyCandidate = _z22(_zf)
if stickyCandidate then
return stickyCandidate
end
_zf = nil
end
local bestCandidate = nil
local bestScore = math.huge
for _, player in ipairs(_z4:GetPlayers()) do
local candidate = _z22(player)
if candidate and candidate.ScreenDistance < bestScore then
bestScore = candidate.ScreenDistance
bestCandidate = candidate
end
end
if bestCandidate then
_zf = bestCandidate.Player
else
_zf = nil
end
return bestCandidate
end
local function _z24(part)
local position = part.Position
if not _zb.Aimbot.Prediction then
return position
end
local velocity = part.AssemblyLinearVelocity
return position + velocity * _zb.Aimbot.PredictionTime
end
local function _z25(candidate, deltaTime)
if not candidate or not candidate.Part or not _z9 then
return
end
local targetPosition = _z24(candidate.Part)
local currentCFrame = _z9.CFrame
local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
local baseAlpha = math.clamp(_zb.Aimbot.Smoothing, 0.01, 1)
local frameFactor = math.max(deltaTime, 1 / 240) * 60
local alpha = 1 - math.pow(1 - baseAlpha, frameFactor)
_z9.CFrame = currentCFrame:Lerp(targetCFrame, math.clamp(alpha, 0, 1))
end
local function _z26(player)
local object = _ze[player]
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
_ze[player] = nil
end
local function _z27(player)
if not _zb.ESP.Enabled then
return nil
end
if not player or player == _z8 then
return nil
end
if _zb.ESP.TeamCheck and _z19(player) then
_z26(player)
return nil
end
local character = player.Character
if not character or not _z18(player) then
_z26(player)
return nil
end
local adornee = _z1a(character, "HumanoidRootPart")
if not adornee then
return nil
end
local old = _ze[player]
if old and old.Character == character then
return old
end
_z26(player)
local highlight = Instance.new("Highlight")
highlight.Name = "CVortexESP"
highlight.Adornee = character
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillTransparency = _zb.ESP.FillTransparency
highlight.OutlineTransparency = _zb.ESP.OutlineTransparency
highlight.FillColor = _zb.ESP.VisibleFill
highlight.OutlineColor = _zb.ESP.VisibleOutline
highlight.Parent = character
local billboard = Instance.new("BillboardGui")
billboard.Name = "CVortexESPInfo"
billboard.Adornee = adornee
billboard.AlwaysOnTop = true
billboard.Size = UDim2.fromOffset(220, 44)
billboard.StudsOffset = Vector3.new(0, 3.2, 0)
billboard.MaxDistance = _zb.Aimbot.MaxDistance
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
_ze[player] = object
return object
end
local function _z28(player)
if not _zb.ESP.Enabled then
_z26(player)
return
end
if not player or player == _z8 then
return
end
if _zb.ESP.TeamCheck and _z19(player) then
_z26(player)
return
end
if not _z18(player) then
_z26(player)
return
end
local object = _z27(player)
if not object then
return
end
local character = player.Character
local target = _z1a(character, _zb.Aimbot.TargetPart)
or _z1a(character, "HumanoidRootPart")
if not target then
return
end
local visible = true
if _zb.ESP.VisibilityColors then
visible = _z1e(character, target)
end
if visible then
object.Highlight.FillColor = _zb.ESP.VisibleFill
object.Highlight.OutlineColor = _zb.ESP.VisibleOutline
else
object.Highlight.FillColor = _zb.ESP.HiddenFill
object.Highlight.OutlineColor = _zb.ESP.HiddenOutline
end
object.Highlight.FillTransparency = _zb.ESP.FillTransparency
object.Highlight.OutlineTransparency = _zb.ESP.OutlineTransparency
local textParts = {}
if _zb.ESP.ShowNames then
local display = player.DisplayName or player.Name
if display ~= player.Name then
table.insert(textParts, string.format("%s (@%s)", display, player.Name))
else
table.insert(textParts, player.Name)
end
end
if _zb.ESP.ShowDistance then
local distance = _z1c(target.Position)
table.insert(textParts, string.format("[%dm]", math.floor(distance + 0.5)))
end
object.Label.Text = table.concat(textParts, "\n")
object.Billboard.Enabled = #textParts > 0
object.Billboard.MaxDistance = _zb.Aimbot.MaxDistance
if _zb.ESP.VisibilityColors then
object.Label.TextColor3 = visible
and _zb.ESP.VisibleFill
or _zb.ESP.HiddenFill
else
object.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
end
end
local function _z29()
for _, player in ipairs(_z4:GetPlayers()) do
if player ~= _z8 then
_z28(player)
end
end
if not _zb.ESP.Enabled then
for player in pairs(_ze) do
_z26(player)
end
end
end
local function _z2a(player)
if not player or player == _z8 then
return
end
if _zd[player] then
for _, connection in ipairs(_zd[player]) do
_z15(connection)
end
end
_zd[player] = {}
local characterAddedConnection = player.CharacterAdded:Connect(function(character)
_zf = (_zf == player) and nil or _zf
_z26(player)
task.spawn(function()
character:WaitForChild("HumanoidRootPart", 5)
if _z10 then
return
end
if _zb.ESP.Enabled then
_z28(player)
end
end)
end)
table.insert(_zd[player], characterAddedConnection)
if player.Character then
task.spawn(function()
if not _z10 and _zb.ESP.Enabled then
_z28(player)
end
end)
end
end
for _, player in ipairs(_z4:GetPlayers()) do
_z2a(player)
end
_z14(_z4.PlayerAdded:Connect(function(player)
_z2a(player)
end))
_z14(_z4.PlayerRemoving:Connect(function(player)
if _zf == player then
_zf = nil
end
_z26(player)
local playerConnections = _zd[player]
if playerConnections then
for _, connection in ipairs(playerConnections) do
_z15(connection)
end
end
_zd[player] = nil
end))
_z14(_z6:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
_z9 = _z6.CurrentCamera
end))
local uiOk, uiErr = pcall(function()
local _z2b = _z3:CreateWindow({
Name = "CVortexHub | Flick",
LoadingTitle = "CVortexHub",
LoadingSubtitle = "Loading...",
ShowText = "CVortexHub",
ToggleUIKeybind = "K",
ConfigurationSaving = {
Enabled = not _za,
FolderName = "CVortexHub",
FileName = "FlickConfigV2",
},
Discord = {
Enabled = not _za,
Invite = "ESQv2sc5p",
RememberJoins = true,
},
KeySystem = true,
KeySettings = {
Title = "CVortexHub Key System",
Subtitle = "Enter Key",
Note = "discord.gg/ESQv2sc5p",
FileName = "CVortexKey",
SaveKey = not _za,
GrabKeyFromSite = false,
Key = {"vortex"},
},
})
local _z2c = _z2b:CreateTab("🎯 Aimbot", 4483362458)
_z2c:CreateSection("Main")
_z2c:CreateToggle({
Name = "Enable Aimbot",
CurrentValue = _zb.Aimbot.Enabled,
Flag = "AimbotEnabledV2",
Callback = function(value)
_zb.Aimbot.Enabled = value
if not value then
_zf = nil
end
_z13(
"Aimbot",
value and "Aimbot enabled" or "Aimbot disabled"
)
end,
})
if not _za then
_z2c:CreateToggle({
Name = "Hold RMB to Aim",
CurrentValue = _zb.Aimbot.HoldRMB,
Flag = "AimbotHoldRMBV2",
Callback = function(value)
_zb.Aimbot.HoldRMB = value
end,
})
end
_z2c:CreateToggle({
Name = "Sticky Target",
CurrentValue = _zb.Aimbot.StickyTarget,
Flag = "AimbotStickyV2",
Callback = function(value)
_zb.Aimbot.StickyTarget = value
if not value then
_zf = nil
end
end,
})
_z2c:CreateSlider({
Name = "Aim Smoothing",
Range = {0.02, 1},
Increment = 0.01,
CurrentValue = _zb.Aimbot.Smoothing,
Flag = "AimSmoothingV2",
Callback = function(value)
_zb.Aimbot.Smoothing = value
end,
})
_z2c:CreateSection("Target")
_z2c:CreateDropdown({
Name = "Target Part",
Options = {"Head", "Torso", "HumanoidRootPart"},
CurrentOption = {_zb.Aimbot.TargetPart},
MultipleOptions = false,
Flag = "TargetPartV2",
Callback = function(option)
local value = type(option) == "table" and option[1] or option
if value then
_zb.Aimbot.TargetPart = value
_zf = nil
end
end,
})
_z2c:CreateToggle({
Name = "Visibility Check",
CurrentValue = _zb.Aimbot.VisibilityCheck,
Flag = "VisibilityCheckV2",
Callback = function(value)
_zb.Aimbot.VisibilityCheck = value
_zf = nil
end,
})
_z2c:CreateToggle({
Name = "Team Check",
CurrentValue = _zb.Aimbot.TeamCheck,
Flag = "AimbotTeamCheckV2",
Callback = function(value)
_zb.Aimbot.TeamCheck = value
_zf = nil
end,
})
_z2c:CreateSlider({
Name = "Maximum Distance",
Range = {100, 5000},
Increment = 100,
Suffix = " studs",
CurrentValue = _zb.Aimbot.MaxDistance,
Flag = "MaxDistanceV2",
Callback = function(value)
_zb.Aimbot.MaxDistance = value
end,
})
_z2c:CreateSection("FOV")
_z2c:CreateToggle({
Name = "Show FOV Circle",
CurrentValue = _zb.Aimbot.ShowFOV,
Flag = "ShowFOVV2",
Callback = function(value)
_zb.Aimbot.ShowFOV = value
_z21()
end,
})
_z2c:CreateSlider({
Name = "FOV Radius",
Range = {25, 600},
Increment = 5,
Suffix = " px",
CurrentValue = _zb.Aimbot.FOV,
Flag = "FOVRadiusV2",
Callback = function(value)
_zb.Aimbot.FOV = value
_z21()
_zf = nil
end,
})
_z2c:CreateColorPicker({
Name = "FOV Color",
Color = Color3.fromRGB(255, 255, 255),
Flag = "FOVColorV2",
Callback = function(value)
if _z20 then
_z20.Color = value
end
end,
})
_z2c:CreateSection("Prediction")
_z2c:CreateToggle({
Name = "Movement Prediction",
CurrentValue = _zb.Aimbot.Prediction,
Flag = "PredictionEnabledV2",
Callback = function(value)
_zb.Aimbot.Prediction = value
end,
})
_z2c:CreateSlider({
Name = "Prediction Time",
Range = {0, 0.25},
Increment = 0.01,
Suffix = " s",
CurrentValue = _zb.Aimbot.PredictionTime,
Flag = "PredictionTimeV2",
Callback = function(value)
_zb.Aimbot.PredictionTime = value
end,
})
local _z2d = _z2b:CreateTab("👁️ ESP", 4483362458)
_z2d:CreateSection("Main")
_z2d:CreateToggle({
Name = "Enable ESP",
CurrentValue = _zb.ESP.Enabled,
Flag = "ESPEnabledV2",
Callback = function(value)
_zb.ESP.Enabled = value
_z29()
_z13(
"ESP",
value and "ESP enabled" or "ESP disabled"
)
end,
})
_z2d:CreateToggle({
Name = "ESP Team Check",
CurrentValue = _zb.ESP.TeamCheck,
Flag = "ESPTeamCheckV2",
Callback = function(value)
_zb.ESP.TeamCheck = value
_z29()
end,
})
_z2d:CreateToggle({
Name = "Visibility Colors",
CurrentValue = _zb.ESP.VisibilityColors,
Flag = "ESPVisibilityColorsV2",
Callback = function(value)
_zb.ESP.VisibilityColors = value
_z29()
end,
})
_z2d:CreateToggle({
Name = "Show Names",
CurrentValue = _zb.ESP.ShowNames,
Flag = "ESPShowNamesV2",
Callback = function(value)
_zb.ESP.ShowNames = value
_z29()
end,
})
_z2d:CreateToggle({
Name = "Show Distance",
CurrentValue = _zb.ESP.ShowDistance,
Flag = "ESPShowDistanceV2",
Callback = function(value)
_zb.ESP.ShowDistance = value
_z29()
end,
})
_z2d:CreateSection("Visible Player Colors")
_z2d:CreateColorPicker({
Name = "Visible Fill",
Color = _zb.ESP.VisibleFill,
Flag = "ESPVisibleFillV2",
Callback = function(value)
_zb.ESP.VisibleFill = value
_z29()
end,
})
_z2d:CreateColorPicker({
Name = "Visible Outline",
Color = _zb.ESP.VisibleOutline,
Flag = "ESPVisibleOutlineV2",
Callback = function(value)
_zb.ESP.VisibleOutline = value
_z29()
end,
})
_z2d:CreateSection("Hidden Player Colors")
_z2d:CreateColorPicker({
Name = "Hidden Fill",
Color = _zb.ESP.HiddenFill,
Flag = "ESPHiddenFillV2",
Callback = function(value)
_zb.ESP.HiddenFill = value
_z29()
end,
})
_z2d:CreateColorPicker({
Name = "Hidden Outline",
Color = _zb.ESP.HiddenOutline,
Flag = "ESPHiddenOutlineV2",
Callback = function(value)
_zb.ESP.HiddenOutline = value
_z29()
end,
})
_z2d:CreateSection("Appearance")
_z2d:CreateSlider({
Name = "Fill Transparency",
Range = {0, 1},
Increment = 0.05,
CurrentValue = _zb.ESP.FillTransparency,
Flag = "ESPFillTransparencyV2",
Callback = function(value)
_zb.ESP.FillTransparency = value
_z29()
end,
})
_z2d:CreateSlider({
Name = "Outline Transparency",
Range = {0, 1},
Increment = 0.05,
CurrentValue = _zb.ESP.OutlineTransparency,
Flag = "ESPOutlineTransparencyV2",
Callback = function(value)
_zb.ESP.OutlineTransparency = value
_z29()
end,
})
_z2d:CreateSlider({
Name = "ESP Update Interval",
Range = {0.05, 0.5},
Increment = 0.05,
Suffix = " s",
CurrentValue = _zb.ESP.UpdateInterval,
Flag = "ESPUpdateIntervalV2",
Callback = function(value)
_zb.ESP.UpdateInterval = value
end,
})
local _z2e = _z2b:CreateTab("⚙️ Settings", 4483362458)
_z2e:CreateSection("UI")
if not _za then
_z2e:CreateKeybind({
Name = "Toggle UI",
CurrentKeybind = "RightShift",
HoldToInteract = false,
Flag = "UIToggleV2",
Callback = function()
end,
})
end
_z2e:CreateSection("Utilities")
_z2e:CreateButton({
Name = "Copy Discord Invite",
Callback = function()
if setclipboard then
setclipboard("https://discord.gg/ESQv2sc5p")
_z13("Discord", "Invite copied to clipboard!", 4)
else
_z13("Discord", "Clipboard API is unavailable in this environment.", 4)
end
end,
})
_z2e:CreateButton({
Name = "Reset Current Target",
Callback = function()
_zf = nil
_z13("Aimbot", "Current target cleared.", 2)
end,
})
_z2e:CreateButton({
Name = "Unload CVortexHub",
Callback = function()
if _z1.__CVortexHubCleanup then
_z1.__CVortexHubCleanup()
end
end,
})
end)
if uiOk then
_z12 = true
else
_z12 = false
warn("[CVortexHub] Rayfield UI failed to build:", uiErr)
end
local _z2f
_z2f = _z5.RenderStepped:Connect(function(deltaTime)
if _z10 then
return
end
if _z6.CurrentCamera ~= _z9 then
_z9 = _z6.CurrentCamera
end
if not _z9 then
return
end
_z21()
_z11 += deltaTime
if _z11 >= _zb.ESP.UpdateInterval then
_z11 = 0
if _zb.ESP.Enabled then
for _, player in ipairs(_z4:GetPlayers()) do
if player ~= _z8 then
_z28(player)
end
end
end
end
if not _z1f() then
if not _zb.Aimbot.StickyTarget then
_zf = nil
end
return
end
local candidate = _z23()
if candidate then
_z25(candidate, deltaTime)
end
end)
_z14(_z2f)
local function _z30()
if _z10 then
return
end
_z10 = true
_zf = nil
for _, connection in ipairs(_zc) do
_z15(connection)
end
table.clear(_zc)
for player, playerConnections in pairs(_zd) do
for _, connection in ipairs(playerConnections) do
_z15(connection)
end
_zd[player] = nil
end
for player in pairs(_ze) do
_z26(player)
end
if _z20 then
pcall(function()
_z20.Visible = false
_z20:Remove()
end)
_z20 = nil
end
pcall(function()
if _z3.Destroy then
_z3:Destroy()
end
end)
if _z1.__CVortexHubCleanup == _z30 then
_z1.__CVortexHubCleanup = nil
end
end
_z1.__CVortexHubCleanup = _z30
task.spawn(function()
task.wait(0.25)
if not _z10 then
_z29()
end
end)
print("CVortexHub loaded")
