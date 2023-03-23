Set-Location $PSScriptRoot

Write-Output -ForegroundColor DarkGreen "Setup"

# Vars
$context = "$(Get-Location)"
$dockerPath = ";$context\docker"
$dockerComposePath = ";$context\docker\cli-plugins"
$dockerHost = "tcp://127.0.0.1:2375"

# Set environment
Write-Output "- Set PATH"
$env:Path += $dockerPath
$env:Path += $dockerComposePath
[environment]::SetenvironmentVariable("Path", $env:Path, [System.environmentVariableTarget]::User)
Write-Output "- Setted PATH"

#  Set DOCKER_HOST
Write-Output "- Set DOCKER_HOST"
$env:DOCKER_HOST = $dockerHost
[environment]::SetenvironmentVariable("DOCKER_HOST", $env:DOCKER_HOST, [System.environmentVariableTarget]::User)
Write-Output "- Setted DOCKER_HOST"

Write-Output "- Done"
# Start linux
wsl -d ubuntu
