$ErrorActionPreference = "Stop"

$wslDestination = "C:\WSL"
$dockerPath = "${wslDestination}\docker"
$dockerComposePath = "${dockerPath}\cli-plugins"
$dockerHost = "tcp://127.0.0.1:2375"

# Copy docker folder
Copy-Item .\docker $wslDestination -Recurse -ErrorAction Inquire

# Set environment
if ( -not ( ( ${env:Path}.contains($dockerPath)) -and (${env:Path}.contains($dockerComposePath) ) ) ) {
    Write-Host "Adding docker & docker-compose to PATH" -ForegroundColor Yellow 
    $env:Path += ";${dockerPath};${dockerComposePath}"
    [environment]::SetenvironmentVariable("Path", $env:Path, [System.environmentVariableTarget]::User)
    Write-Host "added!" -ForegroundColor Green
}
else {
    Write-Host "docker & docker-compose exists in PATH!" -ForegroundColor Blue
}

# Set DOCKER_HOST
if ( -not (Test-Path 'env:DOCKER_HOST') ) {
    Write-Host "Adding DOCKER_HOST to ENV" -ForegroundColor Yellow 
    $env:DOCKER_HOST = $dockerHost
    [environment]::SetenvironmentVariable("DOCKER_HOST", $env:DOCKER_HOST, [System.environmentVariableTarget]::User)
    Write-Host "added!" -ForegroundColor Green
}
else {
    Write-Host "DOCKER_HOST exists in PATH!" -ForegroundColor Blue
}

Write-Host "`nStarting wsl..." -ForegroundColor Green 

# Start linux
wsl -d ubuntu
