# esx_PoliceBuddy

Vehicle Functions
- Get closest plate
- Check fuel level of closest vehicle
- Check tint level of closest vehicle

Ped Functions
- Stop the ped
- Dismiss the ped

Trunk Functions
- Grab AR (Carbine Rifle)
- Refill pistol ammo

Included Events (No parameters required, uses the closes vehicle)
- Open trunk
- Close trunk
- Toggle Duty
- Refuel

Included Events (Parameters required)
- Duty Notification From Server:
```lua
TriggerClientEvent('esx_PoliceBuddy:DutyNotificationClient', playerName --[[String]], notificationText --[[String]])
```
- Duty Notification From Client:
```lua
TriggerEvent('esx_PoliceBuddy:DutyNotificationClient', playerName --[[String]], notificationText --[[String]])
```
