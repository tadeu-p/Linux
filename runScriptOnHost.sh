#!/bin/bash

# SENHA ROOT
senha='8h2y3a'

# CAMINHO DO SCRIPT A SER EXECUTADO
# script='/usr/local/bin/updatechrome.sh'
script='/usr/local/bin/info.sh'


# VETOR DE IPS NOS QUAIS DESEJA EXECUTAR O SCRIPT
ips=(
    # -------------------- SCRIPT CHROME --------------------
    # 192.168.3.32  # Prescrição           - PERMISSÃO NEGADA
    # 192.168.0.139 # Oncologia            - PERMISSÃO NEGADA
    # 192.168.2.33  # Enfermagem           - CONEXÃO RECUSADA
    # 192.168.2.28  # Administrativo       - CONEXÃO RECUSADA
    # 192.168.2.61  # Recepção 2           - CONEXÃO RECUSADA
    # 192.168.0.254 # Consultório 1        - PERMISSÃO NEGADA
    # 192.168.1.185 # AIH                  - CONEXÃO RECUSADA
    # 192.168.2.74  # Auditoria 2          - DESLIGADO
    # 192.168.1.24  # Auditores            - PERMISSÃO NEGADA
    # 192.168.0.141 # Presidente           - DESLIGADO
    # 192.168.0.229 # Imprensa             - CONEXÃO RECUSADA
    # 192.168.2.33  # Enfermagem           - CONEXÃO RECUSADA
    #========================================================
    # --------------- Desligados ---------------
    192.168.2.61  # Recepção 2              - CONEXÃO RECUSADA
    192.168.1.185 # AIH                     - CONEXÃO RECUSADA
    192.168.2.33  # Enfermagem              - CONEXÃO RECUSADA
    192.168.1.24  # Auditores               - PERMISSÃO NEGADA
    192.168.2.133 # AIH                     - DESLIGADO
    192.168.2.227 # Administrativo 2        - DESLIGADO
    192.168.2.74  # Auditoria 2             - DESLIGADO
    192.168.1.38  # Enfermagem              - DESLIGADO
    192.168.1.14  # Pastoral                - DESLIGADO
    #-----------------------------------------
    # 1 - Processador ruim e pouca memória
    # 192.168.1.92  # NIR Médicos
    # 192.168.2.20  # Sala Multi 2
    
    # 2 - Processador ruim e memória OK
    
    # 3 - Processador OK e pouca memória
    # 192.168.1.150 # Estagiário
 
    # 4 - Processador OK e memória OK
  
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
