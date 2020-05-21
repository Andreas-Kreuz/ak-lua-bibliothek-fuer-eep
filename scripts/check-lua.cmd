@REM NOTE:
@REM -----
@REM The "luacheck" and "busted" commands must be in the PATH variable

call luacheck --std max+busted lua/LUA
IF %ERRORLEVEL% NEQ 0 (
    echo %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)


call busted --verbose --coverage -o plainTerminal --
IF %ERRORLEVEL% NEQ 0 (
    echo %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)
