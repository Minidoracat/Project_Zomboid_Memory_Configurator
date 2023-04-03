@echo off
chcp 65001
setlocal enabledelayedexpansion

echo Checking system memory size...
set "totalmem=0"
for /f "skip=1" %%a in ('wmic OS get TotalVisibleMemorySize') do (
    set /a "totalmem=%%a/1024/1024"
    goto :done
)
:done

echo System memory size: %totalmem%GB

echo Searching for Steam installation directory...
for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKLM\SOFTWARE\Wow6432Node\Valve\Steam" /v InstallPath`) do (
    set "steamPath=%%c"
)

echo Steam installation directory: %steamPath%

set "libraryFoldersFile=%steamPath%\steamapps\libraryfolders.vdf"

if not exist "%libraryFoldersFile%" (
    echo Cannot find libraryfolders.vdf file, please check if the Steam installation directory is correct.
    pause
    exit
)

set gameId=108600
set gameInstallDir=

set "lineNum="
for /f "tokens=1,* delims=:" %%a in ('findstr /n /C:"%gameId%" "%libraryFoldersFile%"') do (
    set "lineNum=%%a"
)

set "pathLine="
for /f "tokens=1,* delims=:" %%a in ('findstr /n /C:"path" "%libraryFoldersFile%"') do (
    if %%a LSS %lineNum% set "pathLine=%%b"
)

if not defined pathLine (
    echo Cannot find the installation directory for %gameId%, please check if the game is installed.
    pause
    exit
)
set "gameInstallDir=%pathLine:~9,-1%"
set "gameInstallDir=%gameInstallDir:\=\%\\common"

set "steamInstallDir=%gameInstallDir:\\common=%"
set "steamInstallDir=%steamInstallDir:\\=\%"

set "steamInstallDir=%steamInstallDir: "=_%"
set "steamInstallDir=%steamInstallDir:\"=%"
set "steamInstallDir=%steamInstallDir:"=%"
set "steamInstallDir=%steamInstallDir:~1%

echo Steam library folder where the game is installed: %steamInstallDir%

set "appManifestFile=%steamInstallDir%\steamapps\appmanifest_%gameId%.acf"


if not exist "%appManifestFile%" (
    echo Cannot find appmanifest_%gameId%.acf file, please check if the game is installed.
    pause
    exit
)

set installDirRaw=

for /f "delims=" %%a in ('findstr /c:"installdir" "%appManifestFile%"') do (
    set "installDirRaw=%%a"
)


set "installDirRaw=%installDirRaw:installdir=%"
set "installDirRaw=%installDirRaw:"=%"
set "installDirRaw=%installDirRaw: =%"
set "installDirRaw=%installDirRaw:	=%"


set "jsonFile=%steamInstallDir%\steamapps\common\%installDirRaw%\ProjectZomboid64.json"

echo ProjectZomboid64.json file location: %jsonFile%

if not exist "%jsonFile%" (
    echo Cannot find ProjectZomboid64.json file, please check if the game installation directory is correct.
    pause
    exit
)


echo Checking currently set memory value...

for /f "usebackq delims=" %%a in (`powershell -Command "Select-String -Path '%jsonFile%' -Pattern '-Xmx\s*(\d+[a-zA-Z]?)' -AllMatches | Foreach-Object { $_.Matches } | Foreach-Object { $_.Groups[1].Value }"`) do (
    set "memoryValue=%%a"
)

if "%memoryValue%"=="" (

    echo ================Error fetching game memory setting, it is recommended to verify the game through Steam and run again.================
    pause
    exit
) else (
    echo Currently set memory value: %memoryValue%
)


set /a "suggestedMemory=%totalmem% *4/5"

:choice
echo Suggested memory setting value (about 80%% of the system): %suggestedMemory%GB
echo Please choose:
echo 1. Use the suggested memory setting value %suggestedMemory% GB
echo 2. Enter the memory setting value manually (in GB)
set /p "choice=Please enter your choice (1 or 2): "

if "%choice%"=="1" (
    set "newMemory=%suggestedMemory%"
) else if "%choice%"=="2" (
    set /p "newMemory=Please enter the custom memory setting value (in GB, only enter numbers, do not enter GB): "
) else (
    echo Invalid input, please re-enter.
    goto choice
)


echo Setting memory value to %newMemory%GB...
powershell -Command "(Get-Content '%jsonFile%') -replace '-Xmx\d+(?:m|M|g|G)', '-Xmx%newMemory%g' | Set-Content '%jsonFile%'"

for /f "usebackq delims=" %%a in (`powershell -Command "Select-String -Path '%jsonFile%' -Pattern '-Xmx\s*(\d+[a-zA-Z]?)' -AllMatches | Foreach-Object { $_.Matches } | Foreach-Object { $_.Groups[1].Value }"`) do (
    set "memoryValue=%%a"
)

if "%memoryValue%"=="%newMemory%g" (
    echo Setting successful, currently set memory value: %memoryValue%
) else (
    echo Setting failed, currently set memory value: %memoryValue%
)

echo Update completed, the new memory setting value is %newMemory%GB
pause

