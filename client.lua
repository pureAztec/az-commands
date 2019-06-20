
--[[----------------------------------------------------------------------]]--
--[[  Licença: c9ff1098b0b8663888450fc9a4e1fea3							  ]]--
--[[  Discord: AZTËC™#0001                                                ]]--
--[[  Discord: discord.me/aztecde                                         ]]--
--[[  Youtube: https://www.youtube.com/channel/UC8jGkFhiXnbWWBbr90z596Q   ]]--
--[[----------------------------------------------------------------------]]--

--[[ F U N Ç Õ E S ]]--
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

--[[ E V E N T O S ]]--
RegisterNetEvent("azt:tptoway")
AddEventHandler("azt:tptoway", function()
    if(IsWaypointActive()) then    
        local ped = GetPlayerPed(-1)
        if(IsPedInAnyVehicle(ped))then
            ped = GetVehiclePedIsUsing(ped)
        end	
        local waypointBlip = GetFirstBlipInfoId(8)
        local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 
        local ground
        local groundFound = false
        local groundCheckHeights = {0.0, 50.0, 100.0, 150.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}
        for i,height in ipairs(groundCheckHeights) do
            RequestCollisionAtCoord(x, y, height)
            Wait(0)
            SetEntityCoordsNoOffset(ped, x, y, height, 0, 0, 1)
            ground,z = GetGroundZFor_3dCoord(x,y,height)
            if(ground) then
                z = z + 3
                groundFound = true
                break;
            end
        end
        if(not groundFound)then
            z = 1000
            GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0)
        end
        SetEntityCoordsNoOffset(ped, x,y,z, 0, 0, 1)
    end
end)

RegisterNetEvent('azt:deletevehicle')
AddEventHandler('azt:deletevehicle', function()
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then 
        local pos = GetEntityCoords(ped)
        if (IsPedSittingInAnyVehicle(ped)) then 
            local vehicle = GetVehiclePedIsIn(ped, false)
            if (GetPedInVehicleSeat(vehicle, -1) == ped) then 
                SetEntityAsMissionEntity(vehicle, true, true)
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
                if (DoesEntityExist(vehicle)) then
					Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
					if (DoesEntityExist(vehicle)) then
						Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
					else 
						ShowNotification("~g~Veículo deletado sucesso.")
					end 
                else 
                	ShowNotification("~g~Veículo deletado sucesso.")
                end 
            else 
                ShowNotification( "~r~Você precisa estar em um veículo!" )
            end 
        else
            local playerPos = GetEntityCoords(ped, 1)
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(ped, 0.0, 6.0, 0.0)
            local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
            if (DoesEntityExist(vehicle)) then 
                SetEntityAsMissionEntity(vehicle, true, true)
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
                if (DoesEntityExist(vehicle)) then 
                	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
					if (DoesEntityExist(vehicle)) then 
						Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
					else
						ShowNotification("~g~Veículo deletado com sucesso.")
					end
                else 
                	ShowNotification("~g~Veículo deletado com sucesso.")
                end 
            else 
                ShowNotification("~r~Você precisa estar em um veículo!")
            end 
        end 
    end 
end)

function GetVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

RegisterNetEvent('azt:fixvehicle')
AddEventHandler('azt:fixvehicle', function(player)
    if player then
        local ped = GetPlayerPed(GetPlayerFromServerId(tonumber(player)))
        local vehicle = GetVehiclePedIsIn(ped, false)
        if IsPedInAnyVehicle(ped, false) then
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleFixed(vehicle)
        end
    else
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped,false)
        if IsPedInAnyVehicle(ped, false) then
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleFixed(vehicle)        
        end
    end  
end)

RegisterNetEvent("azt:playerlife")
AddEventHandler("azt:playerlife", function(player, value)
    if player then
        SetEntityHealth(GetPlayerPed(GetPlayerFromServerId(tonumber(player))), value)
        ShowNotification("ID "..player.." revivido.")
    else
        SetEntityHealth(GetPlayerPed(-1), value)
    end
end)

RegisterNetEvent("azt:spawnvehicle")
AddEventHandler("azt:spawnvehicle", function(model, player)
    local vehicle = GetHashKey(model)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
      Wait(1)
    end
    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(player))), 0, 5.0, 0)
    local spawned_car = CreateVehicle(vehicle, coords, 64.55118,116.613,78.69622, true, false)    
    SetVehicleOnGroundProperly(spawned_car)
    SetPedIntoVehicle(GetPlayerPed(GetPlayerFromServerId(tonumber(player))), spawned_car, - 1)
    SetModelAsNoLongerNeeded(vehicle)
    Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
    if spawned_car then
        ShowNotification("Veículo "..model.." spawnado, ID: "..player..".")
    end
end)

RegisterNetEvent("azt:playerarmor")
AddEventHandler("azt:playerarmor", function(player, armour, vest)    
    local ped = GetPlayerPed(GetPlayerFromServerId(tonumber(player)))
    if vest then
        if(GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
            SetPedComponentVariation(ped, 9, 4, 1, 2)
        else 
            if(GetEntityModel(ped) == GetHashKey("mp_f_freemode_01")) then
                SetPedComponentVariation(ped, 9, 6, 1, 2)
            end
        end
    end
    SetPedArmour(ped, math.floor(armour))
end)