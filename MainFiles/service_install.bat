@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
:: 65001 - UTF-8
title Установка сервиса от Eclipsa

:: Admin rights check
if "%1"=="admin" (
    echo Запущено с правами администратора
) else (
    echo Запрашиваю права администратора...
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

:: Main
cd /d "%~dp0"
cd ..
set BIN_PATH=%~dp0..\bin\

echo ===================================
echo  Установка сервиса от Eclipsa
echo ===================================
echo:

:: Checking for updates
call MainFiles\check_updates.bat soft
echo:

echo [*] Устанавливаю сервис "Discord обход от Eclipsa"...

:: Setup the service with optimal parameters
set "args= --wf-tcp=80,443 --wf-udp=443,50000-50100 --filter-udp=443 --hostlist=\"lists\list-general.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%BIN_PATH%quic_initial_www_google_com.bin\" --new --filter-udp=50000-50100 --ipset=\"lists\ipset-discord.txt\" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new --filter-tcp=80 --hostlist=\"lists\list-general.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --hostlist=\"lists\list-general.txt\" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%BIN_PATH%tls_clienthello_www_google_com.bin\" --new --filter-udp=443 --ipset=\"lists\ipset-cloudflare.txt\" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=\"%BIN_PATH%quic_initial_www_google_com.bin\" --new --filter-tcp=80 --ipset=\"lists\ipset-cloudflare.txt\" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new --filter-tcp=443 --ipset=\"lists\ipset-cloudflare.txt\" --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=\"%BIN_PATH%tls_clienthello_www_google_com.bin\""

:: Creating service with parsed args
set ARGS=%args%
echo [i] Параметры запуска: !ARGS!
set SRVCNAME=zapret

echo:
echo [*] Устанавливаю сервис "Discord обход от Eclipsa"...
net stop %SRVCNAME% >nul 2>&1
sc delete %SRVCNAME% >nul 2>&1
sc create %SRVCNAME% binPath= "\"%BIN_PATH%winws.exe\" %ARGS%" DisplayName= "Discord обход от Eclipsa" start= auto
sc description %SRVCNAME% "Обход блокировок Discord от Eclipsa"
sc start %SRVCNAME%

echo:
echo [+] Сервис успешно установлен и запущен!
echo [i] Теперь обход будет работать автоматически при каждой загрузке Windows.
echo:
pause
endlocal 