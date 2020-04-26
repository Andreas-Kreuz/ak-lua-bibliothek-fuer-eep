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

@REM Build EEP Web Server with included EEP Web App
cd "%projectPath%\server"
IF %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

call mvn clean compile
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)


@REM Build EEP Web App
cd "%projectPath%\web-app"
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call npm run-script build
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)


@REM Build EEP Web Server with included EEP Web App
cd "%projectPath%\server"
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

xcopy /E /I /S ..\web-app\dist\ak-eep-web target\classes\public\ak-eep-web
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call mvn install package
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
