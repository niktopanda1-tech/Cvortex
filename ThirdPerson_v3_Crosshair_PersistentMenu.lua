-- Third Person v3 | Adjustable camera + crosshair | Mobile / PC
-- Standalone. Uses Roblox GUI frames for the crosshair (no Drawing API required).
-- DisplayOrder / protected GUI can keep UI above normal end-of-round fade layers.
-- Some games replace CoreGui or cover it with Core UI; that cannot be guaranteed.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
if not player then return end

local env = (type(getgenv) == "function" and getgenv()) or _G
if type(env.ThirdPersonOnlyStop) == "function" then
    pcall(env.ThirdPersonOnlyStop)
end

local cameraConfig = {
    Enabled = true,
    Distance = 7,
    Height = 0.8,
    Shoulder = 0,
}
local crosshair = {
    Enabled = true,
    Color = Color3.fromRGB(255, 128, 255),
    Thickness = 2,
    Length = 8,
    Opacity = 1,
    XOffset = 0,
    YOffset = 0,
    Recenter = true,
}

local alive = true
local stepName = "ThirdPersonOnly_V3_Camera"
local coreLinks = {}
local uiLinks = {}
local hiddenParts = {}
local lastVisibilitySync = 0
local currentTab = "Camera"
local panelOpen = false
local quickPosition = UDim2.fromOffset(12, 166)
local ui = nil
local lastViewport = nil
local fixedCenter = nil

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function connect(signal, fn, bucket)
    local c = signal:Connect(fn)
    table.insert(bucket or uiLinks, c)
    return c
end

local function disconnectAll(bucket)
    for _, c in ipairs(bucket) do pcall(function() c:Disconnect() end) end
    table.clear(bucket)
end

local C = {
    panel = Color3.fromRGB(21, 22, 25),
    button = Color3.fromRGB(36, 37, 41),
    buttonActive = Color3.fromRGB(65, 66, 72),
    edge = Color3.fromRGB(83, 85, 91),
    text = Color3.fromRGB(235, 235, 238),
    sub = Color3.fromRGB(174, 176, 182),
}

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function stroke(parent)
    local s = Instance.new("UIStroke")
    s.Thickness = 1
    s.Color = C.edge
    s.Transparency = 0.35
    s.Parent = parent
end

local function button(parent, title, x, y, w, h)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Position = UDim2.fromOffset(x, y)
    b.Size = UDim2.fromOffset(w, h)
    b.BackgroundColor3 = C.button
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.Text = title
    b.AutoButtonColor = true
    b.Active = true
    corner(b, 8)
    stroke(b)
    return b
end

local function label(parent, title, x, y, w, h, size, colour)
    local t = Instance.new("TextLabel")
    t.Parent = parent
    t.Position = UDim2.fromOffset(x, y)
    t.Size = UDim2.fromOffset(w, h)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = colour or C.text
    t.TextSize = size or 12
    t.Font = Enum.Font.GothamMedium
    t.TextXAlignment = Enum.TextXAlignment.Left
    return t
end

local function restoreParts()
    for part, original in pairs(hiddenParts) do
        if part and part.Parent then
            pcall(function() part.LocalTransparencyModifier = original end)
        end
        hiddenParts[part] = nil
    end
end

