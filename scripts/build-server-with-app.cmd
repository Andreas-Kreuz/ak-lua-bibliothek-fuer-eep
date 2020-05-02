@REM NOTE:
@REM -----
@REM The "npm" command must be in the PATH variable
@REM Requires node.js to be installed (https://nodejs.org/en/).
@REM
@REM The "mvn" command must be in the PATH variable
@REM Requires Maven to be installed (https://maven.apache.org/)
@REM
@REM The "java" command must be in the PATH variable
@REM Requires a Java Development Kit to be installed (https://jdk.java.net/)

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

@REM Build EEP Web Server completely
cd "%projectPath%\web-server"
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call npm run-script build
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
