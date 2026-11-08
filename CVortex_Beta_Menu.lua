local function reportCVortexError(errorMessage)
warn("CVortex: " .. tostring(errorMessage))
local players = game:GetService("Players")
local player = players.LocalPlayer
if not player then return end
pcall(function()
local playerGui = player:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("CVortex_StartError")
if previous then previous:Destroy() end
local screen = Instance.new("ScreenGui")
screen.Name = "CVortex_StartError"
screen.ResetOnSpawn = false
screen.DisplayOrder = 11000
screen.Parent = playerGui
local box = Instance.new("TextLabel")
box.Name = "ErrorMessage"
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.Position = UDim2.fromScale(0.5, 0.5)
box.Size = UDim2.new(0.8, 0, 0, 106)
box.BackgroundColor3 = Color3.fromRGB(28, 30, 41)
box.TextColor3 = Color3.fromRGB(255, 190, 190)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.TextScaled = false
box.TextWrapped = true
box.Text = "CVortex startup error: " .. tostring(errorMessage)
box.Parent = screen
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
end)
end

-- This is intentionally separate from the full UI.  It is drawn before the
-- ESP, world scanner, and menu are initialised, so the key screen is never
-- hidden by an unrelated startup error.
local function showKeyBootstrap(startCVortex)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
while not player do
Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
player = Players.LocalPlayer
end
local playerGui = player:WaitForChild("PlayerGui")
local env = (type(getgenv) == "function" and getgenv()) or _G
local old = playerGui:FindFirstChild("CVortexBootKey")
if old then old:Destroy() end
local oldError = playerGui:FindFirstChild("CVortex_StartError")
if oldError then oldError:Destroy() end

local function create(className, parent, properties)
local object = Instance.new(className)
for property, value in pairs(properties) do object[property] = value end
if className == "UIStroke" then object.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end
if object:IsA("GuiObject") then object.BorderSizePixel = 0 end
object.Parent = parent
return object
end
local gui = create("ScreenGui", playerGui, {
Name = "CVortexBootKey", ResetOnSpawn = false, IgnoreGuiInset = true,
DisplayOrder = 10000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
env.CVortexBootKeyGui = gui
local mask = create("Frame", gui, {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(6, 8, 13),
BackgroundTransparency = .72, BorderSizePixel = 0,
})
local card = create("Frame", mask, {
AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5),
Size = UDim2.fromOffset(350, 236), BackgroundColor3 = Color3.new(1, 1, 1),
BorderSizePixel = 0,
})
create("UICorner", card, {CornerRadius = UDim.new(0, 14)})
create("UIGradient", card, {Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 28)),
ColorSequenceKeypoint.new(.65, Color3.fromRGB(25, 26, 34)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(43, 28, 39)),
})})
create("UIStroke", card, {Color = Color3.fromRGB(91, 97, 115), Transparency = .55})
create("TextLabel", card, {
Position = UDim2.fromOffset(22, 22), Size = UDim2.fromOffset(200, 28),
BackgroundTransparency = 1, Text = "CVortex", TextColor3 = Color3.fromRGB(242, 246, 255),
Font = Enum.Font.BuilderSansBold, TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left,
})
create("TextLabel", card, {
Position = UDim2.fromOffset(23, 57), Size = UDim2.fromOffset(304, 18),
BackgroundTransparency = 1, Text = "Enter your key to open the menu", TextColor3 = Color3.fromRGB(174, 186, 205),
Font = Enum.Font.BuilderSans, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
})
local field = create("TextBox", card, {
Position = UDim2.fromOffset(22, 89), Size = UDim2.fromOffset(306, 40),
BackgroundColor3 = Color3.fromRGB(31, 35, 44), BorderSizePixel = 0, Text = "",
PlaceholderText = "Access key", PlaceholderColor3 = Color3.fromRGB(150, 161, 181),
TextColor3 = Color3.fromRGB(245, 248, 255), ClearTextOnFocus = false,
Font = Enum.Font.BuilderSans, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
})
create("UICorner", field, {CornerRadius = UDim.new(0, 9)})
create("UIPadding", field, {PaddingLeft = UDim.new(0, 12)})
local unlock = create("TextButton", card, {
Position = UDim2.fromOffset(22, 142), Size = UDim2.fromOffset(148, 40),
BackgroundColor3 = Color3.fromRGB(236, 77, 100), BorderSizePixel = 0, Text = "Unlock",
TextColor3 = Color3.fromRGB(255, 255, 255), AutoButtonColor = false,
Font = Enum.Font.BuilderSansBold, TextSize = 13,
})
create("UICorner", unlock, {CornerRadius = UDim.new(0, 9)})
local getKey = create("TextButton", card, {
Position = UDim2.fromOffset(180, 142), Size = UDim2.fromOffset(148, 40),
BackgroundColor3 = Color3.fromRGB(44, 48, 60), BorderSizePixel = 0,
Text = "Get Key", TextColor3 = Color3.fromRGB(245, 248, 255),
Font = Enum.Font.BuilderSansBold, TextSize = 13,
})
create("UICorner", getKey, {CornerRadius = UDim.new(0, 9)})
local status = create("TextLabel", card, {
Position = UDim2.fromOffset(22, 198), Size = UDim2.fromOffset(306, 18),
BackgroundTransparency = 1, Text = "Get your key in our Discord", TextColor3 = Color3.fromRGB(163, 178, 204),
Font = Enum.Font.BuilderSans, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Center,
})
getKey.Activated:Connect(function()
local invite = "https://discord.gg/ESQv2sc5p"
local clipboard = setclipboard or toclipboard
if type(clipboard) == "function" and pcall(clipboard, invite) then
status.Text = "Discord invite copied"
else status.Text = invite end
end)
local close = create("TextButton", card, {
Position = UDim2.fromOffset(310, 15), Size = UDim2.fromOffset(26, 26),
BackgroundTransparency = 1, Text = "×", TextColor3 = Color3.fromRGB(220, 230, 245),
Font = Enum.Font.BuilderSansBold, TextSize = 18,
})
local reopen = create("TextButton", gui, {
Position = UDim2.fromOffset(18, 160), Size = UDim2.fromOffset(48, 42),
BackgroundColor3 = Color3.fromRGB(25, 26, 34), Text = "CV",
TextColor3 = Color3.fromRGB(236, 77, 100), Font = Enum.Font.BuilderSansBold,
TextSize = 16, Visible = false,
})
create("UICorner", reopen, {CornerRadius = UDim.new(0, 12)})
close.Activated:Connect(function() mask.Visible = false; reopen.Visible = true end)
reopen.Activated:Connect(function() reopen.Visible = false; mask.Visible = true end)
local scale = create("UIScale", card, {Scale = 1})
local function resizeKey()
local camera = workspace.CurrentCamera
if camera then
scale.Scale = math.min(1, (camera.ViewportSize.X - 20) / 350,
(camera.ViewportSize.Y - 20) / card.Size.Y.Offset)
end
end
resizeKey()
local camera = workspace.CurrentCamera
local resizeConnection = camera and camera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeKey)
gui.Destroying:Connect(function() if resizeConnection then resizeConnection:Disconnect() end end)
local TweenService = game:GetService("TweenService")
field.Focused:Connect(function()
TweenService:Create(field, TweenInfo.new(.16), {BackgroundColor3 = Color3.fromRGB(45, 47, 59)}):Play()
end)
field.FocusLost:Connect(function()
TweenService:Create(field, TweenInfo.new(.16), {BackgroundColor3 = Color3.fromRGB(31, 35, 44)}):Play()
end)
local badge = create("TextLabel", card, {Position = UDim2.fromOffset(215, 26),
Size = UDim2.fromOffset(43, 20), BackgroundColor3 = Color3.fromRGB(63, 32, 44),
Text = "BETA", TextColor3 = Color3.fromRGB(255, 153, 170), Font = Enum.Font.BuilderSansBold, TextSize = 9})
create("UICorner", badge, {CornerRadius = UDim.new(0, 5)})
local started = false
local function submit()
if started then return end
if field.Text:lower():gsub("^%s+", ""):gsub("%s+$", "") ~= "cvortex" then
status.Text = "Incorrect key"
status.TextColor3 = Color3.fromRGB(255, 155, 155)
return
end
started = true
env.CVortexKeyValidated = true
env.CVortexLastStartupError = nil
card.Size = UDim2.fromOffset(350, 236)
status.Size = UDim2.fromOffset(306, 18)
status.TextWrapped = false
status.TextYAlignment = Enum.TextYAlignment.Center
status.TextColor3 = Color3.fromRGB(163, 178, 204)
status.Text = "Loading menu..."
unlock.Text = "Loading..."
resizeKey()
local finished = false
local function complete(success, detail)
if finished then return end
finished = true
if not gui.Parent then return end
if success then
if env.CVortexBootKeyGui == gui then env.CVortexBootKeyGui = nil end
gui:Destroy()
return
end
started = false
local message = tostring(detail or "Unknown startup error")
env.CVortexLastStartupError = message
warn("CVortex startup: " .. message)
if type(env.CVortexPlayerAimCleanup) == "function" then
pcall(env.CVortexPlayerAimCleanup)
end
unlock.Text = "Retry"
card.Size = UDim2.fromOffset(350, 300)
status.Size = UDim2.fromOffset(306, 82)
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top
status.TextColor3 = Color3.fromRGB(255, 155, 155)
status.Text = "Could not open menu. Tap Retry.\n" .. message:sub(1, 240)
resizeKey()
end
task.spawn(function()
local ok, err = pcall(startCVortex, complete)
if not ok then complete(false, err) end
end)
end
unlock.Activated:Connect(submit)
field.FocusLost:Connect(function(enterPressed) if enterPressed then submit() end end)
end

local function runCVortex(onStartupComplete)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local desktopKeybinds = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
and not UserInputService.TouchEnabled
local mobileKeybinds = false
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
LocalPlayer = Players.LocalPlayer
end
LocalPlayer:WaitForChild("PlayerGui")
local env = (type(getgenv) == "function" and getgenv()) or _G
if type(env.CVortexPlayerAimCleanup) == "function" then
pcall(env.CVortexPlayerAimCleanup)
end
if type(env.IgrisPlayerAimCleanup) == "function" then
pcall(env.IgrisPlayerAimCleanup)
end
for _, name in ipairs({"CVortexAimOverlay", "CVortexKey"}) do
local stale = LocalPlayer.PlayerGui:FindFirstChild(name)
if stale then stale:Destroy() end
end
local S = {
StreamerMode = false,
SkyboxEnabled = false,
SkyboxPreset = "Default",
SkyboxColor = Color3.fromRGB(255,255,255),
SkyboxCustomID = "",
ESP = false,
PlayerRange = 500,
PlayerHealth = true,
PlayerHealthBar = false,
PlayerDistance = true,
WeaponESP = false,
OffscreenArrows = true,
OffscreenOnly = false,
OffscreenArrowSize = 42,
OffscreenArrowRadius = 115,
OffscreenArrowColorMode = "Auto",
WeaponESPColor = Color3.fromRGB(255, 220, 130),
BoxESP = true,
SkeletonESP = false,
SkeletonColor = Color3.fromRGB(100, 205, 255),
SkeletonThickness = 2,
FillBox = false,
BoxFillColor = Color3.fromRGB(225, 67, 81),
Tracers = false,
TracerWallCheck = false,
TracerOrigin = "Bottom",
LocalESP = false,
SelfChams = false,
PlayerChams = false,
SelfChamsColor = Color3.fromRGB(80, 180, 255),
PlayerChamsColor = Color3.fromRGB(255, 75, 80),
LocalFill = Color3.fromRGB(80, 180, 255),
LocalOutline = Color3.fromRGB(170, 220, 255),
Fill = Color3.fromRGB(0, 200, 100),
Outline = Color3.fromRGB(120, 255, 170),
ESPWallColors = false,
VisibleColor = Color3.fromRGB(55, 230, 120),
HiddenColor = Color3.fromRGB(255, 75, 80),
FillTransparency = 0.55,
OutlineTransparency = 0,
AimEnabled = false,
TeamCheck = false,
AimIgnoredPlayers = {},
SilentAimEnabled = false,
Keybinds = {},
MobilePins = {},
ShowKeybindPanel = true,
MenuTransparency = 0,
MenuWidth = 610,
MenuHeight = 446,
KeybindPanelWidth = 0,
KeybindPanelHeight = 0,
KeybindPanelX = 16,
KeybindPanelY = 90,
WallCheck = true,
ShowFOV = true,
FOV = 145,
ShowSilentFOV = true,
SilentFOV = 220,
Speed = 10,
Duration = 0,
AimPart = "Head",
Freecam = false,
FreecamSpeed = 40,
Prediction = false,
PredictionMs = 120,
MonsterESP = false,
LowCPUMode = true,
MonsterRange = 650,
MonsterFill = Color3.fromRGB(245, 70, 80),
MonsterOutline = Color3.fromRGB(255, 190, 70),
ContainerESP = false,
ContainerRange = 500,
ContainerNames = true,
ContainerDistance = true,
ContainerOther = false,
ContainerTypes = {
Dresser = true, Nightstand = true, Backpack = true,
KitchenCabinet = true, Fridge = true, Locker = true, SupplyDrop = true,
},
Xray = false,
XrayTransparency = 0.68,
PlayerCounter = true,
HighlightedPlayers = 0,
HighlightedMonsters = 0,
InfiniteJump = false,
AutoBhop = false,
NoFog = false,
SnowEnabled = false,
SnowSize = 0.24,
SnowRate = 26,
SnowLifetime = 5,
ChinaHat = false,
ChinaHatSize = 1,
Trail = false, TrailColor = Color3.fromRGB(225,67,81), TrailSize = 1, TrailLifetime = .6,
BulletTracers = false, BulletTracerColor = Color3.fromRGB(225, 67, 81),
BulletTracerWidth = .1, BulletTracerLifetime = .25, BulletTracerDistance = 800,
Footsteps = false, FootstepColor = Color3.fromRGB(225,67,81), FootstepSize = 1,
JumpCircles = false, JumpCircleColor = Color3.fromRGB(225,67,81), JumpCircleSize = 1,
PlayerList = false, PlayerListWidth = 320, PlayerListHeight = 260,
PlayerListX = 20, PlayerListY = 120,
Brainrots = false, BrainrotChoice = "Tung Tung Sahur", SahurSize = 1, SahurRotation = 0,
CharacterTransparency = 0,
ChinaHatColor = Color3.fromRGB(225, 67, 81),
TargetHUDEnabled = false,
HitmarkerEnabled = false,
KillCrossEnabled = false,
Spin360Enabled = false,
VehicleSpeedEnabled = false,
VehicleSpeedMult = 2,
SpinSpeed = 4,
}
local rageFX = {}
local alive = true
local silentHook = nil
local connections = {}
-- A retry must also clean up a run that failed before the full cleanup exists.
env.CVortexPlayerAimCleanup = function()
alive = false
if rageFX.restoreSpin then pcall(rageFX.restoreSpin) end
if rageFX.restoreVehicleSpeed then pcall(rageFX.restoreVehicleSpeed) end
if silentHook then silentHook.resolve = nil; silentHook.onShot = nil end
for _, connection in ipairs(connections) do
pcall(function() connection:Disconnect() end)
end
table.clear(connections)
for _, name in ipairs({"CVortexFreecam", "CVortexSahurCosmetic", "CVortex_PlayerESP_Aimbot_Render"}) do
pcall(function() RunService:UnbindFromRenderStep(name) end)
end
for _, name in ipairs({"CVortexAimOverlay", "CVortexKey"}) do
local gui = LocalPlayer.PlayerGui:FindFirstChild(name)
if gui then pcall(function() gui:Destroy() end) end
end
end
local highlights = {}
local playerLabels = {}
local playerScreenMarks = {}
local currentTarget = nil
local activation = nil
local aimStartTime = 0
local espTimer = 0
local mainWindow = nil
local performanceHud = nil
local playerCounterLabel = nil
local counterPanel = nil
local monsterHighlights = {}
local containerMarks = {}
local containerScanQueue, containerScanHead, containerScanTail = {}, 1, 0
local containerScanGeneration, containerScanning, containerScanClock = 0, false, 0
local containerUpdateClock = 0
local xrayOriginal = {}
local monsterScanClock = 0
local xrayBuildId = 0
local originalFog = nil
local fogConnections = {}
local noFogValues = {
FogEnd = 100000,
FogStart = 0,
ClockTime = 14,
Brightness = 2,
GlobalShadows = false,
}

local function refreshEnvironment()
if S.NoFog then
if not originalFog then
originalFog = {}
for property in pairs(noFogValues) do
originalFog[property] = Lighting[property]
end
for property, target in pairs(noFogValues) do
table.insert(fogConnections, Lighting:GetPropertyChangedSignal(property):Connect(function()
if alive and S.NoFog and Lighting[property] ~= target then
Lighting[property] = target
end
end))
end
end
for property, value in pairs(noFogValues) do
if Lighting[property] ~= value then Lighting[property] = value end
end
elseif originalFog then
for _, connection in ipairs(fogConnections) do connection:Disconnect() end
table.clear(fogConnections)
local saved = originalFog
originalFog = nil
for property, value in pairs(saved) do Lighting[property] = value end
end
end

local function updateEnvironment()
local ok, err = pcall(refreshEnvironment)
if not ok then warn("CVortex Environment:", err) end
end

local function connect(signal, callback)
local conn = signal:Connect(callback)
table.insert(connections, conn)
return conn
end


local hatResizeQueued = false
local snowPart, snowParticles, hatFolder
local function clearSnow()
if snowPart then
pcall(function() snowPart:Destroy() end)
end
snowPart, snowParticles = nil, nil
end
local function refreshSnow()
if not alive or not S.SnowEnabled then clearSnow(); return end
if not snowPart or not snowPart.Parent then
local part = Instance.new("Part")
part.Name = "CVortexBetaSnowLocal"
part.Size = Vector3.new(40, 1.2, 35)
part.Anchored = true
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
part.Transparency = 1
part.CastShadow = false
local firstCamera = Workspace.CurrentCamera
if firstCamera then
part.CFrame = CFrame.new(firstCamera.CFrame.Position
+ firstCamera.CFrame.LookVector * 12 + Vector3.new(0, 14, 0))
end
part.Parent = Workspace
snowPart = part
local emitter = Instance.new("ParticleEmitter")
emitter.Name = "Snowflakes"
emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
emitter.Color = ColorSequence.new(Color3.fromRGB(240, 247, 255))
emitter.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(.1, .1),
NumberSequenceKeypoint.new(.83, .2),
NumberSequenceKeypoint.new(1, 1),
})
emitter.Shape = Enum.ParticleEmitterShape.Box
emitter.EmissionDirection = Enum.NormalId.Bottom
emitter.Speed = NumberRange.new(.5, 1.3)
emitter.Acceleration = Vector3.new(0, -7, 0)
emitter.Drag = .4
emitter.Rotation = NumberRange.new(-180, 180)
emitter.RotSpeed = NumberRange.new(-45, 45)
emitter.SpreadAngle = Vector2.new(12, 12)
emitter.LightInfluence = .15
emitter.LockedToPart = false
emitter.Parent = part
snowParticles = emitter
end
if snowParticles then
local size = math.clamp(tonumber(S.SnowSize) or .24, .08, .9)
local lifetime = math.clamp(tonumber(S.SnowLifetime) or 5, 2, 9)
snowParticles.Size = NumberSequence.new({
NumberSequenceKeypoint.new(0, size * .55),
NumberSequenceKeypoint.new(.22, size),
NumberSequenceKeypoint.new(1, size * .45),
})
snowParticles.Lifetime = NumberRange.new(lifetime * .8, lifetime)
snowParticles.Rate = math.clamp(tonumber(S.SnowRate) or 26, 3, 80)
snowParticles.Enabled = true
end
end
local wingsModel = nil
local originalCharacterTransparency = {}
local transparencyCharacter
local transparencyLastScan, transparencyLastAlpha = 0, nil
local function restoreCharacterTransparency()
for object, value in pairs(originalCharacterTransparency) do
pcall(function() object.Transparency = value end)
end
table.clear(originalCharacterTransparency)
transparencyCharacter = nil
transparencyLastScan, transparencyLastAlpha = 0, nil
end
local function refreshCharacterTransparency()
local character = LocalPlayer.Character
if character ~= transparencyCharacter then restoreCharacterTransparency() end
local alpha = math.clamp(tonumber(S.CharacterTransparency) or 0, 0, 1)
if not character or alpha == 0 then restoreCharacterTransparency(); return end
local now = os.clock()
if character == transparencyCharacter and alpha == transparencyLastAlpha
and now - transparencyLastScan < (S.LowCPUMode and 1.25 or .45) then return end
transparencyLastScan, transparencyLastAlpha = now, alpha
transparencyCharacter = character
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorOfClass("Tool")
and not (hatFolder and object:IsDescendantOf(hatFolder))
and not (wingsModel and object:IsDescendantOf(wingsModel)) then
if originalCharacterTransparency[object] == nil then
originalCharacterTransparency[object] = object.Transparency
end
local base = originalCharacterTransparency[object]
object.Transparency = base + (1-base)*alpha
end
end
end
local transparencyTick = 0
connect(RunService.Heartbeat, function(dt)
if not alive or S.CharacterTransparency <= 0 then return end
transparencyTick = transparencyTick + dt
if transparencyTick >= .15 then
transparencyTick = 0
refreshCharacterTransparency()
end
end)
local function clearChinaHat()
if hatFolder then pcall(function() hatFolder:Destroy() end) end
hatFolder = nil
end
local function refreshChinaHat()
clearChinaHat()
if not alive or not S.ChinaHat then return end
local character = LocalPlayer.Character
local head = character and character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
local model = Instance.new("Model")
model.Name = "CVortexBetaChinaHat"
model.Parent = character
hatFolder = model

local hatScale = math.clamp(tonumber(S.ChinaHatSize) or 1, .5, 2)
local radius = math.clamp(head.Size.X * 1.06, 1.8, 2.3) * hatScale
local baseY = head.Size.Y * .43 + .01
local rise = math.clamp(head.Size.Y * .68, 1.05, 1.42) * hatScale
local ringCount = 32
local accent = S.ChinaHatColor
local function weldToHead(part, offset)
part.Anchored = false
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
part.Massless = true
part.CastShadow = false
part.CFrame = head.CFrame * offset
part.Parent = model
local weld = Instance.new("WeldConstraint")
weld.Part0 = head
weld.Part1 = part
weld.Parent = part
end
local function shellTriangle(a, b, c, index)
local ab, ac, bc = b - a, c - a, c - b
local right = ac:Cross(ab).Unit
local back = bc.Unit
local up = bc:Cross(right).Unit
local height = math.abs(ab:Dot(up))
local function wedge(name, length, offset)
local part = Instance.new("WedgePart")
part.Name = name
part.Material = Enum.Material.SmoothPlastic
part.Color = accent
part.Transparency = .65
part.Size = Vector3.new(.015, height, length)
weldToHead(part, offset)
end
wedge("Shell_" .. index .. "A", math.abs(ab:Dot(back)),
CFrame.fromMatrix((a + b) / 2, right, up, back))
wedge("Shell_" .. index .. "B", math.abs(ac:Dot(back)),
CFrame.fromMatrix((a + c) / 2, -right, up, -back))
end
local apex = Vector3.new(0, baseY + rise, 0)
for n = 0, ringCount - 1 do
local angle0 = 2 * math.pi * n / ringCount
local angle1 = 2 * math.pi * (n + 1) / ringCount
shellTriangle(apex,
Vector3.new(math.cos(angle0) * radius, baseY, math.sin(angle0) * radius),
Vector3.new(math.cos(angle1) * radius, baseY, math.sin(angle1) * radius), n + 1)
end

local center = Instance.new("Part")
center.Name = "GlowAnchor"
center.Size = Vector3.new(.12, .12, .12)
center.Transparency = 1
weldToHead(center, CFrame.new(0, baseY, 0))

local function glowRing(r, height, width, alpha, tint)
local nodes = {}
local segments = 28
for k = 1, segments do
local theta = 2 * math.pi * (k - 1) / segments
local point = Instance.new("Attachment")
point.Name = "RingPoint_" .. k
point.Position = Vector3.new(
math.cos(theta) * r, height, math.sin(theta) * r)
point.Parent = center
nodes[k] = point
end
for k = 1, segments do
local edge = Instance.new("Beam")
edge.Name = "GlowEdge"
edge.Attachment0 = nodes[k]
edge.Attachment1 = nodes[k % segments + 1]
edge.FaceCamera = true
edge.LightEmission = 1
edge.LightInfluence = 0
edge.Width0 = width
edge.Width1 = width
edge.Transparency = NumberSequence.new(alpha)
edge.Color = ColorSequence.new(tint)
edge.Parent = center
end
end
glowRing(radius + .065, .005, .035, .08, accent)
glowRing(radius * .745, rise * .30, .017, .43,
accent:Lerp(Color3.new(1, 1, 1), .25))

local light = Instance.new("PointLight")
light.Name = "HatGlow"
light.Color = accent
light.Brightness = .65
light.Range = 6.5
light.Shadows = false
light.Parent = center

local tip = Instance.new("Part")
tip.Name = "GlowingTip"
tip.Shape = Enum.PartType.Ball
tip.Size = Vector3.new(.12, .12, .12)
tip.Material = Enum.Material.Neon
tip.Color = accent
weldToHead(tip, CFrame.new(0, baseY + rise - .015, 0))
end

local snowTick = 0
connect(RunService.RenderStepped, function(dt)
if not alive or not S.SnowEnabled or not snowPart then return end
snowTick = snowTick + dt
if snowTick < .1 then return end
snowTick = 0
local camera = Workspace.CurrentCamera
if camera then
snowPart.CFrame = CFrame.new(camera.CFrame.Position
+ camera.CFrame.LookVector * 12 + Vector3.new(0, 14, 0))
end
end)
connect(LocalPlayer.CharacterAdded, function(character)
task.defer(function()
if not alive or not S.ChinaHat then return end
local head = character:WaitForChild("Head", 8)
if head and alive then refreshChinaHat() end
end)
end)

local chamsOriginals = {}
local chamsApplied = {}
local function restoreChams(player)
chamsApplied[player] = nil
local saved = chamsOriginals[player]
if not saved then return end
chamsOriginals[player] = nil
for object, properties in pairs(saved) do
pcall(function()
for property, value in pairs(properties) do object[property] = value end
end)
end
end
local function colorCharacter(player, character, color)
local timeNow = os.clock()
local cached = chamsApplied[player]
if cached and cached.character == character and cached.color == color
and timeNow - cached.scanned < (S.LowCPUMode and 2 or 1) then return end
chamsApplied[player] = {character = character, color = color, scanned = timeNow}
local saved = chamsOriginals[player]
if not saved then saved = {}; chamsOriginals[player] = saved end
local function set(object, property, value)
local properties = saved[object]
if not properties then properties = {}; saved[object] = properties end
pcall(function()
if properties[property] == nil then properties[property] = object[property] end
if object[property] ~= value then object[property] = value end
end)
end
for _, object in ipairs(character:GetDescendants()) do
if not object:FindFirstAncestorOfClass("Tool")
and not (hatFolder and object:IsDescendantOf(hatFolder))
and not (wingsModel and object:IsDescendantOf(wingsModel)) then
if object:IsA("BasePart") and object.Name ~= "HumanoidRootPart" then
set(object, "Color", color)
set(object, "Material", Enum.Material.SmoothPlastic)
set(object, "Reflectance", 0)
if object:IsA("MeshPart") then set(object, "TextureID", "") end
elseif object:IsA("SpecialMesh") then
set(object, "TextureId", "")
set(object, "VertexColor", Vector3.new(1, 1, 1))
elseif object:IsA("Decal") or object:IsA("Texture") then
set(object, "Transparency", 1)
elseif object:IsA("Shirt") then set(object, "ShirtTemplate", "")
elseif object:IsA("Pants") then set(object, "PantsTemplate", "")
elseif object:IsA("ShirtGraphic") then set(object, "Graphic", "")
elseif object:IsA("SurfaceAppearance") then
if not saved[object] then saved[object] = {Parent = object.Parent} end
object.Parent = nil
end
end
end
end
local function removeESP(player)
restoreChams(player)
local marks = playerScreenMarks[player]
if marks then
marks.line:Destroy()
marks.box:Destroy()
marks.name:Destroy()
marks.distance:Destroy()
marks.health:Destroy()
marks.healthBar:Destroy()
marks.weapon:Destroy()
if marks.skeletonLines then
for _, segment in ipairs(marks.skeletonLines) do
pcall(function() segment:Destroy() end)
end
end
playerScreenMarks[player] = nil
end
local old = highlights[player]
highlights[player] = nil
if old then pcall(function() old:Destroy() end) end
local label = playerLabels[player]
playerLabels[player] = nil
if label then pcall(function() label.gui:Destroy() end) end
end
local function refreshPlayerLabel(player, character, humanoid, distance)
local record = playerLabels[player]
if S.BoxESP then
if record then record.gui.Enabled = false end
return
end
local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
if not head or not head:IsA("BasePart") or not (S.PlayerHealth or S.PlayerDistance) then
if record then record.gui.Enabled = false end
return
end
if not record or not record.gui.Parent then
local gui = Instance.new("BillboardGui")
gui.Name = "CVortex_PlayerInfo"
gui.Size = UDim2.fromOffset(210, 36)
gui.StudsOffsetWorldSpace = Vector3.new(0, 2.8, 0)
gui.AlwaysOnTop = true
gui.MaxDistance = 0
gui.LightInfluence = 0
gui.Adornee = head
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local text = Instance.new("TextLabel")
text.Name = "Info"
text.Size = UDim2.fromScale(1, 1)
text.BackgroundColor3 = Color3.fromRGB(16, 17, 20)
text.BackgroundTransparency = 1
text.BorderSizePixel = 0
text.TextColor3 = Color3.fromRGB(245, 245, 245)
text.TextSize = 12
text.Font = Enum.Font.BuilderSansMedium
text.TextStrokeTransparency = .65
text.Parent = gui
Instance.new("UICorner", text).CornerRadius = UDim.new(0, 5)
record = {gui = gui, text = text}
playerLabels[player] = record
end
if record.gui.Adornee ~= head then record.gui.Adornee = head end
if not record.gui.Enabled then record.gui.Enabled = true end
local details = {}
if S.PlayerHealth then
table.insert(details, string.format("HP %d/%d", math.ceil(math.max(0, humanoid.Health)), math.ceil(math.max(0, humanoid.MaxHealth))))
end
if S.PlayerDistance then table.insert(details, string.format("%d studs", math.floor(distance + .5))) end
local nextText = ((S.StreamerMode and player == LocalPlayer) and "Streamer" or player.DisplayName) .. "\n" .. table.concat(details, "  ·  ")
if record.text.Text ~= nextText then record.text.Text = nextText end

end
local espWallParams = RaycastParams.new()
espWallParams.FilterType = Enum.RaycastFilterType.Exclude
espWallParams.IgnoreWater = true
local function refreshESP(player)
if not alive then return end
local selfPlayer = player == LocalPlayer
local enabled = selfPlayer and S.LocalESP or (not selfPlayer and (S.ESP or S.WeaponESP))
local chams = selfPlayer and S.SelfChams or (not selfPlayer and S.PlayerChams)
if not chams then restoreChams(player) end
if not enabled and not chams then removeESP(player); return end
local character = player.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not character or not humanoid or humanoid.Health <= 0 then
removeESP(player)
return
end
local distance = 0
if not selfPlayer then
local myCharacter = LocalPlayer.Character
local origin = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
local targetRoot = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
if not origin or not targetRoot or not origin:IsA("BasePart") or not targetRoot:IsA("BasePart") then
removeESP(player)
return
end
distance = (targetRoot.Position - origin.Position).Magnitude
if distance > S.PlayerRange then
restoreChams(player)
local marker = highlights[player]
if marker then
if marker.Enabled then marker.Enabled = false end
if marker:GetAttribute("CVESPActive") ~= false then
marker:SetAttribute("CVESPActive", false)
end
end
local label = playerLabels[player]
if label then label.gui.Enabled = false end
return
end
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
local espColor = nil
if not selfPlayer and (S.ESPWallColors or S.TracerWallCheck) then
local camera = Workspace.CurrentCamera
local target = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
if camera and target then
local rayOrigin = camera.CFrame.Position
espWallParams.FilterDescendantsInstances = LocalPlayer.Character and {LocalPlayer.Character} or {}
local hit = Workspace:Raycast(rayOrigin, target.Position - rayOrigin, espWallParams)
local visible = not (hit and not hit.Instance:IsDescendantOf(character))
outline:SetAttribute("WallVisible", visible)
if S.ESPWallColors then espColor = visible and S.VisibleColor or S.HiddenColor end
end
end
outline.FillColor = espColor or (selfPlayer and S.LocalFill or S.Fill)
outline.OutlineColor = espColor or (selfPlayer and S.LocalOutline or S.Outline)
outline.FillTransparency = not selfPlayer and S.BoxESP and 1 or S.FillTransparency
outline.OutlineTransparency = not selfPlayer and S.BoxESP and 1 or S.OutlineTransparency
if chams then
colorCharacter(player, character, selfPlayer and S.SelfChamsColor or S.PlayerChamsColor)
outline.FillTransparency = 1
outline.OutlineTransparency = 1
elseif not enabled then
outline.FillTransparency = 1
end
if not enabled then outline.OutlineTransparency = 1 end
local showHighlight = not chams and (selfPlayer and S.LocalESP or (not selfPlayer and S.ESP and not S.BoxESP))
if outline.Enabled ~= showHighlight then outline.Enabled = showHighlight end
local visiblePlayerESP = selfPlayer and S.LocalESP or (not selfPlayer and S.ESP)
if outline:GetAttribute("CVESPActive") ~= visiblePlayerESP then
outline:SetAttribute("CVESPActive", visiblePlayerESP)
end
if not selfPlayer then
if enabled and S.ESP then
refreshPlayerLabel(player, character, humanoid, distance)
elseif playerLabels[player] then
playerLabels[player].gui.Enabled = false
end
end
end
local function updateCounter()
local n = 0
for player, marker in pairs(highlights) do
if player ~= LocalPlayer and marker and marker.Parent
and (marker.Enabled or marker:GetAttribute("CVESPActive") == true)
and marker.Adornee and marker.Adornee.Parent then
n = n + 1
end
end
S.HighlightedPlayers = n
if playerCounterLabel then
local showCounter = alive and S.PlayerCounter
if counterPanel.Visible ~= showCounter then counterPanel.Visible = showCounter end
if showCounter then
local message = "PLAYERS " .. tostring(n) .. "   MONSTERS " .. tostring(S.HighlightedMonsters)
if playerCounterLabel.Text ~= message then playerCounterLabel.Text = message end
end
end
end
local function refreshAllESP()
for _, player in ipairs(Players:GetPlayers()) do
refreshESP(player)
end
updateCounter()
end
local overlay = Instance.new("ScreenGui")
overlay.Name = "CVortexAimOverlay"
overlay.ResetOnSpawn = false
overlay.IgnoreGuiInset = true
overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
overlay.DisplayOrder = 2500
overlay.Parent = LocalPlayer:WaitForChild("PlayerGui")
overlay.Enabled = false
-- Local motion cosmetics and an independent, bounded player-list window.
local activeWindowDrag = nil
local function enableWindowResize(frame, options)
if not frame then return end
options = options or {}
local grip = Instance.new("TextButton")
grip.Name = "CVortexResizeGrip"
grip.AnchorPoint = Vector2.new(1, 1)
grip.Position = UDim2.new(1, -3, 1, -3)
grip.Size = UDim2.fromOffset(options.gripSize or 27, options.gripSize or 27)
grip.BackgroundTransparency = 1
grip.BorderSizePixel = 0
grip.Text = "◢"
grip.Font = Enum.Font.GothamBold
grip.TextSize = 15
grip.TextColor3 = Color3.fromRGB(232, 234, 239)
grip.ZIndex = math.max(frame.ZIndex + 7, 25)
grip.AutoButtonColor = false
grip.Active = true
grip.Parent = frame
local pointer, origin, width, height, pos
local function stop()
if pointer and activeWindowDrag == frame then activeWindowDrag = nil end
pointer = nil
end
connect(grip.InputBegan, function(input)
if not alive or activeWindowDrag then return end
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
activeWindowDrag, pointer = frame, input
origin, width, height, pos = input.Position,
frame.Size.X.Offset, frame.Size.Y.Offset, frame.Position
end)
connect(UserInputService.InputChanged, function(input)
if not pointer or not alive then return end
if pointer.UserInputType == Enum.UserInputType.Touch then
if input ~= pointer then return end
elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
local scale = math.max(.25, options.scale and options.scale() or 1)
local view = Workspace.CurrentCamera
and Workspace.CurrentCamera.ViewportSize or Vector2.new(1000, 720)
local maxW = math.max(options.minW or 160,
math.min(options.maxW or 1000, (view.X - 12) / scale))
local maxH = math.max(options.minH or 80,
math.min(options.maxH or 800, (view.Y - 12) / scale))
local d = input.Position - origin
local w = math.floor(math.clamp(width + d.X / scale,
options.minW or 160, maxW) + .5)
local h = math.floor(math.clamp(height + d.Y / scale,
options.minH or 80, maxH) + .5)
if options.onResize then options.onResize(w, h)
else frame.Size = UDim2.fromOffset(w, h) end
if frame.AnchorPoint.X ~= 0 or frame.AnchorPoint.Y ~= 0 then
frame.Position = UDim2.new(pos.X.Scale,
pos.X.Offset + (w - width) * frame.AnchorPoint.X * scale,
pos.Y.Scale,
pos.Y.Offset + (h - height) * frame.AnchorPoint.Y * scale)
end
end)
connect(UserInputService.InputEnded, function(input)
if pointer and (input == pointer
or (pointer.UserInputType == Enum.UserInputType.MouseButton1
and input.UserInputType == Enum.UserInputType.MouseButton1)) then
if options.onFinish then options.onFinish() end
stop()
end
end)
connect(UserInputService.WindowFocusReleased, stop)
return grip
end

