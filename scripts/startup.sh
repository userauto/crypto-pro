#!/bin/bash

# Получение тестовой ЭЦП при первом запуске. Раскомментировать строку ниже, если нужно получить тестовый ЭЦП.
#/opt/cprocsp/bin/amd64/cryptcp -creatcert -dn "E=user@cryptopro.ru,C=RU, CN=CRYPTO-PRO Test Center 2, SN=CRYPTO-PRO" -both -cont '\\.\HDIMAGE\Тестовая_ЭЦП' -ku -certusage "1.3.6.1.5.5.7.3.2" -ca http://testca.cryptopro.ru/certsrv -provt 80 -exprt && sleep 5

# Запуск cryptsrv
sleep 1
/bin/bash -c /opt/cprocsp/sbin/amd64/cryptsrv 
                                                                                                                                                  
# Запуск графической среды Крипто-Про при старте контейнера. Раскомментировать строку ниже, если нужна графическая оболочка при старте.
#/opt/cprocsp/bin/amd64/cptools

# Продолжения работы контейнера в фоновом режиме
tail -f /dev/null
