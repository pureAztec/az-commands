
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

defaultArmor = 100			-- # Valor do colete padrão do servidor
defaultHealth = 200			-- # Valor da vida padrão do servidor

local commands = {			-- # Lista de comandos, caso alterem mudem dentro da chave do mesmo!
	["noclip"] = "nc",
	["tptowaypoint"] = "tpp",
	["tpto"] = "tpo",
	["tptome"] = "tpm",
	["tpcoords"] = "tpc",
	["dv"] = "dv",
	["fix"] = "fixar",
	["bag"] = "inv",
	["revive"] = "reviver",
	["armor"] = "colete",
	["vehiclespawn"] = "veh",
	["cruise"] = "vcr",
	["coords"] = "cds"
}

--[[ C O M A N D O S ]]--
RegisterCommand(commands.revive, function(source, args)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "god.mode") then		
		if #args > 0 then
			if args[1] then
				local user_id = vRP.getUserSource({tonumber(args[1])})
				TriggerClientEvent("azt:playerlife", source, user_id, defaultHealth)
				vRP.setHunger({tonumber(args[1]), 0})
				vRP.setThirst({tonumber(args[1]), 0})
			end
		else
			local user_id = vRP.getUserId({source})
			TriggerClientEvent("azt:playerlife", source, user_id, defaultHealth)
			vRP.setHunger({user_id, 0})
			vRP.setThirst({user_id, 0})
		end
	end
end)

RegisterCommand(commands.armor, function(source, args)
	CancelEvent()	
	if hasGroup(source, "superadmin") then
		if #args > 0 then
			if args[1] then
				local user_id = vRP.getUserSource({tonumber(args[1])})
				TriggerClientEvent("azt:playerarmor", source, user_id, defaultArmor, true)
			end
		else
			local user_id = vRP.getUserId({source})
			TriggerClientEvent("azt:playerarmor", source, user_id, defaultArmor, true)
		end
	end
end, false)

RegisterCommand(commands.bag, function(source, args)
	CancelEvent()
	local user_id = vRP.getUserId({source})
	local data = vRP.getUserDataTable({user_id})	
	if data then
		local weight = vRP.getInventoryWeight({user_id})
		local max_weight = vRP.getInventoryMaxWeight({user_id})		
		local inventory = ""
		for k,v in pairs(data.inventory) do 
			local name,description,peso,itemlistname = vRP.getItemDefinition({k})
			if inventory == "" then
				inventory = name..": "..v.amount
			else
				inventory = inventory.." | "..name..": "..v.amount
			end
		end
		TriggerClientEvent('chat:addMessage', source, {
			template = [[<div style= "margin-left:9px;font-size:20px;max-width: 400px;height: 5px;display: inline;"><font color=darkorange>Invetario:</font> {0} | <font color=darkorange>[{1}/{2}]</font><br></div>]],
			args = {inventory, weight, max_weight}
		})
	end
end)

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
					vRPclient.teleport(tplayer, {x, y, z})
				end
			end)
		end
	end
end, false)

RegisterCommand(commands.tpcoords, function(source, args)
	CancelEvent()
	if #args > 0 then
		if hasPermission(source, "player.tpto") then
			if args[1] and args[2] and args[3] then
				vRPclient.teleport(source, {args[1], args[2], args[3]})
			end
		end
	end
end, false)

RegisterCommand(commands.dv, function(source)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.deleteveh") then
		TriggerClientEvent('azt:deletevehicle', source)
	end	
end, false)

RegisterCommand(commands.fix, function(source, args)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.fix") then
		local user_id = vRP.getUserId({source})
		if #args > 0 then
			if args[1] then
				TriggerClientEvent("azt:fixvehicle", source, tonumber(args[1]))
			end
		else
			TriggerClientEvent("azt:fixvehicle", source, user_id)
		end
	end
end)

RegisterCommand(commands.vehiclespawn, function(source, args)
	CancelEvent()
	if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.spawnveh") then
		if #args > 0 then
			if args[1] then
				if args[2] then
					local tplayer = vRP.getUserSource({tonumber(args[2])})
					TriggerClientEvent("azt:spawnvehicle", source, args[1], tplayer)
				else
					local user_id = vRP.getUserId({source})
					TriggerClientEvent("azt:spawnvehicle", source, args[1], user_id)
				end			
			end
		end
	end
end)

RegisterCommand(commands.cruise, function(source, args)
	CancelEvent()	
	if #args > 0 then
		if args[1] then	
			local velocity = tonumber(args[1])			
			if args[2] then
				local player = vRP.getUserSource({tonumber(args[2])})
				if hasGroup(source, "superadmin") or hasGroup(source, "moderador") or hasGroup(source, "suporte") or hasPermission(source, "admin.spawnveh") then				
					TriggerClientEvent("azt:velcontrolvehicle", source, player, velocity)
				end
			else					
				local user_id = vRP.getUserId({source})
				local player = vRP.getUserSource({user_id}) 
				TriggerClientEvent("azt:velcontrolvehicle", source, player, velocity)
			end			
		end
	else
		local user_id = vRP.getUserId({source})
		local player = vRP.getUserSource({user_id}) 
		TriggerClientEvent("azt:velcontrolvehicle", source, player, velocity)
	end	
end)

RegisterCommand(commands.coords, function(source)
	CancelEvent()
	local user_id = vRP.getUserId({source})
	vRPclient.getPosition(source, {}, function(x, y, z)
		vRP.prompt({source, "[ID: "..user_id.."] Copie as coordenadas com Ctrl-A Ctrl-C", x..", "..y..", "..z}, function(source, tab) end)
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
