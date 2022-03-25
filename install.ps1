Write-Host "Установка"

# Vars
$dockerPath = "$(Get-Location)\docker"
$dockerComposePath = "$(Get-Location)\docker\cli-plugins"
$dockerHost = "tcp://127.0.0.1:2375"
$7zPath = "$env:ProgramFiles\7-Zip\7z.exe"

# Is 7zip installed?
if (-not (Test-Path $7zPath)) {
    if (-not (winget install 7zip -s winget)) {
        throw "чоооЁбу дался? где 7z? winget потерял?"
    }
}
Set-Alias 7zip $7zPath

# Expand distro
7zip  e ".\ubuntu.zip.001"

# Install wsl
wsl --install
# Import distro
if (wsl --import ubuntu-docker $env:HOME\WSL .\ubuntu) {
    Write-Host "Образ импортирован"
}

# Set environment
$env:PATH += $dockerPath
Write-Host "Добавлен PATH $($dockerPath)"

$env:PATH += $dockerComposePath
Write-Host "Добавлен PATH $($dockerComposePath)"

$env:DOCKER_HOST = $dockerHost
Write-Host "Добавлен DOCKER_HOST $($env:DOCKER_HOST)"

# Start linux
wsl -d ubuntu-docker