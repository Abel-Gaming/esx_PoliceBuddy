ESX              = nil
local OnDuty = false
local IsTrunkOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterCommand(Config.Command, function()
	OpenMainMenu()
end, false)

RegisterKeyMapping('policebuddy', 'Police Buddy', 'keyboard', '[')

-- Main Menu Options
local mainoptions = {
	{label = "Citizen Interaction (NPC)", value = 'ped_options'},
	{label = "Vehicle Interaction", value = 'vehicle_options'}
}

--Opens the main menu
function OpenMainMenu()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Police",
		align = "left",
		elements = mainoptions
	}, function(data, menu)		
		
		if data.current.value == 'vehicle_options' then
			OpenVehicleMenu()
		elseif data.current.value == 'ped_options' then
			OpenPedMenu()
		end

	end,
	function(data, menu)
		menu.close()
	end)
end

-- Vehicle Menu Options
local vehicleoptions = {
	{label = "Get Closest Plate", value = 'get_plate'},
	{label = "Check Vehicle Fuel Level", value = 'get_fuel_level'},
	{label = "Check Vehicle Tint", value = 'get_tint'},
}

--Opens the vehicle menu
function OpenVehicleMenu()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Vehicle Interaction",
		align = "left",
		elements = vehicleoptions
	}, function(data, menu)		
		
		if data.current.value == 'get_plate' then
			GetClosestPlate()
		elseif data.current.value == 'get_fuel_level' then
			GetClosestFuel()
		elseif data.current.value == 'get_tint' then
			GetClosestTint()
		end

	end,
	function(data, menu)
		menu.close()
	end)
end

-- Ped Menu Options
local pedoptions = {
	{label = "Stop Ped", value = 'stop_ped'},
	{label = "Dismiss Ped", value = 'release_ped'}
}

-- Opens the ped menu
function OpenPedMenu()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Ped Interaction",
		align = "left",
		elements = pedoptions
	}, function(data, menu)		
		
		if data.current.value == 'stop_ped' then
			StopPed()
		elseif data.current.value == 'release_ped' then
			ReleasePed()
		end

	end,
	function(data, menu)
		menu.close()
	end)
end

function GetClosestPlate()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local closestVehicleCoords = GetEntityCoords(closestVehicle)

	if #(GetEntityCoords(PlayerPedId()) - closestVehicleCoords) <= 5.0 then
		local closestVehiclePlate = GetVehicleNumberPlateText(closestVehicle)
		local closestVehicleHash = ESX.Game.GetVehicleProperties(closestVehicle).model
		local closestVehicleName = GetDisplayNameFromVehicleModel(closestVehicleHash)
		ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Plate: ~b~' .. closestVehiclePlate)
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby vehicle')
	end
end

function GetClosestFuel()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local closestVehicleCoords = GetEntityCoords(closestVehicle)

	if #(GetEntityCoords(PlayerPedId()) - closestVehicleCoords) <= 5.0 then
		local fuelLevel = GetVehicleFuelLevel(closestVehicle)
		local closestVehicleHash = ESX.Game.GetVehicleProperties(closestVehicle).model
		local closestVehicleName = GetDisplayNameFromVehicleModel(closestVehicleHash)
		ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Fuel Level: ~b~' .. fuelLevel)
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby vehicle')
	end
end

function GetClosestTint()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local closestVehicleCoords = GetEntityCoords(closestVehicle)

	if #(GetEntityCoords(PlayerPedId()) - closestVehicleCoords) <= 5.0 then
		local tint = GetVehicleWindowTint(closestVehicle)

		local closestVehicleHash = ESX.Game.GetVehicleProperties(closestVehicle).model
		local closestVehicleName = GetDisplayNameFromVehicleModel(closestVehicleHash)

		if tint == -1 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~None')
		elseif tint == 0 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~None')
		elseif tint == 1 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~Pure Black')
		elseif tint == 2 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~Dark Smoke')
		elseif tint == 3 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~Light Smoke')
		elseif tint == 4 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~Stock')
		elseif tint == 5 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~Limo')
		elseif tint == 6 then
			ESX.ShowHelpNotification('~o~Vehicle: ' .. closestVehicleName .. '~n~~y~Tint: ~b~Green')
		end
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby vehicle')
	end
