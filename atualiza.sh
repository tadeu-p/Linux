#!/bin/bash

# TESTA SE HÁ CONEXÃO, CONTINUARÁ TESTANDO ATE A CONDIÇÃO FOR VERDADEIRA OU TER REALIZADO 60 ITERAÇÕES
counter=0
until ping -c1 -q 192.168.1.1 &>/dev/null; do
    sleep 1
    echo "$counter" >>/tmp/chrome.log
    let counter++
    if [[ $counter == 60 ]]; then
        echo "Tempo excedido!" >>/tmp/chrome.log
        exit 0
    fi
done

# CONCATENA O ANO E O MÊS DO DIA EM QUE O SCRIPT ESTÁ SENDO EXECUTADO. EX: 2205
today=`date "+%y%m"`
# CONCATENA O ANO E O MÊS DA DATA DE ALTERAÇÃO DA PASTA. EX: 2109
chrome=`date -r /opt/google/chrome "+%y%m"`

# TESTA SE A DATA (AAMM) DA ÚLTIMA ALTERAÇÃO DA PASTA DO CHROME FOR MAIOR QUE DATA DO DIA (AAMM)
# EX: 2205 > 2109
# NESTE CASO COMO A DATA DA ÚLTIMA ALTERAÇÃO É MENOR QUE A DATA DO DIA, O SCRIPT SERÁ EXECUTADO
if [[ $today > $chrome ]]; then
    echo "Atualizado em " `date`>>/tmp/chrome.log
    chmod 700 /opt/google/chrome/google-chrome
    # BAIXA O CHROME DO SERVIDOR, O QUAL ATUALIZA A VERSÃO 1X POR SEMANA
    if 
        wget "192.168.1.10/pasta/programas/chrome.deb" -O /tmp/chrome.deb >>/tmp/chrome.scr; 
    then
        echo "Chrome baixado!" >>/tmp/chrome.log
    else
        echo "Falha ao baixar o Chrome!" >>/tmp/chrome.log
    fi
    
    # INSTALA O CHROME
    if 
        dpkg -i /tmp/chrome.deb >>/tmp/chrome.scr; 
    then
        echo "Chrome instalado!" >>/tmp/chrome.log
    else
        echo "Falha ao instalar o Chrome!" >>/tmp/chrome.log
    fi

    if
        apt-get install -f -y >>/tmp/chrome.scr;
    then
        echo "Finalizada instalacao!" >>/tmp/chrome.log
    else
        echo "Falha ao finalizar a instalacao!" >>/tmp/chrome.log
    fi
    chmod 755 /opt/google/chrome/google-chrome
else
    echo "A versão instalada já é a mais atualizada!" >>/tmp/chrome.log
    # CASO A DATA SEJA IGUAL, O SCRIPT É ENCERRADO
    exit 0
fi
