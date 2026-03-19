@REM NOTE:
@REM -----
@REM The "npm" command must be in the PATH variable
@REM Requires node.js to be installed (https://nodejs.org/en/).

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

cd /d "%projectPath%"
call yarn.cmd workspace @ak/web-app run cy-tests
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
