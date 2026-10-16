-- CVortex Graphics | standalone Roblox client-side graphics menu
-- Works as a local graphics-effects panel. The real Roblox quality setting may be protected.
-- No external UI libraries are required.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Terrain = workspace.Terrain
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local env = (type(getgenv) == "function" and getgenv()) or _G
if type(env.CVortexGraphicsUnload) == "function" then
    pcall(env.CVortexGraphicsUnload)
end

local alive = true
local connections = {}
local original = {} -- remembers only fields that we actually changed
local generation = 0
local shades = {
    bg = Color3.fromRGB(16, 17, 19),
    surface = Color3.fromRGB(27, 28, 31),
    raised = Color3.fromRGB(38, 39, 43),
    border = Color3.fromRGB(65, 66, 70),
    text = Color3.fromRGB(239, 239, 240),
    muted = Color3.fromRGB(156, 157, 161),
    accent = Color3.fromRGB(198, 199, 202),
}

local current = {
    Shadows = true,
    PostEffects = true,
    Particles = true,
    Textures = true,
    ObjectShadows = true,
    SimpleWater = false,
}

local function subscribe(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
    return connection
end

local function memorizeAndSet(inst, property, value)
    if not alive or not inst or not inst.Parent then return end
    local data = original[inst]
    if not data then
        data = {}
        original[inst] = data
    end
    if data[property] == nil then
        local ok, oldValue = pcall(function() return inst[property] end)
        if not ok then return end
        -- False is not nil in Luau, so boolean values are safe to save.
        data[property] = oldValue
    end
    pcall(function() inst[property] = value end)
end

local function revert(inst, property)
    local data = original[inst]
    if data and data[property] ~= nil then
        pcall(function() inst[property] = data[property] end)
    end
end

local function revertAll()
    for inst, data in pairs(original) do
        for property, value in pairs(data) do
            pcall(function() inst[property] = value end)
        end
    end
    table.clear(original)
end

local function handleInstance(inst)
    if not alive then return end
    if inst:IsA("PostEffect") then
        if current.PostEffects then revert(inst, "Enabled")
        else memorizeAndSet(inst, "Enabled", false) end
    elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam")
        or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles") then
        if current.Particles then revert(inst, "Enabled")
        else memorizeAndSet(inst, "Enabled", false) end
    elseif inst:IsA("Decal") or inst:IsA("Texture") then
        if current.Textures then revert(inst, "Transparency")
        else memorizeAndSet(inst, "Transparency", 1) end
    elseif inst:IsA("BasePart") then
        if current.ObjectShadows then revert(inst, "CastShadow")
        else memorizeAndSet(inst, "CastShadow", false) end
    end
end

local function applyLighting()
    if current.Shadows then revert(Lighting, "GlobalShadows")
    else memorizeAndSet(Lighting, "GlobalShadows", false) end

    for _, spec in ipairs({
        {"WaterWaveSize", 0},
        {"WaterWaveSpeed", 0},
        {"WaterReflectance", 0},
    }) do
        if current.SimpleWater then memorizeAndSet(Terrain, spec[1], spec[2])
        else revert(Terrain, spec[1]) end
    end
end

local function reapplyAll()
    generation = generation + 1
    local myGeneration = generation
    applyLighting()
    task.spawn(function()
        local instances = game:GetDescendants()
        for index, inst in ipairs(instances) do
            if not alive or myGeneration ~= generation then return end
            handleInstance(inst)
            if index % 180 == 0 then task.wait() end
        end
    end)
end

local function applyPreset(name)
    if name == "FPS" then
        current.Shadows = false
        current.PostEffects = false
        current.Particles = false
        current.Textures = false
        current.ObjectShadows = false
        current.SimpleWater = true
    elseif name == "Balanced" then
        current.Shadows = false
        current.PostEffects = false
        current.Particles = true
        current.Textures = true
        current.ObjectShadows = true
        current.SimpleWater = true
    else -- Default restores original values captured before this script changed them.
        current.Shadows = true
        current.PostEffects = true
        current.Particles = true
        current.Textures = true
        current.ObjectShadows = true
        current.SimpleWater = false
    end
    reapplyAll()
end

-- GraphicsQualityLevel is not writable by all clients / executors.
local userGameSettings
pcall(function() userGameSettings = UserSettings():GetService("UserGameSettings") end)
local savedQuality
local savedRenderQuality
pcall(function() savedRenderQuality = settings().Rendering.QualityLevel end)
if userGameSettings then
    pcall(function() savedQuality = userGameSettings.SavedQualityLevel end)
end
local selectedQuality = 5
local qualityStatus = ""
local function setNativeQuality(level)
    selectedQuality = math.clamp(math.floor(level), 1, 10)
    local ok = false
    local qualityOption = Enum.SavedQualitySetting["QualityLevel" .. tostring(selectedQuality)]
    if userGameSettings and qualityOption then
        ok = pcall(function() userGameSettings.SavedQualityLevel = qualityOption end)
    end
    if not ok then
        local rawLevel = Enum.QualityLevel["Level" .. string.format("%02d", selectedQuality)]
        if rawLevel then
            ok = pcall(function() settings().Rendering.QualityLevel = rawLevel end)
        end
    end
    qualityStatus = ok and "Applied (if permitted)" or "Roblox locked this setting"
    return ok
end

local gui = Instance.new("ScreenGui")
gui.Name = "CVortexGraphicsStandalone"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 950

local parent = PlayerGui
if type(gethui) == "function" then
    local ok, result = pcall(gethui)
    if ok and typeof(result) == "Instance" then parent = result end
end
local okParent = pcall(function() gui.Parent = parent end)
if not okParent then gui.Parent = PlayerGui end

local function rounded(parentInstance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parentInstance
    return corner
end

local function stroked(parentInstance, color)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or shades.border
    stroke.Thickness = 1
    stroke.Transparency = 0.35
    stroke.Parent = parentInstance
    return stroke
end

local function frame(parentInstance, width, height, color)
    local f = Instance.new("Frame")
    f.Size = UDim2.fromOffset(width, height)
    f.BorderSizePixel = 0
    f.BackgroundColor3 = color or shades.surface
    f.Parent = parentInstance
    return f
end

local function text(parentInstance, content, size, color, weight)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = content
    label.TextColor3 = color or shades.text
    label.Font = weight and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextSize = size or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parentInstance
    return label
end

local function button(parentInstance, title)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.BackgroundColor3 = shades.raised
    b.BorderSizePixel = 0
    b.Text = title
    b.TextSize = 13
    b.TextColor3 = shades.text
    b.Font = Enum.Font.GothamMedium
    b.Parent = parentInstance
    rounded(b, 9)
    stroked(b)
    return b
end

local function makeDraggable(root, target, allowClick)
    local started, dragInput, dragOrigin, startPos, traveled
    subscribe(root.InputBegan, function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        started, dragInput = true, input
        dragOrigin, startPos = input.Position, target.Position
        traveled = false
        local finished
        finished = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                started = false
                if finished then finished:Disconnect() end
            end
        end)
        table.insert(connections, finished)
    end)
    subscribe(root.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    subscribe(UserInputService.InputChanged, function(input)
        if started and dragInput == input and dragOrigin and startPos then
            local delta = input.Position - dragOrigin
            if delta.Magnitude > 5 then traveled = true end
            if traveled then
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    if allowClick then
        return function() return traveled end
    end
end

-- Small on-screen handle, always available when the panel is collapsed.
local handle = button(gui, "G")
handle.Name = "GraphicsButton"
handle.Size = UDim2.fromOffset(43, 43)
handle.Position = UDim2.new(1, -58, 0.5, -22)
handle.TextSize = 19
handle.Font = Enum.Font.GothamBold
handle.BackgroundColor3 = shades.bg
rounded(handle, 13)
local wasHandleDragged = makeDraggable(handle, handle, true)

local panel = frame(gui, 420, 505, shades.bg)
panel.Name = "GraphicsPanel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
rounded(panel, 15)
stroked(panel)

local header = frame(panel, 420, 64, shades.bg)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 64)
rounded(header, 15)
makeDraggable(header, panel)

local headerTitle = text(header, "GRAPHICS", 18, shades.text, true)
headerTitle.Position = UDim2.fromOffset(18, 12)
headerTitle.Size = UDim2.fromOffset(225, 24)
local subtitle = text(header, "Client graphics settings", 11, shades.muted)
subtitle.Position = UDim2.fromOffset(18, 34)
subtitle.Size = UDim2.fromOffset(225, 17)

local hide = button(header, "−")
hide.Position = UDim2.new(1, -89, 0, 16)
hide.Size = UDim2.fromOffset(30, 30)
hide.TextSize = 20
local quit = button(header, "×")
quit.Position = UDim2.new(1, -51, 0, 16)
quit.Size = UDim2.fromOffset(30, 30)
quit.TextSize = 22

local separator = frame(panel, 384, 1, shades.border)
separator.Position = UDim2.fromOffset(18, 63)
separator.Size = UDim2.new(1, -36, 0, 1)
separator.BackgroundTransparency = 0.45

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "Settings"
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = shades.border
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new()
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.Position = UDim2.fromOffset(15, 72)
scroll.Size = UDim2.new(1, -30, 1, -126)
scroll.Parent = panel

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 9)
layout.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 3)
pad.PaddingRight = UDim.new(0, 5)
pad.PaddingTop = UDim.new(0, 3)
pad.PaddingBottom = UDim.new(0, 8)
pad.Parent = scroll

