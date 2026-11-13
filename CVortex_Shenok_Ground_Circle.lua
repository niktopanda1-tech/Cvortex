-- CVORTEX | Shenok Ground Circle
-- Optional standalone fallback for the Shenok UI. No per-frame loops.
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local player = Players.LocalPlayer
local env = (type(getgenv) == 'function' and getgenv()) or _G

if type(env.CVORTEX_GROUND_CIRCLE_UNLOAD) == 'function' then
    pcall(env.CVORTEX_GROUND_CIRCLE_UNLOAD)
end

local function findShenok()
    local parents = {player:WaitForChild('PlayerGui')}
    pcall(function()
        if type(gethui) == 'function' then
            local ui = gethui()
            if ui then table.insert(parents, ui) end
        end
    end)
    pcall(function()
        table.insert(parents, game:GetService('CoreGui'))
    end)
    for _, parent in ipairs(parents) do
        local screen = parent:FindFirstChild('CVORTEX')
        if screen and screen:IsA('ScreenGui') and screen:FindFirstChild('Main') then
            return screen
        end
    end
    return nil
end

local screen = findShenok()
if not screen then
    local ok, err = pcall(function()
        local url = 'https://shenok.niktopanda1.workers.dev/api/script'
        local execute = loadstring or load
        assert(type(execute) == 'function', 'loadstring unavailable')
        execute(game:HttpGet(url))()
    end)
    if not ok then warn('[CVORTEX] Unable to launch Shenok:', err) end
    for _ = 1, 35 do
        screen = findShenok()
        if screen then break end
        task.wait(.25)
    end
end
if not screen then
    warn('[CVORTEX] Shenok UI was not found.')
    return
end

local window = screen:FindFirstChild('Main')
if not window then return end
local oldToggle = window:FindFirstChild('GroundCircleToggle')
if oldToggle then oldToggle:Destroy() end
window.Size = UDim2.fromOffset(274, 320)
window.Position = UDim2.new(0.5, -137, 0.4, -95)

local button = Instance.new('TextButton')
button.Name = 'GroundCircleToggle'
button.Position = UDim2.fromOffset(10, 279)
button.Size = UDim2.new(1, -20, 0, 30)
button.BackgroundColor3 = Color3.fromRGB(39,39,39)
button.BorderColor3 = Color3.fromRGB(65,65,65)
button.BorderSizePixel = 1
button.Text = 'Ground Circle  [OFF]'
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansSemibold
button.TextSize = 15
button.ZIndex = 5
button.Parent = window

local state = {enabled = false, disc = nil, tween = nil, connections = {}}
local function connect(signal, callback)
    table.insert(state.connections, signal:Connect(callback))
end
local function clearCircle()
    if state.tween then
        pcall(function() state.tween:Cancel() end)
        state.tween = nil
    end
    if state.disc then
        state.disc:Destroy()
        state.disc = nil
    end
end
local function attachCircle(character)
    clearCircle()
    if not state.enabled or not screen.Parent or not character or not character.Parent then return end
    local root = character:FindFirstChild('HumanoidRootPart')
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local offset = humanoid.RigType == Enum.HumanoidRigType.R6
        and 2.9 or math.max(2.25, root.Size.Y * 0.5 + humanoid.HipHeight - 0.07)

    local disc = Instance.new('Part')
    disc.Name = 'CVORTEX_GroundCircle'
    disc.Size = Vector3.new(6, .08, 6)
    disc.Transparency = 1
    disc.CanCollide = false
    disc.CanTouch = false
    disc.CanQuery = false
    disc.Massless = true
    disc.CastShadow = false
    disc.Anchored = false
    disc.CFrame = root.CFrame * CFrame.new(0, -offset, 0)
    disc.Parent = workspace

    local weld = Instance.new('WeldConstraint')
    weld.Part0 = root
    weld.Part1 = disc
    weld.Parent = disc

    local surface = Instance.new('SurfaceGui')
    surface.Name = 'GroundCircleSurface'
    surface.Adornee = disc
    surface.Face = Enum.NormalId.Top
    surface.AlwaysOnTop = false
    surface.LightInfluence = 0
    surface.MaxDistance = 300
    surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    surface.PixelsPerStud = 80
    surface.Parent = disc

    local image = Instance.new('ImageLabel')
    image.Name = 'RotatingCircle'
    image.BackgroundTransparency = 1
    image.Position = UDim2.fromScale(0, 0)
    image.Size = UDim2.fromScale(1, 1)
    image.Image = 'rbxassetid://79169556966872'
    image.ImageTransparency = 0
    image.ScaleType = Enum.ScaleType.Fit
    image.Rotation = 0
    image.Parent = surface

    state.disc = disc
    state.tween = TweenService:Create(image,
        TweenInfo.new(18, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0),
        {Rotation = 360})
    state.tween:Play()
end
local function refreshCircle()
    clearCircle()
    if not state.enabled then return end
    local character = player.Character
    if not character then return end
    task.spawn(function()
        local root = character:WaitForChild('HumanoidRootPart', 8)
        local humanoid = character:WaitForChild('Humanoid', 8)
        if state.enabled and screen.Parent and character == player.Character
            and root and humanoid then
            attachCircle(character)
        end
    end)
end
connect(button.Activated, function()
    state.enabled = not state.enabled
    button.Text = state.enabled and 'Ground Circle  [ON]' or 'Ground Circle  [OFF]'
    refreshCircle()
end)
connect(player.CharacterAdded, function(character)
    if not state.enabled then return end
    task.spawn(function()
        local root = character:WaitForChild('HumanoidRootPart', 8)
        local humanoid = character:WaitForChild('Humanoid', 8)
        if state.enabled and screen.Parent and player.Character == character
            and root and humanoid then attachCircle(character) end
    end)
end)
connect(player.CharacterRemoving, clearCircle)
local function unload()
    state.enabled = false
    clearCircle()
    for _, c in ipairs(state.connections) do pcall(function() c:Disconnect() end) end
    state.connections = {}
    if button.Parent then button:Destroy() end
    if env.CVORTEX_GROUND_CIRCLE_UNLOAD == unload then
        env.CVORTEX_GROUND_CIRCLE_UNLOAD = nil
    end
end
connect(screen.Destroying, unload)
env.CVORTEX_GROUND_CIRCLE_UNLOAD = unload