end

function StopPed()
	local closestPed = ESX.Game.GetClosestPed(GetEntityCoords(PlayerPedId()))
	local closestPedCoords = GetEntityCoords(closestPed)

	if #(GetEntityCoords(PlayerPedId()) - closestPedCoords) <= 3.0 then
		ClearPedTasksImmediately(closestPed)
		TaskStandStill(closestPed, -1)
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby ped')
	end
end

function ReleasePed()
	local closestPed = ESX.Game.GetClosestPed(GetEntityCoords(PlayerPedId()))
	local closestPedCoords = GetEntityCoords(closestPed)

	if #(GetEntityCoords(PlayerPedId()) - closestPedCoords) <= 3.0 then
		ClearPedTasksImmediately(closestPed)
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby ped')
	end
end

-- EVENTS
RegisterNetEvent('esx_PoliceBuddy:OpenTrunk')
AddEventHandler('esx_PoliceBuddy:OpenTrunk', function()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	SetVehicleDoorOpen(closestVehicle, 5, false, true)
	OpenTrunkMenu()
end)

RegisterNetEvent('esx_PoliceBuddy:CloseTrunk')
AddEventHandler('esx_PoliceBuddy:CloseTrunk', function()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	SetVehicleDoorShut(closestVehicle, 5, true)
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_PoliceBuddy:ToggleDuty')
AddEventHandler('esx_PoliceBuddy:ToggleDuty', function()
	if OnDuty then
		ESX.ShowHelpNotification('You are now ~r~off duty!')
		local notificationText = Config.OffDutyText
		TriggerServerEvent('esx_PoliceBuddy:ServerDutyToggle', notificationText, Config.DiscordOffDutyText)
		OnDuty = false
	else
		ESX.ShowHelpNotification('You are now ~g~on duty!')
		local notificationText = Config.OnDutyText
		TriggerServerEvent('esx_PoliceBuddy:ServerDutyToggle', notificationText, Config.DiscordOnDutyText)
		OnDuty = true
	end
end)

RegisterNetEvent('esx_PoliceBuddy:Refuel')
AddEventHandler('esx_PoliceBuddy:Refuel', function()
	local closestVehicle = ESX.Game.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
	local closestVehicleCoords = GetEntityCoords(closestVehicle)

	if #(GetEntityCoords(PlayerPedId()) - closestVehicleCoords) <= 5.0 then
		local closestVehicleHash = ESX.Game.GetVehicleProperties(closestVehicle).model
		local closestVehicleName = GetDisplayNameFromVehicleModel(closestVehicleHash)
		SetVehicleFixed(closestVehicle)
		ESX.ShowHelpNotification('~b~' .. closestVehicleName .. ' ~w~was refueled!')
	else
		ESX.ShowHelpNotification('~r~[ERROR]~w~ No nearby vehicle')
	end
end)

-- Server Event Returns
RegisterNetEvent('esx_PoliceBuddy:DutyNotificationClient')
AddEventHandler('esx_PoliceBuddy:DutyNotificationClient', function(playerName, notificationText)
	ESX.ShowAdvancedNotification('~y~Duty Notification', '~b~LSPD', '~b~' .. playerName .. ' ~w~' .. notificationText, 'CHAR_CALL911', 1)
end)

-- Event Menus
-- Trunk Menu Options
local trunkoptions = {
	{label = "Grab AR", value = 'grab_rifle'},
	{label = "Refill Pistol Ammo", value = 'refill_pistol_ammo'}
}

-- Opens the trunk menu
function OpenTrunkMenu()
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Trunk",
		align = "left",
		elements = trunkoptions
	}, function(data, menu)		
		
		if data.current.value == 'grab_rifle' then
			TriggerServerEvent('esx_PoliceBuddy:GiveRifle')
		elseif data.current.value == 'refill_pistol_ammo' then
			TriggerServerEvent('esx_PoliceBuddy:RefillAmmo', 'WEAPON_PISTOL')
		end

	end,
	function(data, menu)
		menu.close()
	end)
end