local function section(titleText)
    local heading = text(scroll, titleText, 11, shades.muted, true)
    heading.Size = UDim2.new(1, -10, 0, 20)
    return heading
end

local presetButtons = {}
local function refreshToggleButtons() end
local chosenPreset = "Default"
section("PRESETS")
local presetRow = frame(scroll, 388, 45, shades.surface)
presetRow.Size = UDim2.new(1, -6, 0, 48)
rounded(presetRow, 11)
local presetNames = {"FPS", "Balanced", "Default"}
for index, name in ipairs(presetNames) do
    local b = button(presetRow, name)
    b.Size = UDim2.new(1 / 3, -10, 1, -12)
    b.Position = UDim2.new((index - 1) / 3, 6, 0, 6)
    presetButtons[name] = b
    subscribe(b.MouseButton1Click, function()
        chosenPreset = name
        applyPreset(name)
        refreshToggleButtons()
    end)
end

section("CUSTOM EFFECTS")
local toggleButtons = {}
local function addToggle(label, key)
    local row = frame(scroll, 388, 45, shades.surface)
    row.Size = UDim2.new(1, -6, 0, 46)
    rounded(row, 11)
    local name = text(row, label, 13, shades.text)
    name.Position = UDim2.fromOffset(13, 0)
    name.Size = UDim2.new(1, -114, 1, 0)
    local control = button(row, "ON")
    control.Size = UDim2.fromOffset(65, 30)
    control.Position = UDim2.new(1, -76, 0.5, -15)
    toggleButtons[key] = control
    subscribe(control.MouseButton1Click, function()
        current[key] = not current[key]
        chosenPreset = "Custom"
        reapplyAll()
        refreshToggleButtons()
    end)
