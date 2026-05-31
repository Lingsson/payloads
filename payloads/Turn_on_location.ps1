Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Allow" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessLocation" -Value 1 -Force

Set-Service -Name "lfsvc" -StartupType Automatic

Start-Sleep -Milliseconds 500

Start-Service -Name "lfsvc"

Stop-Service -Name "lfsvc" -Force -ErrorAction SilentlyContinue
Start-Service -Name "lfsvc"

gpupdate /force

Stop-Process -Name "explorer" -Force
