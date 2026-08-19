local Module = {}

--init
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local PlaceId = game.PlaceId
local JobId = game.JobId

function Module:TeleportPlayer(target)
    HumanoidRootPart.CFrame = target
end

function Module:Rejoin()
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId);
end

function Module:JoinJobId(job_id)
    TeleportService:TeleportToPlaceInstance(PlaceId, job_id);
end

local MIN_FREE_SLOTS = 1
local SEARCH_LIMIT = 100
local WAIT_BETWEEN_REQUESTS = 0.4

local function findServerToHop()
    local cursor = nil

    while true do
        local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor then
            url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
        end

        local data = HttpService:JSONDecode(game:HttpGet(url))

        for _, server in ipairs(data.data) do
            local serverId = tostring(server.id)
            local playing = tonumber(server.playing) or 0
            local maxPlayers = tonumber(server.maxPlayers) or 0

            if serverId ~= JobId and maxPlayers > playing then
                return serverId
            end
        end

        if data.nextPageCursor then
            cursor = data.nextPageCursor
            task.wait(1)
        else
            break
        end
    end

    return nil
end


function Module:HopServer()
    local serverId = findServerToHop()
    if not serverId then
        print("ServerHop: tidak menemukan server")
        return
    end

    TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
end

function Module:HopLowerServer()
    local serverId = findServerToHop()
    if not serverId then
        print("ServerHop: tidak menemukan server")
        return
    end

    TeleportService:TeleportToPlaceInstance(PlaceId, serverId, LocalPlayer)
end

return Module
