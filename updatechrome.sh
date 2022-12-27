#!/bin/bash

# TESTA ARQUIVO
if 
    test -f "/usr/local/bin/atualiza.sh"; 
then
    echo "O ARQUIVO JA EXISTE!"
    arquivo=1
    if 
        rm -f /usr/local/bin/atualiza.sh;
    then
        echo "REMOCAO DO ARQUIVO - OK"
    else
        echo "REMOCAO DO ARQUIVO - ERRO"
    fi
else
    echo "O ARQUIVO NAO EXISTE!"
    arquivo=0
fi

# CRIA ARQUIVO
if 
    touch /usr/local/bin/atualiza.sh;
then
    echo "CRIAR ARQUIVO - OK"
else
    echo "CRIAR ARQUIVO - ERRO"
fi

# SCRIPT NO ARQUIVO
if 
echo '#!/bin/bash

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
        #statements
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
fi' > /usr/local/bin/atualiza.sh
then
    echo "INSTRUCOES NO ARQUIVO - OK"
else
    echo "INSTRUCOES NO ARQUIVO - ERRO"
fi

# PERMISSÃO NO ARQUIVO
if 
    chmod +x /usr/local/bin/atualiza.sh
then
    echo "PERMISSAO - OK"
else
    echo "PERMISSAO - ERRO"
fi

# INSTRUÇÃO CRONTAB
if [[ $arquivo == 0 ]];then
    if 
        printf "\n#On reboot will update Chrome if the version inslalled is older than a month\n@reboot root /usr/local/bin/atualiza.sh\n" >> /etc/crontab
    then
        echo "CRONTAB EXECUTADO - OK"
    else
        echo "CRONTAB - ERRO"
    fi
elif [[ $arquivo == 1 ]];then
    echo "CRONTAB VERIFICADO - OK"
fi

# CRON RESTART
if 
    /etc/init.d/cron restart
then
    echo "CRON RESTART - OK"
else
    echo "CRON RESTART - ERRO"
fi
