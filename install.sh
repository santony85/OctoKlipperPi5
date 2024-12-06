#!/bin/bash
# This script installs octoprint and Klipper on a Raspberry Pi 5 machine running the
# Raspbian distribution.

function reboot(){
	sudo reboot
}

function uninstall(){
	cd ~
	rm -Rf .octoprint
	rm -Rf klipper
	rm -Rf mjpg-streamer
	rm -Rf OctoPrint
	rm -Rf scripts
	rm -Rf klippy-env
	rm *
	echo -e "${green}###### Delete OK ######${white}"; echo
	main
	
}

function installDep(){
	cd ~
	sudo apt update
	sudo apt upgrade
	sudo apt install -y python3 python3-pip python3-dev python3-setuptools python3-venv git libyaml-dev build-essential libffi-dev libssl-dev
	mkdir OctoPrint && cd OctoPrint
	python3 -m venv venv
	source venv/bin/activate
	pip install --upgrade pip wheel
	pip install octoprint
	pip install "https://github.com/thelastWallE/OctoprintKlipperPlugin/archive/master.zip"
	sudo usermod -a -G tty octopi
	sudo usermod -a -G dialout octopi
	cd ~
	sudo mv octoprint.service /etc/systemd/system/octoprint.service
	sudo systemctl enable octoprint.service
	sudo service octoprint start
	sudo apt install -y haproxy
	sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfgCP
	sudo mv haproxy.cfg /etc/haproxy/haproxy.cfg
	sudo systemctl enable haproxy.service
	sudo service haproxy start
	sudo apt install -y subversion libjpeg62-turbo-dev imagemagick ffmpeg libv4l-dev cmake
	cd ~
	git clone https://github.com/jacksonliam/mjpg-streamer.git
	cd mjpg-streamer/mjpg-streamer-experimental
	export LD_LIBRARY_PATH=.
	make
	cd ~
	mkdir scripts
	mv webcamDaemon scripts
	chmod +x scripts/webcamDaemon
	sudo mv webcamd.service /etc/systemd/system/webcamd.service
	sudo systemctl daemon-reload
	sudo systemctl enable webcamd
	sudo systemctl start webcamd
	git clone https://github.com/Klipper3d/klipper
	mv klipper/scripts/install-octopi.sh klipper/scripts/install-octopi.shCP
	chmod 777 install-octopi.sh
	mv install-octopi.sh klipper/scripts/install-octopi.sh
	./klipper/scripts/install-octopi.sh
	echo -e "${green}###### Installation OK ######${white}"; echo
	installPlugins
    echo -e "${green}###### Installation Plugins OK ######${white}"; echo
	main
	
}

function installPlugins(){
	cd ~
	cd OctoPrint
	source venv/bin/activate
	 pip install yaml --break-system-packages
	pip install "https://github.com/jneilliii/OctoPrint-BedLevelVisualizer/archive/master.zip"
	pip install "https://github.com/LazeMSS/OctoPrint-UICustomizer/archive/main.zip"
	pip install "https://github.com/QuinnDamerell/OctoPrint-OctoEverywhere/archive/master.zip"
	sudo service octoprint restart
	cp ~/.octoprint/config.yaml ~/config.yaml
    mv ~/.octoprint/config.yaml ~/.octoprint/config.yamlCP
	cd ~
	python3 updateconfig.py
	cp new.yaml ~/.octoprint/config.yaml
  

}

function main() {
  echo -e "|********************************************************|"
  echo -e "|${green}              New octoprint install PI 5 !              ${white}|"
  echo -e "|${green}  View Changelog: https://git.io/JnmlX                  ${white}|"
  echo -e "|${yellow}  It is recommended to keep KIAUH up to date. Updates   ${white}|"
  echo -e "|********************************************************|"
  echo -e "| I) Installer                                           |"
  echo -e "| D) UnInstaller                                         |"
  echo -e "| Q) Quitter                                             |"
  echo -e "|********************************************************|"
  echo -e "| R) Reboot                                              |"
  echo -e "|********************************************************|"
  
  while true; do
		read -p "${cyan}###### Select action:${white} " -e input
		case "${input}" in
		  I|i)
			installDep
			break;;
		  D|d)
			uninstall
			break;;
		  R|r)
		    reboot
		    break;;
		  Q|q)
			echo -e "${green}###### Happy printing! ######${white}"; echo
			exit 0;;
		  *)
			error_msg "Invalid Input!\n";;
		esac
	  done && input=""
	
}
main