end

addToggle("Global shadows", "Shadows")
addToggle("Object shadows", "ObjectShadows")
addToggle("Post-processing", "PostEffects")
addToggle("Particles / trails", "Particles")
addToggle("Decals / textures", "Textures")
addToggle("Simple water", "SimpleWater")

section("ROBLOX GRAPHICS LEVEL")
local qualityRow = frame(scroll, 388, 50, shades.surface)
qualityRow.Size = UDim2.new(1, -6, 0, 52)
rounded(qualityRow, 11)
local nativeLabel = text(qualityRow, "Quality 1–10", 13, shades.text)
nativeLabel.Position = UDim2.fromOffset(13, 4)
nativeLabel.Size = UDim2.new(0.55, 0, 0, 23)
local qualityNote = text(qualityRow, "May be locked by Roblox", 10, shades.muted)
qualityNote.Position = UDim2.fromOffset(13, 26)
qualityNote.Size = UDim2.new(0.65, 0, 0, 17)
local down = button(qualityRow, "−")
down.Size = UDim2.fromOffset(32, 32)
down.Position = UDim2.new(1, -112, 0.5, -16)
local number = text(qualityRow, "5", 14, shades.text, true)
number.Position = UDim2.new(1, -76, 0, 0)
number.Size = UDim2.fromOffset(33, 52)
number.TextXAlignment = Enum.TextXAlignment.Center
local up = button(qualityRow, "+")
up.Size = UDim2.fromOffset(32, 32)
up.Position = UDim2.new(1, -39, 0.5, -16)
local function tryQuality(delta)
    setNativeQuality(selectedQuality + delta)
    number.Text = tostring(selectedQuality)
    qualityNote.Text = qualityStatus
