#Shared for everyone
$uciChessDir = Join-Path $env:ProgramData "UCI-Chess"
$uciChessGuiDir = Join-Path $uciChessDir "GUI"
$uciChessEngineDir = Join-Path $uciChessDir "Engine"

$isAdmin = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    $startMenuPath = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs"
} else {
    $specialFolder = [System.Environment+SpecialFolder]::Programs
    $startMenuPath = [System.Environment]::GetFolderPath($specialFolder)
}

$uciChessShortcutDir = Join-Path $startMenuPath "UCI-Chess"

#Shared for this package

$uciChessPkgInstallDirName = "reckless"
$uciChessPkgInstallDir = Join-Path $uciChessEngineDir $uciChessPkgInstallDirName
$uciChessPkgExecPath = Join-Path $uciChessPkgInstallDir "reckless.exe"

$uciChessPkgShortcutDir = Join-Path $uciChessShortcutDir "Engine"
$uciChessPkgShortcutPath = Join-Path $uciChessPkgShortcutDir "Reckless UCI Chess Engine.lnk"

#Individual for this script

if (Test-Path $uciChessPkgInstallDir) {
    "Removing old program installation"
    Remove-Item -Path $uciChessPkgInstallDir -Force -ErrorAction Stop -Recurse
}

if (Test-Path $uciChessPkgShortcutPath) {
    "Removing old shortcut"
    Remove-Item -Path $uciChessPkgShortcutPath
}

$packageArgs = @{
    PackageName    = 'ucichess-engine-reckless'
    Url64bit       = 'https://github.com/codedeliveryservice/Reckless/releases/download/v%%VERSION%%/reckless-windows-avx2.exe'
    Checksum64     = '%%CHECKSUM%%'
    ChecksumType64 = 'sha256'
    FileFullPath   = $uciChessPkgExecPath
}

"Downloading and installing"
Get-ChocolateyWebFile @packageArgs

"Installing shortcut"
Install-ChocolateyShortcut -targetPath $uciChessPkgExecPath -ShortcutFilePath $uciChessPkgShortcutPath
