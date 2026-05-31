# Wi-Fi Profile Extraction

This script retrieves saved Wi-Fi profiles from a Windows device using `netsh`.
It extracts stored SSIDs and (if available) their saved security keys,
then formats and sends the result to a Discord webhook.

How it works
1. Lists all saved Wi-Fi profiles using `netsh wlan show profiles`
2. Extracts SSID names from the output
3. Queries each profile for detailed information including stored key data
4. Filters results to show only:
   - SSID names
   - Key content (if available)
5. Formats the output into a readable message
6. Sends the result to a Discord webhook via HTTP POST