local motionVisuals = {save = function() end}
do
local folder, root, humanoid, stateConnection, trail
local attachments, particles, rows = {}, {}, {}
local elapsed, stepped, lastPosition, footSide = 0, 0, nil, 1
local pointer, origin, startPosition, destination, moveTween
local lastViewport
local function make(class, parent, props)
local object = Instance.new(class)
for key,value in pairs(props or {}) do object[key] = value end
object.Parent = parent
return object
end
local function round(object, radius)
make("UICorner",object,{CornerRadius=UDim.new(0,radius or 8)})
end
local panel = make("Frame",overlay,{Name="CVPlayerList",Visible=false,BorderSizePixel=0,
BackgroundColor3=Color3.fromRGB(29,30,33),ClipsDescendants=true})
round(panel,10)
local header=make("TextLabel",panel,{Size=UDim2.new(1,0,0,36),BackgroundTransparency=1,
Text="  PLAYERS",TextColor3=Color3.fromRGB(239,240,243),Font=Enum.Font.GothamBold,
TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Active=true})
local columns=make("TextLabel",panel,{Position=UDim2.fromOffset(12,36),Size=UDim2.new(1,-24,0,23),
BackgroundTransparency=1,Text="PLAYER                         HP       PING",TextSize=10,
Font=Enum.Font.Gotham,TextColor3=Color3.fromRGB(154,157,166),TextXAlignment=Enum.TextXAlignment.Left})
columns.Text="PLAYER"
for _,col in ipairs({{"HP",-132,74},{"PING",-58,46}}) do
make("TextLabel",panel,{Position=UDim2.new(1,col[2],0,36),Size=UDim2.fromOffset(col[3],23),
BackgroundTransparency=1,Text=col[1],TextSize=10,Font=Enum.Font.Gotham,
TextColor3=Color3.fromRGB(154,157,166)})
end
local list=make("ScrollingFrame",panel,{Position=UDim2.fromOffset(8,60),Size=UDim2.new(1,-16,1,-66),
BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,
ScrollBarImageColor3=Color3.fromRGB(130,134,145),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y})
make("UIListLayout",list,{Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder})
local preview=make("Frame",overlay,{Name="CVPlayerListDestination",Visible=false,
BackgroundColor3=Color3.fromRGB(225,67,81),BackgroundTransparency=.94,BorderSizePixel=0,ZIndex=50})
round(preview,10)
make("UIStroke",preview,{Color=Color3.fromRGB(225,67,81),Thickness=2,Transparency=.1})
local function bounds(x,y)
local view=Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
return UDim2.fromOffset(math.clamp(x,0,math.max(0,view.X-panel.AbsoluteSize.X)),
math.clamp(y,0,math.max(0,view.Y-panel.AbsoluteSize.Y)))
end
local function cancelDrag()
pointer,destination=nil,nil
preview.Visible=false
if activeWindowDrag==panel then activeWindowDrag=nil end
end
function motionVisuals.layout()
local view=Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
lastViewport=view
panel.Size=UDim2.fromOffset(math.min(math.clamp(S.PlayerListWidth,240,800),view.X),
math.min(math.clamp(S.PlayerListHeight,130,740),view.Y))
panel.Position=bounds(S.PlayerListX,S.PlayerListY)
preview.Size=panel.Size
panel.Visible=alive and S.PlayerList
if not panel.Visible then cancelDrag() end
end
enableWindowResize(panel, {
minW=240, minH=130, maxW=800, maxH=740,
onResize=function(w,h)
S.PlayerListWidth,S.PlayerListHeight=w,h
motionVisuals.layout()
end,
onFinish=function() motionVisuals.save() end,
})
connect(header.InputBegan,function(input)
if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
if activeWindowDrag then return end
activeWindowDrag=panel
if moveTween then moveTween:Cancel() end
pointer,origin,startPosition=input,input.Position,panel.Position
destination=nil
end)
connect(UserInputService.InputChanged,function(input)
if not pointer then return end
if input~=pointer and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
local delta=input.Position-origin
if delta.Magnitude<5 and not destination then return end
destination=bounds(startPosition.X.Offset+delta.X,startPosition.Y.Offset+delta.Y)
preview.Position=destination
preview.Visible=panel.Visible
end)
connect(UserInputService.InputEnded,function(input)
if input~=pointer then return end
local target=destination
cancelDrag()
if target then
S.PlayerListX,S.PlayerListY=target.X.Offset,target.Y.Offset
moveTween=TweenService:Create(panel,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target})
moveTween:Play()
motionVisuals.save()
end
end)
connect(UserInputService.WindowFocusReleased,cancelDrag)
local function updateList()
local players=Players:GetPlayers()
header.Text="  PLAYERS  ·  "..#players
local present={}
table.sort(players,function(a,b) return a.Name:lower()<b.Name:lower() end)
for index,player in ipairs(players) do
present[player]=true
local item=rows[player]
if not item then
local row=make("Frame",list,{Size=UDim2.new(1,-3,0,32),BorderSizePixel=0,
BackgroundColor3=Color3.fromRGB(39,40,44)})
round(row,6)
local function label(pos,size,align,clickable)
return make(clickable and "TextButton" or "TextLabel",row,{
Position=pos,Size=size,BackgroundTransparency=1,
Font=Enum.Font.Gotham,TextSize=11,
TextColor3=Color3.fromRGB(230,232,237),
TextXAlignment=align or Enum.TextXAlignment.Center,
TextTruncate=Enum.TextTruncate.AtEnd,
AutoButtonColor=clickable and false or nil
})
end
item={row=row,name=label(UDim2.fromOffset(8,0),UDim2.new(1,-140,1,0),Enum.TextXAlignment.Left,false),
hp=label(UDim2.new(1,-124,0,0),UDim2.new(0,74,1,0)),
ping=label(UDim2.new(1,-50,0,0),UDim2.new(0,46,1,0))}
rows[player]=item
end
item.row.LayoutOrder=index
item.name.Text=((S.StreamerMode and player==LocalPlayer) and "Streamer" or player.DisplayName)
local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
item.hp.Text=h and string.format("%d/%d",math.ceil(math.max(0,h.Health)),math.ceil(h.MaxHealth)) or "—"
local fraction=h and h.Health/math.max(1,h.MaxHealth) or 1
item.hp.TextColor3=fraction<.3 and Color3.fromRGB(255,100,110)
or fraction<.65 and Color3.fromRGB(255,182,85) or Color3.fromRGB(115,225,163)
-- Other clients' real RTT is not replicated; never substitute our own ping.
item.ping.Text="—"
item.ping.TextColor3=Color3.fromRGB(154,157,166)
if player==LocalPlayer then
local ok,ping=pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
if ok and type(ping)=="number" then
item.ping.Text=tostring(math.floor(ping+.5)).."ms"
item.ping.TextColor3=ping<100 and Color3.fromRGB(115,225,163)
or ping<180 and Color3.fromRGB(255,182,85) or Color3.fromRGB(255,100,110)
end
end
end
for player,item in pairs(rows) do
if not present[player] then item.row:Destroy(); rows[player]=nil end
end
end
local toolboxTrailTemplate, toolboxTrailLoading, toolboxTrailAttempted = nil, false, false
local function requestToolboxTrail()
if toolboxTrailAttempted or toolboxTrailLoading then return end
toolboxTrailAttempted, toolboxTrailLoading = true, true
task.spawn(function()
local selected
local ok, errorMessage = pcall(function()
for _, assetId in ipairs({78977787225367, 4534156885, 89907617583553}) do
local success, objects = pcall(function()
return game:GetObjects("rbxassetid://" .. assetId)
end)
if success and type(objects) == "table" then
local bestScore, visited = -math.huge, 0
local function check(candidate)
if visited >= 1400 then return end
visited = visited + 1
if not candidate:IsA("Trail") then return end
local score = 0
if candidate.Enabled then score = score + 2 end
if candidate.Texture and candidate.Texture ~= "" then score = score + 5 end
if candidate.FaceCamera then score = score + 2 end
if candidate.LightEmission > 0 then score = score + 1 end
if score > bestScore then
local safe = candidate:Clone()
if safe then
if selected then selected:Destroy() end
selected, bestScore = safe, score
end
end
end
for _, obj in ipairs(objects) do
check(obj)
for _, descendant in ipairs(obj:GetDescendants()) do
check(descendant)
if visited >= 1400 then break end
end
obj:Destroy()
end
if selected then break end
end
end
end)
toolboxTrailLoading = false
if not alive then
if selected then selected:Destroy() end
return
end
if ok and selected then
toolboxTrailTemplate = selected
if S.Trail and root and folder and motionVisuals.refresh then
if trail then trail:Destroy(); trail = nil end
motionVisuals.refresh()
end
else
if selected then selected:Destroy() end
warn("CVortex: Toolbox Trail unavailable; keeping local fallback. "..tostring(errorMessage))
end
end)
end

local function clearTrail()
if trail then trail:Destroy(); trail=nil end
for _,a in ipairs(attachments) do a:Destroy() end
table.clear(attachments)
end
local function clearParticles(kind)
for i=#particles,1,-1 do
if not kind or particles[i].kind==kind then
particles[i].object:Destroy(); table.remove(particles,i)
end
end
end
local function part(parent)
return make("Part",parent,{Name="CVLocalEffect",Anchored=true,CanCollide=false,
CanTouch=false,CanQuery=false,CastShadow=false,Material=Enum.Material.Neon,
TopSurface=Enum.SurfaceType.Smooth,BottomSurface=Enum.SurfaceType.Smooth,Transparency=.2})
end
local function ground(position)
local params=RaycastParams.new()
params.FilterType=Enum.RaycastFilterType.Exclude
params.FilterDescendantsInstances={LocalPlayer.Character,folder}
return Workspace:Raycast(position+Vector3.new(0,.3,0),Vector3.new(0,-9,0),params)
end
local function surface(hit)
local up=hit.Normal
local forward=root.CFrame.LookVector-up*root.CFrame.LookVector:Dot(up)
if forward.Magnitude<.01 then forward=Vector3.new(1,0,0):Cross(up) end
forward=forward.Unit
return CFrame.fromMatrix(hit.Position+up*.04,forward:Cross(up).Unit,up,-forward)
end
local function addParticle(record)
if #particles>=40 then particles[1].object:Destroy(); table.remove(particles,1) end
record.age=0
table.insert(particles,record)
end
local function jumpCircle()
if not alive or not overlay.Enabled or not S.JumpCircles or not root or not folder then return end
local hit=ground(root.Position)
if not hit then return end
local model=make("Model",folder,{Name="CVJumpCircle"})
local segments={}
local circleFrame=surface(hit)
local circleSize=math.clamp(S.JumpCircleSize,.5,3)
for i=1,32 do
local segment=part(model)
segment.Color=S.JumpCircleColor
local angle=(i-1)*math.pi*2/32
local radius=circleSize*.6
segment.Size=Vector3.new(.075,.025,2*radius*math.tan(math.pi/32)+.025)
segment.CFrame=circleFrame*CFrame.new(math.cos(angle)*radius,0,math.sin(angle)*radius)*CFrame.Angles(0,-angle,0)
segments[i]=segment
end
addParticle({kind="circle",object=model,segments=segments,frame=circleFrame,
size=circleSize,life=.8})
end
local function unbind()
clearTrail(); clearParticles()
if stateConnection then stateConnection:Disconnect(); stateConnection=nil end
if folder then folder:Destroy(); folder=nil end
root,humanoid,lastPosition=nil,nil,nil
stepped=0
end
local function syncTrail()
if not S.Trail or not root then clearTrail(); return end
if not trail then
attachments[1]=make("Attachment",root,{Name="CVTrailTop"})
attachments[2]=make("Attachment",root,{Name="CVTrailBottom"})
if toolboxTrailTemplate then
trail=toolboxTrailTemplate:Clone()
trail.Name="CVortexToolboxTrail"
trail.Attachment0,trail.Attachment1=attachments[1],attachments[2]
trail.FaceCamera=true
trail.Enabled=true
trail.Parent=folder
else
trail=make("Trail",folder,{Attachment0=attachments[1],Attachment1=attachments[2],
FaceCamera=true,MinLength=.05,LightEmission=.8,
Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.15),NumberSequenceKeypoint.new(1,1)})})
requestToolboxTrail()
end
end
local size=math.clamp(S.TrailSize,.2,3)
attachments[1].Position=Vector3.new(0,size*.5,.55)
attachments[2].Position=Vector3.new(0,-size*.5,.55)
trail.Color=ColorSequence.new(S.TrailColor)
trail.Lifetime=math.clamp(S.TrailLifetime,.2,2)
end
function motionVisuals.refresh()
motionVisuals.layout()
if S.PlayerList then updateList() end
if not S.Footsteps then clearParticles("step") end
if not S.JumpCircles then clearParticles("circle") end
syncTrail()
end
function motionVisuals.destroy()
cancelDrag(); unbind()
if toolboxTrailTemplate then toolboxTrailTemplate:Destroy(); toolboxTrailTemplate=nil end
if moveTween then moveTween:Cancel() end
panel:Destroy(); preview:Destroy()
end
connect(RunService.Heartbeat,function(dt)
if not alive then return end
elapsed=elapsed+dt
if elapsed>=.5 then
elapsed=0
if S.PlayerList and overlay.Enabled then
local size=panel.AbsoluteSize
local view=Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize
if view and (view~=lastViewport or size.X>view.X or size.Y>view.Y or panel.Position.X.Offset+size.X>view.X or panel.Position.Y.Offset+size.Y>view.Y) then motionVisuals.layout() end
updateList()
end
end
local character=LocalPlayer.Character
local nextRoot=character and character:FindFirstChild("HumanoidRootPart")
local nextHumanoid=character and character:FindFirstChildOfClass("Humanoid")
local enabled=overlay.Enabled and (S.Trail or S.Footsteps or S.JumpCircles)
and nextRoot and nextHumanoid and nextHumanoid.Health>0
if not enabled then
if root then unbind() end
return
end
if root~=nextRoot or humanoid~=nextHumanoid then
unbind()
root,humanoid=nextRoot,nextHumanoid
folder=make("Folder",Workspace,{Name="CVortexMotionEffects"})
stateConnection=humanoid.StateChanged:Connect(function(_,state)
if state==Enum.HumanoidStateType.Jumping then jumpCircle() end
end)
syncTrail()
end
local pos=root.Position
if S.Footsteps and lastPosition and humanoid.FloorMaterial~=Enum.Material.Air then
local distance=Vector3.new(pos.X-lastPosition.X,0,pos.Z-lastPosition.Z).Magnitude
if distance<12 then stepped=stepped+distance else stepped=0 end
if stepped>=2.3 then
stepped=0; footSide=-footSide
local hit=ground(pos+root.CFrame.RightVector*(footSide*.48))
if hit then
local p=part(folder)
p.Color=S.FootstepColor
p.Size=Vector3.new(.38,.025,.8)*math.clamp(S.FootstepSize,.5,2)
p.CFrame=surface(hit)
addParticle({kind="step",object=p,life=1.7})
end
end
else stepped=0 end
lastPosition=pos
for i=#particles,1,-1 do
local record=particles[i]
record.age=record.age+dt
local t=math.clamp(record.age/record.life,0,1)
if t>=1 then record.object:Destroy(); table.remove(particles,i)
elseif record.kind=="step" then record.object.Transparency=.2+.8*t*t
else
local radius=record.size*(.6+2.4*(1-(1-t)^2))
for j,segment in ipairs(record.segments) do
local angle=(j-1)*math.pi*2/32
segment.Size=Vector3.new(.075,.025,2*radius*math.tan(math.pi/32)+.025)
segment.CFrame=record.frame*CFrame.new(math.cos(angle)*radius,0,math.sin(angle)*radius)*CFrame.Angles(0,-angle,0)
segment.Transparency=.15+.85*t
end
end
end
end)
end

-- Toolbox cosmetic: ATMnou / 138151705692565. Imported geometry only.
do
local morph = {message="Off · local cosmetic", generation=0, hidden={}}
motionVisuals.sahur = morph
local function status(text)
morph.message=text
if morph.label and morph.label.Parent then morph.label.Text=text end
end
local function restore()
for object,value in pairs(morph.hidden) do
if object.Parent then pcall(function() object.LocalTransparencyModifier=value end) end
end
table.clear(morph.hidden)
if morph.model then morph.model:Destroy(); morph.model=nil end
if morph.added then morph.added:Disconnect(); morph.added=nil end
morph.character,morph.root=nil,nil
end
local function track(object)
if not object:IsA("BasePart") or object:FindFirstAncestorOfClass("Tool") then return end
if hatFolder and object:IsDescendantOf(hatFolder) then return end
if wingsModel and object:IsDescendantOf(wingsModel) then return end
if morph.hidden[object]==nil then morph.hidden[object]=object.LocalTransparencyModifier end
end
local function sanitize(objects)
local model=Instance.new("Model")
model.Name="CVortexBrainrotTemplate"
local count=0
local function copyPart(source)
if not source:IsA("BasePart") then return end
local clone=source:Clone()
if not clone then return end
-- Never parent imported code, constraints or effects into the live game.
for _,child in ipairs(clone:GetDescendants()) do
if not (child:IsA("SpecialMesh") or child:IsA("SurfaceAppearance")
or child:IsA("Decal") or child:IsA("Texture")) then child:Destroy() end
end
clone.Anchored=true
clone.CanCollide=false; clone.CanTouch=false; clone.CanQuery=false
clone.CastShadow=false
clone.LocalTransparencyModifier=0
clone.Parent=model
count=count+1
end
for _,object in ipairs(objects) do
copyPart(object)
for _,part in ipairs(object:GetDescendants()) do copyPart(part) end
end
if count==0 then model:Destroy(); error("Toolbox model has no mesh") end
local box,size=model:GetBoundingBox()
if size.Y<.01 then model:Destroy(); error("Invalid model dimensions") end
model.WorldPivot=box
model:PivotTo(CFrame.new())
model:ScaleTo(5.5/size.Y)
return model
end

local function position()
local model,root=morph.model,morph.root
if not model or not root or not root.Parent then return end
local h=morph.character:FindFirstChildOfClass("Humanoid")
if not h then return end
local depth=h.HipHeight+root.Size.Y*.5
if h.RigType==Enum.HumanoidRigType.R6 then
local leg=morph.character:FindFirstChild("Left Leg")
depth=root.Size.Y*.5+(leg and leg.Size.Y or 2)
end
model:PivotTo(root.CFrame*CFrame.new(0,-depth+morph.height*.5,0)
*CFrame.Angles(0,math.rad(S.SahurRotation),0))
local camera=Workspace.CurrentCamera
local head=morph.character:FindFirstChild("Head")
local firstPerson=camera and head and (camera.CFrame.Position-head.Position).Magnitude<1
for _,part in ipairs(model:GetChildren()) do
if part:IsA("BasePart") then
part.LocalTransparencyModifier=firstPerson and 1 or math.clamp(S.CharacterTransparency,0,1)
end
end
end
function morph.resize()
if not morph.model then return end
morph.model:ScaleTo(morph.template:GetScale()*math.clamp(S.SahurSize,.5,2))
local _,size=morph.model:GetBoundingBox()
morph.height=size.Y
position()
end
function morph.refresh()
morph.generation=morph.generation+1
local generation=morph.generation
morph.loading=false
restore()
if not alive or not S.Brainrots then status("Off · local cosmetic"); return end
if not overlay.Enabled then status("Waiting for menu unlock..."); return end
local character=LocalPlayer.Character
local root=character and character:FindFirstChild("HumanoidRootPart")
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health<=0 then status("Waiting for character..."); return end
morph.loading=true
status("Loading Brainrot model...")
task.spawn(function()
local ok,result=pcall(function()
local choice=S.BrainrotChoice
if morph.template and morph.templateChoice~=choice then
morph.template:Destroy(); morph.template=nil
end
if not morph.template then
local ids={["Tung Tung Sahur"]=138151705692565,
["Tralalero Tralala"]=86823142438072,
["Bombardiro Crocodilo"]=75917340023934}
local id=ids[choice]
if not id then error("Unknown Brainrot: "..tostring(choice)) end
local objects=game:GetObjects("rbxassetid://"..id)
local built,template=pcall(sanitize,objects)
for _,object in ipairs(objects) do object:Destroy() end
if not built then error(template) end
local loaded,loadError=pcall(function()
local failed=false
game:GetService("ContentProvider"):PreloadAsync({template},function(_,result)
if result~=Enum.AssetFetchStatus.Success then failed=true end
end)
if failed then error("Mesh or texture could not load") end
end)
if not loaded then template:Destroy(); error(loadError) end
if not alive or generation~=morph.generation then template:Destroy(); return end
morph.template=template; morph.templateChoice=choice
end
if not alive or not S.Brainrots or generation~=morph.generation then return end
if character~=LocalPlayer.Character or not root.Parent or humanoid.Health<=0 then return end
morph.model=morph.template:Clone()
morph.model.Name="CVortexBrainrot"
morph.character,morph.root=character,root
morph.resize()
morph.model.Parent=Workspace
for _,object in ipairs(character:GetDescendants()) do track(object) end
morph.added=character.DescendantAdded:Connect(track)
status("Active · visible only to you")
end)
if generation~=morph.generation then return end
morph.loading=false
if not ok then
restore()
morph.failedCharacter=character
status("Model unavailable. Toggle off/on to retry.")
warn("CVortex Brainrot model: "..tostring(result))
else morph.failedCharacter=nil end
end)
end
function morph.destroy()
morph.generation=morph.generation+1
restore()
if morph.template then morph.template:Destroy(); morph.template=nil end
RunService:UnbindFromRenderStep("CVortexSahurCosmetic")
end
local tick=0
connect(RunService.Heartbeat,function(dt)
if not alive or not S.Brainrots or not overlay.Enabled then return end
tick=tick+dt
if tick<.25 then return end
tick=0
local character=LocalPlayer.Character
local humanoid=character and character:FindFirstChildOfClass("Humanoid")
if morph.model and (morph.character~=character or not humanoid or humanoid.Health<=0) then
restore(); status("Waiting for character...")
end
if not morph.model and not morph.loading and character~=morph.failedCharacter
and humanoid and humanoid.Health>0 then morph.refresh() end
end)
local hiddenUpdateElapsed = 0
RunService:BindToRenderStep("CVortexSahurCosmetic",Enum.RenderPriority.Last.Value+1,function(dt)
if not alive or not morph.model then return end
position()
hiddenUpdateElapsed = hiddenUpdateElapsed + (dt or 1 / 60)
if hiddenUpdateElapsed < (S.LowCPUMode and .12 or .05) then return end
hiddenUpdateElapsed = 0
for object in pairs(morph.hidden) do
if object.Parent and object:IsDescendantOf(morph.character)
and not object:FindFirstAncestorOfClass("Tool")
and not (hatFolder and object:IsDescendantOf(hatFolder))
and not (wingsModel and object:IsDescendantOf(wingsModel)) then
object.LocalTransparencyModifier=1
else
if object.Parent then object.LocalTransparencyModifier=morph.hidden[object] end
morph.hidden[object]=nil
end
end
end)
end


local bulletTracerFolder
local bulletTracerHistory = {count=0, cursor=0, shots=0, message="Waiting for a shot", label=nil}
local function clearBulletTracers()
if bulletTracerFolder then bulletTracerFolder:Destroy(); bulletTracerFolder=nil end
for i=1,bulletTracerHistory.count do bulletTracerHistory[i]=nil end
bulletTracerHistory.count,bulletTracerHistory.cursor=0,0
end
local function spawnBulletTracer(origin,direction)
if not alive or not S.BulletTracers or not overlay.Enabled then return end
if typeof(origin)~="Vector3" or typeof(direction)~="Vector3" then return end
local length=direction.Magnitude
if length~=length or length<.001 or length==math.huge then return end
if origin.Magnitude~=origin.Magnitude or origin.Magnitude==math.huge then return end
local distance=math.clamp(S.BulletTracerDistance,50,2000)
if not bulletTracerFolder or not bulletTracerFolder.Parent then
clearBulletTracers()
bulletTracerFolder=Instance.new("Folder")
bulletTracerFolder.Name="CVortexBetaBulletTracers"
bulletTracerFolder.Parent=Workspace
end
local params=bulletTracerHistory.params
if not params then
params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
params.IgnoreWater=true; bulletTracerHistory.params=params
end
local filter={bulletTracerFolder}
if LocalPlayer.Character then table.insert(filter,LocalPlayer.Character) end
if Workspace.CurrentCamera then table.insert(filter,Workspace.CurrentCamera) end
params.FilterDescendantsInstances=filter
local ray=direction.Unit*distance
local hit=Workspace:Raycast(origin,ray,params)
local destination=hit and hit.Position or origin+ray
bulletTracerHistory.cursor=bulletTracerHistory.cursor%24+1
local index=bulletTracerHistory.cursor
local item=bulletTracerHistory[index]
if not item then
local function endpoint()
local p=Instance.new("Part")
p.Size=Vector3.new(.02,.02,.02); p.Transparency=1; p.Anchored=true
p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.CastShadow=false
p.Parent=bulletTracerFolder
local a=Instance.new("Attachment"); a.Parent=p
return p,a
end
local start,a=endpoint()
local finish,b=endpoint()
local beam=Instance.new("Beam")
beam.Attachment0=a; beam.Attachment1=b; beam.FaceCamera=true
beam.Segments=1; beam.LightEmission=1; beam.LightInfluence=0
beam.Enabled=false; beam.Parent=bulletTracerFolder
item={start=start,finish=finish,beam=beam}
bulletTracerHistory[index]=item
bulletTracerHistory.count=math.max(bulletTracerHistory.count,index)
end
item.start.Position=origin; item.finish.Position=destination
item.beam.Color=ColorSequence.new(S.BulletTracerColor)
item.beam.Width0=math.clamp(S.BulletTracerWidth,.02,.6)
item.beam.Width1=item.beam.Width0*.5
item.beam.Transparency=NumberSequence.new(.08)
item.beam.Enabled=true
item.expires=os.clock()+math.clamp(S.BulletTracerLifetime,.08,2)
bulletTracerHistory.shots=bulletTracerHistory.shots+1
bulletTracerHistory.message="Shots shown: "..bulletTracerHistory.shots
end
local bulletTracerUpdateClock = 0
connect(RunService.Heartbeat,function(dt)
if not alive then return end
bulletTracerUpdateClock = bulletTracerUpdateClock + dt
if bulletTracerUpdateClock < (S.LowCPUMode and .09 or .055) then return end
bulletTracerUpdateClock = 0
local now=os.clock()
for i=1,bulletTracerHistory.count do
local item=bulletTracerHistory[i]
if item.beam.Enabled and (not S.BulletTracers or not overlay.Enabled or now>=item.expires) then item.beam.Enabled=false end
end
if bulletTracerHistory.label and bulletTracerHistory.label.Parent then
local message=not S.BulletTracers and "Off" or bulletTracerHistory.message
if bulletTracerHistory.label.Text~=message then bulletTracerHistory.label.Text=message end
end
end)

