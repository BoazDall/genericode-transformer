@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Start with clearing the ERRORLEVEL back to 0, in case an error occurred during a previous execution of this batch file
rem See also https://ss64.com/nt/errorlevel.html
(call )

if "%~1" == "" goto displayUsageMessage
if "%~2" == "" goto displayUsageMessage

set "gcFileDirectory=%~1"
set "codeListShortName=%~2"
set "codeListVersionNumber=1.0.0"
if not "%~3" == "" set "codeListVersionNumber=%~3"

set "projectRoot=%~DP0.."
set "morganaConfig=%projectRoot%\local-scripts\morgana-config.xml"
set "pipeline=%projectRoot%\src\main\xml\xproc\create-first-code-list-version.xpl"

where /Q Morgana
if %errorlevel% geq 1 goto displayMessageMorgana

if not exist "%morganaConfig%" goto displayMessageMorganaConfig

echo:
echo Arguments set:
echo   gc-file-directory         %gcFileDirectory%
echo   code-list-short-name      %codeListShortName%
echo   code-list-version-number  %codeListVersionNumber%
echo:

call Morgana -config="%morganaConfig%" "%pipeline%" -option:gc-file-directory="%gcFileDirectory%" -option:code-list-short-name="%codeListShortName%" -option:code-list-version-number="%codeListVersionNumber%"

echo Morgana exit code: %errorlevel%

endlocal
exit /B %errorlevel%

:displayUsageMessage
    echo:
    echo Usage: %~nx0 gc-file-directory code-list-short-name [code-list-version-number]
    echo:
    echo     gc-file-directory         directory in which the initial version of the new code list will be created
    echo     code-list-short-name      short name of the code list
    echo     code-list-version-number  version number of the initial code list version
    echo                               default: 1.0.0
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
