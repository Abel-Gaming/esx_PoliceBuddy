ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_PoliceBuddy:ServerDutyToggle')
AddEventHandler('esx_PoliceBuddy:ServerDutyToggle', function(notificationText, discordText)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerName = xPlayer.getName()
    local identifier = xPlayer.getIdentifier()
    TriggerClientEvent('esx_PoliceBuddy:DutyNotificationClient', -1, xPlayerName, notificationText)
    
    if Config.EnableDiscordWebHook then
        PerformHttpRequest(Config.DiscordWebHookLink, 
        function(err, text, headers) end, 
        'POST', 
        json.encode({username = 'Los Santos Police Department', content = "" .. xPlayerName .. " " .. discordText}), 
        { ['Content-Type'] = 'application/json' }
        )
    end
end)

RegisterServerEvent('esx_PoliceBuddy:GiveRifle')
AddEventHandler('esx_PoliceBuddy:GiveRifle', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.hasWeapon('WEAPON_ASSAULTRIFLE') then
        xPlayer.addWeaponAmmo('WEAPON_ASSAULTRIFLE', 100)
        xPlayer.showNotification('Rifle Ammo Added!')
    else
        xPlayer.addWeapon("WEAPON_ASSAULTRIFLE", 100)
    end
end)

RegisterServerEvent('esx_PoliceBuddy:RefillAmmo')
AddEventHandler('esx_PoliceBuddy:RefillAmmo', function(weapon)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.hasWeapon(weapon) then
        xPlayer.addWeaponAmmo(weapon, 100)
    else
        local weaponlabel = ESX.GetWeaponLabel(weapon)
        xPlayer.showNotification('~r~[ERROR] ~w~You do not have a ' .. weaponlabel)
    end
end)