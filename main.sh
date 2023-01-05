#!/bin/bash
echo "     ____       __    _                                 _       __      ";
echo "    / __ \___  / /_  (_)___ _____       _______________(_)___  / /______";
echo "   / / / / _ \/ __ \/ / __ \ / __ \     / ___/ ___/ ___/ / __ \/ __/ ___/";
echo "  / /_/ /  __/ /_/ / / /_/ / / / /    (__  ) /__/ /  / / /_/ / /_(__  ) ";
echo " /_____/\___/_.___/_/\__,_/_/ /_/    /____/\___/_/  /_/ .___/\__/____/  ";
echo "                                                     /_/                ";

### Run script with sudo perms
if [[ "$EUID" -ne 0 ]]; then
	echo "[INFO]: Please run with sudo! Exiting... "
	exit
fi

echo "[INFO]: 1. Install Docker and docker-compose"
echo "[INFO]: 2. Install Firewalld"
read -p "Enter your script selection (1-2): " selection
if [[ $selection == "1" ]]; then
	echo "[INFO]: Preparing to install Docker! ..."
    sleep 1
    echo "[INFO]: Updating apt package repository..."
    sleep 1
    apt-get update
    echo "[INFO]: Installing Docker..."
    sleep 1
    curl -fsSL https://get.docker.com | bash
    echo "[INFO]: Preparing to install docker-compose! ..."
    sleep 1
    echo "[INFO]: Installing docker-compose..."
    sleep 1
    apt-get install docker-compose-plugin
    echo "[INFO]: Checking docker-compose version..."
    sleep 1
    docker compose version
    echo "[INFO]: Install complete! Press enter to exit."
    read
    exit
    ### End Docker install
elif [[ $selection == "2" ]]; then
    echo "[INFO]: Preparing to install Firewalld"
    sleep 1
    echo "[INFO]: Updating apt package repository..."
    sleep 1
    apt-get update
    echo "[INFO]: Installing Firewalld..."
    sleep 1
    apt install firewalld
    echo "[INFO]: Starting firewalld..."
    sleep 1
    systemctl enable firewalld
    systemctl start firewalld
    if [ $(firewall-cmd --state) == "running" ]; then
        echo "[INFO]: Install complete!"
        sleep 1
        read -p "Do you want to allow HTTP, HTTPS and SSH (N/Y): " firewalld_y_n
        if [[ $firewalld_y_n == "y" ]]; then
            echo "[INFO]: Adding ruled to firewall..."
            sleep 1
            firewall-cmd --add-port=80/tcp --permanent
            firewall-cmd --add-port=443/tcp --permanent
            firewall-cmd --add-port=22/tcp --permanent
            echo "[INFO]: Done adding firewall rules! Press enter to exit..."
            read
            exit
        fi
    else
        echo "[Error]: Error could not install firewalld! Please check error!"
    fi
    exit
    ### End Firewalld install
else
	echo "[WARNING]: The option: "$selection" is not valid. Exiting..."
    exit
fi
