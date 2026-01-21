-- FO5 FINDER | Auto Server Hop -- Steal A Brainrot
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId

print("🔎 FO5 FINDER iniciado...")

local CHECK_DELAY = 4 -- tiempo entre chequeos

-- Función que busca brainrots buenos
local function foundGoodBrainrot()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") then
			local n = string.lower(v.Name)
			if n:find("brainrot") or n:find("mythic") or n:find("legend") then
				return true, v.Name
			end
		end
	end
	return false
end

-- Función para cambiar de servidor
local function hop()
	local success, response = pcall(function()
		return HttpService:JSONDecode(
			game:HttpGet("https://games.roblox.com/v1/games/"..PLACE_ID.."/servers/Public?limit=100")
		)
	end)
	
	if success and response and response.data then
		for _, s in ipairs(response.data) do
			if s.playing < s.maxPlayers then
				TeleportService:TeleportToPlaceInstance(PLACE_ID, s.id, player)
				return
			end
		end
	end
end

-- Bucle principal
task.spawn(function()
	while true do
		local ok, name = foundGoodBrainrot()
		if ok then
			warn("✅ BRAINROT BUENO DETECTADO:", name)
		else
			warn("❌ Nada bueno, cambiando servidor...")
			hop()
			return
		end
		task.wait(CHECK_DELAY)
	end
end)
