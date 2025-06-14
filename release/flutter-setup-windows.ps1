# PowerShell Script to EXE Compiler
# Requires ps2exe module: Install-Module -Name ps2exe

# Convert PowerShell script to executable
ps2exe -inputFile "..\..\setup_flutter_env.ps1" -outputFile "flutter-setup-windows.exe" -requireAdmin -verbose

Write-Host "✅ Windows executable created: flutter-setup-windows.exe"
