#!/bin/bash

# ROOT PASSWORD
password='******'

# FILE PATH ON THE SOURCE PC
file14='/home/FILE-NAME14'
file15='/home/FILE-NAME15'

# SCRIPT TO BE RUN
script='/usr/local/bin/mvtodesktop.sh'

ip14=(
	"192.168.*.*" 
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	)
ip15=(
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
	"192.168.*.*"
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
				sshpass -p $password scp -o StrictHostKeyChecking=no "$file" root@"${ip[i]}":/tmp/;
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
				sshpass -p $password ssh root@"${ip[i]}"	'bash -s' < $script;
		else
			printf 'HOST '"${ip[i]}"' IS OFFLINE ✗\n'
  		fi
done
	}

#######  CP TO HOST - POP 14  #######
cptohost $file14 "${ip14[@]}"
#######  MV ON HOST - POP 14  #######
mvtodesktop $file14 "${ip14[@]}"

#######  CP TO HOST - POP 15  #######
cptohost $file15 "${ip15[@]}"
#######  MV ON HOST - POP 15  #######
mvtodesktop $file15 "${ip15[@]}"
