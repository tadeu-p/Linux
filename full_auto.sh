#!/bin/bash

#########################################################
#	LISTA DE ARQUIVOS UTILIZADOS EM PRODUÇÃO	#
#########################################################
sourceslist="/etc/apt/sources.list"
release="/etc/os-release"
ssh="/etc/ssh/sshd_config"
grub="/etc/default/grub"
cups="/etc/cups/cups-browsed.conf"
avahi="/etc/avahi/avahi-daemon.conf"
bloquear="/usr/local/bin/bloquear.sh"
desbloquear="/usr/local/bin/desbloquear.sh"
lightdm="/etc/lightdm/lightdm.conf"


################################################### INÍCIO DA CRIAÇÃO DAS FUNÇÕES ###################################################

# TESTA SE O SISTEMA UTILIZADO ESTÁ APTO A PROSSEGUIR COM A INSTALAÇÃO
function descobreSO(){
	while IFS= read -r line; do
    if [[ "$line" = *"Debian"* ]] && [[ "$line" = *"10"* ]]; then
     	clear
     	so="O SO instalado é o Debian 10!"
     	echo "$so"
     	instalarDebian10
     	#exit 0
	elif [[ "$line" = *"Debian"* ]] && [[ "$line" = *"11"* ]]; then
     	clear
     	so="O SO instalado é o Debian 11!"
     	echo "$so"
     	instalarDebian11
     	#exit 0
    elif [[ "$line" = *"Ubuntu"* ]] && [[ "$line" = *"20"* ]]; then
     	clear
     	so="O SO instalado é o Ubuntu 20.04!"
     	echo "$so"
     	instalarUbuntu20
     	#exit 0
    fi
	done < $release
	if [[ -z $so ]]; then
		clear
     	echo "ESTE SISTEMA OPERACIONAL NÃO É COMPATÍVEL COM ESTA INSTALAÇÃO!!!"
     	exit 0
     fi
	sleep 3
	}

# ATUALIZA A SOURCES LIST PARA O DEBIAN 10
function sourceListDebian10(){
	if test -f "$sourceslist"
		then
		echo "
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN 10 REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ oldstable main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable main contrib non-free

deb http://deb.debian.org/debian/ oldstable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ oldstable-updates main contrib non-free

deb http://deb.debian.org/debian-security oldstable/updates main
deb-src http://deb.debian.org/debian-security oldstable/updates main

deb http://ftp.debian.org/debian stretch-backports main
deb-src http://ftp.debian.org/debian stretch-backports main" > "$sourceslist";
	else
		echo "O arquivo "$sourceslist" não foi encontrado!"
		return 1
	fi
	}

# ATUALIZA A SOURCES LIST PARA O DEBIAN 11
function sourceListDebian11(){
	if test -f "$sourceslist"
		then
			echo "
#------------------------------------------------------------------------------#
#                   OFFICIAL DEBIAN 11 REPOS                    
#------------------------------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ stable main contrib non-free
deb-src http://deb.debian.org/debian/ stable main contrib non-free

deb http://deb.debian.org/debian/ stable-updates main contrib non-free
deb-src http://deb.debian.org/debian/ stable-updates main contrib non-free

deb http://deb.debian.org/debian-security stable/updates main
deb-src http://deb.debian.org/debian-security stable/updates main

deb http://ftp.debian.org/debian buster-backports main
deb-src http://ftp.debian.org/debian buster-backports main

deb http://deb.debian.org/debian/ bullseye main contrib non-free
deb-src http://deb.debian.org/debian/ bullseye main contrib non-free
deb http://deb.debian.org/debian/ bullseye-updates contrib main non-free
deb http://security.debian.org/ bullseye-security contrib main non-free
" > "$sourceslist";
	else
		echo "O arquivo "$sourceslist" não foi encontrado!"
		return 1
	fi
	}

# ATUALIZA A SOURCES LIST PARA O UBUNTU 20.04
function sourceListUbuntu2004(){
	if test -f "$sourceslist"
		then
			echo "
#------------------------------------------------------------------------------#
#                   OFFICIAL UBUNTU 20.04 REPOS                    
#------------------------------------------------------------------------------#

###### Ubuntu Main Repos
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse

deb http://archive.canonical.com/ubuntu focal partner
deb-src http://archive.canonical.com/ubuntu focal partner" > "$sourceslist";
	else
		echo "O arquivo "$sourceslist" não foi encontrado!"
		return 1
	fi
	}

