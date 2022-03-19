#!/bin/bash

# SENHA ROOT
senha='8h2y3a'

# FILE PATH ON THE SOURCE PC
file14='/home/POP-01.27.14-guia-escolha-tratamento-antibacteriano-endovenoso-principais-infeccoes-adulto.pdf'
file15='/home/POP-01.27.15-profilaxia-antimicrobiana-procedimentos-cirurgicos.pdf'

# SCRIPT TO BE RUN
script='/usr/local/bin/mvtodesktop.sh'


# OS IPS NÃO COMENTADOS SÃO OS QUE ESTÃO FALTANDO

ip14=(
	#PS
	# "192.168.3.48" 
	# "192.168.0.145" 
	# "192.168.1.134" 
	# "192.168.3.51" 
	# "192.168.3.52" 
	# "192.168.1.129" 
	# "192.168.0.252" 
	# "192.168.1.19" 
	# "192.168.0.186" 
	# "192.168.3.55"
	#CM
	# "192.168.3.28"
	# "192.168.3.29"
	# "192.168.3.31"
	# "192.168.3.32"
	# "192.168.3.251"
	# "192.168.3.252"
	# "192.168.3.253"
	# "192.168.0.171"
	# "192.168.0.172"
	)
ip15=(
	#CC
	# "192.168.3.33"
	# "192.168.3.34"
	# "192.168.3.50"
	# "192.168.3.62"
	"192.168.3.78"
	# "192.168.1.209"
	# "192.168.3.84"
	#NEURO
	"192.168.3.88"
	# "192.168.3.66"
	# "192.168.3.43"
	# "192.168.3.44"
	# "192.168.0.147"
	# "192.168.0.148"
	# "192.168.0.149"
	# "192.168.0.150"
	"192.168.0.151"
	#PA
	# "192.168.0.206"
	# "192.168.0.204"
	# "192.168.3.67"
	# "192.168.0.205"
	# #PB
	# "192.168.0.237"
	# "192.168.3.58"
	# "192.168.0.251"
	# "192.168.3.59"
	# "192.168.3.69"
	)

function cptohost() {
	file="$1"
	shift
	ip=("$@") 
for i in "${!ip[@]}"; 
	do
		if
			ping -c1 -q "${ip[i]}" &>/dev/null
			then
				sshpass -p $senha scp -o StrictHostKeyChecking=no "$file" root@"${ip[i]}":/tmp/;
				printf 'FILE COPIED TO: '"${ip[i]}"' ✓\n'
		else
			 printf 'HOST '"${ip[i]}"' IS OFFLINE ✗\n'
  		fi
done
	}

function mvtodesktop() {
	file="$1"
	shift
	ip=("$@")
for i in "${!ip[@]}"; 
	do
		if
			ping -c1 -q "${ip[i]}" &>/dev/null
			then
				sshpass -p $senha ssh root@"${ip[i]}"	'bash -s' < $script;
		else
			printf 'HOST '"${ip[i]}"' IS OFFLINE ✗\n'
  		fi
done
	}

#######  CP TO HOST - POP 14  #######
# cptohost $file14 "${ip14[@]}"
#######  MV ON HOST - POP 14  #######
# mvtodesktop $file14 "${ip14[@]}"

#######  CP TO HOST - POP 15  #######
cptohost $file15 "${ip15[@]}"
#######  MV ON HOST - POP 15  #######
mvtodesktop $file15 "${ip15[@]}"