local skeletonR15 = {
{"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
{"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
{"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
{"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
}
local skeletonR6 = {
{"Head","Torso"}, {"Torso","Left Arm"}, {"Torso","Right Arm"},
{"Torso","Left Leg"}, {"Torso","Right Leg"},
}
local weaponDisplayNames = {
rifle="5.56 Carbine",
ak47="AK-47",
pistol="9mm Pistol",
shotgun="Pump Shotgun",
revolver=".357 Revolver",
double_barrel="Double Barrel",
sledgehammer="Sledgehammer",
hand_cannon="Hand Cannon",
sniper="Bolt-Action Sniper",
}
local weaponKeys = {"EquippedWeapon","CurrentWeapon","WeaponName","HeldWeapon",
"EquippedTool","CurrentGun","GunName","EquippedGun","ActiveWeapon",
"SelectedWeapon","Weapon","EquippedItem","HeldItem","ItemName"}
local weaponPatterns = {"glock","pistol","rifle","sniper","shotgun","revolver",
"deagle","gun","smg","uzi","mp5","mp7","ak47","ak74","akm","m4",
"m16","m1911","scar","famas","p90","aug","awp","magnum",
"beretta","colt","remington","kar98","vector","lmg","minigun",
"rpg","launcher","crossbow","musket","knife","sword","katana",
"machete","bow","blaster","tommy","machinegun","pistol",
"weaponmodel","gunmodel","heldweapon","firearm"}
local weaponEquippedFolders = {"Equipped","EquippedWeapon","Weapons",
"Weapon","HeldItems","EquippedItems","EquippedItems",
"HeldWeapon","WeaponModel","GunModel","CurrentGun"}
local function weaponCleanName(value)
if typeof(value) == "Instance" then value = value.Name end
if type(value) ~= "string" then return nil end
local name = value:gsub("[%c]"," "):gsub("^%s+",""):gsub("%s+$",""):sub(1,55)
if name == "" or name == "nil" or name == "None" then return nil end
return name
end
local function weaponNameMatches(value)
local low = tostring(value or ""):lower():gsub("[%s_%-%.]", "")
if low == "handle" or low == "body" or low == "heldgun" then return false end
for _, phrase in ipairs(weaponPatterns) do
if low:find(phrase,1,true) then return true end
end
return false
end
local function weaponFromMetadata(holder)
if not holder then return nil end
for _, key in ipairs(weaponKeys) do
local name = weaponCleanName(holder:GetAttribute(key))
if name then return name end
local object = holder:FindFirstChild(key)
if object then
if object:IsA("StringValue") then
name = weaponCleanName(object.Value)
elseif object:IsA("ObjectValue") and object.Value then
name = weaponCleanName(object.Value)
end
if name then return name end
end
end
return nil
end
local function equippedWeaponNameFor(player, character)
if not character then return nil end
-- Flick replicates the actual equipped weapon as Character's Gun attribute.
-- HeldGun is a common cosmetic model and is not the weapon identity.
local gunCode = weaponCleanName(character:GetAttribute("Gun"))
if gunCode then
local key = gunCode:lower():gsub("[%s%-]+","_")
if key == "none" or key == "nil" or key == "unarmed" then return nil end
return weaponDisplayNames[key] or gunCode:gsub("_"," ")
end
if character:FindFirstChild("HeldGun") then return nil end
local tool = character:FindFirstChildOfClass("Tool")
if tool and tool.Parent == character then
local label = weaponCleanName(tool.Name)
if label then return label end
end
-- Games with a custom inventory sometimes replicate the equipped item
-- as an attribute or StringValue instead of a Tool.
local metadata = weaponFromMetadata(character) or weaponFromMetadata(player)
if metadata then return metadata end
local children = character:GetChildren()
for _, item in ipairs(children) do
if item:IsA("Model") and weaponNameMatches(item.Name)
and item:FindFirstChildWhichIsA("BasePart", true) then
return weaponCleanName(item.Name)
end
if item:IsA("BasePart") and weaponNameMatches(item.Name) then
return weaponCleanName(item.Name)
end
if item:IsA("Folder") or item:IsA("Model") then
for _, folderName in ipairs(weaponEquippedFolders) do
if item.Name == folderName then
local folderValue = weaponFromMetadata(item)
if folderValue then return folderValue end
for _, child in ipairs(item:GetChildren()) do
if child:IsA("Tool") or child:IsA("Model") then
local label = weaponCleanName(child.Name)
if label then return label end
end
end
break
end
end
end
end
-- A gun may be welded under RightHand / Right Arm rather than parented
-- directly to Character. This scan is cached by the renderer.
local descendants = character:GetDescendants()
for i, item in ipairs(descendants) do
if i > 260 then break end
if item:IsA("Tool") then
local label = weaponCleanName(item.Name)
if label then return label end
end
if item:IsA("Model") and weaponNameMatches(item.Name)
and item:FindFirstChildWhichIsA("BasePart", true)
and not item:FindFirstAncestorOfClass("Accessory") then
local label = weaponCleanName(item.Name)
if label then return label end
end
if item:IsA("BasePart") and weaponNameMatches(item.Name)
and not item:FindFirstAncestorOfClass("Accessory")
and item.Name ~= "Handle" then
local label = weaponCleanName(item.Name)
if label then return label end
end
end
return nil
end
local function createScreenMarks(player)
local line = Instance.new("Frame")
line.Name = "CVortexTracer"
line.AnchorPoint = Vector2.new(.5,.5)
line.BorderSizePixel = 0
line.BackgroundTransparency = .2
line.Visible = false
line.Parent = overlay
local box = Instance.new("Frame")
box.Name = "CVortexPlayerBox"
box.BackgroundColor3 = Color3.fromRGB(255, 75, 80)
box.BackgroundTransparency = 1
box.BorderSizePixel = 0
box.Visible = false
box.Parent = overlay
local borders = {}
for _, edge in ipairs({
{UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 1)},
{UDim2.new(0, 0, 1, -1), UDim2.new(1, 0, 0, 1)},
{UDim2.fromOffset(0, 0), UDim2.new(0, 1, 1, 0)},
{UDim2.new(1, -1, 0, 0), UDim2.new(0, 1, 1, 0)},
}) do
local border = Instance.new("Frame")
border.Name = "SquareBorder"
border.Position = edge[1]
border.Size = edge[2]
border.BorderSizePixel = 0
border.Parent = box
table.insert(borders, border)
end
local function makeText(name)
local label = Instance.new("TextLabel")
label.Name = name
label.BackgroundTransparency = 1
label.BorderSizePixel = 0
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = .35
label.Font = Enum.Font.GothamBold
label.TextSize = 11
label.TextTruncate = Enum.TextTruncate.AtEnd
label.Visible = false
label.Parent = overlay
return label
end
local hpBar = Instance.new("Frame")
hpBar.Name = "CVortexBoxHealthBar"
hpBar.BackgroundColor3 = Color3.fromRGB(23, 25, 28)
hpBar.BackgroundTransparency = .25
hpBar.BorderSizePixel = 0
hpBar.Visible = false
hpBar.Parent = overlay
local hpBarFill = Instance.new("Frame")
hpBarFill.Name = "CVortexBoxHealthBarFill"
hpBarFill.AnchorPoint = Vector2.new(0, 1)
hpBarFill.Position = UDim2.new(0, 0, 1, 0)
hpBarFill.Size = UDim2.fromScale(1, 1)
hpBarFill.BackgroundColor3 = Color3.fromRGB(86, 222, 122)
hpBarFill.BorderSizePixel = 0
hpBarFill.Parent = hpBar
local hpBarOutline = Instance.new("UIStroke")
hpBarOutline.Name = "CVortexBoxHealthBarOutline"
hpBarOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
hpBarOutline.Color = Color3.fromRGB(14, 15, 17)
hpBarOutline.Thickness = 0.5
hpBarOutline.Transparency = 0.08
hpBarOutline.Parent = hpBar
local marks = {line=line, box=box, borders=borders,
name=makeText("CVortexBoxName"), distance=makeText("CVortexBoxDistance"),
health=makeText("CVortexBoxHealth"), weapon=makeText("CVortexBoxWeapon"),
healthBar=hpBar, healthBarFill=hpBarFill}
playerScreenMarks[player] = marks
return marks
end
do
local wasActive=false
local function visible(object,value)
if object.Visible~=value then object.Visible=value end
end
local function hide(m)
visible(m.line,false); visible(m.box,false); visible(m.name,false)
visible(m.distance,false); visible(m.health,false); visible(m.healthBar,false); visible(m.weapon,false)
if m.skeletonLines then
for _, segment in ipairs(m.skeletonLines) do
if segment.Visible then segment.Visible = false end
end
end
end
local function text(label,value)
if label.Text~=value then label.Text=value end
end
local function hideSkeleton(m)
if m.skeletonLines then
for _, segment in ipairs(m.skeletonLines) do
if segment.Visible then segment.Visible = false end
end
end
end
local function drawSkeleton(m, character, camera, viewport, now)
if not S.SkeletonESP or not S.ESP or not character then
hideSkeleton(m)
return
end
if m.skeletonCharacter ~= character or now >= (m.nextSkeletonRefresh or 0) then
local human = m.humanoid
local rig = human and human.RigType == Enum.HumanoidRigType.R15
and skeletonR15 or skeletonR6
local parts = {}
for _, pair in ipairs(rig) do
for _, partName in ipairs(pair) do
if not parts[partName] then
local part = character:FindFirstChild(partName)
if part and part:IsA("BasePart") then parts[partName] = part end
end
end
end
m.skeletonRig = rig
m.skeletonParts = parts
m.skeletonCharacter = character
m.nextSkeletonRefresh = now + .6
end
local cached = {}
local width = math.clamp(tonumber(S.SkeletonThickness) or 2, 1, 5)
local maxLength = math.max(viewport.X, viewport.Y) * .8
m.skeletonLines = m.skeletonLines or {}
for i, pair in ipairs(m.skeletonRig or {}) do
local from = m.skeletonParts[pair[1]]
local to = m.skeletonParts[pair[2]]
local a, b
if from and to and from.Parent and to.Parent then
if not cached[from] then
local position, inView = camera:WorldToViewportPoint(from.Position)
cached[from] = inView and position.Z > .1 and Vector2.new(position.X, position.Y) or false
end
if not cached[to] then
local position, inView = camera:WorldToViewportPoint(to.Position)
cached[to] = inView and position.Z > .1 and Vector2.new(position.X, position.Y) or false
end
a, b = cached[from], cached[to]
end
local segment = m.skeletonLines[i]
local displacement = a and b and (b - a)
local len = displacement and displacement.Magnitude or 0
if len >= 1 and len < maxLength then
if not segment then
segment = Instance.new("Frame")
segment.Name = "CVortex_SkeletonBone"
segment.AnchorPoint = Vector2.new(.5,.5)
segment.BackgroundTransparency = 0
segment.BorderSizePixel = 0
segment.ZIndex = 3
segment.Parent = overlay
m.skeletonLines[i] = segment
end
segment.Position = UDim2.fromOffset((a.X + b.X) * .5, (a.Y + b.Y) * .5)
segment.Size = UDim2.fromOffset(len, width)
segment.Rotation = math.deg(math.atan2(displacement.Y, displacement.X))
if segment.BackgroundColor3 ~= S.SkeletonColor then
segment.BackgroundColor3 = S.SkeletonColor
end
if not segment.Visible then segment.Visible = true end
elseif segment and segment.Visible then
segment.Visible = false
end
end
for i = #(m.skeletonRig or {}) + 1, #m.skeletonLines do
if m.skeletonLines[i].Visible then m.skeletonLines[i].Visible = false end
end
end
local boxRenderElapsed = 0
connect(RunService.RenderStepped,function(dt)
if not alive then return end
local active=overlay.Enabled and ((S.ESP and (S.Tracers or S.BoxESP or S.SkeletonESP)) or S.WeaponESP)
if not active then
if wasActive then for _,m in pairs(playerScreenMarks) do hide(m) end end
wasActive=false
return
end
wasActive=true
boxRenderElapsed = boxRenderElapsed + dt
local interval = S.LowCPUMode
and (UserInputService.TouchEnabled and 1/30 or 1/45)
or 1/60
if boxRenderElapsed < interval then return end
boxRenderElapsed = math.min(boxRenderElapsed - interval, interval)
local camera=Workspace.CurrentCamera
local mine=LocalPlayer.Character
local origin=mine and mine:FindFirstChild("HumanoidRootPart")
if not camera or not origin then
for _,m in pairs(playerScreenMarks) do hide(m) end
return
end
local viewport=camera.ViewportSize
local now=os.clock()
for player,highlight in pairs(highlights) do
if player~=LocalPlayer then
local m=playerScreenMarks[player] or createScreenMarks(player)
local character=player.Character
if m.character~=character or now>=(m.nextRigCheck or 0) then
m.character=character
m.root=character and character:FindFirstChild("HumanoidRootPart")
m.humanoid=character and character:FindFirstChildOfClass("Humanoid")
m.head=character and character:FindFirstChild("Head")
m.leftFoot=character and (character:FindFirstChild("LeftFoot") or character:FindFirstChild("Left Leg"))
m.rightFoot=character and (character:FindFirstChild("RightFoot") or character:FindFirstChild("Right Leg"))
m.tool=character and character:FindFirstChildOfClass("Tool")
if m.weaponCharacter~=character then
m.weaponCharacter=character
m.weaponName=nil
m.nextWeaponScan=0
end
m.nextRigCheck=now+.25
end
local root,h=m.root,m.humanoid
local valid=root and root.Parent and h and h.Parent and h.Health>0
local distance=valid and (root.Position-origin.Position).Magnitude or math.huge
if not valid or distance>S.PlayerRange then hide(m)
else
local center,onScreen=camera:WorldToViewportPoint(root.Position)
local showLine=S.ESP and S.Tracers and onScreen and center.Z>.05
if showLine then
local start=Vector2.new(viewport.X*.5,S.TracerOrigin=="Top" and 2 or viewport.Y-2)
local finish=Vector2.new(center.X,center.Y)
local delta=finish-start
m.line.Size=UDim2.fromOffset(delta.Magnitude,1)
m.line.Position=UDim2.fromOffset((start.X+finish.X)*.5,(start.Y+finish.Y)*.5)
m.line.Rotation=math.deg(math.atan2(delta.Y,delta.X))
m.line.BackgroundColor3=S.TracerWallCheck
and (highlight:GetAttribute("WallVisible")==false and S.HiddenColor or S.VisibleColor) or S.Outline
end
visible(m.line,showLine)
drawSkeleton(m, character, camera, viewport, now)
local showBox=false
if S.ESP and S.BoxESP and center.Z>.05 then
local top=m.head and m.head.Parent and m.head or root
local topY=top.Position.Y+top.Size.Y*.5+.1
local bottomY=root.Position.Y-h.HipHeight-root.Size.Y*.5
if m.leftFoot and m.leftFoot.Parent then bottomY=math.min(bottomY,m.leftFoot.Position.Y-m.leftFoot.Size.Y*.5) end
if m.rightFoot and m.rightFoot.Parent then bottomY=math.min(bottomY,m.rightFoot.Position.Y-m.rightFoot.Size.Y*.5) end
-- Camera-facing bounds remain stable even when looking down at a distant player.
local worldHeight=math.max(2,topY-bottomY+.1)
local midpoint=Vector3.new(root.Position.X,(topY+bottomY)*.5,root.Position.Z)
local halfUp=camera.CFrame.UpVector*(worldHeight*.5)
local a=camera:WorldToViewportPoint(midpoint+halfUp)
local b=camera:WorldToViewportPoint(midpoint-halfUp)
if a.Z>.05 and b.Z>.05 then
local height=math.max(6,math.abs(b.Y-a.Y))
local width=math.max(3,height*.47)
local x=(a.X+b.X)*.5-width*.5
local y=(a.Y+b.Y)*.5-height*.5
showBox=x+width>=0 and x<=viewport.X and y+height>=0 and y<=viewport.Y
if showBox then
m.box.Position=UDim2.fromOffset(x,y)
m.box.Size=UDim2.fromOffset(width,height)
m.name.Position=UDim2.fromOffset(x-20,y-18)
m.name.Size=UDim2.fromOffset(width+40,16)
m.distance.Position=UDim2.fromOffset(x-20,y+height+2)
m.distance.Size=UDim2.fromOffset(width+40,15)
m.health.Position=UDim2.fromOffset(x-54,y+(height-43)*.5)
m.health.Size=UDim2.fromOffset(40,43)
if not m.healthStyled then
m.healthStyled=true
m.health.TextXAlignment=Enum.TextXAlignment.Right
m.health.TextYAlignment=Enum.TextYAlignment.Center
m.health.TextTruncate=Enum.TextTruncate.None
m.health.TextSize=11
end
local barHeight=math.max(4,height-2)
m.healthBar.Position=UDim2.fromOffset(x-3,y+(height-barHeight)*.5)
m.healthBar.Size=UDim2.fromOffset(2,barHeight)
m.weapon.Position=UDim2.fromOffset(x-25,y+height+(S.PlayerDistance and 16 or 2))
m.weapon.Size=UDim2.fromOffset(width+50,14)
if now>=(m.nextTextUpdate or 0) then
m.nextTextUpdate=now+.1
m.box.BackgroundColor3=S.BoxFillColor
m.box.BackgroundTransparency=S.FillBox and .82 or 1
for _,border in ipairs(m.borders) do border.BackgroundColor3=highlight.OutlineColor end
text(m.name,player.DisplayName)
text(m.distance,string.format("%d studs",math.floor(distance+.5)))
text(m.health,string.format("HP\n%d/\n%d",math.ceil(math.max(0,h.Health)),math.ceil(math.max(1,h.MaxHealth))))
local ratio=math.clamp(h.Health/math.max(1,h.MaxHealth),0,1)
m.healthBarFill.Size=UDim2.fromScale(1,ratio)
m.healthBarFill.BackgroundColor3=Color3.fromRGB(234,75,81):Lerp(Color3.fromRGB(78,222,119),ratio)
end
end
end
end
visible(m.box,showBox); visible(m.name,showBox)
visible(m.distance,showBox and S.PlayerDistance)
visible(m.health,showBox and S.PlayerHealth)
visible(m.healthBar,showBox and S.PlayerHealthBar)
local weaponVisible=false
if S.WeaponESP and center.Z>.05 then
if now >= (m.nextWeaponScan or 0) then
m.nextWeaponScan=now+(S.LowCPUMode and .48 or .25)
m.weaponName=equippedWeaponNameFor(player, character)
end
if m.weaponName and m.weaponName~="" then
if showBox then
local boxPosition=m.box.Position
local boxSize=m.box.Size
local labelWidth=math.max(180,boxSize.X.Offset+50)
m.weapon.Position=UDim2.fromOffset(
boxPosition.X.Offset+boxSize.X.Offset*.5-labelWidth*.5,
boxPosition.Y.Offset+boxSize.Y.Offset+(S.PlayerDistance and 19 or 4))
m.weapon.Size=UDim2.fromOffset(labelWidth,17)
weaponVisible=true
else
local head=m.head
local aimPosition=head and head.Parent and
(head.Position+Vector3.new(0,head.Size.Y*.6+.7,0))
or (root.Position+Vector3.new(0,3,0))
local point,inView=camera:WorldToViewportPoint(aimPosition)
if inView and point.Z>.05 then
m.weapon.Position=UDim2.fromOffset(point.X-100,point.Y-19)
m.weapon.Size=UDim2.fromOffset(200,17)
weaponVisible=true
end
end
if weaponVisible then
text(m.weapon,"Weapon: "..m.weaponName)
if m.weapon.TextColor3~=S.WeaponESPColor then
m.weapon.TextColor3=S.WeaponESPColor
end
end
end
end
visible(m.weapon,weaponVisible)
end
end
end
end)
end

local animatedGradients = {}
local gradientPhase, gradientElapsed = 0, 0
connect(overlay.DescendantAdded, function(item)
if not item:IsA("UIGradient") or item.Name == "CVStaticGradient" then return end
task.defer(function()
if alive and item:IsDescendantOf(overlay) then
animatedGradients[item] = {rotation = item.Rotation, offset = item.Offset}
end
end)
end)
connect(RunService.RenderStepped, function(dt)
if not alive or not overlay.Enabled then return end
gradientPhase = (gradientPhase + dt * .7) % (math.pi * 2)
gradientElapsed = gradientElapsed + dt
local gradientInterval = S.LowCPUMode and 1 / 18 or 1 / 30
if gradientElapsed < gradientInterval then return end
gradientElapsed = gradientElapsed % gradientInterval
local wave = math.sin(gradientPhase)
local tilt = math.sin(gradientPhase + math.pi / 2) * 12
for gradient, base in pairs(animatedGradients) do
if not gradient.Parent then
animatedGradients[gradient] = nil
else
local parent, visible = gradient.Parent, true
while parent and parent ~= overlay do
if parent:IsA("GuiObject") and not parent.Visible then
visible = false
break
end
parent = parent.Parent
end
if visible then
local angle = math.rad(base.rotation)
gradient.Offset = base.offset + Vector2.new(math.cos(angle), math.sin(angle)) * (wave * .24)
gradient.Rotation = base.rotation + tilt
end
end
end
end)
counterPanel = Instance.new("Frame")
counterPanel.Name = "CVortexCounterPanel"
counterPanel.Parent = overlay
counterPanel.AnchorPoint = Vector2.new(1, 0)
counterPanel.Position = UDim2.new(1, -14, 0, 15)
counterPanel.Size = UDim2.fromOffset(218, 30)
counterPanel.BackgroundColor3 = Color3.new(1, 1, 1)
counterPanel.BorderSizePixel = 0
counterPanel.Active = true
counterPanel.Visible = S.PlayerCounter
local counterGradient = Instance.new("UIGradient")
counterGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(.45, Color3.fromRGB(48, 13, 23)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 36, 54)),
})
counterGradient.Parent = counterPanel
playerCounterLabel = Instance.new("TextLabel")
playerCounterLabel.Name = "CVortexCounter"
playerCounterLabel.Parent = counterPanel
playerCounterLabel.AnchorPoint = Vector2.new(0, 0)
playerCounterLabel.Position = UDim2.fromOffset(0, 0)
playerCounterLabel.Size = UDim2.fromOffset(218, 30)
playerCounterLabel.Font = Enum.Font.BuilderSansMedium
playerCounterLabel.TextColor3 = Color3.fromRGB(240, 242, 250)
playerCounterLabel.TextSize = 12
playerCounterLabel.Text = "PLAYERS 0   MONSTERS 0"
playerCounterLabel.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
playerCounterLabel.BackgroundTransparency = 1
playerCounterLabel.BorderSizePixel = 0
playerCounterLabel.Active = true
playerCounterLabel.Visible = S.PlayerCounter
local counterCorner = Instance.new("UICorner")
counterCorner.CornerRadius = UDim.new(0, 5)
counterCorner.Parent = counterPanel
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
fovOutline.Color = Color3.fromRGB(225, 67, 81)
fovOutline.Thickness = 1.5
fovOutline.Transparency = 0.2
fovOutline.Parent = fovCircle
local silentFovCircle = Instance.new("Frame")
silentFovCircle.Name = "SilentFOVCircle"
silentFovCircle.Parent = overlay
silentFovCircle.AnchorPoint = Vector2.new(.5, .5)
silentFovCircle.Position = UDim2.fromScale(.5, .5)
silentFovCircle.BackgroundTransparency = 1
silentFovCircle.Size = UDim2.fromOffset(S.SilentFOV * 2, S.SilentFOV * 2)
silentFovCircle.Visible = false
local silentFovCorner = Instance.new("UICorner")
silentFovCorner.CornerRadius = UDim.new(1, 0)
silentFovCorner.Parent = silentFovCircle
local silentFovOutline = Instance.new("UIStroke")
silentFovOutline.Color = Color3.fromRGB(84, 163, 255)
silentFovOutline.Thickness = 1.7
silentFovOutline.Transparency = .12
silentFovOutline.Parent = silentFovCircle
local function updateOverlay()
fovCircle.Visible = alive and S.AimEnabled and S.ShowFOV
fovCircle.Size = UDim2.fromOffset(S.FOV * 2, S.FOV * 2)
silentFovCircle.Visible = alive and S.SilentAimEnabled and S.ShowSilentFOV
silentFovCircle.Size = UDim2.fromOffset(S.SilentFOV * 2, S.SilentFOV * 2)
end
local function stopAim()
activation = nil
currentTarget = nil
updateOverlay()
end
local function startAim(mode)
updateOverlay()
if not alive or not S.AimEnabled then return end
if UserInputService.MouseEnabled and mode ~= "rmb" then return end
activation = mode
currentTarget = nil
aimStartTime = os.clock()
updateOverlay()
end
connect(UserInputService.InputBegan, function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
if not alive or not overlay.Enabled or S.Freecam
or UserInputService:GetFocusedTextBox() then return end
if mainWindow and mainWindow:IsOpen() then return end
startAim("rmb")
end)
connect(UserInputService.InputEnded, function(input)
if input.UserInputType == Enum.UserInputType.MouseButton2
and activation == "rmb" then stopAim() end
end)
connect(UserInputService.WindowFocusReleased, function()
if activation == "rmb" then stopAim() end
end)
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true
local function targetPartFor(player, requestedPart)
if not player or player == LocalPlayer or not player.Parent then return nil end
if S.AimIgnoredPlayers[tostring(player.UserId)] then return nil end
if S.TeamCheck then
local ownTeam, theirTeam = LocalPlayer.Team, player.Team
if not LocalPlayer.Neutral and not player.Neutral then
if ownTeam and theirTeam then
if ownTeam == theirTeam then return nil end
elseif not ownTeam and not theirTeam
and LocalPlayer.TeamColor == player.TeamColor then
return nil
end
end
if not (ownTeam and theirTeam) then
for _, attribute in ipairs({"TeamId", "Team", "Faction", "Squad"}) do
local ownValue = LocalPlayer:GetAttribute(attribute)
if ((type(ownValue) == "string" and ownValue ~= "")
or type(ownValue) == "number")
and ownValue == player:GetAttribute(attribute) then
return nil
end
end
end
end
local character = player.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health <= 0 then return nil end
if (requestedPart or S.AimPart) == "Body" then
return character:FindFirstChild("UpperTorso")
or character:FindFirstChild("Torso")
or character:FindFirstChild("HumanoidRootPart")
end
return character:FindFirstChild("Head")
or character:FindFirstChild("HumanoidRootPart")
end
local function hasLineOfSight(camera, player, part, wallCheck)
if wallCheck == false or (wallCheck == nil and not S.WallCheck) then return true end
local localCharacter = LocalPlayer.Character
rayParams.FilterDescendantsInstances = localCharacter and {localCharacter} or {}
local origin = camera.CFrame.Position
local direction = part.Position - origin
if direction.Magnitude <= 0.05 then return true end
local hit = Workspace:Raycast(origin, direction, rayParams)
return hit == nil or (player.Character ~= nil
and hit.Instance:IsDescendantOf(player.Character))
end
local function targetScreenDistance(camera, player, extraRadius, radius)
local part = targetPartFor(player)
if not part then return nil end
local screen, onScreen = camera:WorldToViewportPoint(part.Position)
if not onScreen or screen.Z <= 0 then return nil end
local center = camera.ViewportSize * 0.5
local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
if dist > (radius or S.FOV) + (extraRadius or 0) then return nil end
if not hasLineOfSight(camera, player, part) then return nil end
return part, dist
end
local function findClosestTarget(camera, radius)
local bestPlayer = nil
local bestDistance = math.huge
for _, other in ipairs(Players:GetPlayers()) do
if other ~= LocalPlayer then
local part, distance = targetScreenDistance(camera, other, 0, radius)
if part and distance < bestDistance then
bestPlayer = other
bestDistance = distance
end
end
end
return bestPlayer
end

