$packageName = 'mariadb'
$urlArray = @('https://downloads.mariadb.org//f/mariadb-10.2.8/win32-packages/mariadb-10.2.8-win32.msi','https://downloads.mariadb.org//f/mariadb-10.2.8/winx64-packages/mariadb-10.2.8-winx64.msi')
$url = $urlArray[0]
$checksum = '5617340110ce7ed81d747b2bac016fb38464cccbc3c7535ed9c87609ecaa9953'
$checksumType = 'sha256'
$url64 = $urlArray[1]
$checksum64 = '{checksumx64}'
$checksumType64 = 'sha256'
$installerType = 'msi'
$silentArgs = '/quiet /qn /norestart'
$validExitCodes = @(0,3010)

Write-Verbose "Downloading and installing program..."
Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -Url64bit "$url64" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType" `
                          -Checksum64 "$checksum64" `
                          -ChecksumType64 "$checksumType64"

Write-Verbose "Querying registry for install location..."
$packageSearch = "MariaDB *"
$regKey = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                   'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                   'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
                           -ErrorAction:SilentlyContinue `
          | Where-Object {$_.DisplayName -like $packageSearch}

Write-Verbose "Adding MariaDB bin directory to path environment variable..."
$binPath = Join-Path $regKey.InstallLocation[0] "bin"
if ($binPath) {
  Install-ChocolateyPath $binPath 'Machine'

  Write-Verbose "Installing service..."
  Start-Process -FilePath $(Join-Path $binPath "mysqld") `
                -ArgumentList '--install' `
                -Wait `
                -NoNewWindow

  Write-Verbose "Starting service..."
  Start-Process -FilePath "NET" `
                -ArgumentList 'START MySQL' `
                -Wait `
                -NoNewWindow
}