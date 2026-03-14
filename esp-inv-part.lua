-- Script : Afficheur d'objets invisibles
-- À placer dans un LocalScript (StarterPlayerScripts)

local RunService = game:GetService("RunService")

local HIGHLIGHT_COLOR = BrickColor.new("Bright red")
local TRANSPARENCY_SEUIL = 0.9 -- Considéré "invisible" si transparence >= 0.9

local objetsHighlight = {}

local function estInvisible(obj)
    if obj:IsA("BasePart") then
        return obj.Transparency >= TRANSPARENCY_SEUIL
    end
    return false
end

local function highlightObjet(obj)
    if objetsHighlight[obj] then return end

    local originalTransparency = obj.Transparency
    local originalColor = obj.BrickColor

    obj.Transparency = 0.5
    obj.BrickColor = HIGHLIGHT_COLOR

    objetsHighlight[obj] = {
        transparency = originalTransparency,
        color = originalColor
    }
end

local function scannerWorkspace()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if estInvisible(obj) then
            highlightObjet(obj)
        end
    end
end

local function resetTout()
    for obj, data in pairs(objetsHighlight) do
        if obj and obj.Parent then
            obj.Transparency = data.transparency
            obj.BrickColor = data.color
        end
    end
    objetsHighlight = {}
    print("Reset effectué.")
end

-- Scan initial
scannerWorkspace()
print("Scan terminé. Objets invisibles mis en rouge.")

-- Scan en continu (toutes les 3 secondes)
RunService.Heartbeat:Connect(function()
    -- Optionnel : re-scan léger pour les nouveaux objets
end)

-- Commande dans le chat pour reset
game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    if msg == "/resetscan" then
        resetTout()
    elseif msg == "/scan" then
        scannerWorkspace()
        print("Nouveau scan effectué.")
    end
end)
