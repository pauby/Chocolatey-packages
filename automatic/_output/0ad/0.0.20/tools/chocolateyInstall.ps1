$packageName = '0ad'
$installerType = 'exe'
$silentArgs = '/S'
$url = 'http://releases.wildfiregames.com/0ad-0.0.20-alpha-win32.exe'
$checksum = '579942a0391947a86e63d649cd69d9c2615bcd3b'
$checksumType = 'sha1'
$validExitCodes = @(0)

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"