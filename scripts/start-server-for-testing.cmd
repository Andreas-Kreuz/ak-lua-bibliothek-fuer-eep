@REM NOTE:
@REM -----
@REM The "java" command must be in the PATH variable
@REM Requires a Java Runtime Environment to be installed (https://jdk.java.net/)

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

call java -jar %projectPath%\server\target\web-app.jar --test "%projectPath%\lua\LUA\ak\io\exchange"
IF %ERRORLEVEL% NEQ 0 (
   exit %ERRORLEVEL%
)
endlocal
