@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Start with clearing the ERRORLEVEL back to 0, in case an error occurred during a previous execution of this batch file
rem See also https://ss64.com/nt/errorlevel.html
(call )

if "%~1" == "" goto displayUsageMessage
if "%~2" == "" goto displayUsageMessage

set "gcFile=%~1"
set "codeListSubregisterUri=%~2"
set "addRdfAsAlternateFormat=true"
if not "%~3" == "" set "addRdfAsAlternateFormat=%~3"

set "projectRoot=%~DP0.."
set "morganaConfig=%projectRoot%\local-scripts\morgana-config.xml"
set "pipeline=%projectRoot%\src\main\xml\xproc\add-publication-details-to-gc.xpl"

where /Q Morgana
if %errorlevel% geq 1 goto displayMessageMorgana

if not exist "%morganaConfig%" goto displayMessageMorganaConfig

echo:
echo Arguments set:
echo   file                         %gcFile%
echo   code-list-subregister-uri    %codeListSubregisterUri%
echo   add-rdf-as-alternate-format  %addRdfAsAlternateFormat%
echo:

call Morgana -config="%morganaConfig%" "%pipeline%" -option:gc-file-path="%gcFile%" -option:code-list-subregister-uri="%codeListSubregisterUri%" -option:add-csv-as-alternate-format=true -option:add-rdf-as-alternate-format=%addRdfAsAlternateFormat%

echo Morgana exit code: %errorlevel%

endlocal
exit /B %errorlevel%

:displayUsageMessage
    echo:
    echo Usage: %~nx0 gc-file code-list-subregister-uri [add-rdf-as-alternate-format]
    echo:
    echo     gc-file                        genericode file path (note: this file will be UPDATED by running this script)
    echo     code-list-subregister-uri      first part of the retrieval location URIs
    echo                                    E.g. "https://example.org/codelistregister/subregister/"
    echo     add-rdf-as-alternate-format    true ^(default^) or false
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
