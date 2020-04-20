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
cd "%projectPath%\ak-eep-web-server"
IF %ERRORLEVEL% NEQ 0 (
    exit %ERRORLEVEL%
)

call mvn clean compile
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)


@REM Build EEP Web App
cd "%projectPath%\ak-eep-web"
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)

call npm run-script build
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)


@REM Build EEP Web Server with included EEP Web App
cd "%projectPath%\ak-eep-web-server"
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)

xcopy /E /I /S ..\ak-eep-web\dist\ak-eep-web target\classes\public\ak-eep-web
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)

call mvn install package
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)

cd %oldDir%
endlocal
