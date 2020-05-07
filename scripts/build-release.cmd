@REM -----
@REM NOTE:
@REM -----
@REM The "npm" command must be in the PATH variable
@REM Requires node.js to be installed (https://nodejs.org/en/).
@REM
@REM The "mvn" command must be in the PATH variable
@REM Requires Maven to be installed (https://maven.apache.org/)
@REM
@REM The "lua" command must be in the PATH variable
@REM Requires Lua to be installed (http://luabinaries.sourceforge.net/download.html)
@REM
@REM The "7z.exe" command must be callable from "C:\Program Files\7-Zip\7z.exe"
@REM Requires 7-zip to be installed (https://www.7-zip.org/)
@REM
@REM The "java" commands must be in the PATH variable
@REM Requires a Java Development Kit to be installed (https://jdk.java.net/)

setlocal
SET oldDir=%CD%
SET projectPath="%~dp0.."

@REM rebuild the server
call "%~dp0build-server-with-app.cmd"
IF %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

xcopy /Y %projectPath%\web-server\dist\lua-server-for-eep.exe %projectPath%\lua\LUA\ak
IF %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

@REM Create the installation package for EEP
cd %projectPath%\lua\LUA
IF %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

call lua ModellInstallation.lua
IF %ERRORLEVEL% NEQ 0 (
    exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
