-- ==========================================
-- DELTA EXECUTOR STYLE - TPs V2 + HITBOX + FARM OP
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpiar UIs anteriores si existen
pcall(function()
    if CoreGui:FindFirstChild("DeltaTPHub") then CoreGui.DeltaTPHub:Destroy() end
    if CoreGui:FindFirstChild("DeltaToggleBtn") then CoreGui.DeltaToggleBtn:Destroy() end
    if CoreGui:FindFirstChild("DeltaLoadingGui") then CoreGui.DeltaLoadingGui:Destroy() end
end)

-- ==========================================
-- 0. PANTALLA DE CARGA (1/3, 2/3, 3/3 - 1 SEGUNDO CADA UNO)
-- ==========================================
local LoadingGui = Instance.new("ScreenGui", CoreGui)
LoadingGui.Name = "DeltaLoadingGui"
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local LoadFrame = Instance.new("Frame", LoadingGui)
LoadFrame.Size = UDim2.new(0, 280, 0, 95)
LoadFrame.Position = UDim2.new(0.5, -140, 0.5, -47)
LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
LoadFrame.BorderSizePixel = 0

local lcc = Instance.new("UICorner", LoadFrame)
lcc.CornerRadius = UDim.new(0, 10)
local lcs = Instance.new("UIStroke", LoadFrame)
lcs.Color = Color3.fromRGB(0, 120, 255)
lcs.Thickness = 2

local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.BackgroundTransparency = 1
LoadText.Font = Enum.Font.GothamBold
LoadText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadText.TextSize = 13
LoadText.Text = "1/3 cargando modificaciones"

task.spawn(function()
    task.wait(1)
    LoadText.Text = "2/3 cargando UI"
    task.wait(1)
    LoadText.Text = "3/3 Hecho"
    task.wait(1)
    LoadingGui:Destroy()
end)

-- Esperar a que termine la carga de los 3 segundos exactos para abrir el Hub principal
task.wait(3.1)

-- ==========================================
-- 1. INTERFAZ PRINCIPAL (TPs V2)
-- ==========================================
local MainGui = Instance.new("ScreenGui", CoreGui)
MainGui.Name = "DeltaTPHub"
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Enabled = true

local MainFrame = Instance.new("Frame", MainGui)
MainFrame.Size = UDim2.new(0, 340, 0, 480)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 120, 255)
MainStroke.Thickness = 2

-- Barra Superior
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
TopBar.BorderSizePixel = 0

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 10)

local FixBar = Instance.new("Frame", TopBar)
FixBar.Size = UDim2.new(1, 0, 0, 10)
FixBar.Position = UDim2.new(0, 0, 1, -10)
FixBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
FixBar.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -15, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
TitleLabel.TextSize = 14
TitleLabel.Text = "DELTA EXECUTOR | TPs V2"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Contenedor
local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 640)
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)

local UIList = Instance.new("UIListLayout", Container)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 12)

