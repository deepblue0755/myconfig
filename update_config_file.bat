@echo off
set GIT=D:\Git\bin\git.exe

if not exist "%GIT%" (
    echo ERROR: could  not find the git command
    goto end
)

rem set the filename postfix according to the machine name
set NAME_SUFFIX=Unknown
if "%COMPUTERNAME%" == "HUANGS-T580" (
    set NAME_SUFFIX=Huangs-T580
)

if "%NAME_SUFFIX%" == "Unknown" (
    echo ERROR: unknown machine
    goto end
)

echo INFO: git pull to latest git version ...
pushd D:\documents\11-configs-from-github
%GIT% pull origin master
popd

call :update_config_file
goto end

rem -----------------------------------------------------------
rem Function update_config_file
rem -----------------------------------------------------------
:update_config_file
echo INFO: Compare files to see if update is needed
fc D:\cygwin64\home\mianb\.bash_profile D:\documents\11-configs-from-github\_bash_profile-%NAME_SUFFIX% > NUL
if %errorlevel% EQU 0 (
    echo INFO: No update has been found for cygwin64 bash_profile
) else (
    xcopy /y D:\cygwin64\home\mianb\.bash_profile D:\documents\11-configs-from-github\_bash_profile-%NAME_SUFFIX%
    echo INFO: "git update to origin ..."
    pushd D:\documents\11-configs-from-github
    %GIT% add _bash_profile-%NAME_SUFFIX%
    %GIT% commit -m "UPDATE cygwin64 bash_profile from machine %COMPUTERNAME%"
    for /f %%i in ( '%GIT% remote' ) do (
        echo "INFO: git push to %%i" 
        %GIT% push -u %%i  master
    )
    popd
)
goto:EOF


:end
echo INFO: Job is done, bye bye
exit /b 0
