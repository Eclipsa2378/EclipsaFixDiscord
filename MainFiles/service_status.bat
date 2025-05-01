@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
:: 65001 - UTF-8

:: Get service status
sc query %1 >nul 2>&1
if not errorlevel 1 (
    for /f "tokens=4" %%a in ('sc query %1 ^| findstr STATE') do (
        set state=%%a
    )
    
    if "!state!"=="1" (
        echo Сервис %1: Остановлен
    ) else if "!state!"=="2" (
        echo Сервис %1: Запускается
    ) else if "!state!"=="3" (
        echo Сервис %1: Остановка
    ) else if "!state!"=="4" (
        echo Сервис %1: Работает
    ) else (
        echo Сервис %1: Неизвестное состояние
    )
) else (
    echo Сервис %1: Не установлен
)

endlocal 