-- ==========================================
-- SISTEMA DE ADVERTENCIA Y TEMBLOR (SHAKE)
-- ==========================================
local function triggerWarning(msg)
    local notif = Instance.new("TextLabel", MainGui)
    notif.Size = UDim2.new(0, 260, 0, 40)
    notif.Position = UDim2.new(0.5, -130, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(30, 15, 15)
    notif.TextColor3 = Color3.fromRGB(255, 80, 80)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 12
    notif.Text = msg
    notif.ZIndex = 10
    
    local nc = Instance.new("UICorner", notif)
    nc.CornerRadius = UDim.new(0, 6)
    local ns = Instance.new("UIStroke", notif)
    ns.Color = Color3.fromRGB(255, 50, 50)
    ns.Thickness = 1.5

    task.spawn(function()
        local origPos = MainFrame.Position
        for i = 1, 6 do
            MainFrame.Position = origPos + UDim2.new(0, math.random(-6, 6), 0, math.random(-6, 6))
            task.wait(0.04)
        end
        MainFrame.Position = origPos
    end)

    task.wait(2.5)
    notif:Destroy()
end

-- ==========================================
-- SISTEMA DE BÚSQUEDA DE OBJETIVOS
-- ==========================================
local visitedTargets = {}

local function getNextTargetHRP(tpType)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil, nil end
    local myRoot = char.HumanoidRootPart
    local bestTargetHRP = nil
    local bestTargetKey = nil
    local shortestDist = math.huge

    local function evaluate(targetObj, key, hrp)
        if not visitedTargets[key] then
            local dist = (hrp.Position - myRoot.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                bestTargetHRP = hrp
                bestTargetKey = key
            end
        end
    end

    if tpType == "Players" then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                evaluate(p.Character, p, p.Character.HumanoidRootPart)
            end
        end
    elseif tpType == "All" then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= char then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if hum and hum.Health > 0 and hrp then
                    evaluate(obj, obj, hrp)
                end
            end
        end
    elseif tpType == "NPC" then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if hum and hrp and not Players:GetPlayerFromCharacter(obj) then
                    local nameL = obj.Name:lower()
                    if nameL:find("npc") or nameL:find("guard") or nameL:find("cientifico") or nameL:find("scientist") then
                        evaluate(obj, obj, hrp)
                    end
                end
            end
        end
    elseif tpType == "Mobs" then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if hum and hrp and not Players:GetPlayerFromCharacter(obj) then
                    local nameL = obj.Name:lower()
                    if nameL:find("mob") or nameL:find("monster") or nameL:find("zombie") or nameL:find("alien") or nameL:find("enemy") or nameL:find("verity") or nameL:find("falsity") or nameL:find("cruelity") or nameL:find("crueldad") then
                        evaluate(obj, obj, hrp)
                    end
                end
            end
        end
    end

    if not bestTargetHRP then
        for k, _ in pairs(visitedTargets) do
            visitedTargets[k] = nil
        end
        return nil, nil
    else
        visitedTargets[bestTargetKey] = true
        return bestTargetHRP, bestTargetKey
    end
end

-- ==========================================
-- CREACIÓN DE CONTROLES DE TP
-- ==========================================
local function createTPSection(name, tpType, order)
    local Card = Instance.new("Frame", Container)
    Card.Size = UDim2.new(1, 0, 0, 75)
    Card.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    Card.BorderSizePixel = 0
    Card.LayoutOrder = order

    local cc = Instance.new("UICorner", Card)
    cc.CornerRadius = UDim.new(0, 8)

    local cs = Instance.new("UIStroke", Card)
    cs.Color = Color3.fromRGB(40, 40, 60)
    cs.Thickness = 1

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(0.55, 0, 0, 30)
    Label.Position = UDim2.new(0, 12, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.Text = name
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local InputBox = Instance.new("TextBox", Card)
    InputBox.Size = UDim2.new(0, 55, 0, 26)
    InputBox.Position = UDim2.new(0.55, 0, 0, 10)
    InputBox.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.PlaceholderText = "Sec"
    InputBox.Text = ""
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 12
    
    local ic = Instance.new("UICorner", InputBox)
    ic.CornerRadius = UDim.new(0, 5)
    local ist = Instance.new("UIStroke", InputBox)
    ist.Color = Color3.fromRGB(0, 120, 255)
    ist.Thickness = 1

    local ToggleBtn = Instance.new("TextButton", Card)
    ToggleBtn.Size = UDim2.new(1, -24, 0, 28)
    ToggleBtn.Position = UDim2.new(0, 12, 0, 40)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    ToggleBtn.TextSize = 12
    ToggleBtn.Text = name .. " (OFF)"
    
    local tbc = Instance.new("UICorner", ToggleBtn)
    tbc.CornerRadius = UDim.new(0, 6)

    local activeState = false

    ToggleBtn.MouseButton1Click:Connect(function()
        local secs = tonumber(InputBox.Text)
        local studsVal = tonumber(_G.StudsValueInput and _G.StudsValueInput.Text or "")

        if not secs or secs <= 0 then
            triggerWarning("⚠ No hay segundos del TP")
            return
        end
        if not studsVal then
            triggerWarning("⚠ No hay studs")
            return
        end

        activeState = not activeState

        TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(1, -28, 0, 25)}):Play()
        task.wait(0.1)
        TweenService:Create(ToggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(1, -24, 0, 28)}):Play()

        if activeState then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.Text = name .. " (ON)"

            task.spawn(function()
                while activeState do
                    local targetHRP, targetKey = getNextTargetHRP(tpType)
                    if targetHRP then
                        local limitSecs = tonumber(InputBox.Text) or 1
                        local startTime = tick()
                        
                        local connection
                        connection = RunService.Heartbeat:Connect(function()
                            if not activeState or not targetHRP or not targetHRP.Parent or (tick() - startTime >= limitSecs) then
                                if connection then connection:Disconnect() end
                                return
                            end
                            
                            pcall(function()
                                local myChar = LocalPlayer.Character
                                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                    local studsOffset = tonumber(_G.StudsValueInput.Text) or 0
                                    local finalCFrame = (studsOffset == 0) and targetHRP.CFrame or (targetHRP.CFrame * CFrame.new(0, 0, studsOffset))
                                    
                                    myChar.HumanoidRootPart.CFrame = finalCFrame
                                    myChar.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    myChar.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                end
                            end)
                        end)
                        
                        while activeState and (tick() - startTime < limitSecs) do
                            task.wait(0.1)
                        end
                        
                        if connection then connection:Disconnect() end
                    else
                        task.wait(0.5)
                    end
                end
            end)
        else
            activeState = false
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            ToggleBtn.Text = name .. " (OFF)"
        end
    end)
end

createTPSection("TP Players", "Players", 1)
createTPSection("TP All", "All", 2)
createTPSection("TP NPC", "NPC", 3)
createTPSection("TP Mobs", "Mobs", 4)

