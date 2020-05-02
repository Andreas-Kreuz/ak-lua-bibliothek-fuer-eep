@REM NOTE:
@REM -----
@REM The "java" command must be in the PATH variable
@REM Requires a Java Runtime Environment to be installed (https://jdk.java.net/)

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

@REM Build EEP Web Shared
cd %projectPath%\web-shared
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call npm install
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

@REM Build EEP Web Server
cd %projectPath%\web-server
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call npm install
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

@REM Build EEP Web App
cd %projectPath%\web-app
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call npm install
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
