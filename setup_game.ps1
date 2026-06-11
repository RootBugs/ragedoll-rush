Write-Host "=== Battle Royale - Setup Script ==="
$projectDir = "E:\projects\ragedoll-rush"
Set-Location $projectDir

# Step 1: Download Godot engine
Write-Host "Step 1: Downloading Godot 4.3 engine..."
$godotUrl = "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip"
$zipPath = "$projectDir\godot_tmp.zip"
Invoke-WebRequest -Uri $godotUrl -OutFile $zipPath -UseBasicParsing
Write-Host "Downloaded! Extracting..."
Expand-Archive -Path $zipPath -DestinationPath $projectDir -Force
Remove-Item $zipPath -Force
Write-Host "Godot engine ready!"

# Step 2: Download export templates
Write-Host "Step 2: Downloading export templates..."
$tplUrl = "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_export_templates.tpz"
$tplZip = "$projectDir\templates_tmp.zip"
Invoke-WebRequest -Uri $tplUrl -OutFile $tplZip -UseBasicParsing
Write-Host "Downloaded templates! Installing..."
$templateDir = "$env:APPDATA\Godot\export_templates\4.3.stable"
New-Item -ItemType Directory -Path $templateDir -Force | Out-Null
Expand-Archive -Path $tplZip -DestinationPath "$env:TEMP\godot_templates" -Force
# Templates might be in a subfolder
if (Test-Path "$env:TEMP\godot_templates\templates") {
    Copy-Item -Path "$env:TEMP\godot_templates\templates\*" -Destination $templateDir -Recurse -Force
} else {
    Copy-Item -Path "$env:TEMP\godot_templates\*" -Destination $templateDir -Recurse -Force
}
Remove-Item -Path "$env:TEMP\godot_templates" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $tplZip -Force
Write-Host "Export templates installed!"

# Step 3: Export the game
Write-Host "Step 3: Exporting BattleRoyale.exe..."
$godotExe = Get-ChildItem -Path $projectDir -Filter "Godot_v4.3-stable_win64_console.exe" | Select-Object -First 1
if ($godotExe) {
    $exePath = $godotExe.FullName
    Write-Host "Using: $exePath"
    & $exePath --headless --export-release "Windows Desktop" "$projectDir\BattleRoyale.exe" 2>&1
    if (Test-Path "$projectDir\BattleRoyale.exe") {
        Write-Host "SUCCESS! BattleRoyale.exe created!" -ForegroundColor Green
        $fileInfo = Get-Item "$projectDir\BattleRoyale.exe"
        Write-Host "Size: $([math]::Round($fileInfo.Length / 1MB, 1)) MB"
    } else {
        Write-Host "Export failed!" -ForegroundColor Red
    }
} else {
    Write-Host "ERROR: Godot console exe not found!" -ForegroundColor Red
}

Write-Host "=== Setup Complete ==="
Write-Host "Double-click 'Play Battle Royale.bat' to run the game through Godot"
Write-Host "Or run BattleRoyale.exe for standalone play (if export succeeded)"
pause
