
--[[----------------------------------------------------------------------]]--
--[[  Licença: c9ff1098b0b8663888450fc9a4e1fea3							  ]]--
--[[  Discord: AZTËC™#0001                                                ]]--
--[[  Discord: discord.me/aztecde                                         ]]--
--[[  Youtube: https://www.youtube.com/channel/UC8jGkFhiXnbWWBbr90z596Q   ]]--
--[[----------------------------------------------------------------------]]--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "azt_commands")

local defaultArmor = 100		-- # Valor do colete padrão do servidor
local defaultHealth = 200		-- # Valor da vida padrão do servidor

local commands = {				-- # Lista de comandos, caso alterem mudem dentro da chave do mesmo!
	["noclip"] = "nc",
	["tptowaypoint"] = "tpp",
	["tpto"] = "tpo",
	["tptome"] = "tpm",
	["dv"] = "dv",
	["fix"] = "fixar",
	["revive"] = "reviver",
	["armor"] = "colete",
	["vehiclespawn"] = "veh",
	["coords"] = "cds"
}

--[[ C O M A N D O S ]]--
RegisterCommand(commands.armor, function(source, args)
	CancelEvent()
	local user_id = vRP.getUserId({source})
	if #args > 0 then		
		if args[1] then
			TriggerClientEvent("azt:playerarmor", source, tonumber(args[1]), defaultArmor, true)
		end
	else
		TriggerClientEvent("azt:playerarmor", source, user_id, defaultArmor, true)
	end
end, false)

RegisterCommand(commands.noclip, function(source)
	CancelEvent()
	if hasPermission(source, "player.noclip") then
		vRPclient.toggleNoclip(source, {})
	end	
end, false)

RegisterCommand(commands.tptowaypoint, function(source)
	CancelEvent()	
	if hasPermission(source, "player.tptowaypoint") then
		TriggerClientEvent("azt:tptoway", source)
	end
end, false)

RegisterCommand(commands.tpto, function(source, args)
	CancelEvent()
	if #args > 0 then
		if hasPermission(source, "player.tpto") then
			local tplayer = vRP.getUserSource({tonumber(args[1])})
			vRPclient.getPosition(tplayer,{},function(x,y,z)
				vRPclient.teleport(source,{x,y,z})
			end)
		end
	end
end, false)

RegisterCommand(commands.tptome, function(source, args)
	CancelEvent()
	if #args > 0 then
		if hasPermission(source, "player.tptome") then
			local user_id = vRP.getUserId({source})
			local player = vRP.getUserSource({user_id}) 
			vRPclient.getPosition(player,{},function(x,y,z)				
				local tplayer = vRP.getUserSource({tonumber(args[1])})
				if tplayer ~= nil then
					vRPclient.teleport(tplayer,{x,y,z})
				end
			end)
		end
	end
end, false)

RegisterCommand(commands.dv, function(source)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.deleteveh") then
		TriggerClientEvent('azt:deletevehicle', source)
	end	
end, false)

RegisterCommand(commands.revive, function(source, args)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "god.mode") then
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id}) 
		if #args > 0 then
			if args[1] then
				print(args[1])
				TriggerClientEvent("azt:playerlife", source, tonumber(args[1]), defaultHealth)
				vRP.setHunger({tonumber(args[1]), 0})
				vRP.setThirst({tonumber(args[1]), 0})
			end
		else
			TriggerClientEvent("azt:playerlife", source, nil, defaultHealth)
			vRP.setHunger({user_id, 0})
			vRP.setThirst({user_id, 0})
		end
	end
end)

RegisterCommand(commands.fix, function(source, args)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.fix") then
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id}) 
		if #args > 0 then
			if args[1] then
				TriggerClientEvent("azt:fixvehicle", source, tonumber(args[1]))
			end
		else
			TriggerClientEvent("azt:fixvehicle", source, nil)
		end
	end
end)

RegisterCommand(commands.vehiclespawn, function(source, args)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.spawnveh") then
		if #args > 0 then
			if args[1] then
				if args[2] then
					TriggerClientEvent("azt:spawnvehicle", source, args[1], tonumber(args[2]))
				else
					local user_id = vRP.getUserId({source})
					TriggerClientEvent("azt:spawnvehicle", source, args[1], user_id)
				end			
			end
		end
	end
end)

RegisterCommand(commands.coords, function(source)
	CancelEvent()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id}) 
	vRPclient.getPosition(player, {}, function(x, y, z)
		print("[ID: "..user_id.."] X: "..x..", Y: "..y..", Z: "..z)
		vRP.prompt(player,"Copie as coordenadas:", x..", "..y..", "..z, function(player, user_id) end)
	end)
end)

--[[ F U N Ç Õ E S ]]--
function hasGroup(source, group)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.hasGroup({user_id, group}) then
		return true	
	end
	return false
end

function hasPermission(source, permission)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id}) 
	if vRP.hasPermission({user_id, permission}) then
		return true	
	end
	return false
end
