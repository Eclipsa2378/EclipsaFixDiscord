@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
:: 65001 - UTF-8
title Discord обход от Eclipsa v1.0

:: Основной цикл программы
:start
call :init
if errorlevel 1 goto end
goto main_menu

:: Инициализация
:init
:: Функции проверки статуса
call :check_bypass_status
call :check_autostart_status

:: Проверка первого запуска
if not exist "%APPDATA%\FixDiscordEclipsa\first_run.txt" (
    cls
    echo ===================================
    echo     Спасибо за использование
    echo     Discord обхода от Eclipsa
    echo ===================================
    echo:
    echo Спасибо что пользуйтесь моим обходом!
    echo Я планирую его доробатывать и обновлять.
    echo:
    echo Все обновления будут публиковаться на GitHub:
    echo https://github.com/Eclipsa2378/EclipsaFixDiscord
    echo:
    echo Если возникнут трудности или предложения,
    echo обратитесь ко мне:
    echo:
    echo ДС: eclipsa2678
    echo ТГ: EclipsaBT
    echo GitHub: https://github.com/Eclipsa2378/EclipsaFixDiscord
    echo:
    pause
    mkdir "%APPDATA%\FixDiscordEclipsa" 2>nul
    echo 1 > "%APPDATA%\FixDiscordEclipsa\first_run.txt"
)

:: P.S. Обход работает так же с YouTube
cd /d "%~dp0"
set BIN=%~dp0bin\
set LISTS=%~dp0lists\
set CONNECTION_CHECK_INTERVAL=60
set MAX_RECONNECT_ATTEMPTS=3
set RUNNING=0

:: Проверка наличия русских символов в пути
echo %~dp0 | findstr /R "[А-Яа-яЁё]" >nul
if not errorlevel 1 (
    cls
    echo ===================================
    echo  Discord обход от Eclipsa v1.2
    echo ===================================
    echo:
    echo [!] ОШИБКА: Путь к обходу содержит русские символы!
    echo [!] Путь: %~dp0
    echo [!] Перенесите обход в папку без русских символов в пути.
    echo [!] Русские символы в пути могут привести к некорректной работе обхода.
    echo:
    pause
    exit /b 1
)

:: Проверка наличия файлов
if not exist "%BIN%winws.exe" (
    cls
    echo ===================================
    echo  Discord обход от Eclipsa v1.0
    echo ===================================
    echo:
    echo [!] ОШИБКА: Не найден файл %BIN%winws.exe
    echo [!] Отсутствуют необходимые файлы для работы обхода.
    echo [!] Обратитесь к Eclipsa за помощью.
    echo:
    pause
    exit /b 1
)

if not exist "%LISTS%list-general.txt" (
    cls
    echo ===================================
    echo  Discord обход от Eclipsa v1.0
    echo ===================================
    echo:
    echo [!] ОШИБКА: Не найдены необходимые файлы в папке lists
    echo [!] Обратитесь к Eclipsa за помощью.
    echo:
    pause
    exit /b 1
)
exit /b 0

:check_bypass_status
tasklist /NH /FI "IMAGENAME eq winws.exe" 2>NUL | find /I "winws.exe">NUL
if "%ERRORLEVEL%"=="0" (
    set "BYPASS_STATUS=активен"
) else (
    set "BYPASS_STATUS=неактивен"
)
exit /b

:check_autostart_status
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "DiscordBypassEclipsa" >nul 2>&1
if "%ERRORLEVEL%"=="0" (
    set "AUTOSTART_STATUS=включен"
) else (
    set "AUTOSTART_STATUS=выключен"
)
exit /b

