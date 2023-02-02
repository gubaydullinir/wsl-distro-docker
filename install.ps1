$ErrorActionPreference = "Stop"

# Vars
$7zPath = "${env:ProgramFiles}s\7-Zip"
$zipArchive = "distro/ubuntu.zip.001"
$dockerPath = "$(Get-Location)\docker"
$dockerComposePath = "${dockerPath}\cli-plugins"
$dockerHost = "tcp://127.0.0.1:2375"

# Check if 7zip installed
if (Test-Path $7zPath) {
    $env:Path += $7zPath
} elseif (-Not (Get-Command 7z)) {
    throw "7z not installed!"
}

# Extract distro
Write-Host "Extracting distro" -ForegroundColor Green 
& 7z e $zipArchive
Write-Host "Distro successfully extracted!" -ForegroundColor Green 

# Import distro
Write-Host "Importing WSL distro" -ForegroundColor Yellow 
wsl --import ubuntu-docker $env:HOME\WSL .\ubuntu
Write-Host "Distro successfully imported!" -ForegroundColor Green 

# Set environment
Write-Host "Adding docker & docker-compose to PATH" -ForegroundColor Yellow 
$env:Path += ";${dockerPath};${dockerComposePath}"
[environment]::SetenvironmentVariable("Path", $env:Path, [System.environmentVariableTarget]::User)
Write-Host "added!" -ForegroundColor Green

# Set DOCKER_HOST
Write-Host "Adding DOCKER_HOST to ENV" -ForegroundColor Yellow 
$env:DOCKER_HOST = $dockerHost
[environment]::SetenvironmentVariable("DOCKER_HOST", $env:DOCKER_HOST, [System.environmentVariableTarget]::User)
Write-Host "added!" -ForegroundColor Green

Write-Host "`nStarting wsl..." -ForegroundColor Green 
# Start linux
wsl -d ubuntu-docker