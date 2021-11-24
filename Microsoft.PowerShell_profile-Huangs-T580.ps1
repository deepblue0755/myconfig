$Env:Path += ";D:\vim\vim82"
$Env:Path += ";D:\cygwin64\bin"
Set-Alias which Get-Command
function touch {set-content -Path ($args[0]) -Value ($null)} 
function reload { &$profile }