local function makeBodyVisible(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "Head"
            and part.Name ~= "HumanoidRootPart" and part.Transparency < 0.98 then
            if hiddenParts[part] == nil then
                hiddenParts[part] = part.LocalTransparencyModifier
            end
            part.LocalTransparencyModifier = 0
        end
    end
end

local function renderCamera()
    if not alive or not cameraConfig.Enabled then return end
    local cam = Workspace.CurrentCamera
    local char = player.Character
    if not cam or not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- Keep native mouse/touch look: modify the position, not the rotation.
    local base = cam.CFrame
    local focus = head.Position + Vector3.new(0, cameraConfig.Height, 0)
    local target = focus - base.LookVector * cameraConfig.Distance
        + base.RightVector * cameraConfig.Shoulder

    rayParams.FilterDescendantsInstances = { char }
    local hit = Workspace:Raycast(focus, target - focus, rayParams)
    if hit then
        target = hit.Position + hit.Normal * 0.3
    end
    cam.CFrame = CFrame.new(target) * base.Rotation

    if os.clock() - lastVisibilitySync > 0.12 then
        lastVisibilitySync = os.clock()
        makeBodyVisible(char)
    end
end
RunService:BindToRenderStep(stepName, Enum.RenderPriority.Camera.Value + 20, renderCamera)

-- Prefer a protected UI root outside PlayerGui. Many games remove/rebuild
-- PlayerGui and its overlays at round transition, but do not touch gethui().
local function guiParent()
    local options = {}
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and typeof(result) == "Instance" then
            table.insert(options, result)
        end
    end
    table.insert(options, CoreGui)
    table.insert(options, player:WaitForChild("PlayerGui"))
    return options
end

local function parentSafely(gui)
    for _, p in ipairs(guiParent()) do
        local ok = pcall(function()
            gui.Parent = p
        end)
        if ok and gui.Parent == p then return true end
    end
    return false
end

local function destroyUI()
    if ui and ui.quick and ui.quick.Parent then
        quickPosition = ui.quick.Position
    end
    disconnectAll(uiLinks)
    if ui and ui.tabLinks then disconnectAll(ui.tabLinks) end
    if ui and ui.root then
        pcall(function() ui.root:Destroy() end)
    end
    ui = nil
end

local function buildUI()
    destroyUI()
    if not alive then return end

    local root = Instance.new("ScreenGui")
    root.Name = "ThirdPersonCrosshairPersistent"
    root.ResetOnSpawn = false
    root.IgnoreGuiInset = true
    root.DisplayOrder = 1000000
    root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    root.Enabled = true
    pcall(function() root.OnTopOfCoreBlur = true end)
    if not parentSafely(root) then
        root:Destroy()
        return
    end

    local overlay = Instance.new("Frame")
    overlay.Parent = root
    overlay.Name = "CrosshairOverlay"
    overlay.Position = UDim2.fromScale(0, 0)
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.Active = false

    local center = Instance.new("Frame")
    center.Parent = overlay
    center.Name = "Center"
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Size = UDim2.fromOffset(0, 0)
    center.BackgroundTransparency = 1
    center.Active = false

    local horizontal = Instance.new("Frame")
    horizontal.Parent = center
    horizontal.Name = "Horizontal"
    horizontal.BorderSizePixel = 0
    horizontal.Active = false

    local vertical = Instance.new("Frame")
    vertical.Parent = center
    vertical.Name = "Vertical"
    vertical.BorderSizePixel = 0
    vertical.Active = false

    local quick = Instance.new("Frame")
    quick.Parent = root
    quick.Name = "Quick"
    quick.Size = UDim2.fromOffset(104, 36)
    quick.Position = quickPosition
    quick.BackgroundTransparency = 1
    quick.Active = true

    local toggle = button(quick, "", 0, 0, 65, 36)
    local settings = button(quick, "•••", 69, 0, 35, 36)

    local panel = Instance.new("Frame")
    panel.Parent = root
    panel.Name = "Settings"
    local view = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
    panel.Size = UDim2.fromOffset(300, math.min(336, math.max(210, view.Y - 16)))
    panel.BackgroundColor3 = C.panel
    panel.Active = true
    panel.Visible = panelOpen
    corner(panel, 12)
    stroke(panel)

    label(panel, "THIRD PERSON", 14, 8, 158, 29, 14)
    local minimize = button(panel, "−", 230, 9, 28, 28)
    local exit = button(panel, "×", 265, 9, 28, 28)
    exit.TextSize = 18

    local camTab = button(panel, "CAMERA", 12, 46, 134, 31)
    local crossTab = button(panel, "CROSSHAIR", 153, 46, 134, 31)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = panel
    scroll.Position = UDim2.fromOffset(12, 87)
    scroll.Size = UDim2.new(1, -24, 1, -99)
    scroll.BorderSizePixel = 0
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 2
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.CanvasSize = UDim2.fromOffset(0, 0)
    scroll.Active = true

    -- All controls are rebuilt on UI restoration; game config lives outside it.
    local tabLinks = {}

    local function numberRow(title, obj, key, y, minVal, maxVal, step, decimals)
        label(scroll, title, 4, y + 5, 115, 25, 12, C.sub)
        local minus = button(scroll, "−", 138, y + 1, 29, 29)
        local val = label(scroll, "", 175, y + 1, 55, 29, 12)
        val.TextXAlignment = Enum.TextXAlignment.Center
        val.BackgroundColor3 = C.button
        val.BackgroundTransparency = 0
        corner(val, 7)
        local plus = button(scroll, "+", 239, y + 1, 29, 29)
        local fmt = "%." .. decimals .. "f"
        local function refresh()
            val.Text = string.format(fmt, obj[key])
        end
        connect(minus.MouseButton1Click, function()
            obj[key] = math.clamp(math.floor((obj[key] - step) / step + 0.5) * step, minVal, maxVal)
            refresh()
            if ui and ui.drawCrosshair then ui.drawCrosshair() end
        end, tabLinks)
        connect(plus.MouseButton1Click, function()
            obj[key] = math.clamp(math.floor((obj[key] + step) / step + 0.5) * step, minVal, maxVal)
            refresh()
            if ui and ui.drawCrosshair then ui.drawCrosshair() end
        end, tabLinks)
        refresh()
    end

    local function switchRow(title, obj, key, y)
        label(scroll, title, 4, y + 5, 145, 25, 12, C.sub)
        local switch = button(scroll, "", 183, y + 1, 85, 29)
        local function refresh()
            switch.Text = obj[key] and "ON" or "OFF"
            switch.BackgroundColor3 = obj[key] and C.buttonActive or C.button
        end
        connect(switch.MouseButton1Click, function()
            obj[key] = not obj[key]
            if obj == cameraConfig and not obj[key] then restoreParts() end
            refresh()
            if ui and ui.drawCrosshair then ui.drawCrosshair() end
            if ui and ui.refreshQuick then ui.refreshQuick() end
        end, tabLinks)
        refresh()
    end

    local function updateCrosshair()
        if not alive then return end
        local display = crosshair.Enabled
        horizontal.Visible = display
        vertical.Visible = display
        if not display then return end

        local thick = crosshair.Thickness
        local size = crosshair.Length
        local alpha = 1 - crosshair.Opacity
        horizontal.Size = UDim2.fromOffset(size * 2, thick)
        horizontal.Position = UDim2.fromOffset(-size, -thick / 2)
        vertical.Size = UDim2.fromOffset(thick, size * 2)
        vertical.Position = UDim2.fromOffset(-thick / 2, -size)
        horizontal.BackgroundColor3 = crosshair.Color
        vertical.BackgroundColor3 = crosshair.Color
        horizontal.BackgroundTransparency = alpha
        vertical.BackgroundTransparency = alpha

        local cam = Workspace.CurrentCamera
        local viewport = cam and cam.ViewportSize or Vector2.new(800, 600)
        if crosshair.Recenter or not fixedCenter then
            fixedCenter = viewport * 0.5
            center.Position = UDim2.new(0.5, -crosshair.XOffset, 0.5, -crosshair.YOffset)
        else
            center.Position = UDim2.fromOffset(
                fixedCenter.X - crosshair.XOffset,
                fixedCenter.Y - crosshair.YOffset
            )
        end
    end

    local function showTab()
        disconnectAll(tabLinks)
        for _, child in ipairs(scroll:GetChildren()) do
            child:Destroy()
        end
        scroll.CanvasPosition = Vector2.zero
        camTab.BackgroundColor3 = currentTab == "Camera" and C.buttonActive or C.button
        crossTab.BackgroundColor3 = currentTab == "Crosshair" and C.buttonActive or C.button

        if currentTab == "Camera" then
            switchRow("Third Person", cameraConfig, "Enabled", 4)
            numberRow("Distance", cameraConfig, "Distance", 47, 3, 18, 1, 0)
            numberRow("Height", cameraConfig, "Height", 90, -1, 4, 0.5, 1)
            numberRow("Shoulder", cameraConfig, "Shoulder", 133, -3, 3, 0.5, 1)
            scroll.CanvasSize = UDim2.fromOffset(0, 187)
        else
            switchRow("Crosshair", crosshair, "Enabled", 4)

            label(scroll, "Color", 4, 48, 110, 29, 12, C.sub)
            local colors = {
                {name = "P", color = Color3.fromRGB(255, 128, 255)},
                {name = "W", color = Color3.fromRGB(255, 255, 255)},
                {name = "B", color = Color3.fromRGB(60, 145, 255)},
                {name = "R", color = Color3.fromRGB(255, 90, 90)},
                {name = "G", color = Color3.fromRGB(75, 225, 145)},
            }
            for i, option in ipairs(colors) do
                local b = button(scroll, option.name, 116 + (i - 1) * 31, 47, 27, 28)
                b.TextColor3 = option.color
                connect(b.MouseButton1Click, function()
                    crosshair.Color = option.color
                    updateCrosshair()
                end, tabLinks)
            end

            label(scroll, "HEX", 4, 84, 60, 25, 12, C.sub)
            local hex = Instance.new("TextBox")
            hex.Parent = scroll
            hex.Position = UDim2.fromOffset(138, 81)
            hex.Size = UDim2.fromOffset(130, 28)
            hex.BackgroundColor3 = C.button
            hex.TextColor3 = C.text
            hex.PlaceholderColor3 = C.sub
            hex.PlaceholderText = "#FF80FF"
            hex.Text = ""
            hex.TextSize = 12
            hex.Font = Enum.Font.GothamMedium
            hex.ClearTextOnFocus = false
            corner(hex, 7)
            connect(hex.FocusLost, function(enterPressed)
                if not enterPressed then return end
                local raw = hex.Text:gsub("#", "")
                if raw:match("^%x%x%x%x%x%x$") then
                    local ok, col = pcall(Color3.fromHex, "#" .. raw)
                    if ok and col then
                        crosshair.Color = col
                        updateCrosshair()
                    end
                end
                hex.Text = ""
            end, tabLinks)

            numberRow("Thickness", crosshair, "Thickness", 122, 1, 10, 1, 0)
            numberRow("Length", crosshair, "Length", 165, 2, 40, 1, 0)
            numberRow("Opacity", crosshair, "Opacity", 208, 0, 1, 0.1, 1)
            numberRow("X offset", crosshair, "XOffset", 251, -150, 150, 1, 0)
            numberRow("Y offset", crosshair, "YOffset", 294, -150, 150, 1, 0)
            switchRow("Auto recenter", crosshair, "Recenter", 337)
            scroll.CanvasSize = UDim2.fromOffset(0, 391)
        end
    end

    local function placePanel()
        local cam = Workspace.CurrentCamera
        local viewport = cam and cam.ViewportSize or Vector2.new(480, 800)
        local abs = quick.AbsolutePosition
        local width = panel.AbsoluteSize.X
        local height = panel.AbsoluteSize.Y
        local x = math.clamp(abs.X, 4, math.max(4, viewport.X - width - 4))
        local y = abs.Y + quick.AbsoluteSize.Y + 8
        if y + height > viewport.Y - 5 then y = abs.Y - height - 8 end
        y = math.clamp(y, 4, math.max(4, viewport.Y - height - 4))
        panel.Position = UDim2.fromOffset(x, y)
    end

    local function refreshQuick()
        toggle.Text = cameraConfig.Enabled and "3P ON" or "3P OFF"
        toggle.BackgroundColor3 = cameraConfig.Enabled and C.button or C.buttonActive
    end

    connect(camTab.MouseButton1Click, function()
        currentTab = "Camera"
        showTab()
    end)
    connect(crossTab.MouseButton1Click, function()
        currentTab = "Crosshair"
        showTab()
    end)
    connect(minimize.MouseButton1Click, function()
        panelOpen = false
        panel.Visible = false
    end)
    connect(settings.MouseButton1Click, function()
        panelOpen = not panelOpen
        panel.Visible = panelOpen
        if panelOpen then placePanel() end
    end)

    local dragInput = nil
    local dragStart = nil
    local dragFrom = nil
    local moved = false
    connect(toggle.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
            dragStart = input.Position
            dragFrom = quick.Position
            moved = false
        end
    end)
    connect(UserInputService.InputChanged, function(input)
        if not dragInput or not dragStart then return end
        if input ~= dragInput and not (
            dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        ) then return end

        local delta = input.Position - dragStart
        if delta.Magnitude > 8 then moved = true end
        if moved then
            local cam = Workspace.CurrentCamera
            local viewport = cam and cam.ViewportSize or Vector2.new(480, 800)
            local x = math.clamp(dragFrom.X.Offset + delta.X, 3, math.max(3, viewport.X - quick.AbsoluteSize.X - 3))
            local y = math.clamp(dragFrom.Y.Offset + delta.Y, 3, math.max(3, viewport.Y - quick.AbsoluteSize.Y - 3))
            quick.Position = UDim2.fromOffset(x, y)
            quickPosition = quick.Position
            if panel.Visible then placePanel() end
        end
    end)
    connect(UserInputService.InputEnded, function(input)
        if not dragInput then return end
        if input ~= dragInput and not (
            dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1
        ) then return end
        local wasClick = not moved
        dragInput = nil
        dragStart = nil
        if wasClick then
            cameraConfig.Enabled = not cameraConfig.Enabled
            if not cameraConfig.Enabled then restoreParts() end
            refreshQuick()
            if currentTab == "Camera" then showTab() end
        end
    end)

    ui = {
        root = root,
        quick = quick,
        panel = panel,
        drawCrosshair = updateCrosshair,
        refreshQuick = refreshQuick,
        placePanel = placePanel,
        tabLinks = tabLinks,
    }

    -- Exit completely, both camera override and custom crosshair.
    connect(exit.MouseButton1Click, function()
        if type(env.ThirdPersonOnlyStop) == "function" then
            env.ThirdPersonOnlyStop()
        end
    end)

    showTab()
    refreshQuick()
    updateCrosshair()
    if panelOpen then
        task.defer(function()
            if alive and ui and ui.root == root then placePanel() end
        end)
    end
end

connect(player.CharacterRemoving, restoreParts, coreLinks)
connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    if ui and ui.drawCrosshair then ui.drawCrosshair() end
end, coreLinks)

