@echo off
set GIT=D:\Git\bin\git.exe
set CONFIG_BACKUP_DIR=D:\documents\11-configs-from-github

if not exist "%GIT%" (
    echo ERROR: could  not find the git command
    goto end
)

if not exist "%CONFIG_BACKUP_DIR%" (
    echo ERROR: could  not find the folder %CONFIG_BACKUP_DIR%
    goto end
)

rem set the filename postfix according to the machine name
set NAME_SUFFIX=Unknown
if "%COMPUTERNAME%" == "HUANGS-T580" (
    set NAME_SUFFIX=Huangs-T580
)

if "%COMPUTERNAME%" == "NUC11" (
    set NAME_SUFFIX=NUC11
)

if "%NAME_SUFFIX%" == "Unknown" (
    echo ERROR: unknown machine
    goto end
)

echo ************************************************************
echo Update config files at %DATE% %TIME% at %COMPUTERNAME%
echo ************************************************************

echo INFO: git pull to latest git version ...
pushd %CONFIG_BACKUP_DIR%
%GIT% pull origin master
popd

call :update_config_files D:\cygwin64\home\%USERNAME%\.bash_profile  _bash_profile
call :update_config_files C:\Users\%USERNAME%\.ideavimrc  _ideavimrc
call :update_config_files D:\Vim\_vimrc  _vimrc
goto end

rem -----------------------------------------------------------
rem Function update_config_files
rem -----------------------------------------------------------
:update_config_files
echo -----------------------------------------------------------
set CONFIG_BACKUP_DIR=D:\documents\11-configs-from-github
REM SET THE FILENAME POSTFIX ACCORDING TO THE MACHINE NAME
if "%COMPUTERNAME%" == "HUANGS-T580" (
    set NAME_SUFFIX=Huangs-T580
)

if "%COMPUTERNAME%" == "NUC11" (
    set NAME_SUFFIX=NUC11
)
echo INFO: check if there's file %1 exist
if not exist "%1" (
    echo INFO: there's not such file %1
    goto :EOF
)
echo INFO: compare %1 file with %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX%
fc %1 %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX% > NUL
if %errorlevel% EQU 0 (
    echo INFO: No update has been found for %1
) else (
    if not exist %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX% (
        echo INFO: create new empty file %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX%  
        type NUL > %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX% 
    )
    echo INFO: copy file %1 to %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX% 
    xcopy /y %1 %CONFIG_BACKUP_DIR%\%2-%NAME_SUFFIX%  > NUL
    echo INFO: git update to origin ...
    pushd %CONFIG_BACKUP_DIR%
    echo INFO: Entering %CONFIG_BACKUP_DIR% ...
    %GIT% add %2-%NAME_SUFFIX%
    %GIT% commit -m "UPDATE %1 from machine %COMPUTERNAME%"
    for /f %%i in ( '%GIT% remote' ) do (
        echo "INFO: git push to %%i" 
        %GIT% push -u %%i  master
    )
    popd
)
goto :EOF


:end
echo INFO: Job is done, bye bye
exit /b 0
