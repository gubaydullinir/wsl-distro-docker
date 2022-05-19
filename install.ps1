Set-Location $PSScriptRoot

Write-Output -ForegroundColor DarkGreen "Setup"

# Vars
$context = "$(Get-Location)"
$dockerPath = ";$context\docker"
$dockerComposePath = ";$context\docker\cli-plugins"
$zipArchive = "ubuntu.zip.001"
$dockerHost = "tcp://127.0.0.1:2375"
$7zPath = "$env:ProgramFiles\7-Zip"

# Is 7zip installed?
if (-not (Test-Path $7zPath)) {
    if (-not (winget install 7zip -s winget)) {
        throw "Choooezhed up? where the �hoooezh is 7z? Choooezhed up winget?"
    }
}

$env:PATH += ";$7zPath"

# Expand distro
7z e $zipArchive

# Install wsl
#wsl --install

# Import distro
if (wsl --import ubuntu-docker $env:HOME\WSL .\ubuntu) {
    Write-Output "- Imported Distro"
} else {
    Write-Output "- wsl error"
}

Write-Output "*"

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
wsl -d ubuntu-docker
