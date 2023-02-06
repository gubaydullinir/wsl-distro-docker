$ErrorActionPreference = "Stop"

# Vars
$7zPath = "${env:ProgramFiles}\7-Zip"
$zipArchive = "distro/ubuntu.zip.001"
$wslDestination = "C:\WSL"
$dockerPath = "${wslDestination}\docker"
$dockerComposePath = "${dockerPath}\cli-plugins"
$dockerHost = "tcp://127.0.0.1:2375"

# Check if 7zip installed
if ( -not (Get-Command 7z -ErrorAction SilentlyContinue) ) {
    if (Test-Path $7zPath) {
        Write-Host "Adding 7zip installation folder to PATH" -ForegroundColor Yellow
        $env:Path += ";${7zPath}"
        Write-Host "added!" -ForegroundColor Yellow
    }
    else {
        throw "7zip not found!"
    }
}

# Extract distro
Write-Host "Extracting distro" -ForegroundColor Yellow 
& 7z e $zipArchive
Write-Host "Distro successfully extracted!" -ForegroundColor Green 

# Import distro
Write-Host "Importing WSL distro" -ForegroundColor Yellow 
wsl --import ubuntu-docker $wslDestination .\ubuntu
Write-Host "Distro successfully imported! WSL is located in: $wslDestination" -ForegroundColor Green

# Copy docker folder
Copy-Item .\docker $wslDestination -Recurse -ErrorAction Inquire

# Set environment
if ( -not ( ( ${env:Path}.contains($dockerPath)) -and (${env:Path}.contains($dockerComposePath) ) ) ) {
    Write-Host "Adding docker & docker-compose to PATH" -ForegroundColor Yellow 
    $env:Path += ";${dockerPath};${dockerComposePath}"
    [environment]::SetenvironmentVariable("Path", $env:Path, [System.environmentVariableTarget]::User)
    Write-Host "added!" -ForegroundColor Green
} else {
    Write-Host "docker & docker-compose exists in PATH!" -ForegroundColor Blue
}

# Set DOCKER_HOST
if ( -not (Test-Path 'env:DOCKER_HOST') ) {
    Write-Host "Adding DOCKER_HOST to ENV" -ForegroundColor Yellow 
    $env:DOCKER_HOST = $dockerHost
    [environment]::SetenvironmentVariable("DOCKER_HOST", $env:DOCKER_HOST, [System.environmentVariableTarget]::User)
    Write-Host "added!" -ForegroundColor Green
} else {
    Write-Host "DOCKER_HOST exists in PATH!" -ForegroundColor Blue
}

Write-Host "`nStarting wsl..." -ForegroundColor Green 
# Start linux
wsl -d ubuntu-docker