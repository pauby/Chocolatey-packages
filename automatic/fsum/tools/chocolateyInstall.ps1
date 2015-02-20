$packageName = '{{PackageName}}'
$packageVersion = '{{PackageVersion}}'
# no version-specific installers available, only latest
$url = '{{DownloadUrl}}'
$checksum = '{{Checksum}}'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage -PackageName "$packageName" -Url "$url" -UnzipLocation "$toolsDir"
