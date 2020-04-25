@REM NOTE:
@REM -----
@REM The "npm" command must be in the PATH variable
@REM Requires node.js to be installed (https://nodejs.org/en/).

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

@REM Build EEP Web App
cd %projectPath%\web-app
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)

call npm run-script start
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)

cd %oldDir%
endlocal