local function cleanup()
    if not alive then return end
    alive = false
    pcall(function() RunService:UnbindFromRenderStep(stepName) end)
    restoreParts()
    destroyUI()
    disconnectAll(coreLinks)
    if env.ThirdPersonOnlyStop == cleanup then
        env.ThirdPersonOnlyStop = nil
    end
end
env.ThirdPersonOnlyStop = cleanup

-- Periodically reattach/recreate the interface if a game removes its GUI.
-- No per-frame work is needed for the crosshair itself.
local elapsed = 0
connect(RunService.Heartbeat, function(dt)
    if not alive then return end
    elapsed = elapsed + dt
    if elapsed < 0.4 then return end
    elapsed = 0

    if not ui or not ui.root or not ui.root.Parent then
        buildUI()
        return
    end

    -- Keep the GUI visible above normal PlayerGui fade overlays.
    if not ui.root.Enabled then ui.root.Enabled = true end
    if ui.root.DisplayOrder ~= 1000000 then
        ui.root.DisplayOrder = 1000000
    end

    local cam = Workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize
    if viewport and (not lastViewport or viewport ~= lastViewport) then
        lastViewport = viewport
        if ui.panel then
            ui.panel.Size = UDim2.fromOffset(300, math.min(336, math.max(210, viewport.Y - 16)))
        end
        if ui.drawCrosshair then ui.drawCrosshair() end
        if panelOpen and ui.placePanel then ui.placePanel() end
    end
end, coreLinks)

buildUI()
