@echo off
chcp 65001 > nul
:: 65001 - UTF-8

:: Admin rights check
if "%1"=="admin" (
    echo Запущено с правами администратора
) else (
    echo Запрашиваю права администратора...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

:: Removing service
echo [*] Удаляю сервис "Discord обход от Eclipsa"...
net stop zapret >nul 2>&1
sc delete zapret >nul 2>&1
echo [+] Сервис успешно удален!

pause 