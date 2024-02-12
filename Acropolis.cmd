echo off
set ver=24.1.9

REM Run as admin
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd","/c %~s0 ::","","runas",1)(window.close) && exit
cd /d "%~dp0"

title Acropolis V%ver%

:MainMenu
cls
title Acropolis V%ver%
mode 82, 24
echo:     ________________________________________________________________________
echo:
echo:                               Welcome to Acropolis
echo:     ________________________________________________________________________ 
echo:
echo:         [1] Default       ^| Installs Acrobat        ^|      (Recommended)
echo:                           ^| standalone version      ^|      
echo:
echo:         [2] Custom        ^| Latest Acrobat is       ^|         (Unstable)
echo:                           ^| already installed       ^|  
echo:         ________________________________________________________________
echo:
echo:         [3] Extras        ^|  Individual Options     ^|   (Advanced Users)
echo:         [4] Recovery      ^|  Restore Defaults       ^|  (Troubleshooting)
echo:         [5] Help          ^|  Acropolis Guide        ^|           (Reddit)
echo:
echo:         [0] Exit
echo:     ________________________________________________________________________ 
echo.
echo:     Enter a menu option on the keyboard [1,2,3,4,5,0] :
choice /C:12345678 /N
set "userChoice=%errorlevel%"

if %userChoice%==1 goto DownloadInstall
if %userChoice%==2 goto DownloadPatch
if %userChoice%==3 goto ExtraSubmenu
if %userChoice%==4 goto RestoreDefaultsSubmenu
if %userChoice%==5 goto Help
if %userChoice%==6 goto ExitScript

goto MainMenu



:DownloadInstall
if not exist "%TEMP%\Acropolis" (
    md "%TEMP%\Acropolis"
)
cls
echo:     ________________________________________________________________________
echo:
echo:                  Downloading and Installing Adobe Acrobat DC...
echo:     ________________________________________________________________________
echo.
REM Download and Installation steps here
rem Download the standalone Acrobat version needed
curl --output "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip" https://trials.adobe.com/AdobeProducts/APRO/Acrobat_HelpX/win32/Acrobat_DC_Web_x64_WWMUI.zip
rem Check if the download was successful
if not exist "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip" (
    echo Error: Failed to download Adobe Acrobat DC. Please check your internet connection, disable your Antivirus and try again.
    pause
    goto MainMenu
)
rem Extracting Adobe Acrobat DC...
tar -xf "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip" -C "%TEMP%\Acropolis"
del /f "%TEMP%\Acropolis\Acrobat_DC_Web_x64_WWMUI.zip"


cls 
echo.
echo:     ________________________________________________________________________
echo:
echo:                                 A T T E N T I O N
echo:     ________________________________________________________________________
echo:     
echo:         If you are prompted to install the genuine service, uncheck it.  
echo:
echo:             Do NOT change the paths and do NOT close the installer.
echo:
echo:         Click the install button and wait for the installation to finish.
echo:         ________________________________________________________________  
echo:
echo:        
echo:
echo:     ________________________________________________________________________
echo.
rem Run the setup file silently
"%TEMP%\Acropolis\Adobe Acrobat\setup.exe" /quiet

goto downloadPatch


:DownloadPatch
if not exist "%TEMP%\Acropolis" (
    md "%TEMP%\Acropolis"
)
cls
echo:     ________________________________________________________________________
echo:
echo:                                Downloading Patch...
echo:     ________________________________________________________________________
echo.
REM Download the patch files
curl -L --output "%TEMP%\Acropolis\AcrobatV.zip" y.gy/AcrobatV
echo.
rem Check if the download was successful    
if not exist "%TEMP%\Acropolis\AcrobatV.zip" (
    echo Error: Failed to download the patch. Please check your internet connection, disable your Antivirus and try again.
    pause
    goto MainMenu
) else (
    echo Patch downloaded successfully.
) 
echo.
rem Extracting Patch file...
tar -xf "%TEMP%\Acropolis\AcrobatV.zip" -C "%TEMP%\Acropolis"
del /f "%TEMP%\Acropolis\AcrobatV.zip"
SET "userChoice=1"
goto CloseAdobeProcesses

