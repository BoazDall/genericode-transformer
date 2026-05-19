@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "projectRoot=%~DP0.."
rem TEST_DIR, SAXON_CUSTOM_OPTIONS and XSPEC_HOME are expected by XSpec and described on https://github.com/xspec/xspec/wiki/Environment-Variables
set "TEST_DIR=%projectRoot%\target"
set "SAXON_CUSTOM_OPTIONS=--recognize-uri-query-parameters:true"

for %%f in ("%projectRoot%\src\test\xml\xspec\*.xspec") do (
    call "%XSPEC_HOME%\bin\xspec.bat" "%%~f"
)
endlocal