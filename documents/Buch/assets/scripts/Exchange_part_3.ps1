New-Item -Path "C:\" -Name "Temp" -ItemType "directory"
$outputPath = "C:\Temp\"

Invoke-WebRequest "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe" -OutFile "$outputPath\vcredist_x64.exe"
Start-Process "$outputPath\vcredist_x64.exe" -ArgumentList "/q" -NoNewWindow -Wait
Start-Process "D:\UCMARedist\Setup.exe" -ArgumentList "/passive /norestart" -NoNewWindow -Wait
Invoke-WebRequest "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi" -OutFile "$outputPath\iis_rewrite.msi"
Start-Process "msiexec.exe" -ArgumentList "/i `"$outputPath\iis_rewrite.msi`" /q /norestart" -NoNewWindow -Wait

# Exchange Installation
D:
.\Setup.EXE /IAcceptExchangeServerLicenseTerms_DiagnosticDataON /Mode:Install /Roles:Mailbox /on:"Fenrir Corporation" /TargetDir:"C:\Exchange_Server"