local function setupRageVisuals()
    local Debris = game:GetService("Debris")
    local function make(class, parent, props)
        local obj = Instance.new(class)
        for property, value in pairs(props or {}) do obj[property] = value end
        obj.Parent = parent
        return obj
    end
    local function round(obj, radius)
        make("UICorner", obj, {CornerRadius = UDim.new(0, radius)})
    end
    local dark = Color3.fromRGB(25, 27, 34)
    local soft = Color3.fromRGB(181, 190, 204)
    local hud = make("Frame", overlay, {
        Name = "CVortexTargetHUD", Size = UDim2.fromOffset(249, 93),
        Position = UDim2.new(1, -268, .62, -48),
        BackgroundColor3 = dark, BorderSizePixel = 0,
        Visible = false, Active = true, ZIndex = 90
    })
    round(hud, 11)
    local mobileHUD = UserInputService.TouchEnabled
    local hudBaseScale = mobileHUD and .72 or 1
    local hudScale = make("UIScale", hud, {Scale = hudBaseScale})
    if mobileHUD then
        hud.Position = UDim2.new(1, -194, .62, -37)
    end
    make("UIStroke", hud, {Color = Color3.fromRGB(103, 113, 131),
        Thickness = 1, Transparency = .35})
    local avatar = make("ImageLabel", hud, {
        Name = "Avatar", Position = UDim2.fromOffset(11, 11),
        Size = UDim2.fromOffset(69, 69), BackgroundColor3 = Color3.fromRGB(43, 47, 58),
        BorderSizePixel = 0, Image = "", ZIndex = 91
    })
    round(avatar, 9)
    local name = make("TextLabel", hud, {
        Name = "TargetName", Position = UDim2.fromOffset(91, 11),
        Size = UDim2.fromOffset(145, 23), BackgroundTransparency = 1,
        Text = "TARGET", Font = Enum.Font.GothamBold, TextSize = 15,
        TextColor3 = Color3.fromRGB(247, 248, 251),
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 91
    })
    local healthText = make("TextLabel", hud, {
        Name = "HP", Position = UDim2.fromOffset(91, 36),
        Size = UDim2.fromOffset(142, 17), BackgroundTransparency = 1,
        Text = "HP 0/100", Font = Enum.Font.GothamMedium,
        TextColor3 = soft, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 91
    })
    local healthBack = make("Frame", hud, {
        Position = UDim2.fromOffset(91, 61), Size = UDim2.fromOffset(143, 9),
        BackgroundColor3 = Color3.fromRGB(51, 54, 65),
        BorderSizePixel = 0, ZIndex = 91
    })
    round(healthBack, 5)
    local healthFill = make("Frame", healthBack, {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(79, 221, 133),
        BorderSizePixel = 0, ZIndex = 92
    })
    round(healthFill, 5)
    local drag = make("TextButton", hud, {
        Name = "DragTargetHUD", Position = UDim2.fromOffset(89, 0),
        Size = UDim2.fromOffset(150, 35),
        BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, Active = true, ZIndex = 94
    })
    local heldInput, startPointer, startPosition
    connect(drag.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        heldInput, startPointer, startPosition = input, input.Position, hud.AbsolutePosition
    end)
    connect(UserInputService.InputChanged, function(input)
        if not heldInput then return end
        if heldInput.UserInputType == Enum.UserInputType.Touch then
            if input ~= heldInput then return end
        elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local delta = input.Position - startPointer
        local viewport = cam.ViewportSize
        local size = hud.AbsoluteSize
        hud.Position = UDim2.fromOffset(
            math.clamp(startPosition.X + delta.X, 4,
                math.max(4, viewport.X - size.X - 4)),
            math.clamp(startPosition.Y + delta.Y, 4,
                math.max(4, viewport.Y - size.Y - 4)))
    end)
    connect(UserInputService.InputEnded, function(input)
        if heldInput and (input == heldInput or
            (heldInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1)) then
            heldInput = nil
        end
    end)
    local marker = make("Frame", overlay, {
        Name = "CVortexHitmarker", AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(42, 42),
        BackgroundTransparency = 1, Visible = false, ZIndex = 97
    })
    local strokes = {}
    for index = 1, 4 do
        local segment = make("Frame", marker, {
            Name = "HitSegment" .. index,
            AnchorPoint = Vector2.new(.5, .5),
            Position = UDim2.fromOffset(
                index <= 2 and (index == 1 and 12 or 30)
                    or (index == 3 and 12 or 30),
                index <= 2 and (index == 1 and 12 or 30)
                    or (index == 3 and 30 or 12)),
            Size = UDim2.fromOffset(13, 2),
            Rotation = index <= 2 and 45 or -45,
            BackgroundColor3 = Color3.fromRGB(255, 251, 246),
            BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 98
        })
        strokes[#strokes + 1] = segment
    end
    local markerExpires = 0
    local function hitFlash()
        if not S.HitmarkerEnabled or not overlay.Enabled then return end
        markerExpires = os.clock() + .25
        marker.Visible = true
        for _, line in ipairs(strokes) do line.BackgroundTransparency = 0 end
    end
    local currentPlayer = nil
    local thumbnailCache = {}
    local watched = {}
    local shotPlayer, shotTime = nil, 0
    local lastConfirmedHit = {}
    local function floorAt(location)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        local hit = Workspace:Raycast(location + Vector3.new(0, 3, 0),
            Vector3.new(0, -18, 0), params)
        return hit and hit.Position or location - Vector3.new(0, 2, 0)
    end
    local function spawnCross(location)
        if not S.KillCrossEnabled or not alive or not location then return end
        local site = floorAt(location)
        local container = make("Model", Workspace, {Name = "CVortexKillCross"})
        local loaded = false
        local ok, objects = pcall(function()
            return game:GetObjects("rbxassetid://133744946946327")
        end)
        if ok and type(objects) == "table" and objects[1] then
            local artifact = objects[1]
            if artifact:IsA("Model") or artifact:IsA("BasePart") then
                local partCount = artifact:IsA("BasePart") and 1 or 0
                if artifact:IsA("Model") then
                    for _, node in ipairs(artifact:GetDescendants()) do
                        if node:IsA("BasePart") then partCount = partCount + 1 end
                    end
                end
                if partCount > 0 and partCount < 120 then
                    if artifact:IsA("BasePart") then
                        artifact.Parent = container
                    else
                        for _, descendant in ipairs(artifact:GetDescendants()) do
                            if descendant:IsA("LuaSourceContainer") then
                                descendant:Destroy()
                            elseif descendant:IsA("BasePart") then
                                descendant.Anchored = true
                                descendant.CanCollide = false
                                descendant.CanTouch = false
                                descendant.CanQuery = false
                            end
                        end
                        artifact.Parent = container
                    end
                    loaded = pcall(function()
                        local extents = container:GetExtentsSize()
                        local maximum = math.max(extents.X, extents.Y, extents.Z)
                        if maximum > 0 then container:ScaleTo(3.4 / maximum) end
                        container:PivotTo(CFrame.new(site + Vector3.new(0, 1.75, 0)))
                    end)
                end
            end
        end
        if not loaded then
            for _, child in ipairs(container:GetChildren()) do child:Destroy() end
            local function stone(partName, size, offset)
                local part = make("Part", container, {
                    Name = partName, Size = size, Anchored = true,
                    CanCollide = false, CanTouch = false, CanQuery = false,
                    Material = Enum.Material.Slate,
                    Color = Color3.fromRGB(128, 132, 146),
                    CFrame = CFrame.new(site + offset)
                })
                return part
            end
            stone("StoneBase", Vector3.new(1.4, .33, .9), Vector3.new(0, .18, 0))
            stone("CrossStem", Vector3.new(.43, 3, .43), Vector3.new(0, 1.7, 0))
            stone("CrossArms", Vector3.new(1.8, .42, .48), Vector3.new(0, 2.48, 0))
        end
        Debris:AddItem(container, 10)
    end
    local function watchCharacter(player, character)
        local old = watched[player]
        if old and old.connection then old.connection:Disconnect() end
        watched[player] = nil
        task.spawn(function()
            local human = character:FindFirstChildOfClass("Humanoid")
                or character:WaitForChild("Humanoid", 7)
            if not alive or not human or character ~= player.Character then return end
            local item = {humanoid = human, character = character,
                health = human.Health, deathAwarded = false}
            watched[player] = item
            item.connection = connect(human.HealthChanged, function(newHP)
                local previous = item.health
                item.health = newHP
                if not alive or not overlay.Enabled or newHP >= previous then return end
                local now = os.clock()
                local recentShot = player == shotPlayer and now - shotTime <= 1.7
                if recentShot and S.HitmarkerEnabled then hitFlash() end
                if recentShot then lastConfirmedHit[player] = now end
                if newHP <= 0 and previous > 0 and not item.deathAwarded
                    and S.KillCrossEnabled and
                    (recentShot or now - (lastConfirmedHit[player] or 0) <= 2) then
                    item.deathAwarded = true
                    local root = character:FindFirstChild("HumanoidRootPart")
                        or character:FindFirstChild("Head")
                    if root then spawnCross(root.Position) end
                end
            end)
        end)
    end
    local function watchPlayer(player)
        if player == LocalPlayer then return end
        connect(player.CharacterAdded, function(character)
            watchCharacter(player, character)
        end)
        if player.Character then watchCharacter(player, player.Character) end
    end
    for _, other in ipairs(Players:GetPlayers()) do watchPlayer(other) end
    connect(Players.PlayerAdded, watchPlayer)
    connect(Players.PlayerRemoving, function(player)
        local item = watched[player]
        if item and item.connection then item.connection:Disconnect() end
        watched[player], lastConfirmedHit[player] = nil, nil
        if currentPlayer == player then currentPlayer = nil; hud.Visible = false end
    end)
    local function chooseTarget(camera)
        return findClosestTarget(camera, S.SilentAimEnabled and
            math.max(S.FOV, S.SilentFOV) or S.FOV)
    end
    rageFX.onShot = function(origin, direction)
        local camera = Workspace.CurrentCamera
        if not camera or not overlay.Enabled then return end
        local picked = nil
        if typeof(origin) == "Vector3" and typeof(direction) == "Vector3"
            and direction.Magnitude > .01 then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = LocalPlayer.Character
                and {LocalPlayer.Character} or {}
            local ray = Workspace:Raycast(origin, direction.Unit * 900, params)
            if ray then
                local model = ray.Instance:FindFirstAncestorOfClass("Model")
                picked = model and Players:GetPlayerFromCharacter(model)
            end
        end
        shotPlayer = picked or chooseTarget(camera)
        shotTime = os.clock()
    end
    connect(UserInputService.InputBegan, function(input, processed)
        if processed or not alive or not overlay.Enabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            and not UserInputService:GetFocusedTextBox()
            and not (mainWindow and mainWindow:IsOpen()) then
            local camera = Workspace.CurrentCamera
            if camera then
                shotPlayer, shotTime = chooseTarget(camera), os.clock()
            end
        end
    end)
    local previousCarSeat, originalCarMaxSpeed, originalCarTorque
    local vehicleWasBoosting = false
    rageFX.vehicleStatus = "Speed Hack OFF"
    local function restoreVehicleProperties()
        if previousCarSeat and previousCarSeat.Parent
            and previousCarSeat:IsA("VehicleSeat") then
            pcall(function()
                if originalCarMaxSpeed ~= nil then previousCarSeat.MaxSpeed = originalCarMaxSpeed end
                if originalCarTorque ~= nil then previousCarSeat.Torque = originalCarTorque end
            end)
        end
    end
    local function restoreVehicleSpeed()
        restoreVehicleProperties()
        previousCarSeat, originalCarMaxSpeed, originalCarTorque = nil, nil, nil
        vehicleWasBoosting = false
    end
    local function updateVehicleSpeed(seat, humanoid, dt)
        local multiplier = math.clamp(tonumber(S.VehicleSpeedMult) or 2, 1, 10)
        if not alive or not S.VehicleSpeedEnabled or not overlay.Enabled or S.Freecam
            or not seat or not seat:IsA("BasePart") or not humanoid or humanoid.Health <= 0
            or multiplier <= 1 then
            restoreVehicleSpeed()
            rageFX.vehicleStatus = not S.VehicleSpeedEnabled and "Speed Hack OFF"
                or (multiplier <= 1 and "x1: original vehicle handling" or "Waiting for driver seat")
            return
        end
        if seat ~= previousCarSeat then
            restoreVehicleSpeed()
            previousCarSeat = seat
            if seat:IsA("VehicleSeat") then
                originalCarMaxSpeed, originalCarTorque = seat.MaxSpeed, seat.Torque
            end
        end
        local assembly = seat.AssemblyRootPart or seat
        if not assembly or assembly.Anchored then
            restoreVehicleProperties()
            rageFX.vehicleStatus = "Vehicle assembly is anchored"
            return
        end
        local velocity = assembly.AssemblyLinearVelocity
        local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
        local forward = seat.CFrame.LookVector
        forward = Vector3.new(forward.X, 0, forward.Z)
        if forward.Magnitude <= .01 then return end
        forward = forward.Unit
        local throttle = 0
        if not UserInputService:GetFocusedTextBox() then
            if seat:IsA("VehicleSeat") then
                throttle = seat.ThrottleFloat
                if math.abs(throttle) < .05 then throttle = seat.Throttle end
            end
            if UserInputService.KeyboardEnabled then
                local gas = UserInputService:IsKeyDown(Enum.KeyCode.W)
                    or UserInputService:IsKeyDown(Enum.KeyCode.Up)
                local reverse = UserInputService:IsKeyDown(Enum.KeyCode.S)
                    or UserInputService:IsKeyDown(Enum.KeyCode.Down)
                if gas or reverse then throttle = (gas and 1 or 0) - (reverse and 1 or 0) end
            end
            if math.abs(throttle) < .05 and UserInputService.TouchEnabled then
                -- Use actual joystick input; current velocity is never a gas signal.
                local move = humanoid.MoveDirection
                if move.Magnitude > .15 then throttle = move:Dot(forward) end
            end
        end
        throttle = math.clamp(throttle, -1, 1)
        if math.abs(throttle) <= .05 then
            restoreVehicleProperties()
            if vehicleWasBoosting then
                local remaining = horizontal * math.exp(-7 * math.clamp(dt, 0, .1))
                if remaining.Magnitude < .6 then
                    remaining = Vector3.zero
                    vehicleWasBoosting = false
                end
                pcall(function()
                    assembly.AssemblyLinearVelocity = Vector3.new(remaining.X, velocity.Y, remaining.Z)
                end)
            end
            rageFX.vehicleStatus = vehicleWasBoosting and "Braking: gas released" or "Stopped / hold gas"
            return
        end
        local baseline = math.max(1, tonumber(originalCarMaxSpeed) or 35)
        local maxSpeed = math.min(250, baseline * multiplier)
        if seat:IsA("VehicleSeat") then
            pcall(function()
                seat.MaxSpeed = maxSpeed
                seat.Torque = math.min(250000, math.max(tonumber(originalCarTorque) or 0, 500) * multiplier)
            end)
        end
        -- Signed speed preserves braking/reverse instead of accelerating along momentum.
        local desired = maxSpeed * throttle
        local along = horizontal:Dot(forward)
        local increment = math.clamp((desired - along) * math.clamp(dt * 3.5, 0, .3), -14, 14)
        vehicleWasBoosting = true
        pcall(function() assembly.AssemblyLinearVelocity = velocity + forward * increment end)
        rageFX.vehicleStatus = ("Boost x%.1f | %d studs/s"):format(multiplier, math.floor(horizontal.Magnitude + .5))
    end

    local previousRoot, previousAutoRotate
    local function restoreSpin()
        if previousRoot and previousRoot.Parent and previousAutoRotate ~= nil then
            local human = previousRoot.Parent:FindFirstChildOfClass("Humanoid")
            if human then human.AutoRotate = previousAutoRotate end
        end
        previousRoot, previousAutoRotate = nil, nil
    end
    local guiClock = 0
    connect(RunService.Heartbeat, function(dt)
        if not alive then restoreSpin();restoreVehicleSpeed();return end
        local timeNow = os.clock()
        if marker.Visible then
            if timeNow >= markerExpires or not S.HitmarkerEnabled
                or not overlay.Enabled then
                marker.Visible = false
            else
                local alpha = math.clamp((markerExpires - timeNow) / .25, 0, 1)
                for _, bar in ipairs(strokes) do
                    bar.BackgroundTransparency = 1 - alpha
                end
            end
        end
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local seat = humanoid and humanoid.SeatPart
        local speed = math.clamp(tonumber(S.SpinSpeed) or 4, 1, 10)
        local angle = math.rad(90 * speed) * math.min(dt, .08)
        if S.Spin360Enabled and overlay.Enabled and not S.Freecam
            and humanoid and humanoid.Health > 0 and root and not seat then
            if previousRoot ~= root then
                restoreSpin()
                previousRoot, previousAutoRotate = root, humanoid.AutoRotate
            end
            humanoid.AutoRotate = false
            -- Rotate only the body orientation, retaining the root position and running velocity.
            local position = root.Position
            root.CFrame = CFrame.new(position) * root.CFrame.Rotation * CFrame.Angles(0, angle, 0)
        else
            restoreSpin()
        end
        updateVehicleSpeed(seat, humanoid, dt)
        guiClock = guiClock + dt
        if guiClock < .095 then return end
        guiClock = 0
        if not overlay.Enabled or not S.TargetHUDEnabled or S.Freecam then
            hud.Visible = false
            currentPlayer = nil
            return
        end
        local camera = Workspace.CurrentCamera
        local target = camera and chooseTarget(camera)
        local character = target and target.Character
        local human = character and character:FindFirstChildOfClass("Humanoid")
        if not target or not human or human.Health <= 0 then
            hud.Visible = false
            currentPlayer = nil
            return
        end
        local becameVisible = not hud.Visible
        hud.Visible = true
        if becameVisible then
            hudScale.Scale = hudBaseScale * .9
            TweenService:Create(hudScale, TweenInfo.new(
                .24, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Scale = hudBaseScale}):Play()
        end
        if target ~= currentPlayer then
            currentPlayer = target
            name.Text = target.Name
            avatar.Image = thumbnailCache[target.UserId] or ""
            if not thumbnailCache[target.UserId] then
                task.spawn(function()
                    local ok, url = pcall(Players.GetUserThumbnailAsync, Players,
                        target.UserId, Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size150x150)
                    if ok and type(url) == "string" then
                        thumbnailCache[target.UserId] = url
                        if alive and currentPlayer == target and avatar.Parent then
                            avatar.Image = url
                        end
                    end
                end)
            end
        end
        local health = math.max(0, human.Health)
        local maximum = math.max(1, human.MaxHealth)
        healthText.Text = ("HP %d/%d"):format(
            math.ceil(health), math.ceil(maximum))
        local fraction = math.clamp(health / maximum, 0, 1)
        if math.abs(healthFill.Size.X.Scale - fraction) > .005 then
            TweenService:Create(healthFill, TweenInfo.new(
                .18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromScale(fraction, 1),
                BackgroundColor3 = Color3.fromRGB(239, 91, 96):Lerp(
                    Color3.fromRGB(79, 221, 133), fraction)
            }):Play()
        end
    end)
    rageFX.restoreSpin = restoreSpin
    rageFX.restoreVehicleSpeed = restoreVehicleSpeed
end
setupRageVisuals()

local function setupOffscreenArrows()
    local imageIds = {
        White = "rbxthumb://type=Asset&id=72242773341476&w=420&h=420",
        Purple = "rbxthumb://type=Asset&id=140717553674439&w=420&h=420",
        Red = "rbxthumb://type=Asset&id=136705433948358&w=420&h=420"
    }
    -- All three transparent images point up and share the same canvas.
    -- Crop the empty margins equally; retain a square so rotation preserves shape.
    local cropOffset, cropSize = Vector2.new(40, 52), Vector2.new(340, 340)
    local preloadImages = {}
    for mode, image in pairs(imageIds) do
        local cached = Instance.new("ImageLabel")
        cached.Name = "CVArrowAsset_" .. mode
        cached.BackgroundTransparency = 1
        cached.Visible = false
        cached.Image = image
        cached.Parent = overlay
        preloadImages[#preloadImages + 1] = cached
    end
    task.spawn(function()
        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync(preloadImages)
        end)
    end)
    local indicators = {}
    local updateClock = .2
    local mobile = UserInputService.TouchEnabled
    local function createArrow(player)
        local existing = indicators[player]
        if existing then return existing end
        local widget = Instance.new("ImageLabel")
        widget.Name = "CVortexOffscreen_" .. player.UserId
        widget.BackgroundTransparency = 1
        widget.BorderSizePixel = 0
        widget.AnchorPoint = Vector2.new(.5, .5)
        widget.ScaleType = Enum.ScaleType.Fit
        widget.Size = UDim2.fromOffset(42, 42)
        widget.ImageRectOffset = cropOffset
        widget.ImageRectSize = cropSize
        widget.ImageColor3 = Color3.fromRGB(255, 255, 255)
        widget.Image = imageIds.Red
        widget.ImageTransparency = 1
        widget.Visible = false
        widget.ZIndex = 70
        widget.Parent = overlay
        local record = {
            gui = widget, position = nil, destination = nil,
            rotation = 0, angle = 0, opacity = 1,
            show = false, accent = false, isFriendly = false,
            selectedAsset = nil
        }
        indicators[player] = record
        return record
    end
    local function deleteArrow(player)
        local info = indicators[player]
        if info and info.gui then info.gui:Destroy() end
        indicators[player] = nil
    end
    connect(Players.PlayerRemoving, deleteArrow)
    local function friendly(player)
        return not player.Neutral and not LocalPlayer.Neutral
            and player.Team ~= nil and player.Team == LocalPlayer.Team
    end
    local function hideAll()
        for _, data in pairs(indicators) do
            data.show = false
            data.opacity = 1
            data.gui.Visible = false
            data.gui.ImageTransparency = 1
        end
    end
    connect(RunService.RenderStepped, function(dt)
        if not alive or not overlay.Enabled or not S.OffscreenArrows
            or S.Freecam then
            hideAll()
            return
        end
        local camera = Workspace.CurrentCamera
        if not camera then hideAll(); return end
        updateClock = updateClock + math.min(dt, .12)
        if updateClock >= (S.LowCPUMode and .085 or .055) then
            updateClock = 0
            local viewport = camera.ViewportSize
            local center = viewport * .5
            local smallest = math.min(viewport.X, viewport.Y)
            local size = math.clamp(tonumber(S.OffscreenArrowSize) or 42, 20, 72)
            local renderSize = size * (mobile and .83 or 1)
            local radius = math.min(
                math.clamp(tonumber(S.OffscreenArrowRadius) or 115, 55, 300),
                smallest * .43 - renderSize * .5)
            radius = math.max(24, radius)
            local nearest, nearestDistance = nil, math.huge
            local potentials = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local root = character and
                        (character:FindFirstChild("HumanoidRootPart")
                        or character:FindFirstChild("Head"))
                    if root and humanoid and humanoid.Health > 0 then
                        local screen, onScreen = camera:WorldToViewportPoint(root.Position)
                        local visibleScreen = onScreen and screen.Z > 0
                            and screen.X >= 0 and screen.X <= viewport.X
                            and screen.Y >= 0 and screen.Y <= viewport.Y
                        if not visibleScreen or not S.OffscreenOnly then
                            local direction
                            if screen.Z > .03 then
                                direction = Vector2.new(screen.X - center.X,
                                    screen.Y - center.Y)
                            else
                                local localPosition = camera.CFrame:
                                    PointToObjectSpace(root.Position)
                                local bearing = math.atan2(localPosition.X,
                                    -localPosition.Z)
                                direction = Vector2.new(math.sin(bearing),
                                    -math.cos(bearing))
                            end
                            if direction.Magnitude < .01 then
                                direction = Vector2.new(0, -1)
                            else
                                direction = direction.Unit
                            end
                            local isFriendly = friendly(player)
                            local worldDistance = (root.Position
                                - camera.CFrame.Position).Magnitude
                            potentials[player] = {
                                destination = center + direction * radius,
                                angle = math.deg(math.atan2(direction.X,
                                    -direction.Y)),
                                size = renderSize,
                                friendly = isFriendly
                            }
                            if not isFriendly and worldDistance < nearestDistance then
                                nearest, nearestDistance = player, worldDistance
                            end
                        end
                    end
                end
            end
            for player, record in pairs(indicators) do
                if not potentials[player] then record.show = false end
            end
            for player, info in pairs(potentials) do
                local record = createArrow(player)
                record.destination = info.destination
                record.angle = info.angle
                record.size = info.size
                record.show = true
                record.accent = player == nearest
                local mode = S.OffscreenArrowColorMode
                if mode ~= "White" and mode ~= "Purple" and mode ~= "Red" then
                    mode = info.friendly and "White" or
                        (record.accent and "Purple" or "Red")
                end
                local image = imageIds[mode] or imageIds.Red
                if record.selectedAsset ~= image then
                    record.selectedAsset = image
                    record.gui.Image = image
                end
            end
        end
        local smoothing = 1 - math.exp(-15 * math.min(dt, .1))
        local fading = 1 - math.exp(-11 * math.min(dt, .1))
        for _, record in pairs(indicators) do
            if record.show and record.destination then
                record.position = record.position and
                    record.position:Lerp(record.destination, smoothing)
                    or record.destination
                local difference = (record.angle - record.rotation + 180) % 360 - 180
                record.rotation = record.rotation + difference * smoothing
                record.gui.Rotation = record.rotation
                record.gui.Position = UDim2.fromOffset(
                    record.position.X, record.position.Y)
                local dimension = record.size
                record.gui.Size = UDim2.fromOffset(dimension, dimension)
            end
            local loaded = record.gui.IsLoaded
            local targetOpacity = record.show and loaded and 0 or 1
            record.opacity = record.opacity +
                (targetOpacity - record.opacity) * fading
            record.gui.ImageTransparency = loaded
                and math.clamp(record.opacity, 0, 1) or 1
            record.gui.Visible = loaded and (record.show or record.opacity < .985)
        end
    end)
end
setupOffscreenArrows()

local silentAimPoint, silentTargetName = nil, nil
local silentTargetClock = 0
connect(RunService.Heartbeat, function(dt)
if not alive or not S.SilentAimEnabled then
silentAimPoint, silentTargetName = nil, nil
return
end
silentTargetClock = silentTargetClock + dt
if silentTargetClock < .05 then return end
silentTargetClock = 0
local camera = Workspace.CurrentCamera
local player = camera and findClosestTarget(camera, S.SilentFOV)
local part = player and targetPartFor(player)
if not part then
silentAimPoint, silentTargetName = nil, nil
return
end
local position = part.Position
if S.Prediction and S.PredictionMs > 0 then
local character = player.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local movingPart = root and root:IsA("BasePart") and root or part
local velocity = movingPart.AssemblyLinearVelocity
local speed = velocity.Magnitude
if speed == speed and speed < math.huge then
if speed > 120 then velocity = velocity * (120 / speed) end
position = position + velocity * (math.clamp(S.PredictionMs, 0, 500) / 1000)
end
end
silentAimPoint, silentTargetName = position, player.Name
end)
local function silentShotDirection(origin)
if not alive or not S.SilentAimEnabled then return nil, "disabled" end
if not silentAimPoint then return nil, "no target in blue FOV / wall check" end
if not targetPartFor(Players:FindFirstChild(silentTargetName or "")) then
return nil, "teammate / target unavailable"
end
local direction = silentAimPoint - origin
if direction.Magnitude <= 0.1 then return nil, "target too close" end
return direction.Unit, silentTargetName
end
local function installSilentHook()
if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then
bulletTracerHistory.message="Executor cannot observe shots (hook API unavailable)"
warn("CVortex: Silent Aim requires hookmetamethod and getnamecallmethod")
return
end
local replicatedStorage = game:GetService("ReplicatedStorage")
local remotes = replicatedStorage:FindFirstChild("Remotes") or replicatedStorage:WaitForChild("Remotes", 8)
local gun = remotes and (remotes:FindFirstChild("Gun") or remotes:WaitForChild("Gun", 8))
if not alive or not gun or not gun:IsA("RemoteEvent") then
bulletTracerHistory.message="Gun event not found"
warn("CVortex: Silent Aim could not find the Gun RemoteEvent")
return
end
if type(env.CVortexBetaGunHookV1) == "table" then
env.CVortexBetaGunHookV1.resolve = nil
end
if type(env.CVortexBetaGunHookV2) == "table" then
env.CVortexBetaGunHookV2.resolve = nil
end
if type(env.CVortexBetaGunHookV3)=="table" then
env.CVortexBetaGunHookV3.resolve=nil
env.CVortexBetaGunHookV3.onShot=nil
end
local hook = env.CVortexBetaGunHookV4
if type(hook) ~= "table" then
hook = {remote = gun}
local oldNamecall
local function intercept(self, ...)
if self == hook.remote and getnamecallmethod() == "FireServer" then
hook.gunCalls = (hook.gunCalls or 0) + 1
local args = table.pack(...)
if args.n == 6 and type(args[1]) == "string" and #args[1] == 4
and typeof(args[2]) == "Vector3" and typeof(args[5]) == "Vector3" then
hook.shots = (hook.shots or 0) + 1
hook.lastReason = "original shot"
if hook.resolve then
local direction, target = hook.resolve(args[5])
if typeof(direction) == "Vector3" and direction.Magnitude > .99 then
hook.lastReason = "sending to " .. tostring(target)
local result = oldNamecall(self,
args[1], direction, args[3], args[4], args[5], args[6])
if hook.onShot then task.defer(hook.onShot,args[5],direction) end
hook.redirectedShots = (hook.redirectedShots or 0) + 1
hook.lastReason = "redirected to " .. tostring(target)
return result
end
hook.lastReason = tostring(target)
end
local result=oldNamecall(self,table.unpack(args,1,args.n))
if hook.onShot then task.defer(hook.onShot,args[5],args[2]) end
return result
end
end
return oldNamecall(self, ...)
end
local wrapped = type(newcclosure) == "function" and newcclosure(intercept) or intercept
local ok, previous = pcall(hookmetamethod, game, "__namecall", wrapped)
if not ok or type(previous) ~= "function" then
bulletTracerHistory.message="Shot observer installation failed"
warn("CVortex: Silent Aim hook installation failed")
return
end
oldNamecall = previous
env.CVortexBetaGunHookV4 = hook
end
hook.remote = gun
hook.onShot = function(origin, direction)
spawnBulletTracer(origin, direction)
if rageFX.onShot then rageFX.onShot(origin, direction) end
end
bulletTracerHistory.message="Ready · waiting for a shot"
hook.resolve = silentShotDirection
hook.error = nil
hook.gunCalls = 0
hook.shots = 0
hook.redirectedShots = 0
hook.lastReason = "waiting for gun fire"
silentHook = hook
end
task.spawn(installSilentHook)
local function predictedAimPosition(part)
local position = part.Position
if not S.Prediction or S.PredictionMs <= 0 then return position end
local character = currentTarget and currentTarget.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local movingPart = root and root:IsA("BasePart") and root or part
local velocity = movingPart.AssemblyLinearVelocity
local speed = velocity.Magnitude
if speed ~= speed or speed == math.huge then return position end
if speed > 120 then velocity = velocity * (120 / speed) end
return position + velocity * (math.clamp(S.PredictionMs, 0, 500) / 1000)
end
local function updateAim(dt)
if not alive or S.Freecam or not S.AimEnabled or not overlay.Enabled then return end
if UserInputService.MouseEnabled then
if activation ~= "rmb" then return end
if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
or UserInputService:GetFocusedTextBox()
or (mainWindow and mainWindow:IsOpen()) then
stopAim()
return
end
end
if S.Duration > 0 and os.clock() - aimStartTime >= S.Duration then
currentTarget = nil
aimStartTime = os.clock()
end
local camera = Workspace.CurrentCamera
if not camera or dt <= 0 then return end
local part = currentTarget and targetScreenDistance(camera, currentTarget, S.FOV * 0.12)
if not part then
currentTarget = findClosestTarget(camera)
part = currentTarget and targetScreenDistance(camera, currentTarget, 0)
end
if not part then return end
local current = camera.CFrame
local aimPosition = predictedAimPosition(part)
local direction = aimPosition - current.Position
if direction.Magnitude <= 0.1 then return end
local response = 0.65 + S.Speed * 1.65
local alpha = math.clamp(1 - math.exp(-response * math.min(dt, 0.1)), 0, 1)
local desired = CFrame.lookAt(current.Position, aimPosition, Vector3.yAxis)
camera.CFrame = current:Lerp(desired, alpha)
end
local function isPlayerCharacter(model)
return model and model:IsA("Model") and Players:GetPlayerFromCharacter(model) ~= nil
end
local monsterWords = {"monster", "creature", "entity", "beast", "stalker", "zombie", "mutant", "enemy", "mimic", "hunter", "wendigo", "scary", "horror"}
local function isMonsterModel(model)
if not model:IsA("Model") or isPlayerCharacter(model) then return false end
if model:FindFirstAncestorOfClass("Tool") then return false end
local ancestor = model.Parent
local depth, monsterFolder = 0, false
while ancestor and ancestor ~= Workspace and depth < 6 do
if ancestor:IsA("Model") and isPlayerCharacter(ancestor) then return false end
if depth < 3 then
local folderName = string.lower(ancestor.Name):gsub("[%s_%-]", "")
if folderName == "monsters" or folderName == "enemies"
or folderName == "creatures" or folderName == "mobs"
or folderName == "hostilenpcs" then
monsterFolder = true
end
end
depth = depth + 1
ancestor = ancestor.Parent
end
local humanoid = model:FindFirstChildOfClass("Humanoid")
if humanoid then
if humanoid.Health <= 0 then return false end
return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
end
local low = string.lower(model.Name)
for _, word in ipairs(monsterWords) do
if string.find(low, word, 1, true) then
return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
end
end
for _, tag in ipairs({"Monster", "Enemy", "NPCMonster", "Creature"}) do
if CollectionService:HasTag(model, tag) then
return model:FindFirstChildWhichIsA("BasePart", true) ~= nil
end
end
if monsterFolder then
return model:FindFirstChildWhichIsA("BasePart") ~= nil
end
return false
end
local monsterCandidates = {}
local monsterScanQueue, monsterScanHead, monsterScanTail = {}, 1, 0
local monsterScanning, monsterBootstrapped = false, false
local monsterLastScan = 0
local function considerMonster(model)
if not alive or not S.MonsterESP or not model or not model:IsA("Model")
or not model:IsDescendantOf(Workspace) or monsterCandidates[model] then return end
if not isMonsterModel(model) then return end
local part = model:FindFirstChild("HumanoidRootPart")
or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
if part and part:IsA("BasePart") then
monsterCandidates[model] = {part=part}
end
end
local function beginMonsterScan()
if not alive or not S.MonsterESP or monsterScanning then return end
monsterScanQueue = {Workspace}
monsterScanHead, monsterScanTail = 1, 1
monsterScanning, monsterBootstrapped = true, true
monsterLastScan = os.clock()
end
local function monsterScanStep()
if not S.MonsterESP or not monsterScanning then return end
local deadline = os.clock() + 0.0018
local checked = 0
while monsterScanHead <= monsterScanTail and checked < 140 do
local inst = monsterScanQueue[monsterScanHead]
monsterScanQueue[monsterScanHead] = nil
monsterScanHead = monsterScanHead + 1
checked = checked + 1
if inst and (inst == Workspace or inst:IsDescendantOf(Workspace)) then
if inst:IsA("Model") then considerMonster(inst) end
if inst == Workspace or inst:IsA("Model") or inst:IsA("Folder") then
for _, child in ipairs(inst:GetChildren()) do
monsterScanTail = monsterScanTail + 1
monsterScanQueue[monsterScanTail] = child
end
end
end
if checked % 20 == 0 and os.clock() >= deadline then break end
end
if monsterScanHead > monsterScanTail then
monsterScanQueue = {}
monsterScanHead, monsterScanTail = 1, 0
monsterScanning = false
end
end
local function clearMonsterESP()
for model, marker in pairs(monsterHighlights) do
monsterHighlights[model] = nil
if marker then pcall(function() marker:Destroy() end) end
end
table.clear(monsterCandidates)
monsterScanQueue = {}
monsterScanHead, monsterScanTail = 1, 0
monsterScanning, monsterBootstrapped = false, false
monsterLastScan = 0
S.HighlightedMonsters = 0
updateCounter()
end
local function refreshMonsterESP()
if not alive or not S.MonsterESP then
if next(monsterHighlights) or next(monsterCandidates) then clearMonsterESP() end
return
end
if not monsterBootstrapped or (not monsterScanning and os.clock() - monsterLastScan >= 25) then
beginMonsterScan()
end
local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local camera = Workspace.CurrentCamera
local origin = root and root.Position or (camera and camera.CFrame.Position)
if not origin then return end
local radius = math.clamp(tonumber(S.MonsterRange) or 650, 100, 1600)
local radiusSquared = radius * radius
local occupied = 0
for _, marker in pairs(highlights) do
if marker and marker.Parent and marker.Enabled then occupied = occupied + 1 end
end
local slots = math.min(20, math.max(0, 28 - occupied))
local nearest = {}
for model, record in pairs(monsterCandidates) do
if not model.Parent or not model:IsDescendantOf(Workspace) then
monsterCandidates[model] = nil
else
local human = model:FindFirstChildOfClass("Humanoid")
if not human or human.Health > 0 then
local part = record.part
if not part or not part.Parent or not part:IsDescendantOf(model) then
part = model:FindFirstChild("HumanoidRootPart")
or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
record.part = part
end
if part and slots > 0 then
local offset = part.Position - origin
local dist = offset:Dot(offset)
if dist <= radiusSquared and (#nearest < slots or dist < nearest[#nearest].distance) then
local index = math.min(#nearest + 1, slots)
while index > 1 and nearest[index - 1].distance > dist do
nearest[index] = nearest[index - 1]
index = index - 1
end
nearest[index] = {model = model, distance = dist}
end
end
end
end
end
local selected = {}
for _, entry in ipairs(nearest) do
local model = entry.model
selected[model] = true
local marker = monsterHighlights[model]
if not marker or not marker.Parent then
marker = Instance.new("Highlight")
marker.Name = "CVortex_MonsterESP"
marker.Adornee = model
marker.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
marker.FillTransparency = .55
marker.OutlineTransparency = 0
marker.Parent = model
monsterHighlights[model] = marker
end
if marker.FillColor ~= S.MonsterFill then marker.FillColor = S.MonsterFill end
if marker.OutlineColor ~= S.MonsterOutline then marker.OutlineColor = S.MonsterOutline end
if not marker.Enabled then marker.Enabled = true end
end
for model, marker in pairs(monsterHighlights) do
if not selected[model] then
monsterHighlights[model] = nil
if marker then pcall(function() marker:Destroy() end) end
end
end
S.HighlightedMonsters = #nearest
updateCounter()
end
connect(Workspace.DescendantAdded, function(inst)
if not alive or not S.MonsterESP then return end
if inst:IsA("Model") then
considerMonster(inst)
elseif inst:IsA("Humanoid") or inst:IsA("BasePart") then
local parent = inst.Parent
if parent and parent:IsA("Model") then
if inst:IsA("Humanoid") or parent:FindFirstChildOfClass("Humanoid") then
considerMonster(parent)
end
end
end
end)
connect(Workspace.DescendantRemoving, function(inst)
if not S.MonsterESP or not monsterCandidates[inst] then return end
monsterCandidates[inst] = nil
local marker = monsterHighlights[inst]
monsterHighlights[inst] = nil
if marker then pcall(function() marker:Destroy() end) end
end)
for _, tag in ipairs({"Monster", "Enemy", "NPCMonster", "Creature"}) do
connect(CollectionService:GetInstanceAddedSignal(tag), function(inst)
if S.MonsterESP then considerMonster(inst) end
end)
end

-- Container ESP stays separate from player/monster highlights and only scans
-- while enabled. A bounded queue avoids a full map traversal in one frame.
local containerAliases = {
{"SupplyDrop", {"supplydrop", "airdrop", "supplycrate"}},
{"Dresser", {"dresser", "drawer"}},
{"Nightstand", {"nightstand", "bedside"}},
{"Backpack", {"backpack", "rucksack"}},
{"KitchenCabinet", {"kitchencabinet", "cupboard"}},
{"Fridge", {"fridge", "refrigerator"}},
{"Locker", {"locker", "wardrobe"}},
}
local function normalizedContainerName(name)
return string.lower(name):gsub("[%s_%-]", "")
end
local function containerType(name)
local low = normalizedContainerName(name)
if low:find("mailbox", 1, true) or low:find("chest", 1, true) then return nil end
for _, entry in ipairs(containerAliases) do
for _, alias in ipairs(entry[2]) do
if low:find(alias, 1, true) then
return S.ContainerTypes[entry[1]] and entry[1] or nil
end
end
end
if S.ContainerOther and (
low:find("container", 1, true) or low:find("crate", 1, true)
or low:find("supply", 1, true)
or low:find("loot", 1, true) or low:match("^box%d*$")
) then return "Other" end
return nil
end
local function containerCandidate(obj)
if not (obj:IsA("Model") or obj:IsA("BasePart")) then return nil end
local kind = containerType(obj.Name)
if not kind then return nil end
if obj:FindFirstAncestorOfClass("Tool") then return nil end
local current = obj
while current and current ~= Workspace do
if current:IsA("Model") then
if Players:GetPlayerFromCharacter(current) then return nil end
if current ~= obj and containerType(current.Name) then return nil end
end
local currentName = normalizedContainerName(current.Name)
if currentName:find("mailbox", 1, true) or currentName:find("chest", 1, true) then return nil end
current = current.Parent
end
if obj:IsA("Model") and isMonsterModel(obj) then return nil end
local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
or obj:FindFirstChildWhichIsA("BasePart", true)
if not part then return nil end
return kind, part
end
local function removeContainerVisual(record)
if record.highlight then pcall(function() record.highlight:Destroy() end) end
if record.billboard then pcall(function() record.billboard:Destroy() end) end
record.highlight, record.billboard, record.label = nil, nil, nil
end
local function clearContainerESP()
for obj, record in pairs(containerMarks) do
removeContainerVisual(record)
containerMarks[obj] = nil
end
containerScanQueue, containerScanHead, containerScanTail = {}, 1, 0
containerScanning = false
end
local function enqueueContainer(obj)
containerScanTail = containerScanTail + 1
containerScanQueue[containerScanTail] = obj
end
local function beginContainerScan()
if not alive or not S.ContainerESP then
clearContainerESP()
return
end
containerScanGeneration = containerScanGeneration + 1
containerScanQueue, containerScanHead, containerScanTail = {}, 1, 0
enqueueContainer(Workspace)
containerScanning = true
end
local function scanContainerStep()
if not containerScanning then return end
local processed, started = 0, os.clock()
while containerScanHead <= containerScanTail and processed < 100 do
local obj = containerScanQueue[containerScanHead]
containerScanQueue[containerScanHead] = nil
containerScanHead = containerScanHead + 1
processed = processed + 1
if obj and (obj == Workspace or obj.Parent) then
local kind, part = containerCandidate(obj)
if kind and part then
local record = containerMarks[obj]
if not record then
record = {}
containerMarks[obj] = record
end
record.kind, record.part, record.generation = kind, part, containerScanGeneration
end
if obj == Workspace or obj:IsA("Folder") or obj:IsA("Model") then
local skipCharacter = obj:IsA("Model") and isPlayerCharacter(obj)
if not skipCharacter and not kind then
for _, child in ipairs(obj:GetChildren()) do enqueueContainer(child) end
end
end
end
if processed % 20 == 0 and os.clock() - started > .0015 then break end
end
if containerScanHead > containerScanTail then
containerScanning = false
containerScanClock = 0
containerScanQueue, containerScanHead, containerScanTail = {}, 1, 0
for obj, record in pairs(containerMarks) do
if record.generation ~= containerScanGeneration or not obj.Parent then
removeContainerVisual(record)
containerMarks[obj] = nil
end
end
end
end
local function updateContainerESP()
if not alive or not S.ContainerESP then return end
local ownChar = LocalPlayer.Character
local ownPart = ownChar and (ownChar:FindFirstChild("HumanoidRootPart")
or ownChar:FindFirstChildWhichIsA("BasePart"))
if not ownPart then return end
local origin = ownPart.Position
local rangeSquared = S.ContainerRange * S.ContainerRange
local choices = {}
for obj, record in pairs(containerMarks) do
if obj.Parent and record.part and record.part.Parent
and (record.kind == "Other" and S.ContainerOther
or S.ContainerTypes[record.kind] == true) then
local offset = record.part.Position - origin
local distanceSquared = offset:Dot(offset)
if distanceSquared <= rangeSquared then
choices[#choices + 1] = {obj=obj, record=record, dist=distanceSquared}
else
removeContainerVisual(record)
end
else
removeContainerVisual(record)
end
end
table.sort(choices, function(a,b) return a.dist < b.dist end)
local occupied = 0
for _, marker in pairs(highlights) do
if marker and marker.Parent and marker.Enabled then occupied = occupied + 1 end
end
for _, marker in pairs(monsterHighlights) do
if marker and marker.Parent and marker.Enabled then occupied = occupied + 1 end
end
local maxHighlight = math.min(10, math.max(0, 29 - occupied))
local showLabels = S.ContainerNames or S.ContainerDistance
local maxLabels = showLabels and (S.LowCPUMode and 18 or 30) or 0
for index, entry in ipairs(choices) do
local obj, record = entry.obj, entry.record
if index <= maxHighlight then
if not record.highlight or not record.highlight.Parent then
local marker = Instance.new("Highlight")
marker.Name = "CVortex_ContainerESP"
marker.Adornee = obj
marker.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
marker.FillColor = Color3.fromRGB(255, 185, 75)
marker.OutlineColor = Color3.fromRGB(255, 225, 155)
marker.FillTransparency = .78
marker.OutlineTransparency = 0
marker.Parent = obj
record.highlight = marker
end
elseif record.highlight then
record.highlight:Destroy()
record.highlight = nil
end
if index <= maxLabels then
if not record.billboard or not record.billboard.Parent then
local billboard = Instance.new("BillboardGui")
billboard.Name = "CVortex_ContainerLabel"
billboard.Adornee = record.part
billboard.Size = UDim2.fromOffset(230, 30)
billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
billboard.AlwaysOnTop = true
billboard.MaxDistance = S.ContainerRange
billboard.Parent = LocalPlayer.PlayerGui
local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 220, 150)
label.TextStrokeTransparency = .35
label.Font = Enum.Font.BuilderSansMedium
label.TextSize = 12
label.Parent = billboard
record.billboard, record.label = billboard, label
end
if record.billboard.Adornee ~= record.part then
record.billboard.Adornee = record.part
end
if record.billboard.MaxDistance ~= S.ContainerRange then
record.billboard.MaxDistance = S.ContainerRange
end
local distance = math.floor(math.sqrt(entry.dist) + .5)
local nextText = S.ContainerNames and S.ContainerDistance
and string.format("%s  |  %d studs", obj.Name, distance)
or S.ContainerNames and obj.Name
or string.format("%d studs", distance)
if record.label.Text ~= nextText then record.label.Text = nextText end
elseif record.billboard then
record.billboard:Destroy()
record.billboard, record.label = nil, nil
end
end
end
connect(Workspace.DescendantAdded, function(obj)
if not alive or not S.ContainerESP then return end
if not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
if not containerType(obj.Name) then return end
task.delay(.2, function()
if not alive or not S.ContainerESP or not obj.Parent then return end
local kind, part = containerCandidate(obj)
if not kind or not part then return end
local record = containerMarks[obj] or {}
record.kind, record.part, record.generation = kind, part, containerScanGeneration
containerMarks[obj] = record
end)
end)
local function isMapPart(obj)
if not obj:IsA("BasePart") or not obj.Anchored or obj.Transparency >= 0.98 then return false end
if obj.Size.Magnitude < 7 then return false end
if LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character) then return false end
if obj:FindFirstAncestorOfClass("Tool") then return false end
local m = obj:FindFirstAncestorOfClass("Model")
while m and m ~= Workspace do
if m:FindFirstChildOfClass("Humanoid") or isPlayerCharacter(m) then return false end
m = m.Parent and m.Parent:FindFirstAncestorOfClass("Model") or nil
end
return true
end
local function applyXrayPart(obj)
if not alive or not S.Xray or not isMapPart(obj) then return end
if xrayOriginal[obj] == nil then xrayOriginal[obj] = obj.LocalTransparencyModifier end
obj.LocalTransparencyModifier = math.max(xrayOriginal[obj], S.XrayTransparency)
end
local function resetXray()
xrayBuildId = xrayBuildId + 1
for part, original in pairs(xrayOriginal) do
if part and part.Parent then
pcall(function() part.LocalTransparencyModifier = original end)
end
xrayOriginal[part] = nil
end
end
local function updateXray()
xrayBuildId = xrayBuildId + 1
local generation = xrayBuildId
if not S.Xray then resetXray(); return end
task.spawn(function()
for i, obj in ipairs(Workspace:GetDescendants()) do
if not alive or not S.Xray or generation ~= xrayBuildId then return end
if obj:IsA("BasePart") then pcall(applyXrayPart, obj) end
if i % 180 == 0 then task.wait() end
end
end)
end
connect(UserInputService.JumpRequest, function()
if not alive or not S.InfiniteJump then return end
local char = LocalPlayer.Character
local human = char and char:FindFirstChildOfClass("Humanoid")
if human and human.Health > 0 then human:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
do
local bhopCharacter, bhopHumanoid, bhopAirborne = nil, nil, false
connect(RunService.Heartbeat, function()
if not alive or not S.AutoBhop or S.Freecam
or not UserInputService.KeyboardEnabled then
bhopAirborne = false
return
end
local character = LocalPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if character ~= bhopCharacter or humanoid ~= bhopHumanoid then
bhopCharacter, bhopHumanoid = character, humanoid
bhopAirborne = false
end
if not humanoid or humanoid.Health <= 0 or humanoid.Sit
or humanoid.PlatformStand then
bhopAirborne = false
return
end
local state = humanoid:GetState()
if state == Enum.HumanoidStateType.Seated
or state == Enum.HumanoidStateType.Swimming
or state == Enum.HumanoidStateType.Climbing
or state == Enum.HumanoidStateType.Dead then
bhopAirborne = false
return
end
if humanoid.FloorMaterial == Enum.Material.Air then
bhopAirborne = true
return
end
if not bhopAirborne then return end
bhopAirborne = false
if UserInputService:GetFocusedTextBox()
or not UserInputService:IsKeyDown(Enum.KeyCode.Space) then return end
humanoid.Jump = true
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
end

connect(Workspace.DescendantAdded, function(obj)
if alive and S.Xray and obj:IsA("BasePart") then
task.defer(function() if alive then pcall(applyXrayPart, obj) end end)
end
end)
local function rejoinServer()
local success = pcall(function()
if game.JobId and game.JobId ~= "" then
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
else
TeleportService:Teleport(game.PlaceId, LocalPlayer)
end
end)
return success
end

local freecamState, freecamGui
local freecamHeld, freecamTouches = {}, {}
local freecamLook, freecamTouch
local ContextActions = game:GetService("ContextActionService")
local function freecamMenuOpen()
return mainWindow and mainWindow:IsOpen()
end
local function setFreecam(enabled)
S.Freecam = enabled == true
if not S.Freecam then
ContextActions:UnbindAction("CVortexFreecamMove")
if freecamState then
local saved = freecamState
freecamState = nil
pcall(function()
saved.camera.CameraType = saved.cameraType
saved.camera.CFrame = saved.frame
local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
saved.camera.CameraSubject = human or saved.subject
end)
UserInputService.MouseBehavior = saved.mouse
end
freecamLook, freecamTouch = false, nil
table.clear(freecamHeld)
table.clear(freecamTouches)
if freecamGui then freecamGui.Visible = false end
return
end
if freecamState then return end
local camera = Workspace.CurrentCamera
if not camera then S.Freecam = false; return end
local pitch, yaw = camera.CFrame:ToOrientation()
freecamState = {camera = camera, cameraType = camera.CameraType,
subject = camera.CameraSubject, frame = camera.CFrame, mouse = UserInputService.MouseBehavior,
position = camera.CFrame.Position, pitch = pitch, yaw = yaw}
camera.CameraType = Enum.CameraType.Scriptable
ContextActions:BindActionAtPriority("CVortexFreecamMove", function(_, state, input)
if state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
freecamHeld[input.KeyCode.Name] = nil
elseif state == Enum.UserInputState.Begin and not UserInputService:GetFocusedTextBox() then
freecamHeld[input.KeyCode.Name] = true
end
return Enum.ContextActionResult.Sink
end, false, 3000, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.Space,
Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward,
Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)
end
connect(UserInputService.InputBegan, function(input, processed)
if not S.Freecam or processed or freecamMenuOpen() then return end
if input.UserInputType == Enum.UserInputType.MouseButton2 then
freecamLook = true
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
elseif input.UserInputType == Enum.UserInputType.Touch
and input.Position.X > Workspace.CurrentCamera.ViewportSize.X * .5 then
freecamTouch = input
end
end)
connect(UserInputService.InputChanged, function(input)
local state = freecamState
if not state or freecamMenuOpen() then return end
if (freecamLook and input.UserInputType == Enum.UserInputType.MouseMovement) or input == freecamTouch then
state.yaw = state.yaw - input.Delta.X * .004
state.pitch = math.clamp(state.pitch - input.Delta.Y * .004, -math.rad(85), math.rad(85))
end
end)
connect(UserInputService.InputEnded, function(input)
if input.UserInputType == Enum.UserInputType.MouseButton2 then
freecamLook = false
if freecamState then UserInputService.MouseBehavior = freecamState.mouse end
end
if input == freecamTouch then freecamTouch = nil end
local key = freecamTouches[input]
if key then freecamHeld[key] = nil; freecamTouches[input] = nil end
end)
connect(UserInputService.WindowFocusReleased, function()
table.clear(freecamHeld)
freecamLook, freecamTouch = false, nil
if freecamState then UserInputService.MouseBehavior = freecamState.mouse end
end)
freecamGui = Instance.new("Frame")
freecamGui.Name = "FreecamControls"
freecamGui.Size = UDim2.fromScale(1, 1)
freecamGui.BackgroundTransparency = 1
freecamGui.Visible = false
freecamGui.Parent = overlay
for _, item in ipairs({{"W", "W", 64, 156}, {"S", "S", 64, 60},
{"A", "A", 16, 108}, {"D", "D", 112, 108}, {"E", "+", 170, 156}, {"Q", "-", 170, 60}}) do
local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(42, 42)
button.Position = UDim2.new(0, item[3], 1, -item[4])
button.Text = item[2]
button.TextSize = 22
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(240, 240, 240)
button.BackgroundColor3 = Color3.fromRGB(45, 46, 49)
button.BackgroundTransparency = .2
button.BorderSizePixel = 0
button.Parent = freecamGui
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
connect(button.InputBegan, function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
freecamHeld[item[1]] = true
freecamTouches[input] = item[1]
end
end)
end
local function updateFreecam(dt)
local state = freecamState
if not state or not alive then return end
if Workspace.CurrentCamera ~= state.camera then setFreecam(false); return end
freecamGui.Visible = UserInputService.TouchEnabled and overlay.Enabled and not freecamMenuOpen()
if not overlay.Enabled or freecamMenuOpen() or UserInputService:GetFocusedTextBox() then
table.clear(freecamHeld)
freecamLook, freecamTouch = false, nil
UserInputService.MouseBehavior = state.mouse
return
end
local function held(key) return freecamHeld[key] and 1 or 0 end
local direction = Vector3.new(held("D") - held("A"), held("E") - held("Q"), held("S") - held("W"))
if direction.Magnitude > 1 then direction = direction.Unit end
local rotation = CFrame.Angles(0, state.yaw, 0) * CFrame.Angles(state.pitch, 0, 0)
state.position = state.position + rotation:VectorToWorldSpace(direction) * S.FreecamSpeed * math.min(dt, .1)
state.camera.CameraType = Enum.CameraType.Scriptable
state.camera.CFrame = CFrame.new(state.position) * rotation
state.camera.Focus = state.camera.CFrame * CFrame.new(0, 0, -16)
end
RunService:BindToRenderStep("CVortexFreecam", Enum.RenderPriority.Camera.Value + 31, updateFreecam)

local renderName = "CVortex_PlayerESP_Aimbot_Render"
local aimRenderBound = pcall(function()
RunService:BindToRenderStep(renderName, Enum.RenderPriority.Camera.Value + 30, updateAim)
end)
if not aimRenderBound then
connect(RunService.RenderStepped, updateAim)
end
connect(RunService.Heartbeat, function(dt)
if not alive then return end
espTimer = espTimer + dt
local playerInterval = S.LowCPUMode and .3 or .18
if espTimer >= playerInterval then
espTimer = 0
if S.ESP or S.WeaponESP or S.LocalESP or S.PlayerChams or S.SelfChams then refreshAllESP()
elseif S.PlayerCounter then updateCounter() end
end
if S.MonsterESP then
monsterScanStep()
monsterScanClock = monsterScanClock + dt
if monsterScanClock >= 0.4 then
monsterScanClock = 0
refreshMonsterESP()
end
else
monsterScanClock = 0
end
if S.ContainerESP then
containerScanClock = containerScanClock + dt
containerUpdateClock = containerUpdateClock + dt
if containerScanClock >= (S.LowCPUMode and 12 or 7) and not containerScanning then
containerScanClock = 0
beginContainerScan()
end
scanContainerStep()
if containerUpdateClock >= (S.LowCPUMode and .65 or .4) then
containerUpdateClock = 0
updateContainerESP()
end
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

local skyboxColorPresets = {
["White"] = Color3.fromRGB(255,255,255),
["Black"] = Color3.fromRGB(0,0,0),
["Grey"] = Color3.fromRGB(105,105,110),
["Red"] = Color3.fromRGB(245,35,52),
["Dark Red"] = Color3.fromRGB(95,0,16),
["Green"] = Color3.fromRGB(30,220,90),
["Lime"] = Color3.fromRGB(160,255,20),
["Dark Green"] = Color3.fromRGB(0,75,37),
["Blue"] = Color3.fromRGB(40,120,255),
["Sky Blue"] = Color3.fromRGB(95,205,255),
["Dark Blue"] = Color3.fromRGB(10,26,85),
["Cyan"] = Color3.fromRGB(0,235,230),
["Purple"] = Color3.fromRGB(153,73,245),
["Violet"] = Color3.fromRGB(86,27,177),
["Pink"] = Color3.fromRGB(255,103,195),
["Orange"] = Color3.fromRGB(255,135,35),
["Yellow"] = Color3.fromRGB(255,245,55),
["Gold"] = Color3.fromRGB(250,195,75),
["Teal"] = Color3.fromRGB(30,155,155),
["Brown"] = Color3.fromRGB(135,80,42),
}
local skyboxModelPresets = {
["Toolbox Black"] = 113702652,
["White Clouds"] = 7493298,
["Monochrome"] = 14133954145,
["Classic Blue"] = 61183,
["Deep Blue"] = 24630181,
["Bright Blue"] = 5312292979,
["Red Horror"] = 136055162054954,
["Green Clouds"] = 113036863157630,
["Galaxy HD"] = 10542194896,
["Space Cluster"] = 230057424,
["Eternal Night"] = 189340925,
["Space Nebula"] = 117954512106943,
["Space Universe"] = 73367614602879,
["Classic Space"] = 14756973,
["Outer Space"] = 23515457,
["Moon Surface"] = 7958849894,
["Blue Moon"] = 3692190308,
["Ancient Moon"] = 5289375257,
["Alien Planet"] = 185000854,
["Aurora Night"] = 15484226156,
["Blue Galaxy Night"] = 136087050163727,
["Sunset Dawn"] = 325545295,
["Golden Sunset"] = 402561625,
["Pastel Sunset"] = 159068040,
["Grimm Night"] = 332466267,
["Storm Realistic"] = 255029168,
["Winter Night"] = 113706263,
["Christmas Sky"] = 347731885,
["Rainbow"] = 16573629759,
["Rainbow HD"] = 18915196644,
["Minecraft Sky"] = 119924202100426,
["Horror Fog"] = 102916083778328,
["Anime Clouds"] = 76895342487886,
["JoJo Sky"] = 121569167370617,
["Green Hill Zone"] = 4003948,
}
local skyboxMemeDecals = {
["Among Us"] = 6018344450,
["Amogus Pixel"] = 7240177729,
["Fat Amogus"] = 12716278332,
}
local skyboxColorNames = {"Default", "White", "Black", "Grey", "Red", "Dark Red",
"Green", "Lime", "Dark Green", "Blue", "Sky Blue", "Dark Blue",
"Cyan", "Purple", "Violet", "Pink", "Orange", "Yellow", "Gold",
"Teal", "Brown", "Custom Color"}
local skyboxSpaceNames = {"Galaxy HD", "Space Cluster", "Eternal Night",
"Space Nebula", "Space Universe", "Classic Space", "Outer Space",
"Moon Surface", "Blue Moon", "Ancient Moon", "Alien Planet",
"Aurora Night", "Blue Galaxy Night"}
local skyboxAtmosphereNames = {"Toolbox Black", "White Clouds", "Monochrome",
"Classic Blue", "Deep Blue", "Bright Blue", "Red Horror",
"Green Clouds", "Sunset Dawn", "Golden Sunset", "Pastel Sunset",
"Grimm Night", "Storm Realistic", "Winter Night",
"Christmas Sky", "Rainbow", "Rainbow HD", "Horror Fog"}
local skyboxOtherNames = {"Minecraft Sky", "Anime Clouds", "JoJo Sky",
"Green Hill Zone", "Among Us", "Amogus Pixel", "Fat Amogus"}
local skyboxActiveSky, skyboxColorSphere, skyboxOriginalSkies = nil, nil, nil
local skyboxGeneration, skyboxStatusText, skyboxStatusLabel = 0, "Original sky", nil
local skyboxModelCache = {}
local skyboxSphereConn

local function skyboxReport(message)
skyboxStatusText = message
if skyboxStatusLabel and skyboxStatusLabel.Parent then
skyboxStatusLabel.Text = message
end
end
local function skyboxRemoveCurrent()
if skyboxActiveSky then
skyboxActiveSky:Destroy()
skyboxActiveSky = nil
end
if skyboxColorSphere then
skyboxColorSphere:Destroy()
skyboxColorSphere = nil
end
if skyboxSphereConn then
skyboxSphereConn:Disconnect()
skyboxSphereConn = nil
end
end
local function restoreSkybox()
skyboxGeneration = skyboxGeneration + 1
skyboxRemoveCurrent()
if skyboxOriginalSkies then
for _, old in ipairs(skyboxOriginalSkies) do
if old and old.Parent == nil then
pcall(function() old.Parent = Lighting end)
end
end
skyboxOriginalSkies = nil
end
skyboxReport("Original sky restored")
end
local function skyboxPrepare()
if not skyboxOriginalSkies then
skyboxOriginalSkies = {}
for _, old in ipairs(Lighting:GetChildren()) do
if old:IsA("Sky") and old ~= skyboxActiveSky then
skyboxOriginalSkies[#skyboxOriginalSkies + 1] = old
end
end
end
for _, old in ipairs(skyboxOriginalSkies) do
if old and old.Parent == Lighting then old.Parent = nil end
end
skyboxRemoveCurrent()
end
local function skyboxLoadAsset(id, asDecal)
local cacheKey = (asDecal and "decal:" or "model:") .. tostring(id)
if skyboxModelCache[cacheKey] then return skyboxModelCache[cacheKey] end
local ok, objects = pcall(function()
return game:GetObjects("rbxassetid://" .. tostring(id))
end)
if not ok or type(objects) ~= "table" then
if asDecal then
local fallback = {}
for _, field in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"}) do
fallback[field] = "rbxassetid://" .. tostring(id)
end
fallback.CelestialBodiesShown = false
fallback.StarCount = 0
return fallback
end
return nil, "Toolbox asset unavailable (game:GetObjects)"
end
local faces = {"SkyboxBk", "SkyboxDn", "SkyboxFt",
"SkyboxLf", "SkyboxRt", "SkyboxUp"}
local properties, found = {}, false
for _, root in ipairs(objects) do
if typeof(root) == "Instance" then
local sample = root:IsA("Sky") and root or root:FindFirstChildWhichIsA("Sky", true)
if not asDecal and sample then
for _, field in ipairs(faces) do
properties[field] = sample[field]
end
properties.CelestialBodiesShown = sample.CelestialBodiesShown
properties.StarCount = sample.StarCount
properties.SunTextureId = sample.SunTextureId
properties.MoonTextureId = sample.MoonTextureId
found = true
elseif asDecal then
local decal = root:IsA("Decal") and root
or root:FindFirstChildWhichIsA("Decal", true)
if decal and decal.Texture ~= "" then
for _, field in ipairs(faces) do
properties[field] = decal.Texture
end
properties.CelestialBodiesShown = false
properties.StarCount = 0
found = true
end
end
pcall(function() root:Destroy() end)
end
end
if not found then return nil, "No Sky/Decal found in Toolbox asset" end
skyboxModelCache[cacheKey] = properties
return properties
end
local function refreshSkybox()
skyboxGeneration = skyboxGeneration + 1
local version = skyboxGeneration
local name = S.SkyboxPreset or "Default"
if not S.SkyboxEnabled or name == "Default" then
restoreSkybox()
return
end
local color = skyboxColorPresets[name]
if name == "Custom Color" then color = S.SkyboxColor end
if color then
skyboxPrepare()
local part = Instance.new("Part")
part.Name = "CVortex_ColorSky_Local"
part.Anchored = true
part.CanCollide, part.CanTouch, part.CanQuery = false, false, false
part.CastShadow = false
part.Material = Enum.Material.Neon
part.Color = color
part.Size = Vector3.new(1,1,1)
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = "rbxassetid://4729380505"
mesh.Scale = Vector3.new(10000, 10000, 10000)
mesh.Parent = part
local camera = Workspace.CurrentCamera
if camera then part.CFrame = CFrame.new(camera.CFrame.Position) end
part.Parent = Workspace
skyboxColorSphere = part
skyboxSphereConn = RunService.RenderStepped:Connect(function()
if not alive or not part.Parent then return end
local currentCamera = Workspace.CurrentCamera
if currentCamera then
part.CFrame = CFrame.new(currentCamera.CFrame.Position)
end
end)
skyboxReport("Solid sky: " .. name)
return
end
local modelId = skyboxModelPresets[name]
if name == "Custom Toolbox" then modelId = tonumber(S.SkyboxCustomID) end
local memeId = skyboxMemeDecals[name]
if not modelId and not memeId then
skyboxReport("Unknown skybox: " .. tostring(name))
return
end
skyboxReport("Loading Toolbox: " .. tostring(name))
task.spawn(function()
local props, errorText = skyboxLoadAsset(modelId or memeId, memeId ~= nil)
if version ~= skyboxGeneration or not alive or not S.SkyboxEnabled
or S.SkyboxPreset ~= name then return end
if not props then
skyboxReport(tostring(name) .. ": " .. tostring(errorText))
return
end
skyboxPrepare()
local sky = Instance.new("Sky")
sky.Name = "CVortex_Skybox_Local"
for _, field in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt",
"SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId",
"MoonTextureId", "CelestialBodiesShown", "StarCount"}) do
if props[field] ~= nil then
pcall(function() sky[field] = props[field] end)
end
end
sky.Parent = Lighting
skyboxActiveSky = sky
skyboxReport("Active: " .. tostring(name))
end)
end

local function cleanup()
if not alive then return end
if rageFX.restoreSpin then pcall(rageFX.restoreSpin) end
if rageFX.restoreVehicleSpeed then pcall(rageFX.restoreVehicleSpeed) end
rageFX.onShot = nil
motionVisuals.sahur.destroy()
motionVisuals.destroy()
restoreSkybox()
clearBulletTracers()
setFreecam(false)
clearSnow()
clearChinaHat()
restoreCharacterTransparency()
RunService:UnbindFromRenderStep("CVortexFreecam")
alive = false
if silentHook then silentHook.resolve = nil; silentHook.onShot = nil end
S.NoFog = false
updateEnvironment()
resetXray()
clearMonsterESP()
clearContainerESP()
pcall(function() RunService:UnbindFromRenderStep(renderName) end)
for player in pairs(highlights) do removeESP(player) end
for _, conn in ipairs(connections) do
pcall(function() conn:Disconnect() end)
end
table.clear(connections)
pcall(function() overlay:Destroy() end)
if mainWindow then
local oldWindow = mainWindow
mainWindow = nil
pcall(function() oldWindow:Destroy() end)
end
if env.CVortexPlayerAimCleanup == cleanup then
env.CVortexPlayerAimCleanup = nil
end
end
env.CVortexPlayerAimCleanup = cleanup
local refreshPlayerProfile = function() end
local function createCustomMenu()
local gui = overlay
local menuConnections = {}
local sharedConnect = connect
local function connect(signal, callback)
    local connection = sharedConnect(signal, callback)
    table.insert(menuConnections, connection)
    return connection
end
local function make(class, parent, properties)
    local obj = Instance.new(class)
    for key, value in pairs(properties or {}) do obj[key] = value end
    if obj:IsA("GuiObject") then obj.BorderSizePixel = 0 end
    obj.Parent = parent
    return obj
end
local function round(parent, radius)
    make("UICorner", parent, {CornerRadius = UDim.new(0, radius)})
end
-- Beta visual system. Keep this factory independent from gameplay and configs.
local theme = {
    panel = Color3.fromRGB(20, 22, 28),
    sidebar = Color3.fromRGB(17, 19, 24),
    field = Color3.fromRGB(30, 33, 41),
    hover = Color3.fromRGB(43, 47, 58),
    white = Color3.fromRGB(241, 243, 248),
    soft = Color3.fromRGB(187, 193, 207),
    muted = Color3.fromRGB(137, 145, 163),
    off = Color3.fromRGB(74, 81, 99),
    orange = Color3.fromRGB(236, 77, 100),
    active = Color3.fromRGB(57, 31, 42),
    line = Color3.fromRGB(66, 73, 89),
    card = Color3.fromRGB(25, 28, 35),
}
local uiMotion = setmetatable({}, {__mode = "k"})
local function animate(object, properties, duration)
    if uiMotion[object] then uiMotion[object]:Cancel() end
    local tween = TweenService:Create(object, TweenInfo.new(duration or .16,
        Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    uiMotion[object] = tween
    tween:Play()
    return tween
end
local function border(object, color, transparency)
    return make("UIStroke", object, {Color = color or theme.line,
        Thickness = 1, Transparency = transparency or .55,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
local function hover(object, base, highlight)
    connect(object.MouseEnter, function() animate(object, {BackgroundColor3 = highlight or theme.hover}) end)
    connect(object.MouseLeave, function() animate(object, {BackgroundColor3 = base or theme.field}) end)
end

local backdrop = make("Frame", gui, {
    Name = "MatteBackdrop", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(5, 7, 12), BackgroundTransparency = .82,
})
local panel = make("Frame", gui, {
    Name = "CVortexBetaMenu", AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(S.MenuWidth, S.MenuHeight),
    BackgroundColor3 = Color3.new(1, 1, 1), Active = true, ZIndex = 10,
})
round(panel, 14)
border(panel, theme.line, .3)
make("UIGradient", panel, {
    Rotation = 18,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.panel),
        ColorSequenceKeypoint.new(.72, Color3.fromRGB(23, 24, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(39, 25, 35)),
    }),
})
local uiScale = make("UIScale", panel, {Scale = 1})
local refreshResponsive = function() end
local function rescale()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local v = cam.ViewportSize
    panel.Size = UDim2.fromOffset(math.min(S.MenuWidth, math.max(340, v.X - 20)),
        math.min(S.MenuHeight, math.max(352, v.Y - 20)))
    uiScale.Scale = math.clamp(math.min((v.X - 16) / math.max(1, panel.Size.X.Offset),
        (v.Y - 16) / math.max(1, panel.Size.Y.Offset)), .39, 1)
    refreshResponsive()
end
rescale()

local sidebar = make("Frame", panel, {
    Name = "CategoryRail", Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(0, 158, 1, 0),
    BackgroundColor3 = theme.sidebar, BorderSizePixel = 0,
})
round(sidebar, 14)
make("Frame", sidebar, {
    Position = UDim2.new(1, -14, 0, 0),
    Size = UDim2.new(0, 14, 1, 0),
    BackgroundColor3 = theme.sidebar, BorderSizePixel = 0,
})
local brandLogo = make("ImageLabel", sidebar, {
    Name = "CVortexBrandLogo",
    Position = UDim2.fromOffset(16, 14), Size = UDim2.fromOffset(118, 36),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    Image = "rbxassetid://131808762032412",
    ImageColor3 = Color3.fromRGB(255, 255, 255),
    ScaleType = Enum.ScaleType.Fit,
})
local brandFallback = make("TextLabel", sidebar, {
    Name = "BrandFallback", Position = UDim2.fromOffset(16, 17),
    Size = UDim2.fromOffset(118, 30),
    BackgroundTransparency = 1, Text = "CVORTEX",
    Font = Enum.Font.BuilderSansBold, TextSize = 17,
    TextColor3 = theme.white, TextXAlignment = Enum.TextXAlignment.Left,
    Visible = not brandLogo.IsLoaded
})
connect(brandLogo:GetPropertyChangedSignal("IsLoaded"), function()
    if brandFallback.Parent then
        brandFallback.Visible = not brandLogo.IsLoaded
    end
end)
task.delay(3, function()
    if brandLogo.Parent and not brandLogo.IsLoaded then
        brandLogo.Image = "rbxthumb://type=Asset&id=131808762032412&w=150&h=150"
    end
end)
make("Frame", sidebar, {
    Position = UDim2.fromOffset(14, 58),
    Size = UDim2.new(1, -27, 0, 1),
    BackgroundColor3 = theme.line, BackgroundTransparency = .56,
})
make("Frame", sidebar, {
    Position = UDim2.new(1, -1, 0, 14),
    Size = UDim2.new(0, 1, 1, -28),
    BackgroundColor3 = theme.line, BackgroundTransparency = .65,
})
local sidebarScroll = make("ScrollingFrame", sidebar, {
    Name = "CategoryTree",
    Position = UDim2.fromOffset(3, 68),
    Size = UDim2.new(1, -7, 1, -78),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.None,
    ScrollBarThickness = 2, ScrollBarImageColor3 = theme.off,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ElasticBehavior = Enum.ElasticBehavior.Never,
})
local profile = make("Frame", panel, {
    Name = "PlayerProfile", Position = UDim2.new(1, -202, 0, 16),
    Size = UDim2.fromOffset(144, 38), BackgroundColor3 = theme.field,
    BorderSizePixel = 0,
})
round(profile, 10)
border(profile, theme.line, .75)
local avatar = make("ImageLabel", profile, {
    Name = "Avatar", Position = UDim2.fromOffset(4, 3),
    Size = UDim2.fromOffset(32, 32), BackgroundColor3 = theme.hover,
    BorderSizePixel = 0, ClipsDescendants = true,
    Visible = not S.StreamerMode,
    Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150",
})
round(avatar, 18)
local profileName = make("TextLabel", profile, {
    Name = "DisplayName", Position = UDim2.fromOffset(43, 2),
    Size = UDim2.fromOffset(94, 18), BackgroundTransparency = 1,
    Text = S.StreamerMode and "Streamer" or LocalPlayer.DisplayName, Font = Enum.Font.BuilderSansBold,
    TextSize = 11, TextColor3 = theme.white,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})
local profileUsername = make("TextLabel", profile, {
    Name = "Username", Position = UDim2.fromOffset(43, 19),
    Size = UDim2.fromOffset(94, 17), BackgroundTransparency = 1,
    Text = S.StreamerMode and "Hidden" or ("@" .. LocalPlayer.Name), Font = Enum.Font.BuilderSans,
    TextSize = 10, TextColor3 = theme.soft,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})
local anonymousAvatar = make("TextLabel", profile, {
    Position = UDim2.fromOffset(4, 3), Size = UDim2.fromOffset(32, 32),
    BackgroundColor3 = theme.hover, BorderSizePixel = 0,
    Text = "CV", TextColor3 = theme.soft, TextSize = 18, Font = Enum.Font.BuilderSansBold,
    Visible = S.StreamerMode,
})
round(anonymousAvatar, 18)
refreshPlayerProfile = function()
    if not profile.Parent then return end
    profileName.Text = S.StreamerMode and "Streamer" or LocalPlayer.DisplayName
    profileUsername.Text = S.StreamerMode and "Hidden" or ("@" .. LocalPlayer.Name)
    avatar.Visible = not S.StreamerMode
    anonymousAvatar.Visible = S.StreamerMode
end
task.spawn(function()
    local ok, image = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    if ok and avatar.Parent then avatar.Image = image end
end)

local header = make("Frame", panel, {
    Name = "MenuHeader", Position = UDim2.fromOffset(158, 0), Size = UDim2.new(1, -158, 0, 70),
    BackgroundTransparency = 1, Active = true,
})
local title = make("TextLabel", header, {
    Position = UDim2.fromOffset(18, 13), Size = UDim2.new(1, -230, 0, 25),
    BackgroundTransparency = 1, Text = "ESP", TextColor3 = theme.white,
    TextSize = 20, Font = Enum.Font.BuilderSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
})
local subtitle = make("TextLabel", header, {
    Name = "CategorySubtitle", Position = UDim2.fromOffset(18, 39),
    Size = UDim2.new(1, -230, 0, 17), BackgroundTransparency = 1,
    Text = "Player visibility", Font = Enum.Font.BuilderSans, TextSize = 11,
    TextColor3 = theme.muted, TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
})
local categoryDescriptions = {
    ESP = "Player visibility", Visuals = "Player & world effects",
    Containers = "Loot & containers", Aim = "Aim controls",
    Movement = "Camera & movement", Settings = "Preferences & profiles",
}
local function headButton(txt, offset)
    local b = make("TextButton", header, {
        Position = UDim2.new(1, offset, 0, 18),
        Size = UDim2.fromOffset(31, 31),
        BackgroundColor3 = theme.field, BorderSizePixel = 0,
        AutoButtonColor = false, Text = txt, Font = Enum.Font.BuilderSans,
        TextColor3 = theme.white, TextSize = 18,
    })
    round(b, 8)
    hover(b, theme.field)
    border(b, theme.line, .8)
    return b
end
local minimize = headButton("−", -42)

local searchSurface = make("Frame", panel, {
    Name = "SearchSurface", Position = UDim2.fromOffset(176, 72),
    Size = UDim2.new(1, -194, 0, 36), BackgroundColor3 = theme.field,
    ClipsDescendants = true,
})
round(searchSurface, 9)
local searchBorder = border(searchSurface, theme.line, .7)
local search = make("TextBox", searchSurface, {
    Name = "FeatureSearch", Position = UDim2.fromOffset(34, 0),
    Size = UDim2.new(1, -68, 1, 0), BackgroundTransparency = 1,
    Text = "", ClearTextOnFocus = false, PlaceholderText = "Search all features",
    PlaceholderColor3 = theme.muted, TextColor3 = theme.white,
    TextSize = 12, Font = Enum.Font.BuilderSans,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
})
make("ImageLabel", searchSurface, {
    Name = "SearchIcon", AnchorPoint = Vector2.new(0, .5),
    Position = UDim2.new(0, 11, .5, 0), Size = UDim2.fromOffset(16, 16),
    BackgroundTransparency = 1, Image = "rbxassetid://10734943674",
    ImageColor3 = theme.muted, ScaleType = Enum.ScaleType.Fit,
})
local clearSearch = make("TextButton", searchSurface, {
    Name = "ClearSearch", AnchorPoint = Vector2.new(1, .5),
    Position = UDim2.new(1, -4, .5, 0), Size = UDim2.fromOffset(28, 28),
    BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Visible = false,
})
for _, angle in ipairs({45, -45}) do
    local line = make("Frame", clearSearch, {AnchorPoint = Vector2.new(.5, .5),
        Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(12, 2),
        Rotation = angle, BackgroundColor3 = theme.soft})
    round(line, 1)
end
connect(clearSearch.Activated, function() search.Text = "" end)

local scrolling = make("ScrollingFrame", panel, {
    Name = "FeatureGroups", Position = UDim2.fromOffset(176, 120), Size = UDim2.new(1, -194, 1, -138),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ScrollBarThickness = 2, ScrollBarImageColor3 = theme.off,
    ElasticBehavior = Enum.ElasticBehavior.Never,
})


local selected, rows, tabs = nil, {}, {}
local groups = {}
local emptyState = make("TextLabel", panel, {
    Name = "EmptySearch", Position = UDim2.fromOffset(190, 158), Size = UDim2.new(1, -218, 0, 62),
    BackgroundTransparency = 1, Text = "No matching features\nTry a different name or category.",
    TextSize = 13, Font = Enum.Font.BuilderSans, TextColor3 = theme.soft,
    TextWrapped = true, Visible = false,
})
scrolling.AutomaticCanvasSize = Enum.AutomaticSize.None
local layoutPending = false
local function layoutGroups()
    layoutPending = false
    if not scrolling.Parent then return end
    local available = math.max(210, panel.Size.X.Offset - 202)
    local columns = available >= 484 and 2 or 1
    local width = math.floor((available - (columns - 1) * 10) / columns)
    local heights = {0, 0}
    for _, group in ipairs(groups) do
        local height, count = 46, 0
        for _, row in ipairs(rows) do
            if row.group == group and row.matched then
                height = height + row.frame.Size.Y.Offset + 3
                count = count + 1
            end
        end
        group.frame.Visible = group.matched == true
        if group.summary then
            group.summary.Visible = count == 0 and group.details ~= nil
            group.summary.Text = tostring(group.detailCount or 0)
                .. ((group.detailCount or 0) == 1 and " option  ·  Open settings" or " options  ·  Open settings")
            if group.summary.Visible then height = height + 27 end
        end
        if group.matched then
            local column = columns == 2 and heights[2] < heights[1] and 2 or 1
            group.frame.Size = UDim2.fromOffset(width, height)
            group.frame.Position = UDim2.fromOffset((column - 1) * (width + 10), heights[column])
            heights[column] = heights[column] + height + 10
        end
    end
    scrolling.CanvasSize = UDim2.fromOffset(0, math.max(heights[1], heights[2]))
end
local function queueLayout()
    if layoutPending then return end
    layoutPending = true
    task.defer(layoutGroups)
end
local tabIconAssets = {
    eye = "rbxassetid://10723346959",
    box = "rbxassetid://10709782497",
    sun = "rbxassetid://10734974297",
    sparkles = "rbxasset://textures/particles/sparkles_main.dds",
    crosshair = "rbxassetid://10709818534",
    footprints = "rbxassetid://10734900011",
    settings = "rbxassetid://10734950309",
}
local function drawTabIcon(button, kind)
    local icon = make("ImageLabel", button, {
        Name = "LucideIcon",
        Position = UDim2.fromOffset(9, 10), Size = UDim2.fromOffset(17, 17),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Image = tabIconAssets[kind] or tabIconAssets.settings,
        ImageColor3 = theme.soft, ScaleType = Enum.ScaleType.Fit,
    })
    return {icon}
end
local selectedSubsection = nil
local expandedCategory = nil
local navigationOrder = {}
local navigationEpoch = 0
local function layoutNavigation(instant)
    navigationEpoch = navigationEpoch + 1
    local epoch = navigationEpoch
    local y = 3
    for _, entry in ipairs(navigationOrder) do
        local buttonPosition = UDim2.fromOffset(7, y)
        if instant then
            entry.button.Position = buttonPosition
        else
            animate(entry.button, {Position = buttonPosition}, .26)
        end
        y = y + 43
        local expanded = expandedCategory == entry.name
        local rotation = expanded and 90 or 0
        if instant then
            entry.arrow.Rotation = rotation
        else
            animate(entry.arrow, {Rotation = rotation}, .24)
        end
        for _, subsection in ipairs(entry.children) do
            local button = subsection.button
            local dot = subsection.dot
            local textLabel = subsection.label
            local target = UDim2.fromOffset(20, y)
            if expanded then
                if not button.Visible then
                    button.Position = UDim2.fromOffset(20, y - 9)
                    textLabel.TextTransparency = 1
                    dot.BackgroundTransparency = 1
                    button.Visible = true
                end
                button.Active = true
                if instant then
                    button.Position = target
                    textLabel.TextTransparency = 0
                    dot.BackgroundTransparency = 0
                else
                    animate(button, {Position = target}, .26)
                    animate(textLabel, {TextTransparency = 0}, .26)
                    animate(dot, {BackgroundTransparency = 0}, .22)
                end
                y = y + 33
            else
                button.Active = false
                if instant then
                    button.Visible = false
                    textLabel.TextTransparency = 1
                    dot.BackgroundTransparency = 1
                elseif button.Visible then
                    animate(button, {
                        Position = UDim2.fromOffset(20, y - 9)
                    }, .2)
                    animate(textLabel, {TextTransparency = 1}, .2)
                    animate(dot, {BackgroundTransparency = 1}, .18)
                    task.delay(.23, function()
                        if navigationEpoch == epoch and button.Parent
                            and expandedCategory ~= entry.name then
                            button.Visible = false
                        end
                    end)
                end
            end
        end
        y = y + 4
    end
    local height = y + 12
    if instant then
        sidebarScroll.CanvasSize = UDim2.fromOffset(0, height)
    else
        animate(sidebarScroll, {CanvasSize = UDim2.fromOffset(0, height)}, .27)
    end
end
local function animatePageChange()
    scrolling.Position = UDim2.fromOffset(185, 120)
    animate(scrolling, {Position = UDim2.fromOffset(176, 120)}, .24)
    task.defer(function()
        if not panel.Parent then return end
        for _, group in ipairs(groups) do
            if group.matched and group.frame.Visible then
                local destination = group.frame.Position
                group.frame.Position = destination + UDim2.fromOffset(0, 7)
                animate(group.frame, {Position = destination}, .24)
            end
        end
    end)
end
local function refreshRows()
    local query = search.Text:lower():match("^%s*(.-)%s*$") or ""
    local searching, found = query ~= "", 0
    clearSearch.Visible = searching
    for _, group in ipairs(groups) do
        local activeGroup = searching or (group.root == selected
            and (not selectedSubsection or group.subsection == selectedSubsection))
        group.matched = false
        group.detailMatch = group.details ~= nil and activeGroup
            and (not searching or (group.name .. " " .. group.root:lower()
                .. " " .. group.tab:lower()
                .. " " .. (group.subsection or ""):lower()
                .. " " .. (group.detailNames or "")):find(query, 1, true) ~= nil)
        if group.detailMatch then group.matched = true; found = found + 1 end
        group.heading.Text = searching
            and (group.root .. " / " .. group.displayName) or group.displayName
    end
    for _, item in ipairs(rows) do
        local activeGroup = searching or (item.group.root == selected
            and (not selectedSubsection or item.group.subsection == selectedSubsection))
        item.matched = activeGroup
            and (not searching or item.name:find(query, 1, true) ~= nil
                or item.group.name:find(query, 1, true) ~= nil
                or item.group.root:lower():find(query, 1, true) ~= nil
                or item.group.tab:lower():find(query, 1, true) ~= nil
                or (item.group.subsection or ""):lower():find(query, 1, true) ~= nil)
        item.frame.Visible = item.matched
        if item.matched then
            found = found + 1
            item.group.matched = true
        end
    end
    queueLayout()
    for name, entry in pairs(tabs) do
        local active = name == selected and not searching
        local bg = active and theme.active or theme.sidebar
        if entry.button.BackgroundColor3 ~= bg then entry.button.BackgroundColor3 = bg end
        entry.marker.Visible = active
        for _, part in ipairs(entry.parts) do
            local tint = active and theme.orange or theme.soft
            if part.ImageColor3 ~= tint then part.ImageColor3 = tint end
        end
        entry.label.TextColor3 = active and theme.white or theme.soft
        for _, stroke in ipairs(entry.arrowParts) do
            stroke.BackgroundColor3 = active and theme.orange or theme.muted
        end
        for _, subsection in ipairs(entry.children) do
            local selectedChild = active and selectedSubsection == subsection.name
            subsection.button.BackgroundColor3 = selectedChild and theme.active or theme.sidebar
            subsection.label.TextColor3 = selectedChild and theme.white or theme.muted
            subsection.dot.BackgroundColor3 = selectedChild and theme.orange or theme.off
        end
    end
    title.Text = searching and "Search" or
        (selectedSubsection and (selected .. " / " .. selectedSubsection)
            or selected or "CVortex")
    subtitle.Text = searching
        and (found == 0 and "No results" or "Matching features & settings")
        or selectedSubsection and ("Settings for " .. selectedSubsection:lower())
        or categoryDescriptions[selected] or "Feature controls"
    emptyState.Visible = searching and found == 0
end
connect(search.Focused, function()
    animate(searchSurface, {BackgroundColor3 = theme.hover})
    animate(searchBorder, {Color = theme.orange, Transparency = .2})
end)
connect(search.FocusLost, function()
    animate(searchSurface, {BackgroundColor3 = theme.field})
    animate(searchBorder, {Color = theme.line, Transparency = .7})
end)
local searchGeneration = 0
connect(search:GetPropertyChangedSignal("Text"), function()
    searchGeneration = searchGeneration + 1
    local generation = searchGeneration
    task.delay(.06, function()
        if panel.Parent and generation == searchGeneration then
            scrolling.CanvasPosition = Vector2.zero
            refreshRows()
        end
    end)
end)
local dragPreview = make("Frame", gui, {
    Name = "MenuDragPreview", AnchorPoint = panel.AnchorPoint,
    Position = panel.Position, Size = panel.Size,
    BackgroundColor3 = theme.orange, BackgroundTransparency = .94,
    BorderSizePixel = 0, Visible = false, ZIndex = 30,
})
round(dragPreview, 15)
make("UIStroke", dragPreview, {Color = theme.orange, Thickness = 2, Transparency = .1})
local previewScale = make("UIScale", dragPreview, {Scale = uiScale.Scale})
refreshResponsive = function()
    local compact = panel.Size.X.Offset < 500
    profile.Size = UDim2.fromOffset(compact and 38 or 144, 38)
    profile.Position = UDim2.new(1, compact and -96 or -202, 0, 16)
    profileName.Visible = not compact
    profileUsername.Visible = not compact
    title.Size = UDim2.new(1, compact and -124 or -230, 0, 25)
    subtitle.Size = UDim2.new(1, compact and -124 or -230, 0, 17)
    dragPreview.Size = panel.Size
    previewScale.Scale = uiScale.Scale
    queueLayout()
end
local window = {}
function window:SetSize(w, h)
    w = math.clamp(tonumber(w) or 610, 480, 940)
    h = math.clamp(tonumber(h) or 446, 345, 740)
    S.MenuWidth, S.MenuHeight = w, h
    panel.Size = UDim2.fromOffset(w, h)
    dragPreview.Size = panel.Size
    searchSurface.Size = UDim2.new(1, -194, 0, 36)
    scrolling.Size = UDim2.new(1, -194, 1, -138)
    rescale()
    queueLayout()
end
window:SetSize(S.MenuWidth, S.MenuHeight)
local menuOpen, menuTween, menuGeneration = true, nil, 0
local fadeValue = make("NumberValue", panel, {Value = 0})
local fadeProperties = nil
local function captureFadeProperties()
    if fadeProperties then return end
    fadeProperties = {}
    local objects = panel:GetDescendants()
    table.insert(objects,panel)
    for _, object in ipairs(objects) do
        local properties = {}
        if object:IsA("GuiObject") then properties.BackgroundTransparency = object.BackgroundTransparency end
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            properties.TextTransparency = object.TextTransparency
            properties.TextStrokeTransparency = object.TextStrokeTransparency
        end
        if object:IsA("ImageLabel") then properties.ImageTransparency = object.ImageTransparency end
        if object:IsA("ScrollingFrame") then properties.ScrollBarImageTransparency = object.ScrollBarImageTransparency end
        if object:IsA("UIStroke") then properties.Transparency = object.Transparency end
        if next(properties) then fadeProperties[object] = properties end
    end
end
connect(fadeValue.Changed,function(alpha)
    if not fadeProperties then return end
    for object, properties in pairs(fadeProperties) do
        if object.Parent then
            for property, base in pairs(properties) do object[property] = base + (1-base)*alpha end
        end
    end
end)
local function animateMenu(open)
    captureFadeProperties()
    menuOpen = open
    menuGeneration = menuGeneration + 1
    local generation = menuGeneration
    if menuTween then menuTween:Cancel() end
    if open then
        panel.Visible = true
        backdrop.Visible = true
        if performanceHud then performanceHud.Visible = true end
        rescale()
        local target = uiScale.Scale
        uiScale.Scale = target * .975
        TweenService:Create(uiScale, TweenInfo.new(.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=target}):Play()
    end
    menuTween = TweenService:Create(fadeValue,TweenInfo.new(.25),{Value=open and 0 or 1})
    menuTween:Play()
    TweenService:Create(backdrop,TweenInfo.new(.25),{BackgroundTransparency=open and .82 or 1}):Play()
    if not open then
        task.delay(.26,function()
            if alive and generation == menuGeneration then
                panel.Visible = false; backdrop.Visible = false; if performanceHud then performanceHud.Visible = true end
            end
        end)
    end
end
function window:IsOpen() return menuOpen end
function window:Toggle() animateMenu(not menuOpen) end
function window:ShowImmediately()
    if menuTween then menuTween:Cancel() end
    menuGeneration = menuGeneration + 1
    menuOpen = true
    gui.Enabled = true
    panel.Visible = true
    backdrop.Visible = true
    backdrop.BackgroundTransparency = .82
    if performanceHud then performanceHud.Visible = true end
    fadeValue.Value = 0
    for object, properties in pairs(fadeProperties or {}) do
        if object.Parent then
            for property, base in pairs(properties) do object[property] = base end
        end
    end
    rescale()
end
function window:Reveal()
    self:ShowImmediately()
    local ok, err = pcall(function()
        captureFadeProperties()
        fadeValue.Value = 1
        animateMenu(true)
    end)
    if not ok then
        self:ShowImmediately()
        warn("CVortex: opening animation skipped:", err)
    end
end
function window:Destroy()
    for _, connection in ipairs(menuConnections) do connection:Disconnect() end
    table.clear(menuConnections)
    for _, tween in pairs(uiMotion) do tween:Cancel() end
    dragPreview:Destroy()
    panel:Destroy()
    backdrop:Destroy()
end
local function drag(handle, target, scale)
    local active, origin, position, moved, pointer, destination, moveTween
    connect(handle.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if activeWindowDrag then return end
        activeWindowDrag = target
        if moveTween then moveTween:Cancel() end
        active, moved, pointer = true, false, input
        destination = nil
        dragPreview.Visible = false
        origin, position = input.Position, target.Position
    end)
    connect(UserInputService.InputChanged, function(input)
        if not active then return end
        if input ~= pointer and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = input.Position - origin
        if delta.Magnitude < 7 and not moved then return end
        moved = true
        local k = scale or 1
        destination = UDim2.new(position.X.Scale, position.X.Offset + delta.X / k,
            position.Y.Scale, position.Y.Offset + delta.Y / k)
        previewScale.Scale = uiScale.Scale
        dragPreview.Position = destination
        dragPreview.Visible = panel.Visible
    end)
    connect(UserInputService.InputEnded, function(input)
        if input == pointer then
            active = false
            pointer = nil
            if activeWindowDrag == target then activeWindowDrag = nil end
            dragPreview.Visible = false
            if moved and destination and panel.Visible then
                moveTween = TweenService:Create(target,
                    TweenInfo.new(.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = destination})
                moveTween:Play()
            end
        end
    end)
    connect(UserInputService.WindowFocusReleased, function()
        active, pointer, destination = false, nil, nil
        dragPreview.Visible = false
        if activeWindowDrag == target then activeWindowDrag = nil end
    end)
    return function() return moved end
end
drag(header, panel)
enableWindowResize(panel, {
    minW = 480, minH = 345, maxW = 940, maxH = 740, gripSize = 38,
    scale = function() return uiScale.Scale end,
    onResize = function(w, h) window:SetSize(w, h) end,
    onFinish = function() if window.OnResizeSaved then window.OnResizeSaved() end end,
})
connect(minimize.Activated, function() window:Toggle() end)
connect(UserInputService.InputBegan, function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then window:Toggle() end
end)
local cameraConnection
local function watchCamera()
    if cameraConnection then cameraConnection:Disconnect() end
    if Workspace.CurrentCamera then cameraConnection = connect(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), rescale) end
    rescale()
end
connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), watchCamera)
watchCamera()
local tabCount, order = 0, 0
local function label(parent, text, width)
    return make("TextLabel", parent, {
        Position = UDim2.fromOffset(12, 7), Size = UDim2.new(1, -(width or 108), 0, 30),
        BackgroundTransparency = 1, Text = text, Font = Enum.Font.BuilderSansMedium,
        TextSize = 12, TextColor3 = theme.white, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })
end
local function button(parent, text)
    local b = make("TextButton", parent, {
        Position = UDim2.new(1, -88, 0, 8), Size = UDim2.fromOffset(76, 28),
        BackgroundColor3 = theme.hover, BorderSizePixel = 0, AutoButtonColor = false,
        Text = text, Font = Enum.Font.BuilderSansBold, TextColor3 = theme.white, TextSize = 11,
    })
    round(b, 7)
    border(b, theme.line, .75)
    hover(b, theme.hover, Color3.fromRGB(57, 61, 75))
    local pressScale = make("UIScale", b, {Scale=1})
    connect(b.InputBegan,function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(pressScale,TweenInfo.new(.1),{Scale=.94}):Play()
        end
    end)
    connect(b.InputEnded,function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(pressScale,TweenInfo.new(.16),{Scale=1}):Play()
        end
    end)
    return b
end
local details = make("CanvasGroup", gui, {
    Name = "FunctionSettings", Size = UDim2.fromOffset(320, 404),
    BackgroundColor3 = theme.panel, Visible = false, Active = true,
    GroupTransparency = 1, ZIndex = 100,
})
round(details, 12)
border(details, theme.line, .3)
make("Frame", details, {
    Position = UDim2.fromOffset(14, 48), Size = UDim2.new(1, -28, 0, 1),
    BackgroundColor3 = theme.line, BackgroundTransparency = .5,
})
local detailPreview = make("Frame", gui, {
    Name = "MenuDragPreview", Size = details.Size, Visible = false,
    BackgroundColor3 = theme.orange, BackgroundTransparency = .94, ZIndex = 101,
})
round(detailPreview, 12)
make("UIStroke", detailPreview, {Color = theme.orange, Thickness = 2, Transparency = .1})
local detailPreviewScale = make("UIScale", detailPreview, {Scale = 1})
local detailDestination

local detailScale = make("UIScale", details, {Scale = 1})
local detailHeader = make("Frame", details, {
    Size = UDim2.new(1, -46, 0, 48), BackgroundTransparency = 1, Active = true,
})
local detailTitle = label(detailHeader, "Settings", 24)
detailTitle.TextSize = 15
detailTitle.Font = Enum.Font.BuilderSansBold
detailTitle.TextWrapped = false
detailTitle.TextTruncate = Enum.TextTruncate.AtEnd
local detailClose = make("TextButton", details, {
    Position = UDim2.new(1, -42, 0, 10), Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = theme.hover, Text = "×", TextColor3 = theme.white,
    Font = Enum.Font.BuilderSansBold, TextSize = 20, AutoButtonColor = false,
})
round(detailClose, 8)
hover(detailClose, theme.hover)
local detailScroll = make("ScrollingFrame", details, {
    Position = UDim2.fromOffset(10, 58), Size = UDim2.new(1, -20, 1, -70),
    BackgroundTransparency = 1, ScrollBarThickness = 3,
    ScrollBarImageColor3 = theme.off, CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
local detailGroups, detailGeneration, detailTween = {}, 0, nil
local detailMoved = false
local function detailBounds(position)
    local camera = Workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
    detailScale.Scale = math.min(1, (viewport.X - 16) / details.Size.X.Offset, (viewport.Y - 16) / details.Size.Y.Offset)
    return UDim2.fromOffset(
        math.clamp(position.X, 8, math.max(8, viewport.X - details.Size.X.Offset * detailScale.Scale - 8)),
        math.clamp(position.Y, 8, math.max(8, viewport.Y - details.Size.Y.Offset * detailScale.Scale - 8)))
end
local detailPointer, detailOrigin, detailStart
local function closeDetails()
    detailPointer = nil
    if activeWindowDrag == details then activeWindowDrag = nil end
    detailPreview.Visible = false
    detailDestination = nil
    detailGeneration = detailGeneration + 1
    local generation = detailGeneration
    if detailTween then detailTween:Cancel() end
    detailTween = TweenService:Create(details, TweenInfo.new(.18), {GroupTransparency = 1})
    detailTween:Play()
    task.delay(.19, function()
        if details.Parent and generation == detailGeneration then details.Visible = false end
    end)
end
local function openDetails(group)
    detailGeneration = detailGeneration + 1
    if detailTween then detailTween:Cancel() end
    for _, frame in ipairs(detailGroups) do frame.Visible = frame == group.details end
    detailTitle.Text = group.displayName
    detailScroll.CanvasPosition = Vector2.zero
    local destination = detailMoved and Vector2.new(details.Position.X.Offset, details.Position.Y.Offset)
        or Vector2.new(panel.AbsolutePosition.X + panel.AbsoluteSize.X + 12, panel.AbsolutePosition.Y)
    local target = detailBounds(destination)
    details.Position = target + UDim2.fromOffset(14, 0)
    details.GroupTransparency = 1
    details.Visible = true
    detailTween = TweenService:Create(details, TweenInfo.new(.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = target, GroupTransparency = 0})
    detailTween:Play()
end
connect(detailClose.Activated, closeDetails)
connect(UserInputService.WindowFocusReleased, function()
    detailScroll.ScrollingEnabled = true
    scrolling.ScrollingEnabled = true
end)
connect(panel:GetPropertyChangedSignal("Visible"), function()
    if not panel.Visible then closeDetails() end
end)
connect(detailHeader.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if activeWindowDrag then return end
        activeWindowDrag = details
        if detailTween then detailTween:Cancel() end
        details.GroupTransparency = 0
        detailPointer, detailOrigin = input, input.Position
        detailStart = Vector2.new(details.Position.X.Offset, details.Position.Y.Offset)
        detailDestination = nil
    end
end)
connect(UserInputService.InputChanged, function(input)
    if detailPointer and (input == detailPointer or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - detailOrigin
        detailMoved = true
        if details.Visible and delta.Magnitude > 4 then
            detailDestination = detailBounds(detailStart + Vector2.new(delta.X, delta.Y))
            detailPreviewScale.Scale = detailScale.Scale
            detailPreview.Position = detailDestination
            detailPreview.Visible = true
        end
    end
end)
connect(UserInputService.InputEnded, function(input)
    if input == detailPointer then
        detailPointer = nil
        if activeWindowDrag == details then activeWindowDrag = nil end
        detailPreview.Visible = false
        if detailDestination and details.Visible then
            detailTween = TweenService:Create(details, TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = detailDestination})
            detailTween:Play()
        end
        detailDestination = nil
    end
end)
connect(UserInputService.WindowFocusReleased, function()
    detailPointer, detailDestination = nil, nil
    detailPreview.Visible = false
    if activeWindowDrag == details then activeWindowDrag = nil end
end)
local originalMenuBackgrounds = setmetatable({}, {__mode = "k"})
function window:SetTransparency(value)
    local alpha = math.clamp(tonumber(value) or 0, 0, .85)
    local surfaces = {panel, sidebar, details}
    for _, group in ipairs(groups) do table.insert(surfaces, group.frame) end
    for _, entry in ipairs(rows) do table.insert(surfaces, entry.frame) end
    for _, group in ipairs(detailGroups) do
        for _, child in ipairs(group:GetChildren()) do
            if child:IsA("Frame") then table.insert(surfaces, child) end
        end
    end
    for _, object in ipairs(surfaces) do
        if originalMenuBackgrounds[object] == nil then
            originalMenuBackgrounds[object] = object.BackgroundTransparency
        end
        local base = originalMenuBackgrounds[object]
        local transparency = base + (1 - base) * alpha
        object.BackgroundTransparency = transparency
        if fadeProperties and fadeProperties[object] then
            fadeProperties[object].BackgroundTransparency = transparency
            object.BackgroundTransparency = transparency + (1-transparency) * fadeValue.Value
        end
    end
end
local destroyMain = window.Destroy
function window:Destroy()
    detailPreview:Destroy()
    details:Destroy()
    destroyMain(self)
end
local navigationSectionMap = {
    ESP = {
        ["Player Highlights"]="Player", ["Offscreen Arrows"]="Player", ["Chams"]="Player",
        ["Player info and range"]="Player", ["Player Colors"]="Player",
        ["Local Colors"]="Player", ["Appearance"]="Player",
        ["Monster ESP"]="Monsters", ["X-Ray"]="World",
        ["Performance"]="Performance",
    },
    Visuals = {
        ["Snowfall"]="World", ["Brainrots"]="Player",
        ["Character cosmetics"]="Player", ["Motion effects"]="Player",
        ["Bullet Tracers"]="Tracers", ["Player List"]="HUD",
    },
    Skyboxes = {
        ["Client-side sky presets"]="World", ["Solid colors"]="World",
        ["Cosmos / space"]="World", ["Sky / weather / rainbow"]="World",
        ["Memes / anime / games"]="World", ["Quick search"]="World",
        ["Toolbox model ID"]="World",
    },
    Containers = {
        ["Container ESP"]="Loot", ["Labels and range"]="Labels",
    },
    Aimbot = {
        ["Main"]="Main", ["Main Aim"]="Main", ["Silent Aim"]="Silent",
        ["Manual Team Check"]="Main",
        ["FOV"]="Main", ["Silent Aim FOV (blue)"]="Silent",
        ["Prediction"]="Prediction", ["Smooth Aim"]="Main",
    },
    Movement = {["Freecam"]="Camera", ["Movement"]="Character"},
    Settings = {["Appearance"]="Menu", ["Privacy"]="Privacy", ["Configs"]="Configs"},
}
local navigationPriority = {
    ESP = {Player=1, Monsters=2, World=3, Performance=4},
    Visuals = {Player=1, World=2, Tracers=3, HUD=4},
    Containers = {Loot=1, Labels=2},
    Aim = {Main=1, Silent=2, Prediction=3},
    Movement = {Character=1, Camera=2},
    Rage = {["Target HUD"]=1, ["Spin 360"]=2, ["Combat Effects"]=3},
    Settings = {Menu=1, Privacy=2, Configs=3},
}
local function ensureNavSubsection(entry, subsectionName)
    if entry.childIndex[subsectionName] then return end
    local button = make("TextButton", sidebarScroll, {
        Name = "Sub_" .. entry.name .. "_" .. subsectionName,
        Position = UDim2.fromOffset(20, 0), Size = UDim2.new(1, -32, 0, 29),
        BackgroundColor3 = theme.sidebar, AutoButtonColor = false,
        Text = "", Visible = false,
    })
    round(button, 7)
    local dot = make("Frame", button, {
        Position = UDim2.fromOffset(11, 12), Size = UDim2.fromOffset(5, 5),
        BackgroundColor3 = theme.off,
    })
    round(dot, 3)
    local subsectionLabel = make("TextLabel", button, {
        Name = "SubsectionName",
        Position = UDim2.fromOffset(27, 0),
        Size = UDim2.new(1, -33, 1, 0),
        BackgroundTransparency = 1,
        Text = subsectionName, TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = theme.muted, Font = Enum.Font.BuilderSansMedium,
        TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local child = {button = button, dot = dot, label = subsectionLabel, name = subsectionName}
    entry.childIndex[subsectionName] = child
    table.insert(entry.children, child)
    local preferred = navigationPriority[entry.name] or {}
    table.sort(entry.children, function(a, b)
        local x, y = preferred[a.name] or 99, preferred[b.name] or 99
        return x == y and a.name < b.name or x < y
    end)
    connect(button.MouseEnter, function()
        if not (selected == entry.name and selectedSubsection == subsectionName) then
            animate(button, {BackgroundColor3 = theme.field}, .2)
        end
    end)
    connect(button.MouseLeave, function()
        if not (selected == entry.name and selectedSubsection == subsectionName) then
            animate(button, {BackgroundColor3 = theme.sidebar}, .2)
        end
    end)
    connect(button.Activated, function()
        closeDetails()
        selected, selectedSubsection, expandedCategory = entry.name, subsectionName, entry.name
        if search.Text ~= "" then search.Text = "" end
        scrolling.CanvasPosition = Vector2.zero
        refreshRows()
        animatePageChange()
        layoutNavigation(false)
    end)
    layoutNavigation(true)
end
function window:Tab(options)
    local name = options.Title
    local rootName = name == "Skyboxes" and "Visuals"
        or name == "Aimbot" and "Aim" or name
    tabCount = tabCount + 1
    local tab = {}
    local entry = tabs[rootName]
    if not entry then
        local nav = make("TextButton", sidebarScroll, {
            Name = "Category_" .. rootName, Position = UDim2.fromOffset(7, 0),
            Size = UDim2.new(1, -18, 0, 38),
            BackgroundColor3 = theme.sidebar,
            AutoButtonColor = false, Text = "",
        })
        round(nav, 9)
        local marker = make("Frame", nav, {
            Name = "ActiveCategory", Position = UDim2.fromOffset(-5, 10),
            Size = UDim2.fromOffset(3, 18), BackgroundColor3 = theme.orange,
            Visible = false,
        })
        round(marker, 2)
        local icons = drawTabIcon(nav, options.Icon)
        local textLabel = make("TextLabel", nav, {
            Position = UDim2.fromOffset(34, 0),
            Size = UDim2.new(1, -57, 1, 0), BackgroundTransparency = 1,
            Text = rootName, Font = Enum.Font.BuilderSansBold, TextSize = 12,
            TextColor3 = theme.soft, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        local arrow = make("Frame", nav, {
            Name = "Chevron", Position = UDim2.new(1, -22, .5, -8),
            Size = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1, Rotation = 0,
        })
        local arrowPieces = {}
        for _, spec in ipairs({
            {7, 6, 45}, {7, 10, -45},
        }) do
            local stroke = make("Frame", arrow, {
                AnchorPoint = Vector2.new(.5, .5),
                Position = UDim2.fromOffset(spec[1], spec[2]),
                Size = UDim2.fromOffset(8, 2), Rotation = spec[3],
                BackgroundColor3 = theme.muted,
            })
            round(stroke, 1)
            table.insert(arrowPieces, stroke)
        end
        entry = {
            name = rootName, button = nav, parts = icons,
            marker = marker, label = textLabel, arrow = arrow,
            arrowParts = arrowPieces, children = {}, childIndex = {},
        }
        tabs[rootName] = entry
        table.insert(navigationOrder, entry)
        if not selected then
            selected = rootName
            expandedCategory = rootName
        end
        connect(nav.MouseEnter, function()
            if selected ~= rootName then animate(nav, {BackgroundColor3 = theme.field}, .2) end
        end)
        connect(nav.MouseLeave, function()
            if selected ~= rootName then animate(nav, {BackgroundColor3 = theme.sidebar}, .2) end
        end)
        connect(nav.Activated, function()
            closeDetails()
            selected, selectedSubsection = rootName, nil
            expandedCategory = expandedCategory == rootName and nil or rootName
            if search.Text ~= "" then search.Text = "" end
            scrolling.CanvasPosition = Vector2.zero
            refreshRows()
            animatePageChange()
            layoutNavigation(false)
        end)
        layoutNavigation(true)
    end
    local currentGroup
    function tab:Section(opts)
        order = order + 1
        local frame = make("Frame", scrolling, {
            Name = "Section", Size = UDim2.new(1, -12, 0, 0),
            BackgroundColor3 = theme.card, Visible = false,
        })
        round(frame, 10)
        border(frame, theme.line, .75)
        make("UIPadding", frame, {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
        make("UIListLayout", frame, {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
        local headingRow = make("Frame", frame, {Name = "SectionHeading", LayoutOrder = 0,
            Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1})
        local heading = make("TextLabel", headingRow, {
            Position = UDim2.fromOffset(4, 0), Size = UDim2.new(1, -38, 1, 0),
            BackgroundTransparency = 1, Text = opts.Title, Font = Enum.Font.BuilderSansBold,
            TextSize = 12, TextColor3 = theme.white, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        local summary = make("TextButton", frame, {Name = "SettingsSummary", LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
            Text = "Open settings", Font = Enum.Font.BuilderSans, TextSize = 11,
            TextColor3 = theme.muted, TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false, Visible = false})
        local subName = (navigationSectionMap[name] or {})[opts.Title] or opts.Title
        ensureNavSubsection(entry, subName)
        currentGroup = {
            frame = frame, name = opts.Title:lower(),
            displayName = opts.Title, tab = name, root = rootName,
            subsection = subName, heading = heading,
            headingRow = headingRow, summary = summary,
        }
        table.insert(groups, currentGroup)
    end
    local function row(opts, height, detail)
        if not currentGroup then tab:Section({Title = name}) end
        if detail then
            if not currentGroup.details then
                local group = currentGroup
                group.details = make("Frame", detailScroll, {
                    Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, Visible = false,
                })
                make("UIListLayout", group.details, {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
                table.insert(detailGroups, group.details)
                local settingsButton = make("ImageButton", group.headingRow, {
                    Name = "OpenSettings", Position = UDim2.new(1, -28, 0, 1),
                    Size = UDim2.fromOffset(28, 28), BackgroundColor3 = theme.field,
                    Image = tabIconAssets.settings, ImageColor3 = theme.soft,
                    ScaleType = Enum.ScaleType.Fit, AutoButtonColor = false,
                })
                -- Keep the icon inset without changing the hit area.
                settingsButton.Image = ""
                make("ImageLabel", settingsButton, {Position = UDim2.fromOffset(6, 6),
                    Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
                    Image = tabIconAssets.settings, ImageColor3 = theme.soft})
                round(settingsButton, 7)
                hover(settingsButton, theme.field)
                connect(settingsButton.Activated, function() openDetails(group) end)
                connect(group.summary.Activated, function() openDetails(group) end)
            end
            currentGroup.detailNames = (currentGroup.detailNames or "") .. " " .. opts.Title:lower()
            currentGroup.detailCount = (currentGroup.detailCount or 0) + 1
            refreshRows()
            order = order + 1
            local f = make("Frame", currentGroup.details, {
                LayoutOrder = order, Size = UDim2.new(1, 0, 0, height or 42),
                BackgroundColor3 = theme.card, BackgroundTransparency = 0,
            })
            round(f, 6)
            return f
        end
        order = order + 1
        local f = make("Frame", currentGroup.frame, {
            LayoutOrder = order, Size = UDim2.new(1, 0, 0, height or 44),
            BackgroundColor3 = theme.field, BackgroundTransparency = .28, BorderSizePixel = 0,
        })
        round(f, 6)
        connect(f:GetPropertyChangedSignal("Size"), function() queueLayout() end)
        table.insert(rows, {tab = name, frame = f, name = opts.Title:lower(), group = currentGroup})
        refreshRows()
        return f
    end
    function tab:Status(opts)
        local f = row(opts, 62)
        local heading = label(f, opts.Title, 20)
        heading.Position = UDim2.fromOffset(12, 3)
        heading.TextColor3 = theme.soft
        heading.TextSize = 10
        return make("TextLabel", f, {
            Position = UDim2.fromOffset(12, 25), Size = UDim2.new(1, -24, 0, 31),
            BackgroundTransparency = 1, Text = opts.Value or "Waiting for a shot...",
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextColor3 = theme.white, Font = Enum.Font.BuilderSansMedium,
            TextSize = 11,
        })
    end
    function tab:MultiSelect(opts)
        local f = row(opts, 52)
        f.ClipsDescendants = true
        label(f, opts.Title, 120)
        local expand = button(f, "")
        expand.Name = "MultiSelectExpand"
        expand.Position = UDim2.new(1, -100, 0, 8)
        expand.Size = UDim2.fromOffset(88, 28)
        local caption = make("TextLabel", expand, {
            Name = "ExpandCaption", Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1,
            Text = "Select", TextColor3 = theme.white, TextSize = 11,
            Font = Enum.Font.BuilderSansBold,
        })
        local arrow = make("Frame", expand, {
            Name = "ExpandArrow", AnchorPoint = Vector2.new(1, .5),
            Position = UDim2.new(1, -10, .5, 0), Size = UDim2.fromOffset(12, 10),
            BackgroundTransparency = 1,
        })
        for _, side in ipairs({-1, 1}) do
            local line = make("Frame", arrow, {AnchorPoint = Vector2.new(.5, .5),
                Position = UDim2.new(.5, side * 2.5, .5, 0),
                Size = UDim2.fromOffset(8, 2), Rotation = -side * 45,
                BackgroundColor3 = theme.soft})
            round(line, 1)
        end
        local expanded = false
        local activeTween
        connect(expand.Activated, function()
            expanded = not expanded
            caption.Text = expanded and "Close" or "Select"
            animate(arrow, {Rotation = expanded and 180 or 0}, .18)
            if activeTween then activeTween:Cancel() end
            activeTween = TweenService:Create(f, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, -4, 0, expanded and 198 or 52)})
            activeTween:Play()
        end)
        local choices = make("ScrollingFrame", f, {
            Position = UDim2.fromOffset(8, 53), Size = UDim2.new(1, -16, 1, -58),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
            CanvasSize = UDim2.fromOffset(0, 0),
        })
        local choiceConnections = {}
        local function refreshChoices()
        for _, connection in ipairs(choiceConnections) do connection:Disconnect() end
        table.clear(choiceConnections)
        for _, child in ipairs(choices:GetChildren()) do child:Destroy() end
        local items = opts.ItemsProvider and opts.ItemsProvider() or opts.Items or {}
        choices.CanvasSize = UDim2.fromOffset(0, #items * 37)
        for i, entry in ipairs(items) do
            local choice = make("TextButton", choices, {
                Position = UDim2.fromOffset(0, (i-1)*37), Size = UDim2.new(1, -4, 0, 31),
                BackgroundColor3 = theme.hover, BorderSizePixel = 0, AutoButtonColor = false,
                Font = Enum.Font.BuilderSansMedium, TextSize = 12, TextColor3 = theme.white,
                TextTruncate = Enum.TextTruncate.AtEnd,
            })
            round(choice, 7)
            local function paint(animated)
                local selected = opts.Get(entry[1])
                choice.Text = (selected and "✓  " or "    ") .. entry[2]
                local color = selected and Color3.fromRGB(125, 37, 54) or theme.hover
                if animated then TweenService:Create(choice, TweenInfo.new(.15), {BackgroundColor3 = color}):Play()
                else choice.BackgroundColor3 = color end
            end
            paint(false)
            table.insert(choiceConnections, choice.Activated:Connect(function()
                opts.Set(entry[1], not opts.Get(entry[1])); paint(true)
            end))
        end
        end
        refreshChoices()
        connect(f.Destroying, function()
            for _, connection in ipairs(choiceConnections) do connection:Disconnect() end
            table.clear(choiceConnections)
        end)
        return {Refresh = refreshChoices, Frame = f}
    end
    function tab:Toggle(opts)
        local hasBindButton = (desktopKeybinds or mobileKeybinds) and type(opts.OnBindClick) == "function"
        local f = row(opts, 46)
        local titleLabel = label(f, opts.Title, 66)
        titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        titleLabel.Position = UDim2.fromOffset(9, 5)
        titleLabel.Size = UDim2.new(1, hasBindButton and -108 or -62, 0, 36)
        local bindButton
        if hasBindButton then
            bindButton = make("TextButton", f, {
                Position = UDim2.new(1, -98, 0, 11), Size = UDim2.fromOffset(42, 24),
                BackgroundColor3 = theme.hover, BorderSizePixel = 0,
                Text = "—", Font = Enum.Font.BuilderSansBold,
                TextSize = 9, TextColor3 = theme.soft, AutoButtonColor = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
            })
            round(bindButton, 7)
            connect(bindButton.Activated, function() opts.OnBindClick() end)
        end
        local track = make("TextButton", f, {
            Name = "ToggleSwitch", Position = UDim2.new(1, -50, 0, 5), Size = UDim2.fromOffset(44, 36),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        })
        local trackVisual = make("Frame", track, {Name = "Track",
            Position = UDim2.fromOffset(2, 7), Size = UDim2.fromOffset(40, 22),
            BackgroundColor3 = theme.hover})
        round(trackVisual, 11)
        local knob = make("Frame", trackVisual, {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(3, 3),
            BackgroundColor3 = theme.white, BorderSizePixel = 0,
        })
        round(knob, 9)
        local value = opts.Value == true
        local trackTween, knobTween
        local function paint(animated)
            local color = value and theme.orange or theme.hover
            local position = UDim2.fromOffset(value and 21 or 3, 3)
            if trackTween then trackTween:Cancel() end
            if knobTween then knobTween:Cancel() end
            if animated then
                trackTween = TweenService:Create(trackVisual, TweenInfo.new(.18), {BackgroundColor3 = color})
                knobTween = TweenService:Create(knob, TweenInfo.new(.18), {Position = position})
                trackTween:Play()
                knobTween:Play()
            else
                trackVisual.BackgroundColor3 = color
                knob.Position = position
            end
        end
        paint(false)
        local controller = {}
        function controller:Get() return value end
        function controller:Set(nextValue)
            nextValue = nextValue == true
            if value == nextValue then return end
            value = nextValue
            paint(true)
            opts.Callback(value)
        end
        function controller:UpdateBind(keyName, capturing, pinned)
            if not bindButton then return end
            bindButton.Text = capturing and "..." or (keyName or "—")
            TweenService:Create(bindButton, TweenInfo.new(.2), {
                BackgroundColor3 = (capturing or (mobileKeybinds and pinned)) and theme.orange or theme.hover,
                TextColor3 = capturing and theme.white or (keyName and theme.white or theme.soft),
            }):Play()
        end
        controller:UpdateBind(opts.BindName, false, opts.MobilePinned)
        connect(track.Activated, function() controller:Set(not value) end)
        return controller
    end
    function tab:Button(opts)
        local f = row(opts)
        label(f, opts.Title)
        connect(button(f, opts.ButtonText or "Open").Activated, function() opts.Callback() end)
    end
    function tab:Slider(opts)
        local f = row(opts, 76, true)
        label(f, opts.Title)
        local value = opts.Value.Default
        local min, max, step = opts.Value.Min, opts.Value.Max, opts.Step or 1
        local field = make("TextBox", f, {
            Position = UDim2.new(1, -85, 0, 9), Size = UDim2.fromOffset(72, 27),
            BackgroundColor3 = theme.hover, BorderSizePixel = 0, ClearTextOnFocus = false,
            Text = tostring(value), TextSize = 11, TextColor3 = theme.white, Font = Enum.Font.BuilderSans,
        })
        round(field, 7)
        local track = make("TextButton", f, {
            Position = UDim2.fromOffset(16, 44), Size = UDim2.new(1, -32, 0, 24),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        })
        local rail = make("Frame", track, {Position = UDim2.new(0, 0, .5, -2), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = theme.hover, BorderSizePixel = 0})
        round(rail, 2)
        local fill = make("Frame", rail, {Size = UDim2.fromScale((value-min)/(max-min), 1), BackgroundColor3 = theme.orange, BorderSizePixel = 0})
        round(fill, 2)
        local knob = make("Frame", rail, {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale((value-min)/(max-min), .5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = theme.white, BorderSizePixel = 0})
        round(knob, 6)
        local function set(v)
            value = math.clamp(min + math.floor((v-min)/step + .5)*step, min, max)
            field.Text = string.format("%.2f", value):gsub("0+$", ""):gsub("%.$", "")
            fill.Size = UDim2.fromScale((value-min)/(max-min), 1)
            knob.Position = UDim2.fromScale((value-min)/(max-min), .5)
            opts.Callback(value)
        end
        connect(field.FocusLost, function() set(tonumber(field.Text) or value) end)
        local pointer
        local function setX(x) if track.AbsoluteSize.X > 0 then set(min + math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X, 0, 1)*(max-min)) end end
        connect(track.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                pointer = input; detailScroll.ScrollingEnabled = false; scrolling.ScrollingEnabled = false; setX(input.Position.X)
            end
        end)
        connect(UserInputService.InputChanged, function(input)
            if pointer and (input == pointer or input.UserInputType == Enum.UserInputType.MouseMovement) then setX(input.Position.X) end
        end)
        connect(UserInputService.InputEnded, function(input)
            if input == pointer then pointer = nil; detailScroll.ScrollingEnabled = true; scrolling.ScrollingEnabled = true end
        end)
    end
    function tab:Dropdown(opts)
        local f = row(opts, 76, true)
        local heading = label(f, opts.Title, 24)
        heading.Position = UDim2.fromOffset(12, 3)
        local b = button(f, tostring(opts.Value))
        b.Position = UDim2.fromOffset(10, 34)
        b.Size = UDim2.new(1, -20, 0, 32)
        b.TextTruncate = Enum.TextTruncate.AtEnd
        local index = table.find(opts.Values, opts.Value) or 1
        connect(b.Activated, function()
            index = index % #opts.Values + 1
            b.Text = opts.Values[index]
            opts.Callback(opts.Values[index])
        end)
    end
    function tab:Colorpicker(opts)
        local f = row(opts, 128, true)
        f.ClipsDescendants = true
        local heading = label(f, opts.Title, 20)
        heading.Position = UDim2.fromOffset(10, 3)
        heading.Size = UDim2.new(1, -20, 0, 26)
        local value = opts.Default
        local field = make("TextBox", f, {
            Position = UDim2.fromOffset(10, 32), Size = UDim2.new(1, -20, 0, 24),
            BackgroundColor3 = theme.hover, BorderSizePixel = 0, ClearTextOnFocus = false,
            Text = "#" .. value:ToHex(), TextColor3 = theme.white, TextSize = 11, Font = Enum.Font.BuilderSans,
        })
        round(field, 6)
        local syncPalette = function() end
        connect(field.FocusLost, function()
            local hex = field.Text:gsub("#", "")
            if #hex == 6 and hex:match("^%x+$") then value = Color3.fromHex(hex); opts.Callback(value) end
            field.Text = "#" .. value:ToHex()
            syncPalette()
        end)
        local palette = make("Frame", f, {
            Position = UDim2.fromOffset(10, 62), Size = UDim2.new(1, -20, 0, 24),
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        for i, color in ipairs({Color3.fromRGB(245,125,43),Color3.fromRGB(245,70,80),Color3.fromRGB(0,200,100),Color3.fromRGB(80,180,255),Color3.fromRGB(245,245,245)}) do
            local swatch = make("TextButton", palette, {Position = UDim2.new((i-1)/5, 0, 0, 0), Size = UDim2.new(.2, -5, 1, 0), BackgroundColor3 = color, BorderSizePixel = 0, Text = ""})
            round(swatch, 6)
            connect(swatch.Activated, function() value = color; field.Text = "#" .. color:ToHex(); syncPalette(); opts.Callback(color) end)
        end
        local expand = button(f, "Palette")
        expand.Position = UDim2.new(1, -82, 0, 92)
        expand.Size = UDim2.fromOffset(72, 26)
        local sample = make("Frame", f, {
            Position = UDim2.fromOffset(10, 96), Size = UDim2.fromOffset(22, 18),
            BackgroundColor3 = value,
        })
        round(sample, 5)
        local hint = label(f, "Custom color", 96)
        hint.Position = UDim2.fromOffset(40, 91)
        hint.TextColor3 = theme.soft
        hint.TextSize = 10
        local sv = make("TextButton", f, {
            Position = UDim2.fromOffset(10, 132), Size = UDim2.new(1, -20, 0, 110),
            Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.new(1, 0, 0),
            ClipsDescendants = true,
        })
        round(sv, 6)
        local white = make("Frame", sv, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1,1,1)})
        make("UIGradient", white, {Name = "CVStaticGradient", Transparency = NumberSequence.new(0, 1)})
        local black = make("Frame", sv, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0,0,0)})
        make("UIGradient", black, {Name = "CVStaticGradient", Rotation = 90, Transparency = NumberSequence.new(1, 0)})
        local cursor = make("TextLabel", sv, {
            AnchorPoint = Vector2.new(.5,.5), Size = UDim2.fromOffset(16,16),
            BackgroundTransparency = 1, Text = "○", TextColor3 = theme.white,
            TextStrokeTransparency = .3, TextSize = 20, ZIndex = 3,
        })
        local hue = make("TextButton", f, {
            Position = UDim2.fromOffset(10, 252), Size = UDim2.new(1, -20, 0, 18),
            Text = "", BackgroundColor3 = Color3.new(1,1,1), AutoButtonColor = false,
        })
        round(hue, 5)
        local stops = {}
        for i = 0, 6 do table.insert(stops, ColorSequenceKeypoint.new(i/6, Color3.fromHSV(i/6,1,1))) end
        make("UIGradient", hue, {Name = "CVStaticGradient", Color = ColorSequence.new(stops)})
        local hueCursor = make("Frame", hue, {
            AnchorPoint = Vector2.new(.5,0), Size = UDim2.fromOffset(3,18),
            BackgroundColor3 = theme.white,
        })
        local h, saturation, brightness = value:ToHSV()
        local function paintPalette()
            value = Color3.fromHSV(h, saturation, brightness)
            sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            sample.BackgroundColor3 = value
            cursor.Position = UDim2.fromScale(saturation, 1-brightness)
            hueCursor.Position = UDim2.fromScale(h, 0)
            field.Text = "#" .. value:ToHex()
        end
        syncPalette = function()
            h, saturation, brightness = value:ToHSV()
            paintPalette()
        end
        syncPalette()
        local expanded, expansionTween = false, nil
        connect(expand.Activated, function()
            expanded = not expanded
            expand.Text = expanded and "Close" or "Palette"
            if expansionTween then expansionTween:Cancel() end
            expansionTween = TweenService:Create(f, TweenInfo.new(.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, 0, 0, expanded and 282 or 128)})
            expansionTween:Play()
        end)
        local pointer, surface
        local function pick(position)
            local size, origin = surface.AbsoluteSize, surface.AbsolutePosition
            local x = math.clamp((position.X-origin.X)/math.max(1,size.X),0,1)
            if surface == hue then h = x
            else
                saturation = x
                brightness = 1-math.clamp((position.Y-origin.Y)/math.max(1,size.Y),0,1)
            end
            paintPalette()
        end
        for _, target in ipairs({sv, hue}) do
            connect(target.InputBegan, function(input)
                if expanded and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    pointer, surface = input, target
                    detailScroll.ScrollingEnabled = false
                    pick(input.Position)
                end
            end)
        end
        connect(UserInputService.InputChanged, function(input)
            if pointer and (input == pointer or input.UserInputType == Enum.UserInputType.MouseMovement) then pick(input.Position) end
        end)
        connect(UserInputService.InputEnded, function(input)
            if input == pointer then
                pointer = nil
                detailScroll.ScrollingEnabled = true
                opts.Callback(value)
            end
        end)
    end
    function tab:TextInput(opts)
        local f = row(opts, 76)
        local heading = label(f, opts.Title, 24)
        heading.Position = UDim2.fromOffset(12, 3)
        local field = make("TextBox", f, {
            Position = UDim2.fromOffset(10, 34), Size = UDim2.new(1, -20, 0, 32),
            BackgroundColor3 = theme.hover, Text = opts.Value or "",
            PlaceholderText = opts.Placeholder or "Name", TextColor3 = theme.white,
            PlaceholderColor3 = theme.muted, ClearTextOnFocus = false,
            TextSize = 12, Font = Enum.Font.BuilderSans, TextXAlignment = Enum.TextXAlignment.Left,
        })
        round(field, 7)
        make("UIPadding", field, {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9)})
        border(field, theme.line, .6)
        connect(field.FocusLost, function() opts.Callback(field.Text) end)
        return field
    end
    refreshRows()
    return tab
end
return window
end


local function initializeCVortexUI()
local HttpService = game:GetService("HttpService")
local configPath = "CVortex/player_esp_beta.json"
local configStore = {configs = {}, selected = "Default", autoload = "Default"}
local uiSetters = {}
local keybindToggleRegistry = {}
local coreBindOrder = {
{id = "CV3_AimEnabled", title = "Aimbot"},
{id = "CV3_SilentAimEnabled", title = "Silent Aim"},
{id = "CV3_PlayerESP", title = "Player ESP"},
{id = "CV_SelfChams", title = "Self Chams"},
{id = "CV_PlayerChams", title = "Player Chams"},
{id = "CV7_MonsterESP", title = "Monster ESP"},
{id = "CV8_ContainerESP", title = "Container ESP"},
{id = "CV_Freecam", title = "Freecam"},
{id = "CV_Wings", title = "Wings"},
{id = "CV_TungTungSahur", title = "Tung Tung Sahur"},
{id = "CV_Trail", title = "Trail"},
{id = "CV_Footsteps", title = "Footsteps"},
{id = "CV_JumpCircles", title = "Jump Circles"},
{id = "CV_PlayerList", title = "Player List"},
{id = "CV7_Xray", title = "X-Ray"},
{id = "CV7_InfiniteJump", title = "Infinite Jump"},
}
local coreBindAllowed = {}
for _, item in ipairs(coreBindOrder) do coreBindAllowed[item.id] = true end

local captureBinding = nil
local refreshKeybindPanel = function() end
local refreshKeybindButtons = function() end
local configStatus = function() end
local configListRefresh = function() end
local applyingConfig = false
local function encodeSettings()
local data = {}
for key, value in pairs(S) do
if key ~= "HighlightedPlayers" and key ~= "HighlightedMonsters" then
if typeof(value) == "Color3" then data[key] = "#" .. value:ToHex()
elseif type(value) == "table" then
local copy = {}
for k, v in pairs(value) do copy[k] = v end
data[key] = copy
else data[key] = value end
end
end
return data
end
local defaultSettings = encodeSettings()
local function persistConfigs()
if type(writefile) ~= "function" then return false end
local ok = pcall(function()
if type(makefolder) == "function" then pcall(makefolder, "CVortex") end
writefile(configPath, HttpService:JSONEncode(configStore))
end)
return ok
end
local function applySettings(data)
if type(data) ~= "table" then return end
applyingConfig = true
if data.Keybinds == nil then table.clear(S.Keybinds) end
table.clear(S.AimIgnoredPlayers)
currentTarget = nil
silentAimPoint, silentTargetName = nil, nil
for key, current in pairs(S) do
local value = data[key]
if value ~= nil and key ~= "HighlightedPlayers" and key ~= "HighlightedMonsters" then
if typeof(current) == "Color3" and type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then
S[key] = Color3.fromHex(value:sub(2))
elseif key == "Keybinds" and type(value) == "table" then
table.clear(current)
local used = {}
for _, bind in ipairs(coreBindOrder) do
local keyName = value[bind.id]
if type(keyName) == "string" and not used[keyName]
and keyName ~= "Unknown" and keyName ~= "Delete"
and keyName ~= "Escape" and keyName ~= "Backspace"
and keyName ~= "RightShift" then
local valid, code = pcall(function() return Enum.KeyCode[keyName] end)
if valid and code and code ~= Enum.KeyCode.Unknown then
current[bind.id] = keyName
used[keyName] = true
end
end
end
elseif key == "AimIgnoredPlayers" and type(value) == "table" then
for id, username in pairs(value) do
if type(id) == "string" and id:match("^%d+$") and #id <= 20
and type(username) == "string" and #username > 0 and #username <= 32 then
current[id] = username
end
end
elseif key == "MobilePins" and type(value) == "table" then
table.clear(current)
for id, pinned in pairs(value) do
if coreBindAllowed[id] and pinned == true then current[id] = true end
end
elseif type(current) == "table" and type(value) == "table" then
for item in pairs(current) do if type(value[item]) == "boolean" then current[item] = value[item] end end
elseif type(current) == type(value) and type(current) ~= "table" then S[key] = value end
end
end
for key, setter in pairs(uiSetters) do pcall(setter, S[key]) end
applyingConfig = false
setFreecam(S.Freecam)
refreshPlayerProfile()
refreshAllESP()
if S.MonsterESP then task.spawn(refreshMonsterESP) else clearMonsterESP() end
updateXray()
updateEnvironment()
refreshSkybox()
refreshSnow()
refreshChinaHat()
motionVisuals.refresh()
motionVisuals.sahur.refresh()
refreshCharacterTransparency()
if mainWindow then
mainWindow:SetTransparency(S.MenuTransparency)
if mainWindow.SetSize then mainWindow:SetSize(S.MenuWidth, S.MenuHeight) end
end
updateOverlay()
updateCounter()
if performanceHud then performanceHud.Visible = true end
if not S.AimEnabled then stopAim()
elseif overlay.Enabled then startAim("toggle") end
refreshKeybindButtons()
refreshKeybindPanel()
end
local function saveActiveConfig()
if applyingConfig then return end
configStore.configs[configStore.selected] = encodeSettings()
persistConfigs()
end
motionVisuals.save = saveActiveConfig
if type(readfile) == "function" then
local ok, value = pcall(function() return HttpService:JSONDecode(readfile(configPath)) end)
if ok and type(value) == "table" and type(value.configs) == "table" then
configStore.configs = value.configs
if type(value.selected) == "string" then configStore.selected = value.selected end
if type(value.autoload) == "string" then configStore.autoload = value.autoload end
end
end
if configStore.autoload and configStore.configs[configStore.autoload] then
configStore.selected = configStore.autoload
applySettings(configStore.configs[configStore.autoload])
end
connect(UserInputService.InputBegan, function(input, processed)
if not alive or not desktopKeybinds then return end
if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
local key = input.KeyCode
if captureBinding then
if key == Enum.KeyCode.Unknown then return end
local id = captureBinding
captureBinding = nil
if key == Enum.KeyCode.Delete or key == Enum.KeyCode.Backspace then
S.Keybinds[id] = nil
saveActiveConfig()
elseif key ~= Enum.KeyCode.Escape and key ~= Enum.KeyCode.RightShift then
for other, name in pairs(S.Keybinds) do
if name == key.Name then S.Keybinds[other] = nil end
end
S.Keybinds[id] = key.Name
saveActiveConfig()
end
refreshKeybindButtons()
refreshKeybindPanel()
return
end
if processed or UserInputService:GetFocusedTextBox() then return end
if key == Enum.KeyCode.Unknown then return end
for _, bind in ipairs(coreBindOrder) do
if S.Keybinds[bind.id] == key.Name then
local controller = keybindToggleRegistry[bind.id]
if controller then controller:Set(not controller:Get()) end
break
end
end
end)
refreshKeybindButtons = function()
for id, controller in pairs(keybindToggleRegistry) do
if coreBindAllowed[id] then
controller:UpdateBind(S.Keybinds[id], captureBinding == id, S.MobilePins[id])
end
end
end

local function launchMenu()
local windowOk, windowError = pcall(function()
table.clear(keybindToggleRegistry)
captureBinding = nil
local window = createCustomMenu()
window.OnResizeSaved = saveActiveConfig
mainWindow = window
local createTab = window.Tab
function window:Tab(options)
local tab = createTab(self, options)
for _, method in ipairs({"Toggle", "Slider", "Dropdown", "Colorpicker", "MultiSelect"}) do
local original = tab[method]
tab[method] = function(self, opts)
if opts.Callback then
local callback = opts.Callback
opts.Callback = function(value)
callback(value)
saveActiveConfig()
if method == "Toggle" then refreshKeybindPanel() end
end
elseif opts.Set then
local setter = opts.Set
opts.Set = function(key, value) setter(key, value); saveActiveConfig() end
end
if method == "Toggle" and (desktopKeybinds or mobileKeybinds) and coreBindAllowed[opts.Flag] then
local id = opts.Flag or (options.Title .. ":" .. opts.Title)
opts.BindName = S.Keybinds[id]
opts.MobilePinned = S.MobilePins[id]
opts.OnBindClick = function()
if mobileKeybinds then
S.MobilePins[id] = not S.MobilePins[id] or nil
saveActiveConfig()
refreshKeybindButtons()
refreshKeybindPanel()
else
captureBinding = (captureBinding == id) and nil or id
refreshKeybindButtons()
refreshKeybindPanel()
end
end
local controller = original(self, opts)
keybindToggleRegistry[id] = controller
controller.Title = opts.Title
refreshKeybindPanel()
return controller
end
return original(self, opts)
end
end
return tab
end
local visuals = window:Tab({Title = "ESP", Icon = "eye"})
visuals:Section({Title = "Player Highlights"})
visuals:Toggle({
Title = "Player ESP (others)", Value = S.ESP, Flag = "CV3_PlayerESP",
Callback = function(value)
S.ESP = value == true
refreshAllESP()
end,
})
visuals:Toggle({
Title = "Local Player ESP (self)", Value = S.LocalESP, Flag = "CV3_LocalESP",
Callback = function(value)
S.LocalESP = value == true
refreshESP(LocalPlayer)
end,
})

visuals:Section({Title = "Offscreen Arrows"})
visuals:Toggle({
Title = "Offscreen Arrows", Value = S.OffscreenArrows,
Flag = "CV_OffscreenArrows",
Callback = function(value) S.OffscreenArrows = value == true end,
})
visuals:Toggle({
Title = "Only when offscreen", Value = S.OffscreenOnly,
Flag = "CV_OffscreenOnly",
Callback = function(value) S.OffscreenOnly = value == true end,
})
visuals:Slider({
Title = "Arrow size", Value = {Min = 20, Max = 72, Default = S.OffscreenArrowSize},
Step = 1, Flag = "CV_OffscreenArrowSize",
Callback = function(value)
S.OffscreenArrowSize = math.clamp(tonumber(value) or 42, 20, 72)
end,
})
visuals:Slider({
Title = "Arrow distance from center",
Value = {Min = 55, Max = 300, Default = S.OffscreenArrowRadius},
Step = 5, Flag = "CV_OffscreenArrowRadius",
Callback = function(value)
S.OffscreenArrowRadius = math.clamp(tonumber(value) or 115, 55, 300)
end,
})
visuals:Dropdown({
Title = "Arrow image", Values = {"Auto", "White", "Purple", "Red"},
Value = S.OffscreenArrowColorMode,
Flag = "CV_OffscreenArrowColorMode",
Callback = function(value)
local name = type(value) == "table" and value[1] or value
if name == "Auto" or name == "White" or name == "Purple" or name == "Red" then
S.OffscreenArrowColorMode = name
end
end,
})

visuals:Section({Title = "Chams"})
visuals:Toggle({Title = "Self Chams", Value = S.SelfChams, Flag = "CV_SelfChams",
Callback = function(v) S.SelfChams = v == true; refreshAllESP() end})
visuals:Colorpicker({Title = "Self Chams color", Default = S.SelfChamsColor,
Callback = function(v) S.SelfChamsColor = v; refreshAllESP() end})
visuals:Toggle({Title = "Player Chams", Value = S.PlayerChams, Flag = "CV_PlayerChams",
Callback = function(v) S.PlayerChams = v == true; refreshAllESP() end})
visuals:Colorpicker({Title = "Player Chams color", Default = S.PlayerChamsColor,
Callback = function(v) S.PlayerChamsColor = v; refreshAllESP() end})
visuals:Section({Title = "Player info and range"})
visuals:Toggle({
Title = "Weapon ESP", Value = S.WeaponESP, Flag = "CVBeta_WeaponESP",
Callback = function(value)
S.WeaponESP = value == true
refreshAllESP()
end,
})
visuals:Colorpicker({
Title = "Weapon ESP color", Default = S.WeaponESPColor, Flag = "CVBeta_WeaponColor",
Callback = function(value)
if typeof(value) == "Color3" then S.WeaponESPColor = value end
end,
})
visuals:Toggle({
Title = "Skeleton ESP", Value = S.SkeletonESP, Flag = "CVBeta_SkeletonESP",
Callback = function(value) S.SkeletonESP = value == true end,
})
visuals:Colorpicker({
Title = "Skeleton color", Default = S.SkeletonColor, Flag = "CVBeta_SkeletonColor",
Callback = function(value)
if typeof(value) == "Color3" then S.SkeletonColor = value end
end,
})
visuals:Slider({
Title = "Skeleton thickness", Value = {Min = 1, Max = 5, Default = S.SkeletonThickness},
Step = .5, Flag = "CVBeta_SkeletonThickness",
Callback = function(value)
S.SkeletonThickness = math.clamp(tonumber(value) or 2, 1, 5)
end,
})
visuals:Toggle({Title = "Box ESP", Value = S.BoxESP,
Callback = function(value) S.BoxESP = value == true; refreshAllESP() end})
visuals:Toggle({Title = "Fill box", Value = S.FillBox,
Callback = function(value) S.FillBox = value == true end})
visuals:Colorpicker({Title = "Fill box color", Default = S.BoxFillColor, Flag = "CVBeta_BoxFillColor",
Callback = function(value) if typeof(value) == "Color3" then S.BoxFillColor = value end end})
visuals:Toggle({Title = "ESP wall colors", Value = S.ESPWallColors,
Callback = function(v) S.ESPWallColors = v == true; refreshAllESP() end})
visuals:Colorpicker({Title = "Visible enemy color", Default = S.VisibleColor,
Callback = function(v) S.VisibleColor = v; refreshAllESP() end})
visuals:Colorpicker({Title = "Enemy behind wall color", Default = S.HiddenColor,
Callback = function(v) S.HiddenColor = v; refreshAllESP() end})
visuals:Toggle({
Title = "HP text (vertical)", Value = S.PlayerHealth, Flag = "CVBeta_PlayerHealth",
Callback = function(value) S.PlayerHealth = value == true; refreshAllESP() end,
})
visuals:Toggle({
Title = "HP bar (vertical)", Value = S.PlayerHealthBar, Flag = "CVBeta_PlayerHealthBar",
Callback = function(value) S.PlayerHealthBar = value == true end,
})
visuals:Toggle({
Title = "Player distance", Value = S.PlayerDistance, Flag = "CVBeta_PlayerDistance",
Callback = function(value) S.PlayerDistance = value == true; refreshAllESP() end,
})
visuals:Slider({
Title = "Player ESP range (studs)", Step = 50,
Value = {Min = 50, Max = 5000, Default = S.PlayerRange}, Flag = "CVBeta_PlayerRange",
Callback = function(value)
S.PlayerRange = math.clamp(tonumber(value) or 500, 50, 5000)
refreshAllESP()
end,
})
visuals:Toggle({Title = "Player tracers", Value = S.Tracers,
Callback = function(v) S.Tracers = v == true end})
visuals:Toggle({Title = "Tracer wall check", Value = S.TracerWallCheck,
Callback = function(v) S.TracerWallCheck = v == true; refreshAllESP() end})
visuals:Dropdown({Title = "Tracer origin", Values = {"Top", "Bottom"}, Value = S.TracerOrigin,
Callback = function(v) S.TracerOrigin = v end})
visuals:Section({Title = "Player Colors"})
visuals:Colorpicker({
Title = "Player Fill Color", Default = S.Fill, Flag = "CV3_PlayerFill",
Callback = function(value)
if typeof(value) == "Color3" then
S.Fill = value
refreshAllESP()
end
end,
})
visuals:Colorpicker({
Title = "Player Outline Color", Default = S.Outline, Flag = "CV3_PlayerOutline",
Callback = function(value)
if typeof(value) == "Color3" then
S.Outline = value
refreshAllESP()
end
end,
})
visuals:Section({Title = "Local Colors"})
visuals:Colorpicker({
Title = "Local Fill Color", Default = S.LocalFill, Flag = "CV3_LocalFill",
Callback = function(value)
if typeof(value) == "Color3" then
S.LocalFill = value
refreshESP(LocalPlayer)
end
end,
})
visuals:Colorpicker({
Title = "Local Outline Color", Default = S.LocalOutline, Flag = "CV3_LocalOutline",
Callback = function(value)
if typeof(value) == "Color3" then
S.LocalOutline = value
refreshESP(LocalPlayer)
end
end,
})
visuals:Section({Title = "Appearance"})
visuals:Slider({
Title = "Fill Transparency",
Value = {Min = 0, Max = 1, Default = S.FillTransparency}, Step = 0.05,
Flag = "CV3_FillTransparency",
Callback = function(value)
S.FillTransparency = math.clamp(tonumber(value) or 0.55, 0, 1)
refreshAllESP()
end,
})
visuals:Slider({
Title = "Outline Transparency",
Value = {Min = 0, Max = 1, Default = S.OutlineTransparency}, Step = 0.05,
Flag = "CV3_OutlineTransparency",
Callback = function(value)
S.OutlineTransparency = math.clamp(tonumber(value) or 0, 0, 1)
refreshAllESP()
end,
})
visuals:Section({Title = "Performance"})
visuals:Toggle({
Title = "Low CPU Mode (recommended)", Value = S.LowCPUMode, Flag = "CVBeta_LowCPU",
Callback = function(value)
S.LowCPUMode = value == true
end,
})
visuals:Section({Title = "Monster ESP"})
visuals:Toggle({
Title = "Monster ESP", Value = S.MonsterESP, Flag = "CV7_MonsterESP",
Callback = function(value)
S.MonsterESP = value == true
if S.MonsterESP then task.spawn(refreshMonsterESP) else clearMonsterESP() end
end,
})
visuals:Slider({
Title = "Monster ESP Distance",
Value = {Min = 100, Max = 1600, Default = S.MonsterRange},
Step = 50, Flag = "CV7_MonsterRange",
Callback = function(value)
S.MonsterRange = math.clamp(tonumber(value) or 650, 100, 1600)
if S.MonsterESP then refreshMonsterESP() end
end,
})
visuals:Toggle({
Title = "Player Counter", Value = S.PlayerCounter, Flag = "CV7_PlayerCounter",
Callback = function(value)
S.PlayerCounter = value == true
updateCounter()
end,
})
visuals:Colorpicker({
Title = "Monster Fill", Default = S.MonsterFill, Flag = "CV7_MonsterFill",
Callback = function(value)
if typeof(value) == "Color3" then S.MonsterFill = value; if S.MonsterESP then task.spawn(refreshMonsterESP) end end
end,
})
visuals:Section({Title = "X-Ray"})
visuals:Toggle({
Title = "X-Ray Walls", Value = S.Xray, Flag = "CV7_Xray",
Callback = function(value)
S.Xray = value == true
updateXray()
end,
})
visuals:Slider({
Title = "Wall Transparency", Value = {Min = 0.2, Max = 0.95, Default = S.XrayTransparency},
Step = 0.05, Flag = "CV7_XrayTransparency",
Callback = function(value)
S.XrayTransparency = math.clamp(tonumber(value) or 0.68, 0.2, 0.95)
if S.Xray then resetXray(); updateXray() end
end,
})

local visualFx = window:Tab({Title = "Visuals", Icon = "sun"})
visualFx:Section({Title = "Snowfall"})
visualFx:Toggle({
Title = "Falling snowflakes", Value = S.SnowEnabled, Flag = "CVBeta_Snow",
Callback = function(value) S.SnowEnabled = value == true; refreshSnow() end,
})
visualFx:Slider({
Title = "Snowflake size",
Value = {Min = .08, Max = .9, Default = S.SnowSize}, Step = .02,
Flag = "CVBeta_SnowSize",
Callback = function(value)
S.SnowSize = math.clamp(tonumber(value) or .24, .08, .9)
if S.SnowEnabled then refreshSnow() end
end,
})
visualFx:Slider({
Title = "Spawn frequency (flakes/sec)",
Value = {Min = 3, Max = 80, Default = S.SnowRate}, Step = 1,
Flag = "CVBeta_SnowRate",
Callback = function(value)
S.SnowRate = math.clamp(tonumber(value) or 26, 3, 80)
if S.SnowEnabled then refreshSnow() end
end,
})
visualFx:Slider({
Title = "Fade / disappear time (sec)",
Value = {Min = 2, Max = 9, Default = S.SnowLifetime}, Step = .5,
Flag = "CVBeta_SnowLifetime",
Callback = function(value)
S.SnowLifetime = math.clamp(tonumber(value) or 5, 2, 9)
if S.SnowEnabled then refreshSnow() end
end,
})
visualFx:Section({Title = "Brainrots"})
visualFx:Toggle({Title="Brainrot Morph",Value=S.Brainrots,Flag="CV_Brainrots",
Callback=function(value)
S.Brainrots=value==true
motionVisuals.sahur.failedCharacter=nil
motionVisuals.sahur.refresh()
end})
visualFx:Dropdown({Title="Brainrot model",
Values={"Tung Tung Sahur","Tralalero Tralala",
"Bombardiro Crocodilo"},
Value=S.BrainrotChoice, Flag="CV_BrainrotChoice",
Callback=function(value)
S.BrainrotChoice=value
motionVisuals.sahur.failedCharacter=nil
if S.Brainrots then motionVisuals.sahur.refresh() end
end})
motionVisuals.sahur.label=visualFx:Status({Title="Model status",Value=motionVisuals.sahur.message})
visualFx:Slider({Title="Brainrot size",Value={Min=.5,Max=2,Default=S.SahurSize},Step=.05,
Callback=function(value) S.SahurSize=math.clamp(value,.5,2); motionVisuals.sahur.resize() end})
visualFx:Slider({Title="Brainrot rotation",Value={Min=-180,Max=180,Default=S.SahurRotation},Step=15,
Callback=function(value) S.SahurRotation=math.clamp(value,-180,180) end})
visualFx:Section({Title = "Character cosmetics"})
visualFx:Slider({Title = "Character transparency (%)",
Value = {Min = 0, Max = 100, Default = S.CharacterTransparency*100}, Step = 5,
Callback = function(value)
S.CharacterTransparency = math.clamp(value/100,0,1)
refreshCharacterTransparency()
end})

visualFx:Toggle({
Title = "ChainHat (ChinaHat)", Value = S.ChinaHat, Flag = "CVBeta_ChinaHat",
Callback = function(value)
S.ChinaHat = value == true
refreshChinaHat()
end,
})

visualFx:Colorpicker({
Title = "China Hat color", Default = S.ChinaHatColor, Flag = "CVBeta_ChinaHatColor",
Callback = function(value)
if typeof(value) ~= "Color3" then return end
S.ChinaHatColor = value
refreshChinaHat()
end,
})
visualFx:Slider({
Title = "China Hat size", Value = {Min = .5, Max = 2, Default = S.ChinaHatSize}, Step = .05,
Flag = "CVBeta_ChinaHatSize",
Callback = function(value)
S.ChinaHatSize = math.clamp(tonumber(value) or 1, .5, 2)
if not hatResizeQueued then
hatResizeQueued = true
task.delay(.08, function()
hatResizeQueued = false
if alive and S.ChinaHat then refreshChinaHat() end
end)
end
end,
})

visualFx:Section({Title = "Motion effects"})
for _, effect in ipairs({
{key="Trail", title="Trail", color="TrailColor", size="TrailSize", min=.2, max=3},
{key="Footsteps", title="Footsteps", color="FootstepColor", size="FootstepSize", min=.5, max=2},
{key="JumpCircles", title="Jump Circles", color="JumpCircleColor", size="JumpCircleSize", min=.5, max=3},
}) do
local spec = effect
visualFx:Toggle({Title=spec.title,Value=S[spec.key],Flag="CV_"..spec.key,
Callback=function(value) S[spec.key]=value==true; motionVisuals.refresh() end})
visualFx:Colorpicker({Title=spec.title.." color",Default=S[spec.color],
Callback=function(value) S[spec.color]=value; motionVisuals.refresh() end})
visualFx:Slider({Title=spec.title.." size",Value={Min=spec.min,Max=spec.max,Default=S[spec.size]},Step=.1,
Callback=function(value) S[spec.size]=math.clamp(value,spec.min,spec.max); motionVisuals.refresh() end})
end
visualFx:Slider({Title="Trail lifetime",Value={Min=.2,Max=2,Default=S.TrailLifetime},Step=.1,
Callback=function(value) S.TrailLifetime=math.clamp(value,.2,2); motionVisuals.refresh() end})

visualFx:Section({Title = "Bullet Tracers"})
bulletTracerHistory.label=visualFx:Status({Title="Shot detection",Value=bulletTracerHistory.message})
visualFx:Toggle({
Title = "Bullet Tracers (local shots)",
Value = S.BulletTracers, Flag = "CVBeta_BulletTracers",
Callback = function(value)
S.BulletTracers = value == true
if not S.BulletTracers then clearBulletTracers() end
end,
})
visualFx:Colorpicker({
Title = "Tracer color", Default = S.BulletTracerColor,
Flag = "CVBeta_BulletTracerColor",
Callback = function(value)
if typeof(value) == "Color3" then S.BulletTracerColor = value end
end,
})
visualFx:Slider({
Title = "Bullet tracer width",
Value = {Min = .02, Max = .6, Default = S.BulletTracerWidth},
Step = .02, Flag = "CVBeta_BulletTracerWidth",
Callback = function(value)
S.BulletTracerWidth = math.clamp(tonumber(value) or .1, .02, .6)
end,
})
visualFx:Slider({
Title = "Tracer fade time",
Value = {Min = .08, Max = 2, Default = S.BulletTracerLifetime},
Step = .04, Flag = "CVBeta_BulletTracerLifetime",
Callback = function(value)
S.BulletTracerLifetime = math.clamp(tonumber(value) or .25, .08, 2)
end,
})
visualFx:Slider({
Title = "Tracer max distance",
Value = {Min = 50, Max = 2000, Default = S.BulletTracerDistance},
Step = 50, Flag = "CVBeta_BulletTracerDistance",
Callback = function(value)
S.BulletTracerDistance = math.clamp(tonumber(value) or 800, 50, 2000)
end,
})

visualFx:Section({Title = "Player List"})
visualFx:Toggle({Title="Player List",Value=S.PlayerList,Flag="CV_PlayerList",
Callback=function(value) S.PlayerList=value==true; motionVisuals.refresh() end})
visualFx:Slider({Title="Player List width",Value={Min=240,Max=800,Default=S.PlayerListWidth},Step=10,
Callback=function(value) S.PlayerListWidth=math.clamp(value,240,800); motionVisuals.layout() end})
visualFx:Slider({Title="Player List height",Value={Min=130,Max=740,Default=S.PlayerListHeight},Step=10,
Callback=function(value) S.PlayerListHeight=math.clamp(value,130,740); motionVisuals.layout() end})

local containers = window:Tab({Title = "Containers", Icon = "box"})
containers:Section({Title = "Container ESP"})
containers:Toggle({
Title = "Container ESP", Value = S.ContainerESP, Flag = "CV8_ContainerESP",
Callback = function(value)
S.ContainerESP = value == true
beginContainerScan()
end,
})
containers:MultiSelect({
Title = "Container types",
Items = {{"Dresser", "Dresser / drawers"}, {"Nightstand", "Nightstand"},
{"Backpack", "Backpack"}, {"KitchenCabinet", "Kitchen cabinet"},
{"Fridge", "Fridge"}, {"Locker", "Locker"}, {"SupplyDrop", "Supply Drop"}, {"Other", "Other containers"}},
Get = function(kind)
if kind == "Other" then return S.ContainerOther end
return S.ContainerTypes[kind] == true
end,
Set = function(kind, value)
if kind == "Other" then S.ContainerOther = value else S.ContainerTypes[kind] = value end
if S.ContainerESP then beginContainerScan() end
end,
})
containers:Section({Title = "Labels and range"})
containers:Toggle({
Title = "Names", Value = S.ContainerNames, Flag = "CV8_ContainerNames",
Callback = function(value) S.ContainerNames = value == true end,
})
containers:Toggle({
Title = "Distance", Value = S.ContainerDistance, Flag = "CV8_ContainerDistance",
Callback = function(value) S.ContainerDistance = value == true end,
})
containers:Slider({
Title = "ESP range (studs)", Step = 50,
Value = {Min = 100, Max = 1000, Default = S.ContainerRange},
Flag = "CV8_ContainerRange",
Callback = function(value)
S.ContainerRange = math.clamp(tonumber(value) or 500, 100, 1000)
end,
})
local environment = visualFx
environment:Section({Title = "Visibility"})
environment:Toggle({
Title = "No Fog", Value = S.NoFog, Flag = "CV7_NoFog",
Callback = function(value)
S.NoFog = value == true
updateEnvironment()
end,
})
local skyTab = window:Tab({Title = "Skyboxes", Icon = "cloud"})
skyTab:Section({Title = "Client-side sky presets"})
local skyToggle
skyToggle = skyTab:Toggle({
Title = "Enable custom sky", Value = S.SkyboxEnabled, Flag = "CV_SkyboxEnabled",
Callback = function(value)
S.SkyboxEnabled = value == true
refreshSkybox()
end,
})
local function chooseSkybox(value)
if type(value) ~= "string" then return end
S.SkyboxPreset = value
if value == "Default" then
restoreSkybox()
return
end
if not S.SkyboxEnabled then
if skyToggle and skyToggle.Set then skyToggle:Set(true)
else S.SkyboxEnabled = true; refreshSkybox() end
else
refreshSkybox()
end
end
skyTab:Section({Title = "Solid colors"})
skyTab:Dropdown({
Title = "Color / Default",
Values = skyboxColorNames,
Value = table.find(skyboxColorNames, S.SkyboxPreset) and S.SkyboxPreset or "Default",
Flag = "CV_SkyboxColorSelect",
Callback = chooseSkybox,
})
skyTab:Colorpicker({
Title = "Custom solid sky color", Default = S.SkyboxColor, Flag = "CV_SkyboxCustomColor",
Callback = function(value)
if typeof(value) ~= "Color3" then return end
S.SkyboxColor = value
chooseSkybox("Custom Color")
end,
})
skyTab:Section({Title = "Cosmos / space"})
skyTab:Dropdown({
Title = "Space skyboxes",
Values = skyboxSpaceNames,
Value = table.find(skyboxSpaceNames, S.SkyboxPreset) and S.SkyboxPreset or skyboxSpaceNames[1],
Flag = "CV_SkyboxSpace",
Callback = chooseSkybox,
})
skyTab:Section({Title = "Sky / weather / rainbow"})
skyTab:Dropdown({
Title = "Atmospheric skyboxes",
Values = skyboxAtmosphereNames,
Value = table.find(skyboxAtmosphereNames, S.SkyboxPreset) and S.SkyboxPreset or skyboxAtmosphereNames[1],
Flag = "CV_SkyboxWeather",
Callback = chooseSkybox,
})
skyTab:Section({Title = "Memes / anime / games"})
skyTab:Dropdown({
Title = "Fun skyboxes",
Values = skyboxOtherNames,
Value = table.find(skyboxOtherNames, S.SkyboxPreset) and S.SkyboxPreset or skyboxOtherNames[1],
Flag = "CV_SkyboxMemes",
Callback = chooseSkybox,
})
skyTab:Section({Title = "Quick search"})
skyTab:TextInput({
Title = "Find skybox by name",
Placeholder = "Type Galaxy, White, Amogus...",
Value = "",
Callback = function(value)
local query = tostring(value or ""):lower():match("^%s*(.-)%s*$")
if query == "" then return end
local match = nil
for _, list in ipairs({skyboxColorNames, skyboxSpaceNames, skyboxAtmosphereNames, skyboxOtherNames}) do
for _, name in ipairs(list) do
if name:lower() == query then match = name; break end
if not match and name:lower():find(query, 1, true) then match = name end
end
if match and match:lower() == query then break end
end
if match then
chooseSkybox(match)
saveActiveConfig()
else
skyboxReport("Skybox not found: " .. query)
end
end,
})
skyboxStatusLabel = skyTab:Status({Title = "Sky status", Value = skyboxStatusText})
skyTab:Section({Title = "Toolbox model ID"})
skyTab:TextInput({
Title = "Load your own Skybox model ID",
Placeholder = "Creator Store Model ID", Value = S.SkyboxCustomID or "",
Callback = function(value)
local id = tostring(value or ""):match("(%d+)")
if not id or #id > 20 then
skyboxReport("Enter a valid Creator Store model ID")
return
end
S.SkyboxCustomID = id
chooseSkybox("Custom Toolbox")
saveActiveConfig()
end,
})
if S.SkyboxEnabled and S.SkyboxPreset ~= "Default" then refreshSkybox() end

local aimTab = window:Tab({Title = "Aimbot", Icon = "crosshair"})
aimTab:Section({Title = "Main"})
aimTab:Toggle({
Title = UserInputService.MouseEnabled and "Enable Aimbot (hold RMB)" or "Enable Aimbot", Value = S.AimEnabled, Flag = "CV3_AimEnabled",
Callback = function(value)
S.AimEnabled = value == true
if not S.AimEnabled then stopAim()
else startAim("toggle") end
updateOverlay()
end,
})
aimTab:Toggle({
Title = "Team Check (Aim + Silent)", Value = S.TeamCheck, Flag = "CVBeta_TeamCheck",
Callback = function(value)
S.TeamCheck = value == true
currentTarget = nil
silentAimPoint, silentTargetName = nil, nil
end,
})
aimTab:Section({Title = "Manual Team Check"})
local ignoredNames = {}
local function ignoredPlayerItems()
    local items, seen = {}, {}
    table.clear(ignoredNames)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local id = tostring(player.UserId)
            ignoredNames[id], seen[id] = player.Name, true
            items[#items + 1] = {id, player.DisplayName .. " (@" .. player.Name .. ")"}
        end
    end
    for id, username in pairs(S.AimIgnoredPlayers) do
        if not seen[id] then
            ignoredNames[id] = username
            items[#items + 1] = {id, "@" .. username .. " (offline)"}
        end
    end
    table.sort(items, function(a, b) return a[2]:lower() < b[2]:lower() end)
    return items
end
local ignoredList = aimTab:MultiSelect({
    Title = "Ignore players (Aim + Silent)", ItemsProvider = ignoredPlayerItems,
    Get = function(id) return S.AimIgnoredPlayers[id] ~= nil end,
    Set = function(id, selected)
        if selected then S.AimIgnoredPlayers[id] = ignoredNames[id]
        else S.AimIgnoredPlayers[id] = nil end
        currentTarget = nil
        silentAimPoint, silentTargetName = nil, nil
    end,
})
local function refreshIgnoredPlayers()
    task.defer(function()
        if alive and ignoredList.Frame.Parent then ignoredList:Refresh() end
    end)
end
local joined = Players.PlayerAdded:Connect(refreshIgnoredPlayers)
local left = Players.PlayerRemoving:Connect(refreshIgnoredPlayers)
connect(ignoredList.Frame.Destroying, function() joined:Disconnect(); left:Disconnect() end)
aimTab:Button({Title = "Clear ignored players", ButtonText = "Clear", Callback = function()
    table.clear(S.AimIgnoredPlayers)
    currentTarget = nil
    silentAimPoint, silentTargetName = nil, nil
    ignoredList:Refresh()
    saveActiveConfig()
end})
aimTab:Section({Title = "Silent Aim"})
aimTab:Toggle({
Title = "Silent Aim (beta)", Value = S.SilentAimEnabled, Flag = "CV3_SilentAimEnabled",
Callback = function(value) S.SilentAimEnabled = value == true; updateOverlay() end,
})
local silentStatus = aimTab:Status({Title = "Silent Aim status"})
local function refreshSilentStatus()
if not silentStatus.Parent then return end
local hook = silentHook
if not hook then
silentStatus.Text = "Hook unavailable. Check Delta console."
else
silentStatus.Text = string.format("Calls %d  |  Shots %d  |  Redirect %d\n%s",
hook.gunCalls or 0, hook.shots or 0, hook.redirectedShots or 0,
hook.error and "error: " .. hook.error or hook.lastReason or "waiting")
end
end
refreshSilentStatus()
local statusClock = 0
local statusConnection
statusConnection = connect(RunService.Heartbeat, function(dt)
if not silentStatus.Parent then
statusConnection:Disconnect()
return
end
statusClock = statusClock + dt
if statusClock >= .4 then
statusClock = 0
refreshSilentStatus()
end
end)
aimTab:Section({Title = "Main Aim"})
aimTab:Toggle({
Title = "Wall Check", Value = S.WallCheck, Flag = "CV3_WallCheck",
Callback = function(value)
S.WallCheck = value == true
currentTarget = nil
end,
})
aimTab:Dropdown({
Title = "Aim Part", Values = {"Head", "Body"}, Value = S.AimPart,
Flag = "CV3_AimPart",
Callback = function(value)
local option = type(value) == "table" and value[1] or value
if option == "Head" or option == "Body" then
S.AimPart = option
currentTarget = nil
end
end,
})
aimTab:Section({Title = "FOV"})
aimTab:Toggle({
Title = "Show FOV Circle", Value = S.ShowFOV, Flag = "CV3_ShowFOV",
Callback = function(value)
S.ShowFOV = value == true
updateOverlay()
end,
})
aimTab:Slider({
Title = "FOV Radius",
Value = {Min = 25, Max = 400, Default = S.FOV}, Step = 5,
Flag = "CV3_FOV",
Callback = function(value)
S.FOV = math.clamp(tonumber(value) or 145, 25, 400)
updateOverlay()
currentTarget = nil
end,
})
aimTab:Section({Title = "Silent Aim FOV (blue)"})
aimTab:Toggle({
Title = "Show Silent FOV", Value = S.ShowSilentFOV, Flag = "CV_ShowSilentFOV",
Callback = function(value) S.ShowSilentFOV = value == true; updateOverlay() end,
})
aimTab:Slider({
Title = "Silent FOV Radius",
Value = {Min = 25, Max = 500, Default = S.SilentFOV}, Step = 5,
Flag = "CV_SilentFOV",
Callback = function(value)
S.SilentFOV = math.clamp(tonumber(value) or 220, 25, 500)
updateOverlay()
end,
})
aimTab:Section({Title = "Prediction"})
aimTab:Toggle({
Title = "Prediction", Value = S.Prediction, Flag = "CV_Prediction",
Callback = function(value) S.Prediction = value == true end,
})
aimTab:Slider({
Title = "Prediction (ms)",
Value = {Min = 0, Max = 500, Default = S.PredictionMs}, Step = 10,
Flag = "CV_PredictionMs",
Callback = function(value)
S.PredictionMs = math.clamp(tonumber(value) or 120, 0, 500)
end,
})
aimTab:Section({Title = "Smooth Aim"})
aimTab:Slider({
Title = "Aim Speed",
Value = {Min = 1, Max = 20, Default = S.Speed}, Step = 1,
Flag = "CV3_AimSpeed",
Callback = function(value)
S.Speed = math.clamp(tonumber(value) or 10, 1, 20)
end,
})
aimTab:Slider({
Title = "Aim Duration (0 = unlimited)",
Value = {Min = 0, Max = 10, Default = S.Duration}, Step = 0.5,
Flag = "CV3_AimDuration",
Callback = function(value)
S.Duration = math.clamp(tonumber(value) or 0, 0, 10)
end,
})


local rageTab = window:Tab({Title = "Rage", Icon = "crosshair"})
rageTab:Section({Title = "Target HUD"})
rageTab:Toggle({
Title = "Target HUD (name, avatar, HP)", Value = S.TargetHUDEnabled,
Flag = "CVR_TargetHUD",
Callback = function(value) S.TargetHUDEnabled = value == true end,
})
rageTab:Section({Title = "Spin 360"})
rageTab:Toggle({
Title = "Spin 360 while running", Value = S.Spin360Enabled,
Flag = "CVR_Spin360",
Callback = function(value) S.Spin360Enabled = value == true end,
})
rageTab:Toggle({
Title = "Vehicle Speed Hack", Value = S.VehicleSpeedEnabled,
Flag = "CVR_VehicleSpeed",
Callback = function(value)
S.VehicleSpeedEnabled = value == true
if not S.VehicleSpeedEnabled and rageFX.restoreVehicleSpeed then rageFX.restoreVehicleSpeed() end
end,
})
rageTab:Slider({
Title = "Spin speed (1-10)", Value = {Min = 1, Max = 10, Default = S.SpinSpeed},
Step = 1, Flag = "CVR_SpinSpeed",
Callback = function(value)
S.SpinSpeed = math.clamp(tonumber(value) or 4, 1, 10)
end,
})
rageTab:Section({Title = "Vehicle Speed"})
rageTab:Slider({
Title = "Vehicle speed multiplier (1-10)",
Value = {Min = 1, Max = 10, Default = S.VehicleSpeedMult},
Step = 1, Flag = "CVR_VehicleSpeedMult",
Callback = function(value)
S.VehicleSpeedMult = math.clamp(tonumber(value) or 2, 1, 10)
end,
})
local vehicleStatus = rageTab:Status({
Title = "Vehicle boost status", Value = "Waiting for a seat..."})
local vehicleStatusClock = 0
connect(RunService.Heartbeat, function(dt)
    if not alive or not vehicleStatus.Parent then return end
    vehicleStatusClock = vehicleStatusClock + dt
    if vehicleStatusClock < .75 then return end
    vehicleStatusClock = 0
    vehicleStatus.Text = tostring(rageFX.vehicleStatus or "Waiting for a seat...")
end)
rageTab:Section({Title = "Combat Effects"})
rageTab:Toggle({
Title = "Hitmarker", Value = S.HitmarkerEnabled,
Flag = "CVR_Hitmarker",
Callback = function(value) S.HitmarkerEnabled = value == true end,
})
rageTab:Toggle({
Title = "Kill Cross (10 seconds)", Value = S.KillCrossEnabled,
Flag = "CVR_KillCross",
Callback = function(value) S.KillCrossEnabled = value == true end,
})
rageTab:Status({Title = "Hit confirmation",
Value = "Uses replicated HP changes after shots; attribution is approximate."})

local movement = window:Tab({Title = "Movement", Icon = "footprints"})
movement:Section({Title = "Freecam"})
movement:Toggle({Title = "Freecam", Value = S.Freecam, Flag = "CV_Freecam",
Callback = function(value) setFreecam(value) end})
movement:Slider({Title = "Freecam speed", Value = {Min = 5, Max = 150, Default = S.FreecamSpeed}, Step = 5,
Callback = function(value) S.FreecamSpeed = math.clamp(tonumber(value) or 40, 5, 150) end})
movement:Status({Title = "Camera controls", Value = "PC: WASD, Q/E; hold RMB to look. Mobile: buttons + swipe right side."})
movement:Section({Title = "Movement"})
movement:Toggle({
Title = "Infinite Jump", Value = S.InfiniteJump, Flag = "CV7_InfiniteJump",
Callback = function(value) S.InfiniteJump = value == true end,
})
movement:Toggle({
Title = "Auto Bhop (hold Space)", Value = S.AutoBhop,
Flag = "CVBeta_AutoBhop",
Callback = function(value) S.AutoBhop = value == true end,
})

movement:Button({
Title = "Rejoin Server", Callback = rejoinServer,
})
local settings = window:Tab({Title = "Settings", Icon = "settings"})
settings:Section({Title = "Appearance"})
settings:Slider({
Title = "Menu transparency (%)", Value = {Min = 0, Max = 85, Default = S.MenuTransparency * 100},
Step = 5, Flag = "CV_MenuTransparency",
Callback = function(value)
S.MenuTransparency = math.clamp((tonumber(value) or 0) / 100, 0, .85)
window:SetTransparency(S.MenuTransparency)
end,
})
settings:Section({Title = "Privacy"})
settings:Toggle({
Title = "Streamer Mode", Value = S.StreamerMode, Flag = "CV_StreamerMode",
Callback = function(value)
S.StreamerMode = value == true
refreshPlayerProfile()
refreshAllESP()
end,
})
settings:Section({Title = "Configs"})
local names = {}
for name in pairs(configStore.configs) do table.insert(names, {name, name}) end
table.sort(names, function(a,b) return a[1] < b[1] end)
if #names == 0 then names[1] = {"Default", "Default"} end
local function rebuildConfigMenu()
local previous = mainWindow
mainWindow = nil
if previous then previous:Destroy() end
local success = launchMenu()
if success and mainWindow then mainWindow:Reveal() end
end
local resettingAll = false
settings:Button({Title = "Reset All", ButtonText = "Reset", Callback = function()
if resettingAll then return end
resettingAll = true
captureBinding = nil
applySettings(defaultSettings)
saveActiveConfig()
task.defer(rebuildConfigMenu)
end})
settings:MultiSelect({Title = "Choose config", Items = names,
Get = function(name) return configStore.selected == name end,
Set = function(name)
if not configStore.configs[name] then return end
saveActiveConfig()
configStore.selected = name
applySettings(configStore.configs[name])
persistConfigs()
task.defer(rebuildConfigMenu)
end,
})
local configName = configStore.selected
settings:TextInput({Title = "Config name", Value = configName, Placeholder = "New config",
Callback = function(value) configName = value end})
settings:Button({Title = "Save named config", Callback = function()
local name = configName:match("^%s*(.-)%s*$")
if #name < 1 or #name > 30 or name:find("[/\\]") then return end
configStore.selected = name
saveActiveConfig()
task.defer(rebuildConfigMenu)
end})
settings:Toggle({Title = "Autoload selected config",
Value = configStore.autoload == configStore.selected,
Callback = function(value)
configStore.autoload = value and configStore.selected or nil
persistConfigs()
end})
settings:Button({Title = "Delete selected config", Callback = function()
configStore.configs[configStore.selected] = nil
if configStore.autoload == configStore.selected then configStore.autoload = nil end
configStore.selected = "Default"
persistConfigs()
task.defer(rebuildConfigMenu)
end})
if desktopKeybinds or mobileKeybinds then
settings:Toggle({
Title = "Show keybinds panel", Value = S.ShowKeybindPanel,
Flag = "CV_KeybindPanelVisible",
Callback = function(value)
S.ShowKeybindPanel = value == true
refreshKeybindPanel()
end,
})
end
settings:Button({
Title = "Unload CVortex",
Callback = cleanup,
})
window:SetTransparency(S.MenuTransparency)
end)
if not windowOk then
warn("CVortex: Menu interface error:", windowError)
if mainWindow then
local failedWindow = mainWindow
mainWindow = nil
pcall(function() failedWindow:Destroy() end)
end
return false, tostring(windowError)
end
updateOverlay()
if S.AimEnabled then startAim("toggle") end
refreshKeybindPanel()
refreshAllESP()
return true
end

-- Keep utility UI locals out of the gameplay closure's 200-register limit.
do
local function buildUtilityUI()
local function ui(className, parent, properties)
local item = Instance.new(className)
for property, value in pairs(properties) do item[property] = value end
if className == "UIStroke" then item.Enabled = false end
if item:IsA("GuiObject") then item.BorderSizePixel = 0 end
item.Parent = parent
return item
end
local orange = Color3.fromRGB(225, 67, 81)
local white = Color3.fromRGB(242, 242, 244)
local muted = Color3.fromRGB(157, 157, 166)
local panelColor = Color3.fromRGB(27, 28, 32)

local function rounded(item, radius)
ui("UICorner", item, {CornerRadius = UDim.new(0, radius)})
end
local function draggable(item, handle, onRelease)
local dragging, startInput, startPosition, moved = false, nil, nil, false
connect((handle or item).InputBegan, function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
dragging = true
moved = false
startInput = input.Position
startPosition = item.Position
end)
connect(UserInputService.InputEnded, function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then
if dragging and moved and onRelease then onRelease(item.Position) end
dragging = false
end
end)
connect(UserInputService.InputChanged, function(input)
if not dragging or not startInput or not startPosition then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement
and input.UserInputType ~= Enum.UserInputType.Touch then return end
local delta = input.Position - startInput
if delta.Magnitude < 7 and not moved then return end
moved = true
item.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end)
return function() return moved end
end

local keybindPanel
local keybindPanelWidth = (tonumber(S.KeybindPanelWidth) or 0) > 0
and math.clamp(S.KeybindPanelWidth, 200, 470)
or (mobileKeybinds and 236 or 258)
if desktopKeybinds or mobileKeybinds then
keybindPanel = ui("Frame", overlay, {
Name = "CVortexKeybinds",
Position = UDim2.fromOffset(S.KeybindPanelX,
mobileKeybinds and math.max(96, S.KeybindPanelY) or S.KeybindPanelY),
Size = UDim2.fromOffset(keybindPanelWidth, 86),
BackgroundColor3 = Color3.fromRGB(69, 71, 75),
BorderSizePixel = 0, Active = true,
Visible = S.ShowKeybindPanel, ZIndex = 5,
})
rounded(keybindPanel, 8)
ui("UIGradient", keybindPanel, {
Rotation = 12,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(61, 63, 67)),
ColorSequenceKeypoint.new(.55, Color3.fromRGB(77, 79, 83)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(94, 96, 101)),
}),
})
local header = ui("TextButton", keybindPanel, {
Name = "DragHeader",
Position = UDim2.fromOffset(0, 0),
Size = UDim2.new(1, 0, 0, 32),
BackgroundTransparency = 1,
Text = mobileKeybinds and "  QUICK BINDS   ·   DRAG"
or "  KEYBINDS   ·   DRAG",
TextXAlignment = Enum.TextXAlignment.Left,
TextColor3 = white, Font = Enum.Font.GothamBold,
TextSize = 11, AutoButtonColor = false,
Active = true, ZIndex = 6,
})
local help = ui("TextLabel", keybindPanel, {
Position = UDim2.fromOffset(9, 29),
Size = UDim2.new(1, -18, 0, 16),
BackgroundTransparency = 1,
Text = mobileKeybinds and "Pin a function in its menu"
or "Tap a key to rebind · Delete to clear",
TextColor3 = muted, TextXAlignment = Enum.TextXAlignment.Left,
Font = Enum.Font.Gotham, TextSize = 9, ZIndex = 6,
})
local items = ui("ScrollingFrame", keybindPanel, {
Position = UDim2.fromOffset(8, 48),
Size = UDim2.new(1, -16, 1, -54),
BackgroundTransparency = 1, BorderSizePixel = 0,
ScrollBarThickness = 2,
ScrollBarImageColor3 = Color3.fromRGB(168, 173, 182),
CanvasSize = UDim2.fromOffset(0, 0),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
ZIndex = 6,
})
ui("UIListLayout", items, {
SortOrder = Enum.SortOrder.LayoutOrder,
Padding = UDim.new(0, 3),
})
local emptyLabel = ui("TextLabel", items, {
LayoutOrder = 99, Size = UDim2.new(1, -6, 0, 25),
BackgroundTransparency = 1, TextColor3 = muted,
Text = mobileKeybinds and "No pinned features" or "No assigned keys",
Font = Enum.Font.GothamMedium, TextSize = 10, ZIndex = 7,
TextXAlignment = Enum.TextXAlignment.Center,
})
local panelRows = {}
for index, bind in ipairs(coreBindOrder) do
local id = bind.id
local row = ui("TextButton", items, {
Name = id, LayoutOrder = index,
Size = UDim2.new(1, -4, 0, 27),
BackgroundColor3 = Color3.fromRGB(72, 74, 79),
BackgroundTransparency = .12,
BorderSizePixel = 0, Visible = false,
Text = "", AutoButtonColor = false, ZIndex = 6,
})
rounded(row, 5)
local label = ui("TextLabel", row, {
Position = UDim2.fromOffset(7, 0),
Size = UDim2.new(1, -116, 1, 0),
BackgroundTransparency = 1,
Text = bind.title, TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
TextColor3 = white, Font = Enum.Font.GothamMedium,
TextSize = 10, ZIndex = 7,
})
local bindButton = ui("TextButton", row, {
Position = UDim2.new(1, -109, .5, -10),
Size = UDim2.fromOffset(58, 21),
BackgroundColor3 = Color3.fromRGB(90, 93, 98),
BorderSizePixel = 0,
Text = mobileKeybinds and "UNPIN" or "SET",
AutoButtonColor = false, Font = Enum.Font.GothamBold,
TextSize = 9, TextColor3 = white, ZIndex = 8,
})
rounded(bindButton, 5)
local status = ui("TextLabel", row, {
Position = UDim2.new(1, -46, 0, 0),
Size = UDim2.fromOffset(42, 27),
BackgroundTransparency = 1,
Text = "OFF", Font = Enum.Font.GothamBold,
TextSize = 9, TextColor3 = muted, ZIndex = 7,
})
panelRows[id] = {row = row, key = bindButton, status = status}
connect(row.Activated, function()
if not alive or captureBinding then return end
local controller = keybindToggleRegistry[id]
if controller then controller:Set(not controller:Get()) end
end)
connect(bindButton.Activated, function()
if not alive then return end
if mobileKeybinds then
S.MobilePins[id] = nil
saveActiveConfig()
else
captureBinding = captureBinding == id and nil or id
end
refreshKeybindButtons()
refreshKeybindPanel()
end)
end
draggable(keybindPanel, header, function(position)
local viewport = Workspace.CurrentCamera
and Workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
local x = math.clamp(position.X.Offset, 0,
math.max(0, viewport.X - keybindPanelWidth))
local minY = mobileKeybinds and 96 or 0
local y = math.clamp(position.Y.Offset, minY,
math.max(minY, viewport.Y - keybindPanel.AbsoluteSize.Y))
keybindPanel.Position = UDim2.fromOffset(x, y)
S.KeybindPanelX, S.KeybindPanelY = x, y
saveActiveConfig()
end)
refreshKeybindPanel = function()
if not keybindPanel or not keybindPanel.Parent then return end
keybindPanel.Visible = alive and S.ShowKeybindPanel
local minY = mobileKeybinds and 96 or 0
keybindPanel.Position = UDim2.fromOffset(
S.KeybindPanelX, math.max(minY, S.KeybindPanelY))
local count = 0
for _, bind in ipairs(coreBindOrder) do
local id = bind.id
local item = panelRows[id]
local controller = keybindToggleRegistry[id]
local key = S.Keybinds[id]
local enabled = controller and controller:Get() or false
local pinned = mobileKeybinds and S.MobilePins[id]
or desktopKeybinds and key
item.row.Visible = controller ~= nil and not not pinned
if item.row.Visible then count = count + 1 end
item.row.BackgroundColor3 = enabled
and Color3.fromRGB(105, 107, 113) or Color3.fromRGB(72, 74, 79)
item.key.Text = mobileKeybinds and "UNPIN"
or (captureBinding == id and "PRESS" or key or "SET")
item.key.BackgroundColor3 = captureBinding == id
and Color3.fromRGB(125, 128, 136) or Color3.fromRGB(90, 93, 98)
item.status.Text = enabled and "ON" or "OFF"
item.status.TextColor3 = enabled
and Color3.fromRGB(141, 255, 182) or muted
end
emptyLabel.Visible = count == 0
if desktopKeybinds and captureBinding then
header.Text = "  PRESS KEY   ·   ESC CANCEL"
help.Text = "Delete / Backspace removes this binding"
else
header.Text = mobileKeybinds
and "  QUICK BINDS   ·   DRAG" or "  KEYBINDS   ·   DRAG"
help.Text = mobileKeybinds and "Tap row to toggle · UNPIN to remove"
or "Tap key to rebind · Delete clears"
end
if (tonumber(S.KeybindPanelWidth) or 0) > 0 then
keybindPanelWidth=math.clamp(S.KeybindPanelWidth, 200, 470)
end
keybindPanel.Size = UDim2.fromOffset(keybindPanelWidth,
math.clamp((tonumber(S.KeybindPanelHeight) or 0) > 0
and S.KeybindPanelHeight or (78 + math.min(math.max(1, count), 7) * 30),
90, 660))
end
enableWindowResize(keybindPanel, {
minW=200, minH=90, maxW=470, maxH=660,
onResize=function(w,h)
keybindPanelWidth=w
S.KeybindPanelWidth,S.KeybindPanelHeight=w,h
keybindPanel.Size=UDim2.fromOffset(w,h)
end,
onFinish=function() saveActiveConfig() end,
})
refreshKeybindPanel()
end


draggable(counterPanel, playerCounterLabel)

performanceHud = ui("TextButton", overlay, {
Name = "CVPerformance",
Position = UDim2.fromOffset(12, UserInputService.TouchEnabled
and math.max(92, game:GetService("GuiService"):GetGuiInset().Y + 54) or 12),
Size = UDim2.fromOffset(196, 46),
BackgroundColor3 = Color3.fromRGB(16, 10, 14), BackgroundTransparency = 1,
BorderSizePixel = 0, Text = "", AutoButtonColor = false,
Active = true, Visible = true,
})
-- Use the verified transparent decal thumbnail and crop its empty canvas.
-- The artwork occupies the widget itself; no plates or fallback blobs underneath.
local bloodArt = ui("ImageLabel", performanceHud, {
Name = "CVBloodPuddle",
Position = UDim2.fromOffset(0, 0), Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1, BorderSizePixel = 0,
Image = "rbxthumb://type=Asset&id=121381990557725&w=420&h=420",
ImageRectOffset = Vector2.new(26, 123), ImageRectSize = Vector2.new(369, 174),
ImageColor3 = Color3.fromRGB(255, 255, 255),
ImageTransparency = 0, ScaleType = Enum.ScaleType.Stretch, ZIndex = 2,
Active = false, Visible = false,
})
local function syncBloodBackground()
if bloodArt.Parent then bloodArt.Visible = bloodArt.IsLoaded end
end
connect(bloodArt:GetPropertyChangedSignal("IsLoaded"), syncBloodBackground)
syncBloodBackground()
task.spawn(function()
pcall(function() game:GetService("ContentProvider"):PreloadAsync({bloodArt}) end)
if alive then syncBloodBackground() end
end)
local performanceLogo = ui("ImageLabel", performanceHud, {
Name = "LogoCV", Position = UDim2.fromOffset(3, 7),
Size = UDim2.fromOffset(28, 32), BackgroundTransparency = 1,
BorderSizePixel = 0, Image = "rbxassetid://131808762032412",
ImageColor3 = white, ScaleType = Enum.ScaleType.Fit, ZIndex = 6,
})
local performanceFallback = ui("TextLabel", performanceHud, {
Name = "LogoFallback", Position = UDim2.fromOffset(3, 8),
Size = UDim2.fromOffset(27, 30), BackgroundTransparency = 1,
Text = "CV", Font = Enum.Font.GothamBold, TextSize = 15,
TextColor3 = white, Visible = not performanceLogo.IsLoaded, ZIndex = 6
})
connect(performanceLogo:GetPropertyChangedSignal("IsLoaded"), function()
    if performanceFallback.Parent then
        performanceFallback.Visible = not performanceLogo.IsLoaded
    end
end)
task.delay(3, function()
    if performanceLogo.Parent and not performanceLogo.IsLoaded then
        performanceLogo.Image = "rbxthumb://type=Asset&id=131808762032412&w=150&h=150"
    end
end)
local function hudIcon(name, imageId, x, y)
return ui("ImageLabel", performanceHud, {
Name = name, Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(15, 15),
BackgroundTransparency = 1, Image = imageId, ImageColor3 = Color3.fromRGB(244, 105, 122),
ScaleType = Enum.ScaleType.Fit, ZIndex = 5,
})
end
hudIcon("FpsIcon", "rbxassetid://7733799969", 35, 5)
hudIcon("PingIcon", "rbxassetid://7743878148", 105, 5)
hudIcon("MemoryIcon", "rbxassetid://7733955793", 35, 25)
hudIcon("ClockIcon", "rbxassetid://7733734848", 113, 25)
local fpsText = ui("TextLabel", performanceHud, {
Position = UDim2.fromOffset(53, 3), Size = UDim2.fromOffset(49, 18),
BackgroundTransparency = 1, Text = "-- FPS", Font = Enum.Font.BuilderSansMedium,
TextSize = 10, TextColor3 = white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})
local pingText = ui("TextLabel", performanceHud, {
Position = UDim2.fromOffset(123, 3), Size = UDim2.fromOffset(69, 18),
BackgroundTransparency = 1, Text = "-- ms", Font = Enum.Font.BuilderSansMedium,
TextSize = 10, TextColor3 = white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})
local ramText = ui("TextLabel", performanceHud, {
Position = UDim2.fromOffset(53, 23), Size = UDim2.fromOffset(58, 18),
BackgroundTransparency = 1, Text = "-- MB", Font = Enum.Font.BuilderSansMedium,
TextSize = 10, TextColor3 = white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})
local clockText = ui("TextLabel", performanceHud, {
Position = UDim2.fromOffset(131, 23), Size = UDim2.fromOffset(47, 18),
BackgroundTransparency = 1, Text = "--:--", Font = Enum.Font.BuilderSansMedium,
TextSize = 10, TextColor3 = white, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})
local metricGreen = Color3.fromRGB(90, 220, 133)
local metricOrange = Color3.fromRGB(255, 177, 72)
local metricRed = Color3.fromRGB(245, 90, 100)
local discordLink = ui("ImageButton", performanceHud, {
Name = "DiscordLink", Position = UDim2.fromOffset(181, 26),
Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1,
Image = "rbxassetid://7743866903", ImageColor3 = Color3.fromRGB(249, 140, 147),
ScaleType = Enum.ScaleType.Fit, AutoButtonColor = false, ZIndex = 6,
})
connect(discordLink.Activated, function()
local clipboard = setclipboard or toclipboard
if type(clipboard) == "function" and pcall(clipboard, "https://discord.gg/ESQv2sc5p") then
discordLink.Image = "rbxassetid://7733715400"
task.delay(1.5, function()
if discordLink.Parent then discordLink.Image = "rbxassetid://7743866903" end
end)
end
end)

local hudDragged = draggable(performanceHud)
connect(performanceHud.Activated, function()
if hudDragged() then return end
if mainWindow then pcall(function() mainWindow:Toggle() end) end
end)
local stats = game:GetService("Stats")
local frames, elapsed = 0, 0
connect(RunService.RenderStepped, function(dt)
if not alive or not overlay.Enabled or not performanceHud.Visible then return end
frames, elapsed = frames + 1, elapsed + dt
if elapsed < .6 then return end
local fps = math.floor(frames / elapsed + .5)
frames, elapsed = 0, 0
local ping = "--"
local ok, value = pcall(function()
return stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
end)
if ok and type(value) == "string" then
local ms = tonumber(value:match("[%d%.]+"))
if ms then ping = tostring(math.floor(ms + .5)) end
end
fpsText.Text = string.format("%d FPS", fps)
pingText.Text = ping .. " ms"
local memOk, memMb = pcall(function() return stats:GetTotalMemoryUsageMb() end)
ramText.Text = memOk and type(memMb) == "number" and string.format("%d MB", math.floor(memMb + .5)) or "-- MB"
local clockOk, localClock = pcall(function() return DateTime.now():FormatLocalTime("HH:mm", "en-us") end)
clockText.Text = clockOk and localClock or os.date("%H:%M")
local pingMs = tonumber(ping)
local fpsColor = fps < 30 and metricRed or (fps < 60 and metricOrange or metricGreen)
local pingColor = not pingMs and white or
(pingMs < 80 and metricGreen or (pingMs < 150 and metricOrange or metricRed))
TweenService:Create(fpsText, TweenInfo.new(.2), {TextColor3 = fpsColor}):Play()
TweenService:Create(pingText, TweenInfo.new(.2), {TextColor3 = pingColor}):Play()
end)

-- The bootstrap owns authentication. Build the menu once and report its result
-- directly to that window, so an error cannot be hidden behind another key UI.
task.defer(function()
local ok, success, detail = pcall(function()
local built, buildError = launchMenu()
if not built then return false, buildError end
if not alive or not mainWindow then return false, "Menu was closed during startup" end
mainWindow:Reveal()
return true
end)
if ok and success and alive then
if onStartupComplete then onStartupComplete(true) end
else
overlay.Enabled = false
local message = tostring(ok and detail or success)
if onStartupComplete then onStartupComplete(false, message)
else reportCVortexError(message) end
end
end)
end
buildUtilityUI()
end

end
initializeCVortexUI()
end

if not game:IsLoaded() then game.Loaded:Wait() end
local supportedGame = game.GameId == 10767946926 or game.PlaceId == 133927229860262
if not supportedGame then
warn("CVortex: Эта игра не поддерживается")
local player = game:GetService("Players").LocalPlayer
if player then
local playerGui = player:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("CVortexUnsupportedGame")
if previous then previous:Destroy() end
local notice = Instance.new("ScreenGui")
notice.Name = "CVortexUnsupportedGame"
notice.ResetOnSpawn = false
notice.DisplayOrder = 10000
notice.Parent = playerGui
local card = Instance.new("Frame")
card.Name = "Message"
card.AnchorPoint = Vector2.new(.5, .5)
card.Position = UDim2.fromScale(.5, .5)
card.Size = UDim2.new(.9, 0, 0, 94)
card.BackgroundColor3 = Color3.fromRGB(29, 30, 31)
card.BorderSizePixel = 0
card.Parent = notice
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
local limit = Instance.new("UISizeConstraint")
limit.MaxSize = Vector2.new(320, 94)
limit.Parent = card
local message = Instance.new("TextLabel")
message.Name = "UnsupportedGameText"
message.Position = UDim2.fromOffset(12, 18)
message.Size = UDim2.new(1, -24, 0, 58)
message.BackgroundTransparency = 1
message.Text = "Эта игра не поддерживается"
message.TextColor3 = Color3.fromRGB(241, 242, 243)
message.Font = Enum.Font.GothamBold
message.TextSize = 16
message.TextWrapped = true
message.Parent = card
local close = Instance.new("TextButton")
close.Name = "Close"
close.Position = UDim2.new(1, -30, 0, 7)
close.Size = UDim2.fromOffset(23, 23)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextColor3 = Color3.fromRGB(191, 193, 195)
close.TextSize = 19
close.Font = Enum.Font.GothamBold
close.Parent = card
close.Activated:Connect(function() notice:Destroy() end)
end
else
local ok, err = pcall(function()
showKeyBootstrap(function(complete)
local started, failure = pcall(runCVortex, complete)
if not started then complete(false, failure) end
end)
end)
if not ok then reportCVortexError(err) end
end






