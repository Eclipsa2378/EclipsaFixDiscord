@echo off
chcp 65001 > nul
:: 65001 - UTF-8
title Discord быстрый обход от Eclipsa

cd /d "%~dp0"
cd ..
call MainFiles\service_status.bat zapret
call MainFiles\check_updates.bat soft
echo:
echo ===================================
echo  Discord быстрый обход от Eclipsa
echo ===================================
echo:
echo Запускаю обход для Discord...
echo:

set BIN=%~dp0..\bin\

start "zapret: discord от Eclipsa" /min "%BIN%winws.exe" --wf-tcp=443 --wf-udp=443,50000-50100 ^
--filter-udp=443 --hostlist="..\lists\list-general.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="%BIN%quic_initial_www_google_com.bin" --new ^
--filter-udp=50000-50100 --ipset="..\lists\ipset-discord.txt" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new ^
--filter-tcp=443 --hostlist="..\lists\list-general.txt" --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8

echo Обход успешно запущен!
echo:
echo Теперь вы можете запустить Discord и работать без проблем.
echo:
pause 