:: Функция для проверки соединения с Discord
:check_connection
if %RUNNING%==0 goto main_menu
ping -n 1 discord.com >nul 2>&1
if errorlevel 1 (
    cls
    echo ===================================
    echo  Discord обход от Eclipsa v1.0
    echo ===================================
    echo:
    echo [!] Обнаружена потеря соединения с Discord!
    echo [!] Пытаюсь восстановить соединение...
    
    set reconnect_attempt=1
    
    :reconnect_loop
    if !reconnect_attempt! GTR %MAX_RECONNECT_ATTEMPTS% (
        echo:
        echo [X] Не удалось восстановить соединение после %MAX_RECONNECT_ATTEMPTS% попыток.
        echo [X] Пожалуйста, обратитесь к Eclipsa за фиксом!
        echo:
        pause
        goto main_menu
    )
    
    echo:
    echo [*] Попытка !reconnect_attempt!/%MAX_RECONNECT_ATTEMPTS%: Перезапуск обхода...
    
    :: Пробуем разные конфигурации обхода
    if !reconnect_attempt!==1 (
        echo [*] Пробую конфигурацию 1...
        set "config=--wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=list-general.txt --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new --filter-udp=50000-50100 --ipset=ipset-discord.txt --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=list-general.txt --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=list-general.txt --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin" --new --filter-udp=443 --ipset=ipset-cloudflare.txt --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new --filter-tcp=80 --ipset=ipset-cloudflare.txt --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --ipset=ipset-cloudflare.txt --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin""
    ) else if !reconnect_attempt!==2 (
        echo [*] Пробую конфигурацию 2...
        set "config=--wf-tcp=443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=list-general.txt --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new --filter-udp=50000-50100 --ipset=ipset-discord.txt --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=443 --hostlist=list-general.txt --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8"
    ) else (
        echo [*] Пробую конфигурацию 3...
        set "config=--wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=list-general.txt --dpi-desync=fake --dpi-desync-repeats=8 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new --filter-udp=50000-50100 --ipset=ipset-discord.txt --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=8 --new --filter-tcp=80 --hostlist=list-general.txt --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=list-general.txt --dpi-desync=fake,split,disorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=8 --dpi-desync-fooling=md5sig,badseq"
    )
    
    :: Останавливаем текущий обход, если он запущен
    taskkill /f /im winws.exe >nul 2>&1
    
    :: Запускаем обход с новой конфигурацией
    start "Discord от Eclipsa" /min "%BIN%winws.exe" !config!
    
    :: Ждем 5 секунд для установки соединения
    timeout /t 5 >nul
    
    :: Проверяем соединение после перезапуска
    ping -n 1 discord.com >nul 2>&1
    if errorlevel 1 (
        echo [!] Попытка !reconnect_attempt! не удалась.
        set /a reconnect_attempt+=1
        goto reconnect_loop
    ) else (
        echo:
        echo [+] Соединение восстановлено!
        timeout /t 2 >nul
        goto main_menu
    )
)

:: Ждем и проверяем снова
timeout /t %CONNECTION_CHECK_INTERVAL% >nul
goto check_connection

:main_menu
cls
set RUNNING=0
call :check_bypass_status
call :check_autostart_status
echo:
echo ===================================
echo  Discord обход от Eclipsa v1.0
echo ===================================
echo  Обход: %BYPASS_STATUS%
echo  Автозапуск: %AUTOSTART_STATUS%
echo ===================================
echo  P.S. Обход работает так же с YouTube
echo ===================================
echo  Обновления доступны на GitHub:
echo  https://github.com/Eclipsa2378/EclipsaFixDiscord
echo ===================================
echo  ВАЖНО: Путь к обходу не должен содержать русские символы!
echo ===================================
echo:
echo [1] Включить обход
echo [2] Включить автозапуск обхода
echo [3] Просто выбери чтобы заработал дискорд
echo [4] Проверка соединения с дискорд
echo [5] Выключить автозапуск обхода
echo [6] Обновление обхода
echo:
set /p choice="Выберите опцию (1-6): "