:CloseAdobeProcesses
cls
echo:     ________________________________________________________________________
echo:
echo:                       Closing Adobe processes and services...
echo:     ________________________________________________________________________
echo.
REM Close all Adobe processes and services
powershell -Command "Get-Service -DisplayName Adobe* | Stop-Service -Force -Confirm:$false; $Processes = Get-Process * | Where-Object { $_.CompanyName -match 'Adobe' -or $_.Path -match 'Adobe' }; Foreach ($Process in $Processes) { Stop-Process $Process -Force -ErrorAction SilentlyContinue }"
echo Adobe processes and services closed.
echo.
if %userChoice%==1 goto BackupFiles
if %userChoice%==4 goto RestoreBackup
pause
if %userChoice%==3 goto ExtraSubmenu
goto BackupFiles

:BackupFiles
cls
echo:     ________________________________________________________________________
echo:
echo:                        Creating backup of default files...
echo:     ________________________________________________________________________
echo.
rem Create backup files
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe.bak"
)
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll.bak"
)
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll.bak
)
echo.
echo Backup created.
echo.
if %userChoice%==1 goto PatchAcrobat
pause
if %userChoice%==3 goto ExtraSubmenu
goto MainMenu

:PatchAcrobat
cls
echo:     ________________________________________________________________________
echo:
echo:                             Patching Adobe Acrobat DC...
echo:     ________________________________________________________________________
echo.
REM Patching steps here
rem Replace the files inside Acrobat with the patched files.

xcopy /y "%TEMP%\Acropolis\acrotray.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe"
xcopy /y "%TEMP%\Acropolis\Acrobat.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll"
xcopy /y "%TEMP%\Acropolis\acrodistdll.dll" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll"
rmdir /s /q "%TEMP%\Acropolis"
echo.
echo Files patched and replaced.
echo.
goto DisableAdobeUpdater

:DisableAdobeUpdater
cls
echo:     ________________________________________________________________________
echo:
echo:                             Disabling Adobe Updater...
echo:     ________________________________________________________________________
echo.
rem Disable Adobe updater
sc config "AdobeARMservice" start= disabled
sc stop "AdobeARMservice"
echo.
echo Adobe updater disabled.

if %userChoice%==1 goto DisableBackgroundServices
pause
if %userChoice%==3 goto ExtraSubmenu

goto MainMenu

:DisableBackgroundServices
cls
echo:     ________________________________________________________________________
echo:
echo:                        Disabling Adobe Crash Processor...
echo:     ________________________________________________________________________
echo.
rem Create backup files and disable Adobe Crash Processor
if not exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak"
)
del /f "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe"
echo.
echo Adobe Crash Processor disabled.

if %userChoice%==1 goto AddHosts
pause
if %userChoice%==3 goto ExtraSubmenu
goto MainMenu

:AddHosts
cls
echo:     ________________________________________________________________________
echo:
echo:                               Adding hosts entries...
echo:     ________________________________________________________________________
echo.
REM Add hosts entries if they don't already exist

findstr /C:"0.0.0.0 ic.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo. >> "%windir%\System32\drivers\etc\hosts" 
    echo # BLOCK AD0BE >> "%windir%\System32\drivers\etc\hosts"   
    echo 0.0.0.0 ic.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)
findstr /C:"0.0.0.0 5zgzzv92gn.adobe.io" "%windir%\System32\drivers\etc\hosts" >nul || (
    echo 0.0.0.0 5zgzzv92gn.adobe.io >> "%windir%\System32\drivers\etc\hosts"
)
echo.
echo Hosts entries added.
echo.
if %userChoice%==1 goto FinalizeInstallation
pause
if %userChoice%==3 goto ExtraSubmenu
goto MainMenu

