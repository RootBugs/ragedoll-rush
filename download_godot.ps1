Write-Host "Downloading Godot 4.3 engine..."
$url = "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip"
$out = "E:\projects\ragedoll-rush\godot_dl.zip"
Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -TimeoutSec 180
Write-Host "Godot downloaded! Size: $((Get-Item $out).Length / 1MB) MB"

Write-Host "Extracting..."
Expand-Archive -Path $out -DestinationPath "E:\projects\ragedoll-rush" -Force
Remove-Item $out -Force
Write-Host "Godot extracted!"

Write-Host "Downloading export templates..."
$tplUrl = "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_export_templates.tpz"
$tplOut = "E:\projects\ragedoll-rush\templates.zip"
Invoke-WebRequest -Uri $tplUrl -OutFile $tplOut -UseBasicParsing -TimeoutSec 300
Write-Host "Templates downloaded! Size: $((Get-Item $tplOut).Length / 1MB) MB"

Write-Host "Installing templates..."
$templateDir = "$env:APPDATA\Godot\export_templates\4.3.stable"
New-Item -ItemType Directory -Path $templateDir -Force | Out-Null
Expand-Archive -Path $tplOut -DestinationPath "$env:TEMP\godot_tpl" -Force
if (Test-Path "$env:TEMP\godot_tpl\templates") {
    Copy-Item "$env:TEMP\godot_tpl\templates\*" $templateDir -Recurse -Force
} else {
    Copy-Item "$env:TEMP\godot_tpl\*" $templateDir -Recurse -Force
}
Remove-Item "$env:TEMP\godot_tpl" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $tplOut -Force
Write-Host "Templates installed!"

Write-Host "Exporting BattleRoyale.exe..."
$godot = "E:\projects\ragedoll-rush\Godot_v4.3-stable_win64_console.exe"
& $godot --headless --export-release "Windows Desktop" "E:\projects\ragedoll-rush\BattleRoyale.exe" 2>&1
if (Test-Path "E:\projects\ragedoll-rush\BattleRoyale.exe") {
    Write-Host "SUCCESS! BattleRoyale.exe created!" -ForegroundColor Green
} else {
    Write-Host "Export FAILED. Using Godot editor instead..." -ForegroundColor Yellow
}
Write-Host "DONE!"