if "%choice%"=="1" (
    cls
    echo ===================================
    echo  Discord обход от Eclipsa v1.0
    echo ===================================
    echo:
    echo [*] Запускаю обход Discord...
    taskkill /f /im winws.exe >nul 2>&1
    start "Discord от Eclipsa" /min "%BIN%winws.exe" --wf-tcp=80,443 --wf-udp=443,50000-50100 ^
    --filter-udp=443 --hostlist=%LISTS%list-general.txt --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
    --filter-udp=50000-50100 --ipset=%LISTS%ipset-discord.txt --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
    --filter-tcp=80 --hostlist=%LISTS%list-general.txt --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
    --filter-tcp=443 --hostlist=%LISTS%list-general.txt --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin" --new ^
    --filter-udp=443 --ipset=%LISTS%ipset-cloudflare.txt --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
    --filter-tcp=80 --ipset=%LISTS%ipset-cloudflare.txt --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
    --filter-tcp=443 --ipset=%LISTS%ipset-cloudflare.txt --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin"
    echo [+] Обход успешно запущен!
    set RUNNING=1
    echo [*] Запускаю мониторинг соединения...
    echo [i] Если Discord перестанет работать, программа автоматически попытается восстановить соединение.
    echo:
    echo [i] Для возврата в меню нажмите любую клавишу...
    pause >nul
    goto main_menu
) else if "%choice%"=="2" (
    cls
    echo ===================================
    echo  Установка автозапуска
    echo ===================================
    echo:
    
    :: Проверка прав администратора
    net session >nul 2>&1
    if errorlevel 1 (
        echo [!] Требуются права администратора
        echo [i] Перезапустите программу от имени администратора
        pause
        goto main_menu
    )
    
    :: Сохраняем полный путь к файлам
    set "FULL_PATH=%~dp0"
    set "FULL_BIN_PATH=%~dp0bin"
    set "FULL_LISTS_PATH=%~dp0lists"
    
    :: Удаляем старую запись (если есть)
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "DiscordBypassEclipsa" /f >nul 2>&1
    
    :: Добавление в автозапуск с полными путями и экранированием кавычек
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "DiscordBypassEclipsa" /t REG_SZ /d "cmd.exe /c start \"\" /min \"%FULL_BIN_PATH%\winws.exe\" --wf-tcp=443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=\"%FULL_LISTS_PATH%\list-general.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%FULL_BIN_PATH%\quic_initial_www_google_com.bin\"" /f
    
    if errorlevel 1 (
        echo [!] Ошибка при добавлении в автозапуск
        echo [i] Попробуйте перезапустить от имени администратора
        pause
        goto main_menu
    )
    
    echo [+] Автозапуск успешно включен!
    echo [i] Обход будет запускаться при старте Windows
    echo:
    pause
    goto main_menu
) else if "%choice%"=="3" (
    cls
    echo ===================================
    echo  Discord простой обход от Eclipsa
    echo ===================================
    echo:
    echo [*] Запускаю быстрый обход Discord...
    taskkill /f /im winws.exe >nul 2>&1
    start "Discord быстрый обход" /min "%BIN%winws.exe" --wf-tcp=443 --wf-udp=443,50000-50100 ^
    --filter-udp=443 --hostlist=%LISTS%list-general.txt --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
    --filter-udp=50000-50100 --ipset=%LISTS%ipset-discord.txt --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
    --filter-tcp=443 --hostlist=%LISTS%list-general.txt --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8
    echo [+] Обход запущен! Discord должен работать.
    echo:
    pause
    goto main_menu
) else if "%choice%"=="4" (
    cls
    echo ===================================
    echo  Проверка соединения с Discord
    echo ===================================
    echo:
    echo [*] Проверка соединения с Discord...
    ping -n 4 discord.com
    if errorlevel 1 (
        echo:
        echo [X] Ошибка соединения с Discord! Обратитесь к Eclipsa за фиксом.
    ) else (
        echo:
        echo [+] Соединение с Discord работает нормально!
    )
    
    echo:
    echo [*] Проверка версии обхода...
    echo [i] Текущая версия: 1.0.0
    echo [i] Автор: Eclipsa
    echo [i] При возникновении проблем обращайтесь: @Eclipsa
    echo:
    pause
    goto main_menu
) else if "%choice%"=="5" (
    cls
    echo ===================================
    echo  Отключение автозапуска
    echo ===================================
    echo:
    
    :: Проверка прав администратора
    net session >nul 2>&1
    if errorlevel 1 (
        echo [!] Требуются права администратора
        echo [i] Перезапустите программу от имени администратора
        pause
        goto main_menu
    )
    
    :: Удаление из автозапуска
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "DiscordBypassEclipsa" /f >nul 2>&1
    
    if errorlevel 1 (
        echo [!] Ошибка при удалении из автозапуска
        echo [i] Попробуйте перезапустить от имени администратора
        pause
        goto main_menu
    )
    
    echo [+] Автозапуск успешно отключен!
    echo:
    pause
    goto main_menu
) else if "%choice%"=="6" (
    cls
    echo ===================================
    echo  Обновление обхода от Eclipsa
    echo ===================================
    echo:
    echo [i] Обновления публикуются на GitHub:
    echo     https://github.com/Eclipsa2378/EclipsaFixDiscord
    echo:
    echo [i] Важная информация:
    echo     В обходе имеются все данные со всех других обходов,
    echo     чтобы вам не пришлось искать самому.
    echo:
    echo [i] Если Discord не работает:
    echo     1. Проверьте на downdetector.com работу Discord
    echo     2. Возможно ужесточили блокировки
    echo     3. Скачайте новую версию с GitHub
    echo:
    echo [i] Рекомендации при проблемах:
    echo     1. Проверьте наличие обновлений на GitHub
    echo     2. Попробуйте перезапустить обход
    echo     3. Попробуйте перезагрузить компьютер
    echo     4. Если не помогло - обратитесь к Eclipsa
    echo:
    echo [i] Контакты для связи:
    echo     ДС: eclipsa2678
    echo     ТГ: EclipsaBT
    echo     GitHub: https://github.com/Eclipsa2378/EclipsaFixDiscord
    echo:
    pause
    goto main_menu
) else (
    echo:
    echo [!] Неверный выбор. Пожалуйста, выберите опцию от 1 до 6.
    timeout /t 2 >nul
    goto main_menu
)

if %RUNNING%==1 goto check_connection
goto main_menu

:end
endlocal
echo.
echo Нажмите любую клавишу для выхода...
pause >nul