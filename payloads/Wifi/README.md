# Wi-Fi Profile Extraction

This script retrieves saved Wi-Fi profiles from a Windows device and extracts stored SSIDs and saved security keys (if available).

The collected information is formatted and sent to a Discord webhook.

## Overview

The script:
- Retrieves saved Wi-Fi profiles from the system
- Attempts to extract stored credentials where available
- Formats the results into a readable message
- Sends the output to a configured Discord webhook

## Important Notes

- This only works on Windows systems with saved Wi-Fi profiles
- Some networks may not expose saved keys depending on system permissions
- Output is transmitted externally via webhook
