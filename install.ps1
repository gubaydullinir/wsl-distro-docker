$ErrorActionPreference = "Stop"

Write-Host -ForegroundColor DarkGreen "Setup"

# Vars
$7zFile = "${env:ProgramFiles}\7-Zip\7z.exe"
$zipArchive = "distro/ubuntu.zip.001"
$dockerPath = "$(Get-Location)\docker"
$dockerComposePath = "${dockerPath}\cli-plugins"
$dockerHost = "tcp://127.0.0.1:2375"

# Check if 7zip installed
if (Test-Path $7zFile) {
    $7z = $7zFile
} elseif (Get-Command 7z) {
    $7z = '7z'
} else {
    throw "7z not installed!"
}

Write-Host "7z is $7z"

# Expand distro
& $7z e $zipArchive
Write-Host -ForegroundColor Yellow "Archive successfully extracted!"

# Import distro
Write-Host -ForegroundColor Yellow "Importing WSL distributive"
if (wsl --import ubuntu-docker $env:HOME\WSL .\ubuntu) {
    Write-Host -ForegroundColor Green "Distributive successfully imported"
} else {
    Write-Host -ForegroundColor Red "WSL Error!!!"
}

# Set environment
Write-Host "- Set PATH"
$env:Path += ";${dockerPath};${dockerComposePath}"
[environment]::SetenvironmentVariable("Path", $env:Path, [System.environmentVariableTarget]::User)
Write-Host "- Setted PATH"

#  Set DOCKER_HOST
Write-Host "- Set DOCKER_HOST"
$env:DOCKER_HOST = $dockerHost
[environment]::SetenvironmentVariable("DOCKER_HOST", $env:DOCKER_HOST, [System.environmentVariableTarget]::User)
Write-Host "- Setted DOCKER_HOST"

Write-Host "- Done"
# Start linux
wsl -d ubuntu-docker
