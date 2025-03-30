@echo off
@REM NOTE:
@REM -----
@REM The "luacheck" and "busted" commands must be in the PATH variable

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

@REM Run checks
cd %projectPath%
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

call luacheck --quiet --std max+busted lua/LUA
IF %ERRORLEVEL% NEQ 0 (
    echo %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

chcp 65001
call busted --verbose --coverage -o utfTerminal -- .
IF %ERRORLEVEL% NEQ 0 (
    echo %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
