#!/bin/bash

# FILE PATHS ON HOST
file14path='/tmp/FILE_NAME14'
file15path='/tmp/FILE_NAME15'

# FILE NAMES
file14='FILE_NAME14'
file15='FILE_NAME15'

# CHECKS IF THERE IS ANY OF THE TWO FILES ON 
if test -f "$file14path" || test -f "$file15path"
	then
		printf 'ONE FILE WAS FOUND! ! ! !\n'
	else
		printf 'FILES NOT FOUND! ! ! !\n'
		exit 0
fi

if test -f "$file14path"
then
	printf 'FILE 14\n'
	# VARIABLE USUARIO RECEIVES ALL THE SYSTEM USERS AS AN ARRAY
	usuario=(`eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1`)
	for i in "${!usuario[@]}"; do
 		if 
 			# COPY THE FILE TO THE USER DESKTOP
			cp "$file14path" /home/"${usuario[i]}"/Área\ de\ trabalho; 
 		then
 			printf 'FILE '$file14' MOVED TO DESKTOP ✓\n'
 			exit 0
 		else
 			printf 'FAILED TO MOVE THE FILE TO DESKTOP ✗\n'
 			exit 0
 		fi
 	done
elif 
	test -f "$file15path"
	then
		printf 'FILE 15\n'
		# VARIABLE USUARIO RECEIVES ALL THE SYSTEM USERS AS AN ARRAY
		usuario=(`eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1`)
		for i in "${!usuario[@]}"; do
			if 
			# COPY THE FILE TO THE USER DESKTOP
			cp "$file15path" /home/"${usuario[i]}"/Área\ de\ trabalho;  
			then
				printf 'FILE '$file15' MOVED TO DESKTOP ✓\n'
				exit 0
			else
				printf 'FAILED TO MOVE THE FILE TO DESKTOP ✗\n'
				exit 0
			fi
		done
else
	printf 'FATAL ERROR! \n'	
fi
