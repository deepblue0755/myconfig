$Env:Path += ";D:\vim\vim82"
$Env:Path += ";D:\cygwin64\bin"
Set-Alias which Get-Command
Set-Alias ifconfig ipconfig
Set-Alias alias Set-Alias
Set-PSReadlineOption -EditMode Vi
function touch {set-content -Path ($args[0]) -Value ($null)} 
function reload { .$profile }
function config { vim $profile }
function nuc11 { Enter-PSSession -ComputerName NUC11 }
function cygwin { D:\cygwin64\bin\mintty -i /Cygwin-Terminal.ico -  }
function windowsterminal { D:\batch\start_win_store_app.ps1 -AppName WindowsTerminal }
function Get-ComObject { gci HKLM:\Software\Classes -ea 0| ? {$_.PSChildName -match '^\w+\.\w+$' -and
(gp "$($_.PSPath)\CLSID" -ea 0)} | ft PSChildName }
$HOSTNAME=[System.Net.Dns]::GetHostName()
