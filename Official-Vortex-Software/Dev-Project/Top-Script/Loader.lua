if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE_URL = "https://raw.githubusercontent.com/Israel-Vortex/vortex-x-scripts/refs/heads/main/Official-Vortex-Software/Vortex-Devs/"

-- Diccionario con los PlaceIds y sus respectivos archivos .lua
local games = {
    [93978595733734]  = "V-DISTRICT.lua",
    [135856908115931] = "DMVSS.lua",
    [142823291]       = "MM2.lua",
    [286090429]       = "Arsenal.lua",
}

local scriptFile = games[game.PlaceId]

if scriptFile then
    local success, err = pcall(function()
        loadstring(game:HttpGet(BASE_URL .. scriptFile))()
    end)
    
    if not success then
        warn("[VORTEX SOFTWARE] Error al cargar el script:", err)
    end
else
    warn("[VORTEX SOFTWARE] Juego no registrado o script en mantenimiento.")
end