-- ==========================================
-- SECCIÓN STUDS (PREESTABLECIDO EN 0 PARA AMBOS LADOS)
-- ==========================================
local StudsCard = Instance.new("Frame", Container)
StudsCard.Size = UDim2.new(1, 0, 0, 50)
StudsCard.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
StudsCard.BorderSizePixel = 0
StudsCard.LayoutOrder = 5

local scc = Instance.new("UICorner", StudsCard)
scc.CornerRadius = UDim.new(0, 8)

local StudsLabel = Instance.new("TextLabel", StudsCard)
StudsLabel.Size = UDim2.new(0.6, 0, 1, 0)
StudsLabel.Position = UDim2.new(0, 12, 0, 0)
StudsLabel.BackgroundTransparency = 1
StudsLabel.Font = Enum.Font.GothamBold
StudsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StudsLabel.TextSize = 13
StudsLabel.Text = "Configurar Studs:"
StudsLabel.TextXAlignment = Enum.TextXAlignment.Left

local StudsInput = Instance.new("TextBox", StudsCard)
StudsInput.Size = UDim2.new(0, 80, 0, 30)
StudsInput.Position = UDim2.new(1, -92, 0.5, -15)
StudsInput.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
StudsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
StudsInput.PlaceholderText = "Ej: 0 / -10"
StudsInput.Text = "0"
StudsInput.Font = Enum.Font.Gotham
StudsInput.TextSize = 13

_G.StudsValueInput = StudsInput

local sic = Instance.new("UICorner", StudsInput)
sic.CornerRadius = UDim.new(0, 5)
local sist = Instance.new("UIStroke", StudsInput)
sist.Color = Color3.fromRGB(0, 120, 255)
sist.Thickness = 1

StudsInput.FocusLost:Connect(function()
    task.spawn(function()
        TweenService:Create(StudsInput, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        task.wait(1)
        TweenService:Create(StudsInput, TweenInfo.new(0.3), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
    end)
end)

-- ==========================================
-- NUEVO BOTÓN: BAJO EL MAPA (7 STUDS FIJOS)
-- ==========================================
local UnderCard = Instance.new("Frame", Container)
UnderCard.Size = UDim2.new(1, 0, 0, 60)
UnderCard.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
UnderCard.BorderSizePixel = 0
UnderCard.LayoutOrder = 6

local ucc = Instance.new("UICorner", UnderCard)
ucc.CornerRadius = UDim.new(0, 8)

local UnderBtn = Instance.new("TextButton", UnderCard)
UnderBtn.Size = UDim2.new(1, -24, 1, -16)
UnderBtn.Position = UDim2.new(0, 12, 0, 8)
UnderBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
UnderBtn.Font = Enum.Font.GothamBold
UnderBtn.TextColor3 = Color3.fromRGB(220, 150, 255)
UnderBtn.TextSize = 13
UnderBtn.Text = "Bajo el Mapa (7 Studs): OFF"

local ubc = Instance.new("UICorner", UnderBtn)
ubc.CornerRadius = UDim.new(0, 6)
local ubs = Instance.new("UIStroke", UnderBtn)
ubs.Color = Color3.fromRGB(150, 50, 255)
ubs.Thickness = 1.5

local underActive = false
local noclipConnection = nil
local undergroundConnection = nil
local savedBaseY = nil

UnderBtn.MouseButton1Click:Connect(function()
    underActive = not underActive
    
    TweenService:Create(UnderBtn, TweenInfo.new(0.1), {Size = UDim2.new(1, -28, 1, -20)}):Play()
    task.wait(0.1)
    TweenService:Create(UnderBtn, TweenInfo.new(0.1), {Size = UDim2.new(1, -24, 1, -16)}):Play()

    if underActive then
        UnderBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
        UnderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        UnderBtn.Text = "Bajo el Mapa (7 Studs): ON"

        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                savedBaseY = char.HumanoidRootPart.Position.Y - 7
            end
        end)

        noclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)

        undergroundConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local currentCamCF = Camera.CFrame
                    
                    if not savedBaseY then
                        savedBaseY = hrp.Position.Y - 7
                    end

                    hrp.CFrame = CFrame.new(hrp.Position.X, savedBaseY, hrp.Position.Z) * CFrame.Angles(math.rad(180), 0, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    
                    Camera.CFrame = currentCamCF
                end
            end)
        end)
    else
        underActive = false
        savedBaseY = nil
        if noclipConnection then noclipConnection:Disconnect() end
        if undergroundConnection then undergroundConnection:Disconnect() end
        
        UnderBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
        UnderBtn.TextColor3 = Color3.fromRGB(220, 150, 255)
        UnderBtn.Text = "Bajo el Mapa (7 Studs): OFF"

        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local pos = hrp.Position
                hrp.CFrame = CFrame.new(pos.X, pos.Y + 15, pos.Z)
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- BOTÓN HITBOX EXPANDER
-- ==========================================
local HitboxCard = Instance.new("Frame", Container)
HitboxCard.Size = UDim2.new(1, 0, 0, 50)
HitboxCard
