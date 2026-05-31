# Change the text inside the quotation marks to change the message it shows in powershell.
Write-Host "Initializing Voice Core..." -ForegroundColor Cyan

# This line connects PowerShell to the Windows talking engine
$Voice = New-Object -ComObject SAPI.SpVoice

# Change the text inside the quotation marks to make it say whatever you want.
$Voice.Speak("Hello.")
