#!/bin/bash

function is_on() {
	ip=("$@")
for i in "${!ip[@]}"; 
	do
		if 
			arping -c1 -q "${ip[i]}" &>/dev/null
		then
  			printf 'HOST '"${ip[i]}"' IS ONLINE\n'
  			echo 'HOST '"${ip[i]}"  >>/tmp/ipon
  			ipon=$((ipon+1))
  		else
  			printf 'HOST '"${ip[i]}"' IS OFFLINE\n'
  			echo 'HOST '"${ip[i]}"  >>/tmp/ipoff
  			ipoff=$((ipoff+1))
  		fi
done
}
ip1=(
	"192.168.1.1"
	"192.168.1.2"
	"192.168.1.3"
	"192.168.1.4"
	"192.168.1.5"
	"192.168.1.6"
	"192.168.1.7"
	"192.168.1.8"
	"192.168.1.9"
	"192.168.1.10"
	)


# is_on "${ip0[@]}"
is_on "${ip1[@]}"
# is_on "${ip2[@]}"
# is_on "${ip3[@]}"
# is_on "${ip4[@]}"

printf ' ---------------------------------------- \n'
printf 'TOTAL ONLINE  '"$ipon"' \n'
printf 'TOTAL OFFLINE '"$ipoff"' \n'
echo ' ---------------------------------------- \n' >> /tmp/ipoff
echo ' ---------------------------------------- \n' >> /tmp/ipon
echo 'TOTAL OFFLINE ' $ipoff >> /tmp/ipoff
echo 'TOTAL ONLINE ' $ipon >> /tmp/ipon
