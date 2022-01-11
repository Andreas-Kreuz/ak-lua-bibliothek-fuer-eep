@REM NOTE:
@REM -----
@REM The "bundle" command must be in the PATH variable
@REM Requires Ruby to be installed (https://rubyinstaller.org/)

setlocal
SET oldDir=%CD%
SET projectPath=%~dp0..

bundle exec jekyll serve
IF %ERRORLEVEL% NEQ 0 (
   exit /b %ERRORLEVEL%
)

cd %oldDir%
endlocal
