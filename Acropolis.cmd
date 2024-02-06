@set ver=24.1.8
@echo off

REM Run as admin
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

title  Acropolis V%ver%

REM Check if running as administrator
IF exist C:\Windows\System32\WDI\LOGFILES (
    REM Running as administrator
) ELSE (
    REM Not running as administrator
    echo This script requires administrative privileges. Please run this script as an administrator.
    pause
    exit /b
)

echo:     _________________________________________________________________
echo:
echo:                         Welcome to Acropolis!
echo:
echo:         This script will install Adobe Acrobat DC (64-Bit) and 
echo:         patch it to work with Windows 10 1903 and above.
echo: 
echo:         Make sure that you have a working internet connection 
echo:         and that you run the script as administrator.
echo:         __________________________________________________________   
echo:
echo:         If Acrobat crashes on startup, check if your Acrobat
echo:         version is higher than the one listed in the Reddit post.   
echo:         __________________________________________________________  
echo: 
echo:         Press any key to continue...
echo:     __________________________________________________________________

pause > nul

md "%TEMP%\Acropolis"
cls
echo:     _________________________________________________________________
echo:
echo:                           Acropolis V%ver% by V.
echo:     _________________________________________________________________
echo.
echo Downloading Adobe Acrobat DC...
echo.

rem Download the standalone Acrobat version needed
curl --output "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip" https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/win32/Acrobat_DC_Web_x64_WWMUI.zip

rem Check if the download was successful
if not exist "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip" (
    echo Error: Failed to download Adobe Acrobat DC. Please check your internet connection, disable your Antivirus and try again.
    pause
    exit /b
)
echo.
echo Downloading Patch...
echo.

rem Download the patch files
curl -L --output "%TEMP%\Acropolis\AcrobatV.zip" y.gy/AcrobatV

rem Check if the download was successful
if not exist "%TEMP%\Acropolis\AcrobatV.zip" (
    echo Error: Failed to download the patch. Please check your internet connection, disable your Antivirus and try again.
    pause
    exit /b
)

rem Close all Adobe processes and services
powershell -Command "Get-Service -DisplayName Adobe* | Stop-Service -Force -Confirm:$false; $Processes = Get-Process * | Where-Object { $_.CompanyName -match 'Adobe' -or $_.Path -match 'Adobe' }; Foreach ($Process in $Processes) { Stop-Process $Process -Force -ErrorAction SilentlyContinue }"


echo.
rem Extracting Adobe Acrobat DC...
tar -xf "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip" -C "%TEMP%\Acropolis"

rem Extracting Patch file...
tar -xf "%TEMP%\Acropolis\AcrobatV.zip" -C "%TEMP%\Acropolis"
echo.

del /f "%TEMP%\Acropolis\AcrobatV.zip"
del /f "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip"

echo Installing Adobe Acrobat DC, uncheck genuine service, don't change anything else and don't close the installer.
echo After the installation, click FINISH!

rem Run the setup file silently
"%TEMP%\Acropolis\Adobe Acrobat\setup.exe" /quiet

rem Create backup files and disable Adobe Crash Processor
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak"
)
del /f "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe"
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe.bak"
)
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll.bak"
)
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll.bak
)

rem Replace the files inside Acrobat with the patched files.
xcopy /y "%TEMP%\Acropolis\acrotray.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe"
xcopy /y "%TEMP%\Acropolis\Acrobat.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll"
xcopy /y "%TEMP%\Acropolis\acrodistdll.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll"

echo.

rem Disable Adobe updater
sc config "AdobeARMservice" start= disabled
sc stop "AdobeARMservice"

rem Add hosts entries if they don't already exist
findstr /C:"0.0.0.0 ic.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo 0.0.0.0 ic.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)
findstr /C:"0.0.0.0 r3zj0yju1q.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo 0.0.0.0 r3zj0yju1q.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)
findstr /C:"0.0.0.0 cd536oo20y.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo 0.0.0.0 cd536oo20y.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)
findstr /C:"0.0.0.0 3ca52znvmj.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo 0.0.0.0 3ca52znvmj.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)
findstr /C:"0.0.0.0 5zgzzv92gn.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo 0.0.0.0 5zgzzv92gn.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)

cls
echo:     _________________________________________________________________
echo:
echo:                           Acropolis V%ver% by V.
echo:     _________________________________________________________________
echo:
echo:                        Files patched and replaced!
echo:
echo:               Successfully disabled Adobe updater service!
echo:
echo:       If you want to avoid updates and be on the safe side, you can  
echo:       disable updates in Acrobat settings.
echo:       Acrobat: Edit ^> Preferences ^> Updater. Uncheck everything
echo:       and click OK.
echo:     _________________________________________________________________
echo:
echo:                          Installation completed!
echo:     _________________________________________________________________
echo:

rmdir /s /q "%TEMP%\Acropolis"

echo Press any key to exit...
pause > nul
