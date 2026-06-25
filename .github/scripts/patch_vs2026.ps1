# Patch Flutter SDK's visual_studio.dart to add VS 2026 support
# https://github.com/flutter/flutter/pull/177458

$vsDart = "$env:FLUTTER_ROOT\packages\flutter_tools\lib\src\windows\visual_studio.dart"
$content = Get-Content $vsDart -Raw

# Check if already patched
if ($content -match "18 => 'Visual Studio 18 2026'") {
    Write-Host "VS 2026 patch already applied, skipping."
    exit 0
}

# Add VS 2026 support before VS 2022 entry
$content = $content -replace '(?m)^      17 => ''Visual Studio 17 2022''', "      18 => 'Visual Studio 18 2026',`n      17 => 'Visual Studio 17 2022'"

Set-Content -Path $vsDart -Value $content

Write-Host "VS 2026 patch applied successfully."

# Debug: run vswhere to check what VS installations are detected
Write-Host "`n=== vswhere debug ==="
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
Write-Host "vswhere path: $vswhere"
Write-Host "vswhere exists: $(Test-Path $vswhere)"

# Run vswhere -latest
$result = & $vswhere -latest -format json -products '*' -utf8 2>&1
Write-Host "vswhere -latest output:"
$result | Out-String | Write-Host

# Run vswhere -prerelease -all
$result2 = & $vswhere -prerelease -all -format json -products '*' -utf8 2>&1
Write-Host "`nvswhere -prerelease -all output:"
$result2 | Out-String | Write-Host

# Check the patched visual_studio.dart
$patchedLine = Get-Content $vsDart | Select-String "Visual Studio 18"
Write-Host "`nPatched cmakeGenerator line: $patchedLine"
