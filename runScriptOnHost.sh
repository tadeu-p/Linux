#!/bin/bash

# SENHA ROOT
senha='123456'

# CAMINHO DO SCRIPT A SER EXECUTADO
script='/usr/local/bin/NOME_DO_ARQUIVO.sh'

# VETOR DE IPS NOS QUAIS DESEJA EXECUTAR O SCRIPT
ips=(
    192.168.1.1
    192.168.1.2
    192.168.1.3
    192.168.1.4
    192.168.1.5
    192.168.1.6
    192.168.1.7
    192.168.1.8
    192.168.1.9
    192.168.1.10
)
function runScriptOnHost() {
    ip=("$@")
for i in "${!ip[@]}"; 
    do
        if
            # TESTA SE O IP ESTA RESPONDENDO
            ping -c1 -q "${ip[i]}" &>/dev/null
            then
                # CASO ESTEJA RESPONDENDO EXECUTA O SCRIPT PASSADO COMO PARAMETRO
                if sudo sshpass -p $senha ssh -o StrictHostKeyChecking=no root@"${ip[i]}" 'bash -s' < $script;
                then
                echo 'Script executado com sucesso em '"${ip[i]}"'!'
                echo "============================================================================="
                sleep 1
            else
                echo 'Falha ao executar o script em '"${ip[i]}"'!'
                echo "============================================================================="
                sleep 1
            fi
        else
            # SE O DESTINO NAO RESPONDER AO PING MOSTRARA A MENSAGEM ABAIXO
            printf 'DESTINO '"${ip[i]}"' ESTÁ OFFLINE ✗\n'
            echo "============================================================================="
        fi
done
    }
# CHAMA A FUNCAO PASSANDO POR PARAMETRO O VETOR DE IPS
echo "========================================================== INICIO =========================================================="
runScriptOnHost "${ips[@]}"
echo "========================================================== FINAL =========================================================="
