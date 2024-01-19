# Acropolis

## Overview
This repository is a script to download, extract and install Adobe Acrobat DC, and apply a patch to the installation. 

## Usage
1. Make sure you have `curl` and `tar` installed.
2. Run the script in a Command Prompt or PowerShell window.
3. The script will download Adobe Acrobat DC and the patch to your `%HOMEPATH%\Downloads\Acropolis` folder.
4. It will then extract the files and run the installation silently.
5. The patch will replace a file in the installed program folder with your own file.
6. The script will also disable the Adobe updater service.
7. Finally, it will remove the `Acropolis` folder.

## Note
- The script assumes you have administrative privileges on your system.
- The script has only been tested on Windows, with a 64-bit version of Adobe Acrobat DC.
- Use at your own risk.