# POR ENQUANTO PARA COMPUTADORES COM APENAS 1 USUÁRIO
# CRIA OS ARQUIVOS DE BLOQUEIO E DESBLOQUEIO DA ÁREA DE TRABALHO
function bloqueioDesktop(){
	touch $bloquear
	touch $desbloquear
	# Bloqueio
	echo "#!/bin/bash
	user=""
function run-in-user-session() {
    display_id="'":$(find /tmp/.X11-unix/* | sed '"'s#/tmp/.X11-unix/X##'"' | head -n 1)"
    usuario=$(who | grep "\(${display_id}\)" | awk '"'{print "'$1'"}'"')
    user_id=$(id -u "$usuario")
    environment=("DISPLAY=$display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$user_id/bus")
    sudo -Hu "$usuario" env "${environment[@]}" "$@"
}
run-in-user-session gsettings set org.mate.panel locked-down true
chown root.root -R /home/$usuario/Área\ de\ trabalho/;
chmod 700 /usr/bin/mate-appearance-properties;
chmod 700 /usr/bin/mozo' > $bloquear;
	# Desbloqueio
	echo "#!/bin/bash
function run-in-user-session() {
    display_id="'":$(find /tmp/.X11-unix/* | sed '"'s#/tmp/.X11-unix/X##'"' | head -n 1)"
    usuario=$(who | grep "\(${display_id}\)" | awk '"'{print "'$1'"}'"')
    user_id=$(id -u "$usuario")
    environment=("DISPLAY=$display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$user_id/bus")
    sudo -Hu "$usuario" env "${environment[@]}" "$@"
}
run-in-user-session gsettings set org.mate.panel locked-down false
chown $usuario.$usuario -R /home/$usuario/Área\ de\ trabalho/;
chmod 755 /usr/bin/mate-appearance-properties;
chmod 755 /usr/bin/mozo' > $desbloquear;
	chmod +x $bloquear && chmod +x $desbloquear;

	}

# DESABILITA A BUSCA DE IMPRESSORAS PELO CUPS
function desabilitarBuscaImpressoras(){
	echo "DESABILITANDO BUSCA DE IMPRESSORAS..."
	sed -i 's/^BrowseRemoteProtocols dnssd cups*/BrowseRemoteProtocols none/g' $cups
	/etc/init.d/cups restart 
	/etc/init.d/cups-browsed restart
	sed -i 's/^use-ipv4=yes*/use-ipv4=no/g' $avahi 
	sed -i 's/^use-ipv6=yes*/use-ipv6=no/g' $avahi
	/etc/init.d/avahi-daemon restart;
	}

# HABILITA O LOGIN COM O USUÁRIO ROOT VIA SSH
function habilitarLoginRootSSH(){
	echo "HABILITANDO LOGIN DE ROOT..."
	sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/g' $ssh
	/etc/init.d/ssh restart
	}

# REMOVE A TELA DO GRUB DA INICIALIZAÇÃO DO SISTEMA
function removerTelaGrub(){
	echo "REMOVENDO TELA DE SELEÇÃO DO GRUB..."
	sed -i 's/^GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' $grub 
	update-grub
	}

function loginAutomatico(){
	echo "HABILITANDO LOGIN AUTOMÁTICO..."
	sed -i 's/#autologin-user=/autologin-user='$usuario'/g' $lightdm
	sed -i 's/#autologin-user-timeout=0/autologin-user-timeout=0/g' $lightdm
}


# POR ENQUANTO PARA COMPUTADORES COM APENAS 1 USUÁRIO
# RECEBE AS INFORMAÇÕES NECESSÁRIA PARA CRIAÇÃO DO ARQUIVO NOMEPC
function nomePC(){
	clear
	display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    # variável usuario recebe o valor a partir do id do display
    usuario=$(who | grep "\(${display_id}\)" | awk '{print $1}')
	echo "Usuário: "$usuario
	# variável hostname recebe o valor da variável de ambiente $HOSTNAME
	hostname=($HOSTNAME);
	echo "Hostname: "$hostname
	read -p "Digite número de IP: " ip;
	#ip="192.168.2.209"
	echo "IP: "$ip
	read -p "Digite número do Patrimônio: " patrimonio;
	#patrimonio="6916"
	echo "Patrimônio: "$patrimonio
	# Criação arquivo NomePC
	cd /home/$usuario/Área\ de\ [a-zA-Z]rabalho;
	touch NomePC;
	echo "NomePC - $hostname
Endereço IP - $ip
-----------------------------------------
Patrimônio - $patrimonio" > /home/$usuario/Área\ de\ [a-zA-Z]rabalho/NomePC
}

# VER DIFERENÇAS ENTRE OS SOs
function instalarSoftwares(){
	echo "ATUALIZANDO REPOSITÓRIOS E INSTALANDO SOFTWARES ADICIONAIS..."
	apt-get update
	apt-get install gedit dconf-editor mozo aptitude libnet-ifconfig-wrapper-perl nfs-common curl wget apt-transport-https system-config-printer -y
	if [[ $so = *"Debian 11"* ]]; then
			apt-get install cups cups-browsed printer-driver-gutenprint -y
	fi
	}

# INSTALA A ÚLTIMA VERSÃO DO GOOGLE CHROME
function instalarChrome(){
	echo "INSTALANDO GOOGLE CHROME..."
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb;
	dpkg -i /tmp/chrome.deb;
	apt-get install -f -y
	}

# INSTALA A ÚLTIMA VERSÃO DO FIREFOX
function instalarFirefox(){
	echo "INSTALANDO MOZILLA FIREFOX..."
	wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=pt-BR" -O /tmp/firefox.tar.bz2;
	tar -jxvf /tmp/firefox.tar.bz2 -C /opt/
	}

# INSTALA A VERSÃO 91.5.0 DO THUNDERBIRD
function instalarThunderbird(){
	echo "INSTALANDO MOZILLA THUNDERBIRD..."
	wget "https://download.mozilla.org/?product=thunderbird-91.5.0-SSL&os=linux64&lang=pt-BR" -O /tmp/thunderbird.tar.bz2;
	tar -jxvf /tmp/thunderbird.tar.bz2 -C /opt
	}

# INSTALA A VERSÃO 6.2.0 DO VNC
function instalarVNC(){
	echo "INSTALANDO VNC..."
	wget https://www.realvnc.com/download/file/vnc.files/VNC-Server-6.2.0-Linux-x64.deb -O /tmp/vnc.deb;
	dpkg -i /tmp/vnc.deb 
	vnclicense -add 232NH-NH733-T85TH-KT2P2-7ZPUA
	}

function instalarDebian10(){
	if sourceListDebian10; then
		echo "SOURCES LIST ATUALIZADA!"
		echo "PROSSEGUINDO COM AS CONFIGURAÇÕES!!!"
		sleep 1
	else
		echo "FALHA AO ATUALIZAR SOURCES LIST!"
		echo "VERIFIQUE O SCRIPT ANTES DE PROSSEGUIR"
		sleep 2
		exit 0
	fi
	}

function instalarDebian11(){
	if sourceListDebian11; then
		echo "SOURCES LIST ATUALIZADA!"
		echo "PROSSEGUINDO COM AS CONFIGURAÇÕES!!!"
		sleep 1
	else
		echo "FALHA AO ATUALIZAR SOURCES LIST!"
		echo "VERIFIQUE O SCRIPT ANTES DE PROSSEGUIR"
		sleep 2
		exit 0
	fi
	}

function instalarUbuntu20(){
	if sourceListUbuntu2004; then
		echo "SOURCES LIST ATUALIZADA!"
		echo "PROSSEGUINDO COM AS CONFIGURAÇÕES!!!"
		sleep 1
	else
		echo "FALHA AO ATUALIZAR SOURCES LIST!"
		echo "VERIFIQUE O SCRIPT ANTES DE PROSSEGUIR"
		sleep 2
		exit 0
	fi
	}

function confirmaOperacao(){
    read -p "$1 ([S]im/[N]ao): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        s|sim)
        echo "sim" ;;
        *)
        echo "nao" ;;

    esac
	}

# FUNÇÃO AUXILIAR PARA EXECUTAR COMANDOS DO GSETTINGS COM O USUÁRIO COMUM
function run-in-user-session() {
    display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    usuario=$(who | grep "\(${display_id}\)" | awk '{print $1}')
    user_id=$(id -u "$usuario")
    environment=("DISPLAY=$display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$user_id/bus")
    sudo -Hu "$usuario" env "${environment[@]}" "$@"
	}
# ALTERA E AJUSTA O PAPEL DE PAREDE
function configTela(){
	echo "BAIXANDO PAPEL DE PAREDE..."
	wget 192.168.1.196/sti/alvf.jpg -O /home/alvf.jpg
	run-in-user-session gsettings set org.mate.background picture-filename /home/alvf.jpg 				#altera o papel de parede
	run-in-user-session gsettings set org.mate.background picture-options scaled 					#altera o estilo para escalonar
	run-in-user-session gsettings set org.mate.background primary-color 'rgb(32,74,135)' 				#altera a cor primária de fundo para azul escuro
	run-in-user-session gsettings set org.mate.background secondary-color 'rgb(255,255,255)' 			#altera a cor secundária de fundo para branco
	run-in-user-session gsettings set org.mate.screensaver lock-enabled false 					#desabilita o bloqueio da tela quando a proteção de tela estiver ativa
	run-in-user-session gsettings set org.mate.screensaver idle-activation-enabled false 				#desabilita a proteção de tela quando o computador ficar ocioso
	run-in-user-session gsettings set org.mate.session idle-delay 120 						#altera o tempo para o computador ficar ocioso para 2min
	run-in-user-session gsettings set org.mate.panel.toplevel:/org/mate/panel/toplevels/top/ orientation 'bottom' 	#altera a posição do panel para inferior
}

function iniciaVNC() {
	if [[ $so = *"Debian 10"* ]]; then
		display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
	    usuario=$(who | grep "\(${display_id}\)" | awk '{print $1}')
		touch /home/$usuario/.config/autostart/VNC.desktop
		chown -R $usuario.$usuario /home/$usuario/.config/autostart/
		echo '[Desktop Entry]
Type=Application
Exec=vncserver-x11
Hidden=false
X-MATE-Autostart-enabled=true
Name[pt_BR]=VNC
Name=VNC
Comment[pt_BR]=
Comment=' > /home/$usuario/.config/autostart/VNC.desktop
	elif [[ $so = *"Debian 11"* ]]; then
			display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
	    	usuario=$(who | grep "\(${display_id}\)" | awk '{print $1}')
			mkdir /home/$usuario/.config/autostart
			touch /home/$usuario/.config/autostart/vncserver-x11.desktop
			echo '[Desktop Entry]
Type=Application
Exec=vncserver-x11
Hidden=false
X-MATE-Autostart-enabled=true
Name[pt_BR]=VNC Server
Name=VNC Server
Comment[pt_BR]=VNC Server
Comment=VNC Server
X-MATE-Autostart-Delay=0' > /home/$usuario/.config/autostart/vncserver-x11.desktop
	elif [[ $so = *"Ubuntu 20.04"* ]]; then
		echo "Ubuntu 20.04"
		# TESTAR NO UBUNTU 20.04
	fi
	}

function desabilitaControleVolume(){
	if [[ $so = *"Debian 10"* ]]; then
		echo "X-MATE-Autostart-enabled=false" >> /etc/xdg/autostart/mate-volume-control-applet.desktop
	elif [[ $so = *"Debian 11"* ]]; then
		echo "X-MATE-Autostart-enabled=false" >> /etc/xdg/autostart/mate-volume-control-status-icon.desktop
	elif [[ $so = *"Ubuntu 20.04"* ]]; then
		echo "Ubuntu 20.04"
		# TESTAR NO UBUNTU 20.04
	fi
	}

function desabilitaGerenciadorRede(){
	if [[ $so = *"Debian 10"* ]]; then
		echo "X-MATE-Autostart-enabled=false" >> /etc/xdg/autostart/nm-applet.desktop
	elif [[ $so = *"Debian 11"* ]]; then
		echo "X-MATE-Autostart-enabled=false" >> /etc/xdg/autostart/nm-applet.desktop
	elif [[ $so = *"Ubuntu 20.04"* ]]; then
		echo "Ubuntu 20.04"
		# TESTAR NO UBUNTU 20.04
	fi
	}

function instalaImpressora(){
	echo "Em processo...";
}

################################################### FIM DA CRIAÇÃO DAS FUNÇÕES ###################################################

clear
descobreSO 
nomePC 
clear
bloqueioDesktop 
instalarSoftwares 
desabilitarBuscaImpressoras
habilitarLoginRootSSH 
removerTelaGrub 
loginAutomatico 
instalarChrome 
instalarVNC 
instalarFirefox 
instalarThunderbird 
configTela 
iniciaVNC 
desabilitaControleVolume 
desabilitaGerenciadorRede 
bloquear.sh
echo "FINALIZANDO INSTALAÇÃO..."
sleep 1
clear
echo "Seu computador será reiniciado em 5"
sleep 1
clear
echo "Seu computador será reiniciado em 4"
sleep 1
clear
echo "Seu computador será reiniciado em 3"
sleep 1
clear
echo "Seu computador será reiniciado em 2"
sleep 1
clear
echo "Seu computador será reiniciado em 1"
echo ""
reboot
