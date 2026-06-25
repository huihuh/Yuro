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
