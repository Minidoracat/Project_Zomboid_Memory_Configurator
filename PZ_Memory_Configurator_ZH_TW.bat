@echo off
chcp 65001
setlocal enabledelayedexpansion

echo 正在檢查系統記憶體大小...
set "totalmem=0"
for /f "skip=1" %%a in ('wmic OS get TotalVisibleMemorySize') do (
    set /a "totalmem=%%a/1024/1024"
    goto :done
)
:done

echo 系統記憶體大小: %totalmem%GB

echo 正在尋找 Steam 的安裝目錄...
for /f "usebackq tokens=1,2,*" %%a in (`reg query "HKLM\SOFTWARE\Wow6432Node\Valve\Steam" /v InstallPath`) do (
    set "steamPath=%%c"
)

echo Steam 安裝目錄: %steamPath%

set "libraryFoldersFile=%steamPath%\steamapps\libraryfolders.vdf"

if not exist "%libraryFoldersFile%" (
    echo 找不到 libraryfolders.vdf 檔案，請確認 Steam 安裝目錄正確。
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
    echo 找不到 %gameId% 的安裝目錄，請確認遊戲安裝。
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

echo 安裝遊戲的 steam 收藏庫資料夾位置: %steamInstallDir%

set "appManifestFile=%steamInstallDir%\steamapps\appmanifest_%gameId%.acf"


if not exist "%appManifestFile%" (
    echo 找不到 appmanifest_%gameId%.acf 檔案，請確認遊戲安裝。
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

echo ProjectZomboid64.json 檔案 位置: %jsonFile%

if not exist "%jsonFile%" (
    echo 找不到 ProjectZomboid64.json 檔案，請確認遊戲安裝目錄正確。
    pause
    exit
)


echo 正在檢查目前設定的記憶體值...

for /f "usebackq delims=" %%a in (`powershell -Command "Select-String -Path '%jsonFile%' -Pattern '-Xmx\s*(\d+[a-zA-Z]?)' -AllMatches | Foreach-Object { $_.Matches } | Foreach-Object { $_.Groups[1].Value }"`) do (
    set "memoryValue=%%a"
)

if "%memoryValue%"=="" (

    echo ================抓取遊戲設定記憶體錯誤，建議使用 Steam 驗證遊戲後再重新執行。================
    pause
    exit
) else (
    echo 目前設定的記憶體值：%memoryValue%
)


set /a "suggestedMemory=%totalmem% *4/5"

:choice
echo 建議的記憶體設定值(約為系統的80%%): %suggestedMemory%GB
echo 請選擇：
echo 1. 使用建議的記憶體設定值 %suggestedMemory% GB
echo 2. 自行輸入記憶體設定值（GB為單位）
set /p "choice=請輸入選擇（1 或 2）: "

if "%choice%"=="1" (
    set "newMemory=%suggestedMemory%"
) else if "%choice%"=="2" (
    set /p "newMemory=請輸入自訂記憶體設定值（以 GB 為單位，請只輸入數字，不要多輸入 GB）: "
) else (
    echo 輸入無效，請重新輸入。
    goto choice
)


echo 設定記憶體值為 %newMemory%GB...
powershell -Command "(Get-Content '%jsonFile%') -replace '-Xmx\d+(?:m|M|g|G)', '-Xmx%newMemory%g' | Set-Content '%jsonFile%'"

for /f "usebackq delims=" %%a in (`powershell -Command "Select-String -Path '%jsonFile%' -Pattern '-Xmx\s*(\d+[a-zA-Z]?)' -AllMatches | Foreach-Object { $_.Matches } | Foreach-Object { $_.Groups[1].Value }"`) do (
    set "memoryValue=%%a"
)

if "%memoryValue%"=="%newMemory%g" (
    echo 設定成功，目前設定的記憶體值：%memoryValue%
) else (
    echo 設定失敗，目前設定的記憶體值：%memoryValue%
)

echo 更新完成，新的記憶體設定值為 %newMemory%GB
pause
