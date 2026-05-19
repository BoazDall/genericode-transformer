@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Start with clearing the ERRORLEVEL back to 0, in case an error occurred during a previous execution of this batch file
rem See also https://ss64.com/nt/errorlevel.html
(call )

if "%~1" == "" goto displayUsageMessage
if "%~2" == "" goto displayUsageMessage
if "%~3" == "" goto displayUsageMessage

set "localDirectoryCodeListRegister=%~1"
set "codeListRegisterUri=%~2"
set "report=%~3"
set "overwriteExistingAlternativeFormats=false"
if not "%~4" == "" set "overwriteExistingAlternativeFormats=%~4"
set "debug=false"
if not "%~5" == "" set "debug=%~5"

set "projectRoot=%~DP0.."
set "morganaConfig=%projectRoot%\local-scripts\morgana-config.xml"
set "pipeline=%projectRoot%\src\main\xml\xproc\generate-code-list-register-site.xpl"
set "docinfoDir=%projectRoot%\src\main\xml\xhtml"

where /Q asciidoctorj
if %errorlevel% geq 1 goto displayMessageAsciidoctorJ

where /Q Morgana
if %errorlevel% geq 1 goto displayMessageMorgana

if not exist "%morganaConfig%" goto displayMessageMorganaConfig

if not exist "%localDirectoryCodeListRegister%" (
    echo Directory containing code list register site does not exist: %localDirectoryCodeListRegister%
    goto displayUsageMessage
)
for %%f in ("%report%") do (
    if not exist "%%~DPf" (
        echo Directory for report does not exist: %%~DPf
        goto displayUsageMessage
    )
)

echo:
echo Arguments set:
echo   local-directory-code-list-register      %localDirectoryCodeListRegister%
echo   code-list-register-uri                  %codeListRegisterUri%
echo   report                                  %report%
echo   overwrite-existing-alternative-formats  %overwriteExistingAlternativeFormats%
echo   debug                                   %debug%
echo:

if not exist "%localDirectoryCodeListRegister%\README.adoc" (
    echo "%localDirectoryCodeListRegister%\README.adoc" does not exist, did you specify the correct directory?
    exit /B 1
)

echo Convert top level README file from AsciiDoc to HTML
echo Converting "%localDirectoryCodeListRegister%\README.adoc"
rem Disable delayed expansion to prevent the exclamation mark in the syntax for unsetting the stylesheet attribute from being stripped by the batch parser
setlocal DisableDelayedExpansion
call asciidoctorj -b xhtml5 -a stylesheet! -a docinfo=private -a docinfodir="%docinfoDir%" -o "%localDirectoryCodeListRegister%\index.html" "%localDirectoryCodeListRegister%\README.adoc"
endlocal
if %errorlevel% neq 0 exit /B %errorlevel%

echo Convert 2nd level README files from AsciiDoc to HTML
for /D %%d in ("%localDirectoryCodeListRegister%\*") do (
    if exist "%%d\README.adoc" (
        echo Converting "%%d\README.adoc"
		rem Disable delayed expansion to prevent the exclamation mark in the syntax for unsetting the stylesheet attribute from being stripped by the batch parser
		setlocal DisableDelayedExpansion
        call asciidoctorj -b xhtml5 -a stylesheet! -a docinfo=shared -a docinfodir="%docinfoDir%" -o "%%d\index.html" "%%d\README.adoc"
		endlocal
        if !errorlevel! neq 0 exit /B !errorlevel!
    )
)

echo Update HTML files
call Morgana -config="%morganaConfig%" "%pipeline%" -option:input-directory="%localDirectoryCodeListRegister%" -option:code-list-register-uri="%codeListRegisterUri%" -output:report="%report%" -option:overwrite-existing-alternative-formats=%overwriteExistingAlternativeFormats% -static:debug=%debug%

echo Morgana exit code: %errorlevel%

endlocal
exit /B %errorlevel%

:displayUsageMessage
    echo:
    echo Usage: %~nx0 local-directory-code-list-register code-list-register-uri report [overwrite-existing-alternative-formats] [debug]
    echo:
    echo     local-directory-code-list-register      path to existing local directory containing the code list register site
    echo                                             E.g. "C:\path\to\local\copy\of\codelistregister"
    echo     code-list-register-uri                  URI of the code list register
    echo                                             E.g. "https://example.org/codelistregister/"
    echo     report                                  path to local file in existing directory to which to write the report (XML file)
    echo                                             E.g. "C:\path\to\report.xml"
    echo     overwrite-existing-alternative-formats  false ^(default^) or true
    echo     debug                                   false ^(default^) or true
    echo:
    endlocal
    exit /B 1

:displayMessageAsciidoctorJ
    echo asciidoctorj was not found, please install it and try again.
    echo Use print-configuration.bat to check your configuration.
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