end
subscribe(down.MouseButton1Click, function() tryQuality(-1) end)
subscribe(up.MouseButton1Click, function() tryQuality(1) end)

section("FRAME RATE")
local fpsRow = frame(scroll, 388, 46, shades.surface)
fpsRow.Size = UDim2.new(1, -6, 0, 46)
rounded(fpsRow, 11)
local fpsLabel = text(fpsRow, "FPS limit", 13)
fpsLabel.Position = UDim2.fromOffset(13, 0)
fpsLabel.Size = UDim2.new(0.42, 0, 1, 0)
local fpsValues = {30, 60, 120, 0}
local fpsNames = {"30", "60", "120", "∞"}
local fpsIndex = 2
local fpsControl = button(fpsRow, "60")
fpsControl.Position = UDim2.new(1, -86, 0.5, -15)
fpsControl.Size = UDim2.fromOffset(74, 30)
subscribe(fpsControl.MouseButton1Click, function()
    fpsIndex = fpsIndex % #fpsValues + 1
    fpsControl.Text = fpsNames[fpsIndex]
    if type(setfpscap) == "function" then
        local ok = pcall(setfpscap, fpsValues[fpsIndex])
        if not ok then fpsControl.Text = "N/A" end
    else
        fpsControl.Text = "N/A"
    end
end)

local footer = frame(panel, 390, 41, shades.bg)
footer.BackgroundTransparency = 1
footer.Size = UDim2.new(1, -30, 0, 40)
footer.Position = UDim2.new(0, 15, 1, -44)
local status = text(footer, "Changes are local to your client", 11, shades.muted)
status.Position = UDim2.fromOffset(3, 0)
status.Size = UDim2.new(1, -6, 1, 0)

function refreshToggleButtons()
    for key, control in pairs(toggleButtons) do
        local enabled = current[key]
        control.Text = enabled and "ON" or "OFF"
        control.BackgroundColor3 = enabled and shades.border or shades.raised
        control.TextColor3 = enabled and shades.text or shades.muted
    end
    for name, control in pairs(presetButtons) do
        local selected = chosenPreset == name
        control.BackgroundColor3 = selected and shades.border or shades.raised
        control.TextColor3 = selected and shades.text or shades.muted
    end
end
refreshToggleButtons()

local function resizePanel()
    if not alive then return end
    local camera = workspace.CurrentCamera
    local vp = camera and camera.ViewportSize or Vector2.new(420, 750)
    panel.Size = UDim2.fromOffset(math.min(420, math.max(270, vp.X - 22)), math.min(505, math.max(315, vp.Y - 50)))
end
resizePanel()
subscribe(workspace:GetPropertyChangedSignal("CurrentCamera"), resizePanel)
if workspace.CurrentCamera then
    subscribe(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), resizePanel)
end

local function setPanelVisible(value)
    if not alive then return end
    panel.Visible = value
    handle.Text = value and "−" or "G"
end
subscribe(handle.MouseButton1Click, function()
    if wasHandleDragged() then return end
    setPanelVisible(not panel.Visible)
end)
subscribe(hide.MouseButton1Click, function() setPanelVisible(false) end)

local function unload()
    if not alive then return end
    alive = false
    generation = generation + 1
    for _, connection in ipairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
    revertAll()
    if savedQuality and userGameSettings then
        pcall(function() userGameSettings.SavedQualityLevel = savedQuality end)
    end
    if savedRenderQuality then
        pcall(function() settings().Rendering.QualityLevel = savedRenderQuality end)
    end
    if env.CVortexGraphicsUnload == unload then env.CVortexGraphicsUnload = nil end
    pcall(function() gui:Destroy() end)
end

env.CVortexGraphicsUnload = unload
subscribe(quit.MouseButton1Click, unload)

-- Apply client changes to later-spawned effects and models too.
subscribe(game.DescendantAdded, function(inst)
    if not alive then return end
    task.defer(function()
        if alive and inst.Parent then handleInstance(inst) end
    end)
end)

-- Starts with Roblox's current appearance, without modifying anything.
-- Use one of the preset buttons or individual settings to apply changes.
