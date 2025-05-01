@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
:: 65001 - UTF-8

:: Set current version and URLs
set "LOCAL_VERSION=1.0.0"
set "AUTHOR=Eclipsa"
set "CONTACT=@Eclipsa"

echo:
echo ===================================
echo  Проверка обновлений от %AUTHOR%
echo ===================================
echo:
echo Текущая версия обхода: %LOCAL_VERSION%
echo:
echo При возникновении проблем обращайтесь: %CONTACT%
echo:

if not "%1"=="soft" pause
endlocal 