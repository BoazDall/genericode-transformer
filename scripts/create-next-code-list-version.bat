@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Start with clearing the ERRORLEVEL back to 0, in case an error occurred during a previous execution of this batch file
rem See also https://ss64.com/nt/errorlevel.html
(call )

if "%~1" == "" goto displayUsageMessage
if "%~2" == "" goto displayUsageMessage

set "gcFileExistingVersion=%~1"
set "newVersionNumber=%~2"

set "projectRoot=%~DP0.."
set "morganaConfig=%projectRoot%\local-scripts\morgana-config.xml"
set "pipeline=%projectRoot%\src\main\xml\xproc\create-next-code-list-version.xpl"

where /Q Morgana
if %errorlevel% geq 1 goto displayMessageMorgana

if not exist "%morganaConfig%" goto displayMessageMorganaConfig

echo:
echo Arguments set:
echo   gc-file-path-existing-version %gcFileExistingVersion%
echo   new-version-number            %newVersionNumber%
echo:

call Morgana -config="%morganaConfig%" "%pipeline%" -option:gc-file-path-existing-version="%gcFileExistingVersion%" -option:new-version-number="%newVersionNumber%" -static:debug=true

echo Morgana exit code: %errorlevel%

endlocal
exit /B %errorlevel%

:displayUsageMessage
    echo:
    echo Usage: %~nx0 gc-file-path-existing-version new-version-number
    echo:
    echo     gc-file-path-existing-version  file path of the existing genericode code list version
    echo     new-version-number             version number of the new genericode code list version that will be created
    echo                                    E.g. "1.1.0" if the existing version is "1.0.0".
    echo:
    echo The new code list version is stored in the same directory as the existing code list version.
    echo:
    endlocal
    exit /B 1

:displayMessageMorgana
    echo Morgana was not found, please install it and try again.
    echo Use print-configuration.bat to check your configuration.
    endlocal
    exit /B 1

:displayMessageMorganaConfig
    echo Morgana configuration file not found: %morganaConfig%
    endlocal
    exit /B 1
