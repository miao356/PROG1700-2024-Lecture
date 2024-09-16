cd ~

Set-Location $env:temp

Write-Host "Installing Windows Package Manager (winget)..." -ForegroundColor Green
$progressPreference = 'silentlyContinue'
#Invoke-WebRequest -Uri 'https://aka.ms/getwinget' -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
#Invoke-WebRequest -Uri 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx' -OutFile 'Microsoft.VCLibs.x64.14.00.Desktop.appx'
#Invoke-WebRequest -Uri 'https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx' -OutFile 'Microsoft.UI.Xaml.2.8.x64.appx'

#Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
#Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
#Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

winget install --id Microsoft.DotNet.SDK.8 --source winget --log C:\temp\install.log -h
winget install Microsoft.PowerShell -h --accept-source-agreements
#winget install Microsoft.WindowsTerminal -h --skip-dependencies
winget install "windows terminal" --source "msstore" -h  --accept-package-agreements
winget install Python.Python.3.10 -h
winget install Git.Git -h
winget install GitHub.cli -h
winget install Microsoft.VisualStudioCode -h
winget install OpenJS.NodeJS -h

$paths = ,"C:\Program Files\dotnet\"
$paths += "%HOME%\.dotnet\tools"
$paths += "%LOCALAPPDATA%\Programs\Microsoft VS Code\bin"
$paths += "%LOCALAPPDATA%\Microsoft\WindowsApps"
$paths += "C:\Program Files\PowerShell\7\"
$paths += "C:\Program Files\Git\bin"

$path = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine) -split ";"
$path += [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User) -split ";"
$userPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)
foreach ($p in $paths) {
  if ($path -notcontains [Environment]::ExpandEnvironmentVariables($p)) {
    $userPath += ";$p"
  }
}

[Environment]::SetEnvironmentVariable("PATH", $userPath, [EnvironmentVariableTarget]::User)
$env:PATH = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine) + ";" + 
            [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)

python -m pip install jupyterlab
dotnet tool install -g Microsoft.dotnet-interactive
dotnet interactive jupyter install
code --install-extension ms-dotnettools.dotnet-interactive-vscode
code --install-extension ms-vscode.powershell
start 'wt' '--fullscreen "C:\Program Files\PowerShell\7\pwsh.exe"'
#start "code"