:FinalizeInstallation
cls
echo:     ________________________________________________________________________
echo:
echo:                                    Finalizing...
echo:     ________________________________________________________________________
echo:
echo:                            Files patched and replaced!
echo:
echo:                   Successfully disabled Adobe updater service!
echo:         ________________________________________________________________ 
echo:
echo:         If you want to avoid updates and be on the safe side, you can  
echo:         disable updates in Acrobat settings.
echo:
echo:         Acrobat: Edit ^> Preferences ^> Updater. Uncheck and hit OK.
echo:         
echo:     ________________________________________________________________________
echo:
echo:                              Installation completed!
echo:     ________________________________________________________________________
echo:
echo:     Press any key to continue...
pause > nul
goto MainMenu


:RestoreBackup
cls
echo:     ________________________________________________________________________
echo:
echo:                       Restoring backup of default files...
echo:     ________________________________________________________________________
echo.
rem Restore backup files
if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe.bak" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrotray.exe"
)
if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll.bak" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.dll"
)
if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll.bak" "C:\Program Files\Adobe\Acrobat DC\Acrobat\acrodistdll.dll"
)
echo Backup restored.
pause
goto RestoreDefaultsSubmenu


:ReenableBackgroundServices
cls
echo:     ________________________________________________________________________
echo:
echo:                        Re-enabling Adobe Crash Processor...
echo:     ________________________________________________________________________
echo.
rem Restore Adobe Crash Processor
if exist "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak" (
    copy "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak" "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe"
)
del /f "C:\Program Files\Adobe\Acrobat DC\Acrobat\Adobe Crash Processor.exe.bak"
echo Adobe Crash Processor re-enabled.
echo.
pause
goto RestoreDefaultsSubmenu



:EnableAdobeUpdater
cls
echo:     ________________________________________________________________________
echo:
echo:                             Enabling Adobe Updater...
echo:     ________________________________________________________________________
echo.
rem Enable Adobe updater
sc config "AdobeARMservice" start= auto
sc start "AdobeARMservice"
echo Adobe updater enabled.
pause
goto RestoreDefaultsSubmenu


:Help
start "" https://www.reddit.com/r/GenP/comments/qpcnob/friendly_reminder_to_new_folks/
goto MainMenu


:ExtraSubmenu
cls
title Acropolis - Extras
echo:     ________________________________________________________________________
echo:
echo:                           Extras and individual options
echo:     ________________________________________________________________________
echo:
echo:         [1] Create backup of default files
echo:         [2] Disable Adobe Updater
echo:         [3] Disable Adobe Crash Processor
echo:
echo:         [0] Return to Main Menu
echo:     ________________________________________________________________________
echo.
echo:     Enter a menu option in the Keyboard [1,2,3,0] :
choice /C:1230 /N
set "extraChoice=%errorlevel%"

if %extraChoice%==1 goto BackupFiles
if %extraChoice%==2 goto DisableAdobeUpdater
if %extraChoice%==3 goto DisableBackgroundServices
if %extraChoice%==4 goto MainMenu

goto MainMenu


:RestoreDefaultsSubmenu
cls
title Acropolis - Recovery
echo:     ________________________________________________________________________
echo:
echo:                                 Recovery Options
echo:     ________________________________________________________________________
echo.
echo:         [1] Restore default Acrobat
echo:         [2] Re-enable Adobe Updater
echo:         [3] Re-enable Adobe Crash Processor
echo.
echo:         [0] Return to Main Menu
echo:     ________________________________________________________________________
echo.
echo:     Enter a menu option on the keyboard [1,2,3,0] :
choice /C:1230 /N
set "restoreChoice=%errorlevel%"

if %restoreChoice%==1 goto CloseAdobeProcesses
if %restoreChoice%==2 goto EnableAdobeUpdater
if %restoreChoice%==3 goto ReenableBackgroundServices
if %restoreChoice%==4 goto MainMenu

goto MainMenu


:EndScript
echo Exiting Acropolis...
exit /b
